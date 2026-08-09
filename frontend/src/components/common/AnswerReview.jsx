import { useEffect, useState } from 'react'
import { getAttemptReview } from '../../services/attempt'
import { getQuizAnswerKey } from '../../services/instructor'
import ErrorMessage from './ErrorMessage'
import Loading from './Loading'

export default function AnswerReview({ attemptId, quizId, studentId, instructorId, onClose }) {
  const [review, setReview] = useState(null)
  const [error, setError] = useState('')
  const instructorMode = Boolean(quizId)

  useEffect(() => {
    const request = instructorMode
      ? getQuizAnswerKey(quizId, instructorId)
      : getAttemptReview(attemptId, studentId)
    request.then(setReview).catch((requestError) => setError(requestError.message))
  }, [attemptId, quizId, studentId, instructorId, instructorMode])

  if (error) return <section className="review-shell"><ErrorMessage message={error} /><button className="outline" onClick={onClose}>Back</button></section>
  if (!review) return <Loading text="Preparing answer review…" />

  return (
    <section className="review-shell">
      <div className="review-header">
        <div><p className="eyebrow">{instructorMode ? 'INSTRUCTOR ANSWER KEY' : 'ATTEMPT REVIEW'}</p><h2>{review.title || review.quiz}</h2>{!instructorMode && <p>Final score: <strong>{review.score}%</strong></p>}</div>
        <button className="outline" onClick={onClose}>Back</button>
      </div>
      <div className="review-list">
        {review.questions.map((question, index) => {
          return (
            <article className={`review-card ${!instructorMode ? (question.correct ? 'review-correct' : 'review-incorrect') : ''}`} key={question.questionId}>
              <div className="review-question"><span>{String(index + 1).padStart(2, '0')}</span><div><h3>{question.questionText}</h3><small>{question.points} point{question.points === 1 ? '' : 's'}{question.skillTag ? ` · ${question.skillTag}` : ''}{question.difficulty ? ` · ${question.difficulty}` : ''}</small></div></div>
              <div className="review-options">{question.options.map((option) => {
                const classes = [option.correct ? 'correct-option' : '', !instructorMode && option.selected ? 'selected-option' : '', !instructorMode && option.selected && !option.correct ? 'selected-wrong' : ''].filter(Boolean).join(' ')
                return <p className={classes} key={option.optionText}><span>{option.correct ? '✓' : option.selected ? '✕' : '○'}</span><strong>{option.optionText}</strong>{!instructorMode && option.selected && <em>Your answer</em>}{option.correct && <em>Correct answer</em>}</p>
              })}</div>
              {!instructorMode && !question.options.some((option) => option.selected) && <p className="not-answered">Not answered</p>}
              {question.explanation && <p className="review-explanation"><strong>Explanation</strong>{question.explanation}</p>}
            </article>
          )
        })}
      </div>
    </section>
  )
}
