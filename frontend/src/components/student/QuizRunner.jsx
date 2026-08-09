import { useCallback, useEffect, useState } from 'react'
import { getQuiz } from '../../services/user'
import { startAttempt, submitAttempt } from '../../services/attempt'
import ErrorMessage from '../common/ErrorMessage'
import Loading from '../common/Loading'
import { getAiHint } from '../../services/ai'
import AnswerReview from '../common/AnswerReview'

// Runs one timed attempt, remembers answers while moving between questions, and
// displays the result returned by the backend after submission.
export default function QuizRunner({ quizId, studentId, onClose }) {
  const [quiz, setQuiz] = useState(null)
  const [attemptId, setAttemptId] = useState(null)
  const [index, setIndex] = useState(0)
  const [answers, setAnswers] = useState({})
  const [seconds, setSeconds] = useState(0)
  const [result, setResult] = useState(null)
  const [error, setError] = useState('')
  const [runNumber, setRunNumber] = useState(0)
  const [hint, setHint] = useState('')
  const [hintLevel, setHintLevel] = useState(0)
  const [hintLoading, setHintLoading] = useState(false)
  const [proctorWarnings, setProctorWarnings] = useState(0)
  const [reviewing, setReviewing] = useState(false)

  useEffect(() => {
    Promise.all([getQuiz(quizId), startAttempt(quizId, studentId)])
      .then(([quizData, attempt]) => {
        setQuiz(quizData)
        setAttemptId(attempt.attemptId)
        // Calculate the remaining time from the server's deadline instead of starting
        // a new local timer. Refreshing the page therefore cannot add extra minutes.
        setSeconds(Math.max(0, Math.floor((new Date(attempt.deadline) - Date.now()) / 1000)))
      })
      .catch((requestError) => setError(requestError.message))
  }, [quizId, studentId, runNumber])

  useEffect(() => {
    if (!quiz || result) return undefined
    const flag = () => setProctorWarnings((current) => current + 1)
    const visibility = () => { if (document.hidden) flag() }
    const blockClipboard = (event) => { event.preventDefault(); flag() }
    window.addEventListener('blur', flag)
    document.addEventListener('visibilitychange', visibility)
    document.addEventListener('copy', blockClipboard)
    document.addEventListener('paste', blockClipboard)
    return () => {
      window.removeEventListener('blur', flag)
      document.removeEventListener('visibilitychange', visibility)
      document.removeEventListener('copy', blockClipboard)
      document.removeEventListener('paste', blockClipboard)
    }
  }, [quiz, result])

  // Clears the completed attempt from the screen and starts a new server-timed
  // attempt for the same quiz. The previous result remains stored in the database.
  const reattempt = () => {
    setQuiz(null)
    setAttemptId(null)
    setIndex(0)
    setAnswers({})
    setSeconds(0)
    setResult(null)
    setError('')
    setHint('')
    setHintLevel(0)
    setProctorWarnings(0)
    setRunNumber((current) => current + 1)
  }

  // Converts the student's answer map into the backend format and submits it once.
  const submit = useCallback(async (timedOut = false) => {
    if (!attemptId || result) return
    const answerList = Object.entries(answers).map(([questionId, selectedOptionId]) => ({
      questionId: Number(questionId),
      selectedOptionId,
    }))
    if (answerList.length === 0 && !timedOut) {
      setError('Answer at least one question before submitting')
      return
    }
    try {
      setResult(await submitAttempt(attemptId, answerList, timedOut, proctorWarnings))
    } catch (requestError) {
      setError(requestError.message)
    }
  }, [answers, attemptId, proctorWarnings, result])

  useEffect(() => {
    if (!quiz || result) return undefined
    if (seconds <= 0) {
      // Hand in whatever the student has answered as soon as time reaches zero.
      // The backend performs the final deadline check and records the attempt status.
      const timer = window.setTimeout(() => submit(true), 0)
      return () => window.clearTimeout(timer)
    }
    const timer = window.setTimeout(() => setSeconds(seconds - 1), 1000)
    return () => window.clearTimeout(timer)
  }, [quiz, result, seconds, submit])

  if (error && !quiz) return <ErrorMessage message={error} />
  if (!quiz) return <Loading text="Starting quiz…" />
  if (result && reviewing) {
    return <AnswerReview attemptId={attemptId} studentId={studentId} onClose={() => setReviewing(false)} />
  }
  if (result) {
    return (
      <section className="result-screen">
        <div className={result.passed ? 'result-ring passed' : 'result-ring'}><strong>{result.score}%</strong><span>{result.passed ? 'Passed' : 'Failed'}</span></div>
        <h2>Quiz submitted</h2>
        <p>{result.correctAnswers} of {result.totalQuestions} answers were correct.</p>
        <p className="xp-earned">+{result.xpEarned} XP earned</p>
        <div className="runner-actions">
          <button className="outline" onClick={onClose}>Back to dashboard</button>
          <button className="outline" onClick={() => setReviewing(true)}>Review answers</button>
          <button className="primary" onClick={reattempt}>Reattempt quiz</button>
        </div>
      </section>
    )
  }

  const question = quiz.questions[index]
  if (!question) return <section className="panel"><ErrorMessage message="This quiz has no questions yet." /><button className="outline" onClick={onClose}>Back</button></section>
  const minutes = String(Math.floor(seconds / 60)).padStart(2, '0')
  const remainingSeconds = String(seconds % 60).padStart(2, '0')

  const requestHint = async () => {
    const nextLevel = Math.min(3, hintLevel + 1)
    setHintLoading(true)
    setError('')
    try {
      const response = await getAiHint({
        question: question.questionText,
        options: question.options.map((option) => option.optionText).join(' | '),
        level: nextLevel,
        actorId: studentId,
      })
      setHint(response.hint)
      setHintLevel(response.level)
    } catch (requestError) {
      setError(requestError.message)
    } finally {
      setHintLoading(false)
    }
  }

  const moveToQuestion = (nextIndex) => {
    setHint('')
    setHintLevel(0)
    setError('')
    setIndex(nextIndex)
  }

  return (
    <section className="runner">
      {proctorWarnings > 0 && <p className="proctor-alert">Focus safeguard: {proctorWarnings} tab, window, or clipboard event{proctorWarnings === 1 ? '' : 's'} detected.</p>}
      <div className="runner-top"><button className="text-button" onClick={onClose}>← Exit</button><div><span>Time remaining</span><strong>{minutes}:{remainingSeconds}</strong></div></div>
      <div className="question-card">
        <p className="eyebrow">QUESTION {index + 1} OF {quiz.questions.length}</p>
        <h2>{question.questionText}</h2>
        <div className="options">
          {question.options.map((option, optionIndex) => (
            <button className={answers[question.id] === option.id ? 'option selected' : 'option'} onClick={() => setAnswers({ ...answers, [question.id]: option.id })} key={option.id}>
              <span>{String.fromCharCode(65 + optionIndex)}</span>{option.optionText}
            </button>
          ))}
        </div>
        <div className="hint-row"><button className="text-button" disabled={hintLoading || hintLevel >= 3} onClick={requestHint}>{hintLoading ? 'Thinking…' : hintLevel ? `Get hint ${hintLevel + 1}` : 'AI Hint'}</button><span>Progressive hints never reveal the answer.</span></div>
        {hint && <p className="ai-hint"><strong>Hint {hintLevel}:</strong> {hint}</p>}
        <ErrorMessage message={error} />
        <div className="runner-actions">
          <button className="outline" disabled={index === 0 || hintLoading} onClick={() => moveToQuestion(index - 1)}>Previous</button>
          {index < quiz.questions.length - 1
            ? <button className="primary" disabled={hintLoading} onClick={() => moveToQuestion(index + 1)}>Next</button>
            : <button className="primary" onClick={() => submit(false)}>Submit quiz</button>}
        </div>
      </div>
    </section>
  )
}
