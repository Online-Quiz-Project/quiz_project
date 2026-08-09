import { useState } from 'react'
import LoginForm from './LoginForm'
import RegisterForm from './RegisterForm'

// Presents login and student registration as two views of the same welcome page.
export default function AuthPage({ onAuthenticated }) {
  const [showRegister, setShowRegister] = useState(false)

  return (
    <main className="auth-page">
      <section className="auth-story">
        <div className="brand auth-brand"><span className="brand-mark">Q</span><strong>Quizly</strong></div>
        <div><p className="eyebrow">LEARN · PRACTICE · GROW</p><h1>Small quizzes.<br />Meaningful progress.</h1><p>Student, instructor, and administrator tools powered by your course database.</p></div>
      </section>
      <section className="auth-form-side">
        {showRegister
          ? <RegisterForm onSuccess={onAuthenticated} onLogin={() => setShowRegister(false)} />
          : <LoginForm onSuccess={onAuthenticated} onRegister={() => setShowRegister(true)} />}
      </section>
    </main>
  )
}
