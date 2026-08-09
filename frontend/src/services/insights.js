import { api } from './api'

export const getLeaderboard = () => api('/insights/leaderboard')
export const getStudentInsights = (studentId) => api(`/insights/students/${studentId}`)
export const getInstructorInsights = (instructorId) => api(`/insights/instructors/${instructorId}`)
export const getPlatformInsights = () => api('/insights/platform')
export const getActivityLogs = () => api('/insights/logs')
