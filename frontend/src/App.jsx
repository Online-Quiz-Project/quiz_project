import { useEffect, useState } from 'react'
import './App.css'
import AuthPage from './components/auth/AuthPage'
import AppLayout from './components/common/AppLayout'
import StudentDashboard from './components/student/StudentDashboard'
import QuizRunner from './components/student/QuizRunner'
import InstructorDashboard from './components/instructor/InstructorDashboard'
import QuizForm from './components/instructor/QuizForm'
import AdminDashboard from './components/admin/AdminDashboard'
import Leaderboard from './components/common/Leaderboard'
import InsightsDashboard from './components/common/InsightsDashboard'
import AnswerReview from './components/common/AnswerReview'
import { clearSession, getStoredUser } from './services/api'

// Keeps the signed-in user and current screen in one place, then sends each role
// to its own part of the application.
export default function App() {
  const [user, setUser] = useState(getStoredUser)
  const [page, setPage] = useState('Dashboard')
  const [quizId, setQuizId] = useState(null)
  const [refreshKey, setRefreshKey] = useState(0)
  const [draftQuiz, setDraftQuiz] = useState(null)
  const [answerKeyQuizId, setAnswerKeyQuizId] = useState(null)

  useEffect(() => {
    const clearExpiredSession = () => setUser(null)
    window.addEventListener('quizly:unauthorized', clearExpiredSession)
    return () => window.removeEventListener('quizly:unauthorized', clearExpiredSession)
  }, [])

  if (!user) return <AuthPage onAuthenticated={setUser} />

  let content
  if (answerKeyQuizId) {
    content = <AnswerReview quizId={answerKeyQuizId} instructorId={user.id} onClose={() => setAnswerKeyQuizId(null)} />
  } else if (quizId) {
    content = <QuizRunner quizId={quizId} studentId={user.id} onClose={() => setQuizId(null)} />
  } else if (page === 'Leaderboard') {
    content = <Leaderboard currentStudentId={user.role === 'ROLE_STUDENT' ? user.id : null} />
  } else if (page === 'Progress' || page === 'Analytics') {
    content = <InsightsDashboard role={user.role} userId={user.id} />
  } else if (page === 'Activity logs') {
    content = <InsightsDashboard role={user.role} userId={user.id} logsOnly />
  } else if (user.role === 'ROLE_STUDENT') {
    content = <StudentDashboard studentId={user.id} page={page} onStartQuiz={setQuizId} />
  } else if (user.role === 'ROLE_INSTRUCTOR' && page === 'Create quiz') {
    content = <QuizForm key={draftQuiz?.id || 'new'} instructorId={user.id} initialQuiz={draftQuiz} onSaved={() => { setDraftQuiz(null); setRefreshKey(refreshKey + 1); setPage('Dashboard') }} />
  } else if (user.role === 'ROLE_INSTRUCTOR') {
    content = <InstructorDashboard instructorId={user.id} refreshKey={refreshKey} onEdit={(quiz) => { setDraftQuiz(quiz); setPage('Create quiz') }} onViewAnswers={setAnswerKeyQuizId} />
  } else {
    content = <AdminDashboard />
  }

  return (
    <AppLayout
      user={user}
      page={page}
      onPageChange={(nextPage) => { setPage(nextPage); setQuizId(null); setAnswerKeyQuizId(null); if (nextPage === 'Create quiz') setDraftQuiz(null) }}
      onLogout={() => { clearSession(); setUser(null); setPage('Dashboard'); setQuizId(null); setDraftQuiz(null); setAnswerKeyQuizId(null) }}
    >
      {content}
    </AppLayout>
  )
}
