import { useCallback, useEffect, useState } from 'react'
import { enrollInCourse, getCourses, getStudentProfile, getStudentQuizzes } from '../../services/user'
import ErrorMessage from '../common/ErrorMessage'
import Loading from '../common/Loading'

// Shows a student's profile, available quizzes, current enrollments, and courses
// they can still join, with each navigation page having a distinct purpose.
export default function StudentDashboard({ studentId, page, onStartQuiz }) {
  const [profile, setProfile] = useState(null)
  const [quizzes, setQuizzes] = useState([])
  const [courses, setCourses] = useState([])
  const [error, setError] = useState('')
  const [message, setMessage] = useState('')
  const [loading, setLoading] = useState(true)
  const [enrollingId, setEnrollingId] = useState(null)

  // Loads the profile, quiz list, and full catalog together so course enrollment
  // can update every affected section in one refresh.
  const loadData = useCallback(() =>
    Promise.all([getStudentProfile(studentId), getStudentQuizzes(studentId), getCourses()])
      .then(([profileData, quizData, courseData]) => {
        setProfile(profileData)
        setQuizzes(quizData)
        setCourses(courseData)
      }), [studentId])

  useEffect(() => {
    loadData()
      .catch((requestError) => setError(requestError.message))
      .finally(() => setLoading(false))
  }, [loadData])

  // Adds the selected course to the signed-in student and then reloads the page
  // data so its new quizzes and instructor appear immediately.
  const enroll = async (courseId) => {
    setError('')
    setMessage('')
    setEnrollingId(courseId)
    try {
      await enrollInCourse(studentId, courseId)
      await loadData()
      setMessage('Course added to your account')
    } catch (requestError) {
      setError(requestError.message)
    } finally {
      setEnrollingId(null)
    }
  }

  if (loading) return <Loading text="Loading your courses and quizzes…" />
  if (error && !profile) return <ErrorMessage message={error} />

  const enrolledIds = new Set(profile.courses.map((course) => course.id))
  const availableCourses = courses.filter((course) => !enrolledIds.has(course.id))

  if (page === 'Profile') {
    return (
      <section className="panel profile-card">
        <p className="eyebrow">STUDENT PROFILE</p>
        <h2>{profile.fullName}</h2>
        <p>{profile.email}</p>
        <p>{[profile.branch, profile.graduationYear && `Graduating ${profile.graduationYear}`].filter(Boolean).join(' · ') || 'Academic details not added yet.'}</p>
        <div className="detail-list">
          {profile.courses.map((course) => (
            <p key={course.id}><span>Enrolled course</span><strong>{course.courseName}</strong><small>{course.instructorName}</small></p>
          ))}
        </div>
      </section>
    )
  }

  if (page === 'Quizzes') {
    return (
      <>
        <div className="section-heading"><div><p className="eyebrow">ASSESSMENTS</p><h2>All available quizzes</h2><p>Published quizzes from every course you are enrolled in.</p></div></div>
        <section className="panel">
          {quizzes.length === 0 && <p className="empty-copy">No published quizzes are available for your courses.</p>}
          {quizzes.map((quiz, index) => (
            <div className="quiz-row" key={quiz.id}>
              <span className="quiz-number">{String(index + 1).padStart(2, '0')}</span>
              <div className="quiz-copy"><strong>{quiz.title}</strong><span>{quiz.courseName}</span></div>
              <div className="quiz-meta"><span>{quiz.questionCount} questions</span><span>{quiz.timeLimitMinutes} min</span><span>{quiz.passPercentage}% pass</span></div>
              <button className="outline" onClick={() => onStartQuiz(quiz.id)}>Start</button>
            </div>
          ))}
        </section>
      </>
    )
  }

  return (
    <>
      <section className="welcome-panel">
        <div><p className="eyebrow">YOUR LEARNING</p><h2>Welcome back, {profile.fullName.split(' ')[0]}.</h2><p>You are enrolled in {profile.courses.length} course{profile.courses.length === 1 ? '' : 's'} with {quizzes.length} published quiz{quizzes.length === 1 ? '' : 'zes'} available.</p></div>
      </section>
      <ErrorMessage message={error} />
      {message && <p className="success-message">{message}</p>}
      <div className="section-heading"><div><p className="eyebrow">DASHBOARD</p><h2>Learning overview</h2></div></div>
      <section className="stat-grid">
        <article className="stat-card"><span>Enrolled courses</span><strong>{profile.courses.length}</strong></article>
        <article className="stat-card green"><span>Available quizzes</span><strong>{quizzes.length}</strong></article>
        <article className="stat-card yellow"><span>Instructors</span><strong>{new Set(profile.courses.map((course) => course.instructorName)).size}</strong></article>
      </section>
      <section className="panel">
        <div className="panel-heading"><div><p className="eyebrow">YOUR COURSES</p><h2>Current enrollments</h2></div></div>
        <div className="course-grid">{profile.courses.map((course) => <article className="course-card" key={course.id}><span>COURSE</span><h3>{course.courseName}</h3><p>Instructor: {course.instructorName}</p></article>)}</div>
      </section>
      <section className="panel">
        <div className="panel-heading"><div><p className="eyebrow">COURSE CATALOG</p><h2>Add another course</h2><p>Join a course to receive quizzes published by its instructor.</p></div></div>
        {availableCourses.length === 0 && <p className="empty-copy">You are enrolled in every available course.</p>}
        <div className="course-grid">
          {availableCourses.map((course) => (
            <article className="course-card" key={course.id}>
              <span>AVAILABLE</span>
              <h3>{course.courseName}</h3>
              <p>Instructor: {course.instructorName}</p>
              <button className="outline course-action" disabled={enrollingId !== null} onClick={() => enroll(course.id)}>
                {enrollingId === course.id ? 'Adding…' : 'Add course'}
              </button>
            </article>
          ))}
        </div>
      </section>
    </>
  )
}
