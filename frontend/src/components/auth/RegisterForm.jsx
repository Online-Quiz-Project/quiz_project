import { useEffect, useState } from 'react'
import { getRegistrationCourses, register } from '../../services/auth'
import ErrorMessage from '../common/ErrorMessage'

// Creates student accounts and lets the student choose their first courses from
// the live course catalog.
export default function RegisterForm({ onSuccess, onLogin }) {
  const [form, setForm] = useState({
    fullName: '', email: '', password: '', confirmPassword: '',
    courseIds: [], branch: '', graduationYear: '',
  })
  const [courses, setCourses] = useState([])
  const [selectedCourseId, setSelectedCourseId] = useState('')
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    getRegistrationCourses()
      .then((data) => {
        setCourses(data)
      })
      .catch((requestError) => setError(requestError.message))
  }, [])

  // Adds only a course returned by the database and prevents the same course
  // from being selected twice while still allowing multiple enrollments.
  const addCourse = () => {
    const courseId = Number(selectedCourseId)
    if (!courseId || !courses.some((course) => course.id === courseId)
        || form.courseIds.includes(courseId)) return
    setForm({ ...form, courseIds: [...form.courseIds, courseId] })
    setSelectedCourseId('')
  }

  // Checks the two passwords locally, then sends only the fields expected by the
  // registration endpoint.
  const submit = async (event) => {
    event.preventDefault()
    if (form.password !== form.confirmPassword) {
      setError('Passwords do not match')
      return
    }
    setLoading(true)
    setError('')
    try {
      onSuccess(await register({
        fullName: form.fullName,
        email: form.email,
        password: form.password,
        courseIds: form.courseIds,
        branch: form.branch || null,
        graduationYear: form.graduationYear ? Number(form.graduationYear) : null,
      }))
    } catch (requestError) {
      setError(requestError.message)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="auth-card">
      <p className="eyebrow">JOIN QUIZLY</p>
      <h2>Create student account</h2>
      <p className="auth-intro">Your account will be saved directly to the users table.</p>
      <form onSubmit={submit}>
        <label>Full name<input value={form.fullName} onChange={(event) => setForm({ ...form, fullName: event.target.value })} required /></label>
        <label>Email address<input type="email" value={form.email} onChange={(event) => setForm({ ...form, email: event.target.value })} required /></label>
        <fieldset className="course-picker course-dropdown"><legend>Choose one or more courses</legend>
          <div className="course-select-row">
            <select value={selectedCourseId} onChange={(event) => setSelectedCourseId(event.target.value)} disabled={courses.length === 0}>
              <option value="">{courses.length ? 'Select a course' : 'No courses are available'}</option>
              {courses
                .filter((course) => !form.courseIds.includes(course.id))
                .map((course) => <option value={course.id} key={course.id}>{course.courseName} — {course.instructorName}</option>)}
            </select>
            <button type="button" className="outline" onClick={addCourse} disabled={!selectedCourseId}>Add</button>
          </div>
          <div className="selected-courses">
            {form.courseIds.map((courseId) => {
              const course = courses.find((item) => item.id === courseId)
              if (!course) return null
              return <div key={courseId}><span>{course.courseName}</span><button type="button" onClick={() => setForm({ ...form, courseIds: form.courseIds.filter((id) => id !== courseId) })}>Remove</button></div>
            })}
          </div>
        </fieldset>
        <label>Branch <span className="optional">(optional)</span><input value={form.branch} onChange={(event) => setForm({ ...form, branch: event.target.value })} placeholder="For example, Computer Science" /></label>
        <label>Graduation year <span className="optional">(optional)</span><input type="number" min="2000" max="2100" value={form.graduationYear} onChange={(event) => setForm({ ...form, graduationYear: event.target.value })} /></label>
        <label>Password<input type="password" minLength="6" value={form.password} onChange={(event) => setForm({ ...form, password: event.target.value })} required /></label>
        <label>Confirm password<input type="password" minLength="6" value={form.confirmPassword} onChange={(event) => setForm({ ...form, confirmPassword: event.target.value })} required /></label>
        <ErrorMessage message={error} />
        <button className="primary auth-submit" disabled={loading || form.courseIds.length === 0}>{loading ? 'Creating…' : 'Create account'}</button>
      </form>
      <p className="auth-switch">Already registered? <button onClick={onLogin}>Sign in</button></p>
    </div>
  )
}
