package com.quizapp.service;

import com.quizapp.dto.QuestionRequest;
import com.quizapp.dto.QuizRequest;
import com.quizapp.dto.QuizDetailsView;
import com.quizapp.dto.QuizView;
import com.quizapp.entities.Question;
import com.quizapp.entities.QuestionOption;
import com.quizapp.entities.Quiz;
import com.quizapp.entities.enums.QUIZ_STATUS;
import com.quizapp.repository.CourseRepository;
import com.quizapp.repository.QuestionRepository;
import com.quizapp.repository.QuizRepository;
import com.quizapp.repository.InstructorRepository;
import com.quizapp.repository.StudentRepository;
import com.quizapp.repository.QuizAttemptRepository;
import com.quizapp.security.AuthenticatedUser;
import com.quizapp.entities.enums.USER_ROLE;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.LinkedHashMap;
import java.util.Map;

@Service
public class QuizService {
    private final QuizRepository quizzes;
    private final CourseRepository courses;
    private final InstructorRepository instructors;
    private final QuestionRepository questions;
    private final LoggingClient logging;
    private final StudentRepository students;
    private final QuizAttemptRepository attempts;

    public QuizService(QuizRepository quizzes, CourseRepository courses,
                       InstructorRepository instructors, QuestionRepository questions,
                       LoggingClient logging, StudentRepository students,
                       QuizAttemptRepository attempts) {
        this.quizzes = quizzes;
        this.courses = courses;
        this.instructors = instructors;
        this.questions = questions;
        this.logging = logging;
        this.students = students;
        this.attempts = attempts;
    }

    @Transactional
    // Creates a new quiz or updates an existing one, including any questions sent
    // from the editor when the instructor saves a draft or publishes it.
    public QuizView save(Long id, QuizRequest request) {
        // The quiz, questions, and answer options are saved in one transaction.
        // If one part fails, the database does not keep a half-finished draft.
        var instructor = instructors.findById(request.getCreatedById())
                .orElseThrow(() -> new EntityNotFoundException("Instructor profile not found"));
        Quiz quiz = id == null ? new Quiz() : getQuiz(id);
        if (id != null && !quiz.getCreatedBy().getId().equals(instructor.getId())) {
            throw new IllegalArgumentException("This quiz does not belong to the instructor");
        }
        var course = courses.findById(request.getCourseId())
                .orElseThrow(() -> new EntityNotFoundException("Course not found"));
        if (!course.getInstructor().getId().equals(instructor.getId())) {
            throw new IllegalArgumentException("The selected instructor does not teach this course");
        }
        quiz.setTitle(request.getTitle());
        quiz.setDescription(request.getDescription());
        quiz.setCourse(course);
        quiz.setCreatedBy(instructor);
        quiz.setTimeLimitMinutes(request.getTimeLimitMinutes());
        quiz.setPassPercentage(request.getPassPercentage());
        quiz.setStatus(request.getStatus() == null ? QUIZ_STATUS.DRAFT : request.getStatus());
        Quiz saved = quizzes.save(quiz);
        if (request.getQuestions() != null) {
            request.getQuestions().forEach(question -> addQuestionToQuiz(saved, question));
        }
        if (saved.getStatus() == QUIZ_STATUS.PUBLISHED && saved.getQuestions().isEmpty()) {
            throw new IllegalArgumentException("A quiz must have at least one question before publishing");
        }
        String eventType = id == null ? "QUIZ_CREATED" : "QUIZ_UPDATED";
        logging.log(eventType, saved.getTitle() + " saved as " + saved.getStatus()
                        + " with " + saved.getQuestions().size() + " questions",
                instructor.getId());
        return QuizView.from(saved);
    }

    @Transactional
    // Appends a question to a quiz that has already been saved.
    public QuizView addQuestion(Long quizId, Long instructorId, QuestionRequest request) {
        Quiz quiz = getQuiz(quizId);
        if (!quiz.getCreatedBy().getId().equals(instructorId)) {
            throw new IllegalArgumentException("This quiz does not belong to the instructor");
        }
        addQuestionToQuiz(quiz, request);
        logging.log("QUIZ_QUESTION_ADDED", "Question added to " + quiz.getTitle(),
                quiz.getCreatedBy().getId());
        return QuizView.from(quiz);
    }

    // Converts the question form data into question and option records while
    // preserving their display order.
    private void addQuestionToQuiz(Quiz quiz, QuestionRequest request) {
        validateQuestion(request);
        Question question = new Question();
        question.setQuiz(quiz);
        question.setQuestionText(request.getQuestionText());
        question.setQuestionType(request.getQuestionType());
        question.setPoints(request.getPoints() == null ? 1 : request.getPoints());
        question.setExplanation(request.getExplanation());
        question.setSkillTag(request.getSkillTag());
        question.setDifficulty(request.getDifficulty());
        // Store the order explicitly because database rows do not otherwise guarantee
        // that questions return in the order the instructor added them.
        question.setDisplayOrder(quiz.getQuestions().size() + 1);

        for (int i = 0; i < request.getOptions().size(); i++) {
            QuestionRequest.OptionRequest input = request.getOptions().get(i);
            QuestionOption option = new QuestionOption();
            option.setQuestion(question);
            option.setOptionText(input.getOptionText());
            option.setIsCorrect(input.isCorrect());
            option.setDisplayOrder(i + 1);
            question.getOptions().add(option);
        }
        questions.save(question);
        quiz.getQuestions().add(question);
    }

    @Transactional(readOnly = true)
    // Gives an instructor their complete quiz list, including work still in draft.
    public List<QuizView> forInstructor(Long instructorId) {
        instructors.findById(instructorId)
                .orElseThrow(() -> new EntityNotFoundException("Instructor profile not found"));
        return quizzes.findByCreatedById(instructorId).stream().map(QuizView::from).toList();
    }

    @Transactional(readOnly = true)
    // Gives a student only the published quizzes available through enrolled courses.
    public List<QuizView> forStudent(Long studentId) {
        students.findById(studentId)
                .orElseThrow(() -> new EntityNotFoundException("Student profile not found"));
        return quizzes.findPublishedForStudent(studentId).stream().map(QuizView::from).toList();
    }

    @Transactional(readOnly = true)
    // Loads the full question and option structure needed to edit or take a quiz.
    public QuizDetailsView details(Long quizId, AuthenticatedUser user) {
        Quiz quiz = getQuiz(quizId);
        boolean allowed = user.role() == USER_ROLE.ROLE_ADMIN
                || (user.role() == USER_ROLE.ROLE_INSTRUCTOR
                    && quiz.getCreatedBy().getId().equals(user.userId()))
                || (user.role() == USER_ROLE.ROLE_STUDENT
                    && quiz.getStatus() == QUIZ_STATUS.PUBLISHED
                    && quiz.getCourse().getEnrollments().stream()
                        .anyMatch(enrollment -> enrollment.getStudent().getId().equals(user.userId())));
        if (!allowed) {
            throw new IllegalArgumentException("This quiz is not available to this account");
        }
        return QuizDetailsView.from(quiz);
    }

    @Transactional(readOnly = true)
    public Map<String, Object> answerKey(Long quizId, Long instructorId) {
        Quiz quiz = getQuiz(quizId);
        if (!quiz.getCreatedBy().getId().equals(instructorId)) {
            throw new IllegalArgumentException("This quiz does not belong to the instructor");
        }
        List<Map<String, Object>> questionViews = quiz.getQuestions().stream().map(question -> {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("questionId", question.getId());
            item.put("questionText", question.getQuestionText());
            item.put("points", question.getPoints());
            item.put("options", question.getOptions().stream().map(option -> {
                Map<String, Object> optionView = new LinkedHashMap<>();
                optionView.put("optionText", option.getOptionText());
                optionView.put("correct", option.getIsCorrect());
                return optionView;
            }).toList());
            item.put("explanation", question.getExplanation());
            item.put("skillTag", question.getSkillTag());
            item.put("difficulty", question.getDifficulty());
            return item;
        }).toList();
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("quizId", quiz.getId());
        result.put("title", quiz.getTitle());
        result.put("status", quiz.getStatus());
        result.put("questions", questionViews);
        logging.log("QUIZ_ANSWER_KEY_VIEWED", quiz.getTitle() + " answer key viewed", instructorId);
        return result;
    }

    @Transactional
    public void delete(Long quizId, Long instructorId) {
        Quiz quiz = getQuiz(quizId);
        if (!quiz.getCreatedBy().getId().equals(instructorId)) {
            throw new IllegalArgumentException("This quiz does not belong to the instructor");
        }
        if (attempts.existsByQuizId(quizId)) {
            throw new IllegalStateException(
                    "This quiz has student attempts and cannot be deleted because its results must be preserved");
        }
        String title = quiz.getTitle();
        quizzes.delete(quiz);
        logging.log("QUIZ_DELETED", title + " deleted", instructorId);
    }

    // Centralizes the lookup and keeps the same useful error message across quiz actions.
    private Quiz getQuiz(Long id) {
        return quizzes.findById(id).orElseThrow(() -> new EntityNotFoundException("Quiz not found"));
    }

    private void validateQuestion(QuestionRequest request) {
        if (request.getPoints() != null && (request.getPoints() < 1 || request.getPoints() > 100)) {
            throw new IllegalArgumentException("Question points must be between 1 and 100");
        }
        if (request.getOptions().size() < 2 || request.getOptions().size() > 6) {
            throw new IllegalArgumentException("A question must have between 2 and 6 options");
        }
        long correctOptions = request.getOptions().stream()
                .filter(QuestionRequest.OptionRequest::isCorrect)
                .count();
        if (correctOptions != 1) {
            throw new IllegalArgumentException("Each question must have exactly one correct answer");
        }
        if (request.getQuestionType() == com.quizapp.entities.enums.QUESTION_TYPE.TRUE_FALSE
                && request.getOptions().size() != 2) {
            throw new IllegalArgumentException("True/false questions must have exactly two options");
        }
    }
}
