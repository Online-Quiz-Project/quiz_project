import { useState } from 'react'
import { login } from '../../services/auth'
import ErrorMessage from '../common/ErrorMessage'

// Collects account credentials and hands a successful database login back to App.
export default function LoginForm({ onSuccess, onRegister }) {
  const [form, setForm] = useState({ email: '', password: '' })
  const [error, setError] = useState('')
  const [loading, setLoading] = useState(false)

  // Prevents a normal page refresh while login is checked and keeps request
  // errors beside the form where the user can act on them.
  const submit = async (event) => {
    event.preventDefault()
    setLoading(true)
    setError('')
    try {
      onSuccess(await login(form))
    } catch (requestError) {
      setError(requestError.message)
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="auth-card">
      <p className="eyebrow">WELCOME BACK</p>
      <h2>Sign in to continue</h2>
      <p className="auth-intro">Use the email and password stored in your database.</p>
      <form onSubmit={submit}>
        <label>Email address<input type="email" value={form.email} onChange={(event) => setForm({ ...form, email: event.target.value })} required /></label>
        <label>Password<input type="password" value={form.password} onChange={(event) => setForm({ ...form, password: event.target.value })} required /></label>
        <ErrorMessage message={error} />
        <button className="primary auth-submit" disabled={loading}>{loading ? 'Signing in…' : 'Sign in'}</button>
      </form>
      <p className="auth-switch">New to Quizly? <button onClick={onRegister}>Create an account</button></p>
    </div>
  )
}
