import { api, setSession } from './api'

// Signs in through the backend and stores the returned session for later requests.
export async function login(data) {
  const user = await api('/auth/login', { method: 'POST', body: JSON.stringify(data) })
  setSession(user)
  return user
}

// Creates a student account and starts its session immediately after registration.
export async function register(data) {
  const user = await api('/auth/register', { method: 'POST', body: JSON.stringify(data) })
  setSession(user)
  return user
}

// Loads real course choices for the public registration form.
export const getRegistrationCourses = () => api('/courses')
