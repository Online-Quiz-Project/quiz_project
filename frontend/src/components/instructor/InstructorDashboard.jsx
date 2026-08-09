import { useEffect, useState } from 'react'
import { deleteQuiz, getInstructorCourses, getInstructorProfile, getInstructorQuizzes } from '../../services/instructor'
import ErrorMessage from '../common/ErrorMessage'
import Loading from '../common/Loading'

// Gives an instructor one view of the subjects they teach and the drafts or
// published quizzes they have created for those subjects.
export default function InstructorDashboard({ instructorId, refreshKey, onEdit, onViewAnswers }) {
  const [quizzes, setQuizzes] = useState([])
  const [courses, setCourses] = useState([])
  const [profile, setProfile] = useState(null)
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(true)
  const [deletingId, setDeletingId] = useState(null)

  useEffect(() => {
    Promise.all([getInstructorQuizzes(instructorId), getInstructorCourses(instructorId), getInstructorProfile(instructorId)])
      .then(([quizData, courseData, profileData]) => {
        setQuizzes(quizData)
        setCourses(courseData)
        setProfile(profileData)
      })
      .catch((requestError) => setError(requestError.message))
      .finally(() => setLoading(false))
  }, [instructorId, refreshKey])

  const removeQuiz = async (quiz) => {
    const confirmed = window.confirm(`Delete “${quiz.title}”? This cannot be undone.`)
    if (!confirmed) return

    setDeletingId(quiz.id)
    setError('')
    try {
      await deleteQuiz(quiz.id, instructorId)
      setQuizzes((current) => current.filter((item) => item.id !== quiz.id))
    } catch (requestError) {
      setError(requestError.message)
    } finally {
      setDeletingId(null)
    }
  }

  if (loading) return <Loading text="Loading your quizzes…" />
  if (error && !profile) return <ErrorMessage message={error} />

  return (
    <>
      <section className="panel profile-card">
        <p className="eyebrow">INSTRUCTOR PROFILE</p>
        <h2>{profile?.fullName}</h2>
        <p>{profile?.email}</p>
        <div className="detail-list">
          <p><span>Department</span><strong>{profile?.department || 'Not added'}</strong></p>
          <p><span>Qualifications</span><strong>{profile?.qualifications || 'Not added'}</strong></p>
        </div>
      </section>
      <section className="panel">
        <div className="panel-heading"><div><p className="eyebrow">TEACHING</p><h2>Your subjects</h2></div></div>
        {courses.length === 0 && <p className="empty-copy">No subjects have been assigned to you yet.</p>}
        <div className="course-grid">
          {courses.map((course) => <article className="course-card" key={course.id}><span>SUBJECT</span><h3>{course.courseName}</h3><p>{course.description || 'No description added.'}</p></article>)}
        </div>
      </section>
      <section className="panel">
        <div className="panel-heading"><div><p className="eyebrow">QUIZ LIBRARY</p><h2>Your database quizzes</h2></div></div>
        <ErrorMessage message={error} />
        {quizzes.length === 0 && <p className="empty-copy">You have not created a quiz yet.</p>}
        <table><thead><tr><th>Quiz</th><th>Course</th><th>Timer</th><th>Passing score</th><th>Status</th><th>Action</th></tr></thead>
          <tbody>{quizzes.map((quiz) => <tr key={quiz.id}><td><strong>{quiz.title}</strong></td><td>{quiz.courseName}</td><td>{quiz.timeLimitMinutes} min</td><td>{quiz.passPercentage}%</td><td><span className={`status ${quiz.status.toLowerCase()}`}>{quiz.status}</span></td><td><div className="quiz-actions">{quiz.status === 'DRAFT' ? <button className="text-button" onClick={() => onEdit(quiz)}>Edit draft</button> : <button className="text-button" onClick={() => onViewAnswers(quiz.id)}>View answers</button>}<button className="text-button danger" disabled={deletingId !== null} onClick={() => removeQuiz(quiz)}>{deletingId === quiz.id ? 'Deleting…' : 'Delete'}</button></div></td></tr>)}</tbody>
        </table>
      </section>
    </>
  )
}
