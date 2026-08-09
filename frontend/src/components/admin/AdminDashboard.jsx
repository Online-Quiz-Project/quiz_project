import { useCallback, useEffect, useState } from 'react'
import { changeUserRole, createCourse, createUser, getAdminMetrics, getUsers } from '../../services/admin'
import { getRegistrationCourses } from '../../services/auth'
import ErrorMessage from '../common/ErrorMessage'
import Loading from '../common/Loading'

const roles = ['ROLE_STUDENT', 'ROLE_INSTRUCTOR', 'ROLE_ADMIN']

// Combines platform totals, account management, role changes, and course creation
// into the administrator's main working screen.
export default function AdminDashboard() {
  const [metrics, setMetrics] = useState(null)
  const [users, setUsers] = useState([])
  const [courses, setCourses] = useState([])
  const [error, setError] = useState('')
  const [message, setMessage] = useState('')
  const emptyUserForm = {
    fullName: '', email: '', password: '', role: 'ROLE_INSTRUCTOR', courseIds: [],
    branch: '', graduationYear: '', department: '', qualifications: '',
  }
  const [userForm, setUserForm] = useState(emptyUserForm)
  const [courseForm, setCourseForm] = useState({ courseName: '', description: '', instructorId: '' })

  // Refreshes related admin data together so metrics, users, and course choices
  // stay in agreement after a change.
  const loadData = useCallback(() => {
    Promise.all([getAdminMetrics(), getUsers(), getRegistrationCourses()])
      .then(([metricData, userData, courseData]) => {
        setMetrics(metricData)
        setUsers(userData)
        setCourses(courseData)
        const firstInstructor = userData.find((user) => user.role === 'ROLE_INSTRUCTOR')
        if (firstInstructor) {
          setCourseForm((current) => ({ ...current, instructorId: String(firstInstructor.id) }))
        }
      })
      .catch((requestError) => setError(requestError.message))
  }, [])

  useEffect(loadData, [loadData])

  // Saves a new role and reloads the table so related course details stay current.
  const updateRole = async (userId, role) => {
    try {
      await changeUserRole(userId, role)
      setMessage('Role updated')
      loadData()
    } catch (requestError) {
      setError(requestError.message)
    }
  }

  // Creates an account from the admin form, including selected courses for students.
  const submitUser = async (event) => {
    event.preventDefault()
    try {
      await createUser({
        ...userForm,
        graduationYear: userForm.graduationYear ? Number(userForm.graduationYear) : null,
      })
      setUserForm(emptyUserForm)
      setMessage('User created')
      loadData()
    } catch (requestError) {
      setError(requestError.message)
    }
  }

  // Creates a course connected to the instructor selected in the form.
  const submitCourse = async (event) => {
    event.preventDefault()
    try {
      await createCourse({ ...courseForm, instructorId: Number(courseForm.instructorId) })
      setCourseForm({ ...courseForm, courseName: '', description: '' })
      setMessage('Course created')
      loadData()
    } catch (requestError) {
      setError(requestError.message)
    }
  }

  if (error && !metrics) return <ErrorMessage message={error} />
  if (!metrics) return <Loading text="Loading platform data…" />

  const cards = [
    ['Students', metrics.students], ['Instructors', metrics.instructors],
    ['Courses', metrics.courses], ['Quizzes', metrics.quizzes],
    ['Attempts', metrics.attempts], ['Passed', metrics.passed],
    ['Failed', metrics.failed], ['Average score', `${Math.round(metrics.averageScore)}%`],
  ]
  const instructors = users.filter((user) => user.role === 'ROLE_INSTRUCTOR')

  return (
    <>
      <div className="section-heading"><div><p className="eyebrow">LIVE DATABASE METRICS</p><h2>Platform overview</h2></div></div>
      <section className="stat-grid">{cards.map(([title, value]) => <article className="stat-card" key={title}><span>{title}</span><strong>{value}</strong></article>)}</section>
      <ErrorMessage message={error} />
      {message && <p className="success-message">{message}</p>}

      <div className="admin-forms">
        <form className="panel compact-form" onSubmit={submitUser}>
          <h2>Create user</h2>
          <label>Full name<input value={userForm.fullName} onChange={(event) => setUserForm({ ...userForm, fullName: event.target.value })} required /></label>
          <label>Email<input type="email" value={userForm.email} onChange={(event) => setUserForm({ ...userForm, email: event.target.value })} required /></label>
          <label>Password<input type="password" minLength="6" value={userForm.password} onChange={(event) => setUserForm({ ...userForm, password: event.target.value })} required /></label>
          <label>Role<select value={userForm.role} onChange={(event) => setUserForm({ ...userForm, role: event.target.value, courseIds: [] })}>{roles.map((role) => <option key={role}>{role}</option>)}</select></label>
          {userForm.role === 'ROLE_STUDENT' && <fieldset className="course-picker"><legend>Student courses</legend>{courses.map((course) => <label key={course.id}><input type="checkbox" checked={userForm.courseIds.includes(course.id)} onChange={(event) => setUserForm({ ...userForm, courseIds: event.target.checked ? [...userForm.courseIds, course.id] : userForm.courseIds.filter((id) => id !== course.id) })} />{course.courseName}</label>)}</fieldset>}
          {userForm.role === 'ROLE_STUDENT' && <>
            <label>Branch<input value={userForm.branch} onChange={(event) => setUserForm({ ...userForm, branch: event.target.value })} /></label>
            <label>Graduation year<input type="number" min="2000" max="2100" value={userForm.graduationYear} onChange={(event) => setUserForm({ ...userForm, graduationYear: event.target.value })} /></label>
          </>}
          {userForm.role === 'ROLE_INSTRUCTOR' && <>
            <label>Department<input value={userForm.department} onChange={(event) => setUserForm({ ...userForm, department: event.target.value })} /></label>
            <label>Qualifications<textarea value={userForm.qualifications} onChange={(event) => setUserForm({ ...userForm, qualifications: event.target.value })} /></label>
          </>}
          <button className="primary" disabled={userForm.role === 'ROLE_STUDENT' && userForm.courseIds.length === 0}>Create user</button>
        </form>

        <form className="panel compact-form" onSubmit={submitCourse}>
          <h2>Create course</h2>
          <label>Course name<input value={courseForm.courseName} onChange={(event) => setCourseForm({ ...courseForm, courseName: event.target.value })} required /></label>
          <label>Description<textarea value={courseForm.description} onChange={(event) => setCourseForm({ ...courseForm, description: event.target.value })} /></label>
          <label>Instructor<select value={courseForm.instructorId} onChange={(event) => setCourseForm({ ...courseForm, instructorId: event.target.value })} required>{instructors.map((user) => <option value={user.id} key={user.id}>{user.fullName}</option>)}</select></label>
          <button className="primary" disabled={!instructors.length}>Create course</button>
          {!instructors.length && <small>Create an instructor account first.</small>}
        </form>
      </div>

      <section className="panel">
        <div className="panel-heading"><div><p className="eyebrow">ROLE MANAGEMENT</p><h2>Users</h2></div></div>
        <table><thead><tr><th>Name</th><th>Email</th><th>Role</th><th>Role details</th><th>Subjects taught</th></tr></thead>
          <tbody>{users.map((user) => <tr key={user.id}><td><strong>{user.fullName}</strong></td><td>{user.email}</td><td><select value={user.role} onChange={(event) => updateRole(user.id, event.target.value)}>{roles.map((role) => <option key={role}>{role}</option>)}</select></td><td>{user.role === 'ROLE_STUDENT' ? ([user.branch, user.graduationYear && `Class of ${user.graduationYear}`].filter(Boolean).join(' · ') || 'Not added') : user.role === 'ROLE_INSTRUCTOR' ? (user.department || 'Not added') : '—'}</td><td>{user.role === 'ROLE_INSTRUCTOR' ? (user.subjects?.join(', ') || 'No subjects assigned') : '—'}</td></tr>)}</tbody>
        </table>
      </section>
    </>
  )
}
