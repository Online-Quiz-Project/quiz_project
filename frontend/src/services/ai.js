import { getStoredUser } from './api'

const AI_API_URL = import.meta.env.VITE_AI_API_URL || 'http://localhost:8000/api'

async function aiApi(path, input) {
  let response
  try {
    const token = getStoredUser()?.token
    response = await fetch(`${AI_API_URL}${path}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        ...(token ? { Authorization: `Bearer ${token}` } : {}),
      },
      body: JSON.stringify(input),
    })
  } catch {
    throw new Error('Cannot connect to the AI service. Make sure the Python service is running.')
  }

  if (!response.ok) {
    const error = await response.json().catch(() => ({ detail: 'AI request failed' }))
    if (response.status === 401) {
      throw new Error('The AI service could not verify your login. Restart it with the same JWT_SECRET as Spring Boot.')
    }
    if (response.status === 403) throw new Error('You do not have permission to perform this action.')
    throw new Error(error.detail || error.message || 'AI request failed')
  }
  return response.json()
}

export const generateAiQuestions = (input) =>
  aiApi('/ai/questions/generate', input)

export const getAiHint = (input) =>
  aiApi('/ai/hint', input)

export const evaluateOpenAnswer = (input) =>
  aiApi('/ai/evaluate', input)
