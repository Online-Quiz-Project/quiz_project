package com.quizapp.service;

import com.quizapp.dto.SubmitAttemptRequest;
import com.quizapp.entities.Question;
import com.quizapp.entities.QuestionOption;
import com.quizapp.entities.Quiz;
import com.quizapp.entities.QuizAttempt;
import com.quizapp.entities.AttemptResponse;
import com.quizapp.entities.enums.ATTEMPT_STATUS;
import com.quizapp.repository.QuestionOptionRepository;
import com.quizapp.repository.QuizAttemptRepository;
import com.quizapp.repository.QuizRepository;
import com.quizapp.repository.StudentRepository;
import com.quizapp.repository.AttemptResponseRepository;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.HashSet;
import java.util.List;

@Service
public class AttemptService {
    private final QuizAttemptRepository attempts;
    private final QuizRepository quizzes;
    private final StudentRepository students;
    private final QuestionOptionRepository options;
    private final LoggingClient logging;
    private final AttemptResponseRepository responses;

    public AttemptService(QuizAttemptRepository attempts, QuizRepository quizzes,
                          StudentRepository students, QuestionOptionRepository options,
                          LoggingClient logging, AttemptResponseRepository responses) {
        this.attempts = attempts;
        this.quizzes = quizzes;
        this.students = students;
        this.options = options;
        this.logging = logging;
        this.responses = responses;
    }

    @Transactional
    // Opens a timed quiz attempt. Refreshing the page continues a valid attempt
    // instead of resetting the student's countdown.
    public Map<String, Object> start(Long quizId, Long studentId) {
        Quiz quiz = quizzes.findById(quizId)
                .orElseThrow(() -> new EntityNotFoundException("Quiz not found"));
        var student = students.findById(studentId)
                .orElseThrow(() -> new EntityNotFoundException("Student profile not found"));
        if (quiz.getStatus() != com.quizapp.entities.enums.QUIZ_STATUS.PUBLISHED
                || quiz.getQuestions().isEmpty()
                || quiz.getCourse().getEnrollments().stream()
                .noneMatch(enrollment -> enrollment.getStudent().getId().equals(studentId))) {
            throw new IllegalArgumentException("This quiz is not available to this student");
        }
        QuizAttempt existing = attempts
                .findFirstByQuizIdAndStudentIdAndStatusOrderByCreatedAtDesc(
                        quizId, studentId, ATTEMPT_STATUS.IN_PROGRESS)
                .orElse(null);
        // Reuse an unfinished attempt while its deadline is still valid. This lets a
        // student refresh the page without receiving a fresh timer.
        if (existing != null && existing.getServerDeadline().isAfter(LocalDateTime.now())) {
            logging.log("QUIZ_RESUMED", quiz.getTitle() + " attempt resumed", studentId);
            return startResponse(existing);
        }
        if (existing != null) {
            existing.setStatus(ATTEMPT_STATUS.EXPIRED);
            attempts.save(existing);
            logging.log("QUIZ_ATTEMPT_EXPIRED", quiz.getTitle() + " previous attempt expired", studentId);
        }

        QuizAttempt attempt = new QuizAttempt();
        attempt.setQuiz(quiz);
        attempt.setStudent(student);
        attempt.setStartedAt(LocalDateTime.now());
        attempt.setServerDeadline(attempt.getStartedAt().plusMinutes(quiz.getTimeLimitMinutes()));
        attempt.setTotalQuestions(quiz.getQuestions().size());
        attempts.save(attempt);
        logging.log("QUIZ_STARTED", quiz.getTitle() + " attempt started", studentId);

        return startResponse(attempt);
    }

    @Transactional
    // Validates each selected option, calculates a percentage score, records every
    // answer, and decides whether the student passed.
    public Map<String, Object> submit(Long attemptId, SubmitAttemptRequest request, Long studentId) {
        QuizAttempt attempt = attempts.findById(attemptId)
                .orElseThrow(() -> new EntityNotFoundException("Attempt not found"));
        if (!attempt.getStudent().getId().equals(studentId)) {
            throw new IllegalArgumentException("This attempt does not belong to the student");
        }
        if (attempt.getStatus() != ATTEMPT_STATUS.IN_PROGRESS) {
            throw new IllegalStateException("Attempt is already finished");
        }
        if (request.getAnswers().isEmpty() && !request.isTimedOut()) {
            throw new IllegalArgumentException("Answer at least one question before submitting");
        }

        int earned = 0;
        int possible = attempt.getQuiz().getQuestions().stream().mapToInt(Question::getPoints).sum();
        int correct = 0;
        var answeredQuestions = new HashSet<Long>();
        for (SubmitAttemptRequest.AnswerRequest input : request.getAnswers()) {
            if (!answeredQuestions.add(input.getQuestionId())) {
                throw new IllegalArgumentException("Each question can only be answered once");
            }
            Question question = attempt.getQuiz().getQuestions().stream()
                    .filter(item -> item.getId().equals(input.getQuestionId())).findFirst()
                    .orElseThrow(() -> new IllegalArgumentException("Question does not belong to quiz"));
            QuestionOption selected = options.findById(input.getSelectedOptionId())
                    .orElseThrow(() -> new EntityNotFoundException("Option not found"));
            if (!selected.getQuestion().getId().equals(question.getId())) {
                throw new IllegalArgumentException("Selected option does not belong to the question");
            }
            boolean isCorrect = selected.getIsCorrect();
            if (isCorrect) {
                earned += question.getPoints();
                correct++;
            }
            AttemptResponse response = new AttemptResponse();
            response.setAttempt(attempt);
            response.setQuestion(question);
            response.setSelectedOption(selected);
            response.setCorrect(isCorrect);
            responses.save(response);
        }
        BigDecimal score = possible == 0 ? BigDecimal.ZERO :
                BigDecimal.valueOf(earned * 100.0 / possible).setScale(2, RoundingMode.HALF_UP);
        attempt.setScore(score);
        attempt.setCorrectAnswers(correct);
        attempt.setSubmittedAt(LocalDateTime.now());
        // Use the saved server deadline rather than the browser timer. A late request is
        // recorded as auto-submitted even if the student's clock was changed or paused.
        attempt.setStatus(request.isTimedOut() || attempt.getSubmittedAt().isAfter(attempt.getServerDeadline())
                ? ATTEMPT_STATUS.AUTO_SUBMITTED : ATTEMPT_STATUS.SUBMITTED);
        attempts.save(attempt);
        logging.log(attempt.getStatus() == ATTEMPT_STATUS.AUTO_SUBMITTED
                        ? "QUIZ_AUTO_SUBMITTED" : "QUIZ_SUBMITTED",
                attempt.getQuiz().getTitle() + " scored " + score + "% with "
                        + request.getProctorWarnings() + " focus warnings",
                attempt.getStudent().getUser().getId());

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("score", score);
        result.put("passed", score.doubleValue() >= attempt.getQuiz().getPassPercentage());
        result.put("correctAnswers", correct);
        result.put("totalQuestions", attempt.getTotalQuestions());
        int xpEarned = score.setScale(0, RoundingMode.HALF_UP).intValue()
                + (score.doubleValue() >= attempt.getQuiz().getPassPercentage() ? 25 : 0);
        result.put("xpEarned", xpEarned);
        return result;
    }

    @Transactional(readOnly = true)
    public Map<String, Object> review(Long attemptId, Long studentId) {
        QuizAttempt attempt = attempts.findById(attemptId)
                .orElseThrow(() -> new EntityNotFoundException("Attempt not found"));
        if (!attempt.getStudent().getId().equals(studentId)) {
            throw new IllegalArgumentException("This attempt does not belong to the student");
        }
        if (attempt.getStatus() == ATTEMPT_STATUS.IN_PROGRESS) {
            throw new IllegalStateException("Submit the quiz before reviewing answers");
        }

        Map<Long, AttemptResponse> saved = responses
                .findByAttemptIdOrderByQuestionDisplayOrderAsc(attemptId).stream()
                .collect(java.util.stream.Collectors.toMap(
                        item -> item.getQuestion().getId(), item -> item));
        List<Map<String, Object>> questions = attempt.getQuiz().getQuestions().stream().map(question -> {
            AttemptResponse response = saved.get(question.getId());
            QuestionOption correctOption = question.getOptions().stream()
                    .filter(QuestionOption::getIsCorrect).findFirst().orElse(null);
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("questionId", question.getId());
            item.put("questionText", question.getQuestionText());
            item.put("points", question.getPoints());
            item.put("skillTag", question.getSkillTag());
            item.put("difficulty", question.getDifficulty());
            item.put("selectedAnswer", response == null || response.getSelectedOption() == null
                    ? null : response.getSelectedOption().getOptionText());
            item.put("correctAnswer", correctOption == null ? null : correctOption.getOptionText());
            item.put("correct", response != null && response.getCorrect());
            item.put("options", question.getOptions().stream().map(option -> {
                Map<String, Object> optionView = new LinkedHashMap<>();
                optionView.put("optionText", option.getOptionText());
                optionView.put("correct", option.getIsCorrect());
                optionView.put("selected", response != null && response.getSelectedOption() != null
                        && response.getSelectedOption().getId().equals(option.getId()));
                return optionView;
            }).toList());
            item.put("explanation", question.getExplanation());
            return item;
        }).toList();

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("attemptId", attempt.getId());
        result.put("quiz", attempt.getQuiz().getTitle());
        result.put("score", attempt.getScore());
        result.put("questions", questions);
        logging.log("QUIZ_REVIEW_VIEWED", attempt.getQuiz().getTitle() + " attempt review viewed", studentId);
        return result;
    }

    // Keeps the attempt-start response consistent for both new and resumed attempts.
    private Map<String, Object> startResponse(QuizAttempt attempt) {
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("attemptId", attempt.getId());
        result.put("deadline", attempt.getServerDeadline());
        result.put("quiz", attempt.getQuiz().getTitle());
        return result;
    }
}
