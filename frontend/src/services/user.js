import { api } from './api'

// Loads the student's identity and every course they have joined.
export const getStudentProfile = (studentId) =>
  api(`/students/${studentId}/profile`)

// Loads published quizzes belonging to the student's enrolled courses.
export const getStudentQuizzes = (studentId) =>
  api(`/quizzes/student/${studentId}`)

// Loads the complete course catalog from the database.
export const getCourses = () =>
  api('/courses')

// Adds one course to the signed-in student's enrollments.
export const enrollInCourse = (studentId, courseId) =>
  api(`/students/${studentId}/courses/${courseId}`, { method: 'POST' })

// Loads a quiz with its questions and answer options.
export const getQuiz = (quizId) =>
  api(`/quizzes/${quizId}`)
