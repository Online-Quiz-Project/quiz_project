import { useEffect, useState } from 'react'
import { createQuiz, getInstructorCourses, updateQuiz } from '../../services/instructor'
import ErrorMessage from '../common/ErrorMessage'
import { generateAiQuestions } from '../../services/ai'

const emptyQuestion = () => ({
  questionText: '',
  questionType: 'MCQ',
  options: ['', '', '', ''],
  correct: 0,
})

// Supports both new quizzes and saved drafts, with a small editor for MCQ and
// true/false questions plus timer and passing-score settings.
export default function QuizForm({ instructorId, initialQuiz, onSaved }) {
  const [courses, setCourses] = useState([])
  const [form, setForm] = useState({
    title: initialQuiz?.title || '',
    description: initialQuiz?.description || '',
    courseId: initialQuiz ? String(initialQuiz.courseId) : '',
    timeLimitMinutes: initialQuiz?.timeLimitMinutes || 20,
    passPercentage: initialQuiz?.passPercentage || 60,
  })
  const [questions, setQuestions] = useState([emptyQuestion()])
  const [error, setError] = useState('')
  const [saving, setSaving] = useState(false)
  const [generating, setGenerating] = useState(false)
  const [aiInput, setAiInput] = useState({ topic: '', notes: '', difficulty: 'medium', count: 5 })

  useEffect(() => {
    getInstructorCourses(instructorId)
      .then((data) => {
        setCourses(data)
        if (data.length) setForm((current) => ({ ...current, courseId: current.courseId || String(data[0].id) }))
      })
      .catch((requestError) => setError(requestError.message))
  }, [instructorId])

  // Replaces only the question being edited, leaving every other question unchanged.
  const updateQuestion = (questionIndex, change) =>
    setQuestions(questions.map((question, index) => index === questionIndex ? { ...question, ...change } : question))

  // Changes the answer layout to match the selected question type and resets the
  // correct answer so an old choice cannot carry into the new type.
  const changeQuestionType = (questionIndex, questionType) => {
    // Changing the question type also resets its choices. True/false uses two fixed
    // answers, while multiple choice begins with four fields the instructor can edit.
    updateQuestion(questionIndex, {
      questionType,
      options: questionType === 'TRUE_FALSE' ? ['True', 'False'] : ['', '', '', ''],
      correct: 0,
    })
  }

  const generateQuestions = async () => {
    setError('')
    setGenerating(true)
    try {
      const result = await generateAiQuestions({
        ...aiInput,
        count: Number(aiInput.count),
        actorId: instructorId,
      })
      const generated = result.questions.map((question) => ({
        questionText: question.questionText,
        questionType: 'MCQ',
        options: question.options,
        correct: question.correctIndex,
        explanation: question.explanation,
        skillTag: question.skillTag,
        difficulty: question.difficulty,
      }))
      setQuestions((current) => [
        ...(current.length === 1 && !current[0].questionText ? [] : current),
        ...generated,
      ])
    } catch (requestError) {
      setError(requestError.message)
    } finally {
      setGenerating(false)
    }
  }

  // Validates entered questions, prepares the API shape, and either creates a quiz
  // or updates its existing draft before returning to the dashboard.
  const save = async (status) => {
    setError('')
    // Ignore a completely untouched question card. Once the instructor starts typing,
    // require the question and every answer choice before saving the quiz.
    const enteredQuestions = questions.filter((item) => item.questionText.trim() || item.options.some((option) => option.trim()))
    if (!form.title.trim()) {
      setError('Enter a quiz title')
      return
    }
    if (!initialQuiz && enteredQuestions.length === 0) {
      setError('Add at least one complete question before saving')
      return
    }
    if (enteredQuestions.some((question) => !question.questionText.trim() || question.options.some((option) => !option.trim()))) {
      setError('Complete the question text and every answer option before saving')
      return
    }
    setSaving(true)
    try {
      const quizData = {
        ...form,
        courseId: Number(form.courseId),
        createdById: instructorId,
        timeLimitMinutes: Number(form.timeLimitMinutes),
        passPercentage: Number(form.passPercentage),
        status,
        questions: enteredQuestions.map((question) => ({
          questionText: question.questionText,
          questionType: question.questionType,
          points: 1,
          explanation: question.explanation || null,
          skillTag: question.skillTag || null,
          difficulty: question.difficulty || null,
          options: question.options.map((optionText, index) => ({
            optionText,
            correct: index === question.correct,
          })),
        })),
      }
      if (initialQuiz) {
        await updateQuiz(initialQuiz.id, quizData)
      } else {
        await createQuiz(quizData)
      }
      onSaved()
    } catch (requestError) {
      setError(requestError.message)
    } finally {
      setSaving(false)
    }
  }

  return (
    <section className="builder">
      <div className="section-heading"><div><p className="eyebrow">QUIZ BUILDER</p><h2>{initialQuiz ? 'Edit draft quiz' : 'Create quiz'}</h2>{initialQuiz && <p>Existing questions are kept. Add new questions below, then save or publish.</p>}</div></div>
      <div className="builder-grid">
        <div className="panel form-panel">
          <label>Title<input value={form.title} onChange={(event) => setForm({ ...form, title: event.target.value })} required /></label>
          <label>Course<select value={form.courseId} onChange={(event) => setForm({ ...form, courseId: event.target.value })}>{courses.map((course) => <option value={course.id} key={course.id}>{course.courseName}</option>)}</select></label>
          <label>Description<textarea value={form.description} onChange={(event) => setForm({ ...form, description: event.target.value })} /></label>
          <div className="field-row"><label>Minutes<input type="number" min="1" value={form.timeLimitMinutes} onChange={(event) => setForm({ ...form, timeLimitMinutes: event.target.value })} /></label><label>Pass percentage<input type="number" min="1" max="100" value={form.passPercentage} onChange={(event) => setForm({ ...form, passPercentage: event.target.value })} /></label></div>
        </div>
        <div>
          <section className="panel ai-generator">
            <div className="ai-heading"><span>AI</span><div><p className="eyebrow">QUESTION COPILOT</p><h2>Generate an editable first draft</h2><p>Review every generated question before publishing.</p></div></div>
            <div className="field-row">
              <label>Topic<input value={aiInput.topic} placeholder="e.g. Java collections" onChange={(event) => setAiInput({ ...aiInput, topic: event.target.value })} /></label>
              <label>Difficulty<select value={aiInput.difficulty} onChange={(event) => setAiInput({ ...aiInput, difficulty: event.target.value })}><option value="easy">Easy</option><option value="medium">Medium</option><option value="hard">Hard</option></select></label>
            </div>
            <label>Source notes<textarea value={aiInput.notes} placeholder="Paste lesson notes or reference material…" onChange={(event) => setAiInput({ ...aiInput, notes: event.target.value })} /></label>
            <div className="ai-actions"><label>Questions<input type="number" min="1" max="20" value={aiInput.count} onChange={(event) => setAiInput({ ...aiInput, count: Math.min(20, Math.max(1, Number(event.target.value) || 1)) })} /></label><button className="primary" disabled={generating || (!aiInput.topic.trim() && !aiInput.notes.trim())} onClick={generateQuestions}>{generating ? 'Generating…' : 'Generate questions'}</button></div>
          </section>
          {questions.map((question, questionIndex) => (
            <div className="panel question-editor" key={questionIndex}>
              <h3>Question {questionIndex + 1}</h3>
              <label>Question type
                <select value={question.questionType} onChange={(event) => changeQuestionType(questionIndex, event.target.value)}>
                  <option value="MCQ">Multiple choice</option>
                  <option value="TRUE_FALSE">True / False</option>
                </select>
              </label>
              <label>Question text<input value={question.questionText} onChange={(event) => updateQuestion(questionIndex, { questionText: event.target.value })} /></label>
              {question.explanation && <p className="ai-explanation"><strong>AI explanation:</strong> {question.explanation}<span>{question.skillTag} · {question.difficulty}</span></p>}
              {question.options.map((option, optionIndex) => (
                <label className="editor-option" key={optionIndex}>
                  <input type="radio" name={`correct-${questionIndex}`} checked={question.correct === optionIndex} onChange={() => updateQuestion(questionIndex, { correct: optionIndex })} />
                  <input value={option} readOnly={question.questionType === 'TRUE_FALSE'} placeholder={`Option ${optionIndex + 1}`} onChange={(event) => updateQuestion(questionIndex, { options: question.options.map((item, index) => index === optionIndex ? event.target.value : item) })} />
                </label>
              ))}
            </div>
          ))}
          <button className="add-question" onClick={() => setQuestions([...questions, emptyQuestion()])}>+ Add question</button>
        </div>
      </div>
      <ErrorMessage message={error} />
      <div className="save-bar"><span>{questions.length} question(s)</span><div><button className="outline" disabled={saving || !courses.length} onClick={() => save('DRAFT')}>Save draft</button><button className="primary" disabled={saving || !courses.length} onClick={() => save('PUBLISHED')}>Publish</button></div></div>
    </section>
  )
}
