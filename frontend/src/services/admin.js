import { api } from './api'

// Loads the counts and results displayed in the admin summary cards.
export const getAdminMetrics = () => api('/admin/metrics')
// Loads accounts with their current roles and related subject information.
export const getUsers = () => api('/admin/users')
// Changes only one user's role without replacing the rest of the account.
export const changeUserRole = (userId, role) =>
  api(`/admin/users/${userId}/role`, { method: 'PATCH', body: JSON.stringify({ role }) })
// Creates a user from the admin panel, including any selected student courses.
export const createUser = (data) =>
  api('/admin/users', { method: 'POST', body: JSON.stringify(data) })
// Creates a course and sends the selected instructor assignment with it.
export const createCourse = (data) =>
  api('/admin/courses', { method: 'POST', body: JSON.stringify(data) })
