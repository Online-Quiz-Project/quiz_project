import { useEffect, useState } from 'react'
import { getActivityLogs, getInstructorInsights, getPlatformInsights, getStudentInsights } from '../../services/insights'
import ErrorMessage from './ErrorMessage'
import Loading from './Loading'

const percent = (value) => `${Math.round(Number(value || 0))}%`

export default function InsightsDashboard({ role, userId, logsOnly = false }) {
  const [data, setData] = useState(null)
  const [logs, setLogs] = useState(null)
  const [error, setError] = useState('')

  useEffect(() => {
    let active = true
    const load = () => {
      const request = logsOnly ? getActivityLogs()
        : role === 'ROLE_STUDENT' ? getStudentInsights(userId)
          : role === 'ROLE_INSTRUCTOR' ? getInstructorInsights(userId) : getPlatformInsights()
      request.then((result) => { if (active) { logsOnly ? setLogs(result) : setData(result); setError('') } })
        .catch((requestError) => { if (active) setError(requestError.message) })
    }
    load()
    const timer = window.setInterval(load, logsOnly ? 5000 : 15000)
    return () => { active = false; window.clearInterval(timer) }
  }, [logsOnly, role, userId])

  if (logsOnly) {
    if (!logs && !error) return <Loading text="Loading the activity stream…" />
    return (
      <>
        <div className="section-heading"><div><p className="eyebrow">AUDIT TRAIL · LIVE</p><h2>Platform activity logs</h2><p>Recent authentication and quiz events, newest first.</p></div><span className="live-pill"><i /> Live</span></div>
        <ErrorMessage message={error} />
        <section className="panel activity-stream">
          {logs?.length === 0 && <p className="empty-copy">New activity will appear here.</p>}
          {logs?.map((log) => <article key={log.id}><span className={`event-dot ${log.eventType.toLowerCase()}`} /><div><strong>{log.eventType.replaceAll('_', ' ')}</strong><p>{log.message}</p></div><time>{new Date(log.createdAt).toLocaleString()}</time></article>)}
        </section>
      </>
    )
  }

  if (!data && !error) return <Loading text="Calculating performance insights…" />

  const cards = role === 'ROLE_STUDENT'
    ? [['Leaderboard rank', data?.rank ? `#${data.rank}` : '—'], ['Total XP', data?.xp || 0], ['Current level', data?.level || 1], ['Pass streak', `${data?.streak || 0} 🔥`]]
    : role === 'ROLE_ADMIN'
      ? [['Completed attempts', data?.completed || 0], ['Attempts this week', data?.attemptsThisWeek || 0], ['Average score', percent(data?.averageScore)], ['Pass rate', percent(data?.passRate)]]
      : [['Student attempts', data?.completed || 0], ['Average score', percent(data?.averageScore)], ['Pass rate', percent(data?.passRate)], ['Avg. completion', `${Math.round(data?.averageDurationMinutes || 0)} min`]]

  return (
    <>
      <div className="section-heading"><div><p className="eyebrow">PERFORMANCE INTELLIGENCE</p><h2>{role === 'ROLE_STUDENT' ? 'Your progress' : 'Analytics overview'}</h2><p>Calculated from completed quiz attempts and refreshed automatically.</p></div></div>
      <ErrorMessage message={error} />
      <section className="stat-grid">{cards.map(([label, value]) => <article className="stat-card" key={label}><span>{label}</span><strong>{value}</strong></article>)}</section>

      {role === 'ROLE_STUDENT' && (
        <>
          <section className="panel level-panel"><div><p className="eyebrow">LEVEL {data.level}</p><h2>{data.xp} XP earned</h2><p>{data.xpToNextLevel} XP until your next level.</p></div><div className="xp-track"><span style={{ width: `${((data.xp % 500) / 500) * 100}%` }} /></div></section>
          <section className="panel"><div className="panel-heading"><div><p className="eyebrow">SCORE HISTORY</p><h2>Recent results</h2></div></div>
              <div className="score-bars">{data.recentScores?.map((item) => <div key={`${item.quiz}-${item.date}`}><span>{item.quiz}</span><div><i style={{ width: `${item.score}%` }} /></div><strong>{Math.round(item.score)}%</strong></div>)}</div>
          </section>
        </>
      )}

      {role === 'ROLE_INSTRUCTOR' && (
        <section className="panel"><div className="panel-heading"><div><p className="eyebrow">QUIZ PERFORMANCE</p><h2>Results by assessment</h2></div></div>
          <table><thead><tr><th>Quiz</th><th>Attempts</th><th>Average</th><th>Pass rate</th></tr></thead>
            <tbody>{data.quizPerformance?.map((item) => <tr key={item.quiz}><td><strong>{item.quiz}</strong></td><td>{item.attempts}</td><td>{percent(item.average)}</td><td>{percent(item.passRate)}</td></tr>)}</tbody>
          </table>
        </section>
      )}

      {role === 'ROLE_ADMIN' && (
        <div className="analytics-grid">
          <section className="panel"><div className="panel-heading"><div><p className="eyebrow">FUNNEL HEALTH</p><h2>Completion quality</h2></div></div>
            <div className="metric-row"><span>Completion rate</span><strong>{percent(data.completionRate)}</strong></div>
            <div className="metric-row"><span>Average duration</span><strong>{Math.round(data.averageDurationMinutes || 0)} min</strong></div>
          </section>
          <section className="panel"><div className="panel-heading"><div><p className="eyebrow">TOP PERFORMERS</p><h2>Highest XP</h2></div></div>
            {data.topPerformers?.map((item) => <div className="top-performer" key={item.studentId}><span>#{item.rank}</span><strong>{item.name}</strong><small>{item.xp} XP</small></div>)}
          </section>
        </div>
      )}
    </>
  )
}
