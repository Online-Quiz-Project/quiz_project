import { useEffect, useState } from 'react'
import { getLeaderboard } from '../../services/insights'
import ErrorMessage from './ErrorMessage'
import Loading from './Loading'

export default function Leaderboard({ currentStudentId }) {
  const [leaders, setLeaders] = useState(null)
  const [error, setError] = useState('')

  useEffect(() => {
    let active = true
    const refresh = () => getLeaderboard()
      .then((data) => { if (active) { setLeaders(data); setError('') } })
      .catch((requestError) => { if (active) setError(requestError.message) })
    refresh()
    const timer = window.setInterval(refresh, 8000)
    return () => { active = false; window.clearInterval(timer) }
  }, [])

  if (!leaders && !error) return <Loading text="Ranking the quiz community…" />

  return (
    <>
      <div className="section-heading">
        <div><p className="eyebrow">UPDATES EVERY 8 SECONDS</p><h2>Live leaderboard</h2><p>Ranked by XP earned from quiz scores and pass bonuses.</p></div>
        <span className="live-pill"><i /> Live</span>
      </div>
      <ErrorMessage message={error} />
      {leaders?.length === 0 && <section className="panel empty-copy">Complete a quiz to claim the first place.</section>}
      {leaders?.length > 0 && (
        <>
          <section className="podium">
            {leaders.slice(0, 3).map((leader) => (
              <article className={`podium-card place-${leader.rank}`} key={leader.studentId}>
                <span className="rank-medal">{leader.rank === 1 ? '★' : `#${leader.rank}`}</span>
                <div className="large-avatar">{leader.name.slice(0, 2).toUpperCase()}</div>
                <h3>{leader.name}</h3><strong>{leader.xp} XP</strong><small>Level {leader.level}</small>
              </article>
            ))}
          </section>
          <section className="panel leaderboard-table">
            <table><thead><tr><th>Rank</th><th>Player</th><th>Level</th><th>Average</th><th>Completed</th><th>XP</th></tr></thead>
              <tbody>{leaders.map((leader) => (
                <tr className={leader.studentId === currentStudentId ? 'current-player' : ''} key={leader.studentId}>
                  <td><strong>#{leader.rank}</strong></td><td>{leader.name}{leader.studentId === currentStudentId && <span className="you-tag">You</span>}</td>
                  <td>{leader.level}</td><td>{leader.averageScore}%</td><td>{leader.quizzesCompleted}</td><td><strong>{leader.xp}</strong></td>
                </tr>
              ))}</tbody>
            </table>
          </section>
        </>
      )}
    </>
  )
}
