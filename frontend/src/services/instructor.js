import { api } from './api'

// Loads every quiz owned by the instructor, including drafts.
export const getInstructorQuizzes = (instructorId) =>
  api(`/quizzes/instructor/${instructorId}`)

// Loads all subjects assigned to the instructor.
export const getInstructorCourses = (instructorId) =>
  api(`/instructors/${instructorId}/courses`)

// Loads the instructor-only department, office hours, and qualification details.
export const getInstructorProfile = (instructorId) =>
  api(`/instructors/${instructorId}/profile`)

// Saves a brand-new quiz and its entered questions.
export const createQuiz = (data) =>
  api('/quizzes', { method: 'POST', body: JSON.stringify(data) })

// Re-saves an existing draft or publishes it using the same quiz ID.
export const updateQuiz = (quizId, data) =>
  api(`/quizzes/${quizId}`, { method: 'PUT', body: JSON.stringify(data) })

// Supports adding a single question to an already saved quiz.
export const addQuestion = (quizId, instructorId, data) =>
  api(`/quizzes/${quizId}/questions?instructorId=${instructorId}`, {
    method: 'POST',
    body: JSON.stringify(data),
  })

export const getQuizAnswerKey = (quizId, instructorId) =>
  api(`/quizzes/${quizId}/answer-key?instructorId=${instructorId}`)

export const deleteQuiz = (quizId, instructorId) =>
  api(`/quizzes/${quizId}?instructorId=${instructorId}`, { method: 'DELETE' })
