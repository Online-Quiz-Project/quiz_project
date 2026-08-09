import { api } from './api'

// Opens a new timed attempt or resumes the student's current one.
export const startAttempt = (quizId, studentId) =>
  api(`/attempts/start?quizId=${quizId}&studentId=${studentId}`, { method: 'POST' })

// Sends all selected answers together for final server-side scoring.
export const submitAttempt = (attemptId, answers, timedOut = false, proctorWarnings = 0) =>
  api(`/attempts/${attemptId}/submit`, {
    method: 'POST',
    body: JSON.stringify({ answers, timedOut, proctorWarnings }),
  })

export const getAttemptReview = (attemptId, studentId) =>
  api(`/attempts/${attemptId}/review?studentId=${studentId}`)
