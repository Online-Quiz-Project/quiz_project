const API_URL = import.meta.env.VITE_API_URL || 'http://localhost:8080/api'

// Saves the small amount of profile data needed to restore this browser tab.
export function setSession(user) {
  // Login currently controls which screens are shown; backend authorization is disabled.
  sessionStorage.setItem('quizlyUser', JSON.stringify({
    id: user.id,
    fullName: user.fullName,
    email: user.email,
    role: user.role,
    token: user.token,
  }))
}

export function getStoredUser() {
  const saved = sessionStorage.getItem('quizlyUser')
  if (!saved) return null
  try {
    return JSON.parse(saved)
  } catch {
    clearSession()
    return null
  }
}

// Removes all local login data when the user signs out or stored data is invalid.
export function clearSession() {
  sessionStorage.removeItem('quizlyUser')
}

// Provides one shared request path for JSON handling and readable backend errors.
export async function api(path, options = {}) {
  let response
  const hasBody = options.body !== undefined
  try {
    const token = getStoredUser()?.token
    response = await fetch(`${API_URL}${path}`, {
      ...options,
      headers: {
        // GET requests without a body do not need a JSON content type and can avoid
        // an unnecessary browser preflight.
        ...(hasBody ? { 'Content-Type': 'application/json' } : {}),
        ...(token ? { Authorization: `Bearer ${token}` } : {}),
        ...options.headers,
      },
    })
  } catch {
    throw new Error('Cannot connect to the backend. Make sure Spring Boot is running on port 8080.')
  }

  if (!response.ok) {
    const error = await response.json().catch(() => ({ message: 'Request failed' }))
    if (response.status === 401) {
      clearSession()
      window.dispatchEvent(new Event('quizly:unauthorized'))
      throw new Error('Your session has expired. Please sign in again.')
    }
    if (response.status === 403) {
      throw new Error('You do not have permission to perform this action.')
    }
    throw new Error(error.message || 'Request failed')
  }

  return response.status === 204 ? null : response.json()
}
