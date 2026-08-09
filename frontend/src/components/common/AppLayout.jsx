const navigation = {
  ROLE_STUDENT: ['Dashboard', 'Quizzes', 'Progress', 'Leaderboard', 'Profile'],
  ROLE_INSTRUCTOR: ['Dashboard', 'Create quiz', 'Analytics', 'Leaderboard'],
  ROLE_ADMIN: ['Dashboard', 'Analytics', 'Leaderboard', 'Activity logs'],
}

// Provides the shared navigation, account header, and content area around each
// role-specific screen.
export default function AppLayout({ user, page, onPageChange, onLogout, children }) {
  const items = navigation[user.role] || ['Dashboard']

  return (
    <div className="app-shell">
      <aside className="sidebar">
        <div className="brand"><span className="brand-mark">Q</span><strong>Quizly</strong></div>
        <nav>
          {items.map((item) => (
            <button
              key={item}
              className={page === item ? 'nav-item active' : 'nav-item'}
              onClick={() => onPageChange(item)}
            >
              <span className="nav-icon">◇</span><span>{item}</span>
            </button>
          ))}
        </nav>
      </aside>
      <div className="main-shell">
        <header className="topbar">
          <div><p className="eyebrow">ONLINE LEARNING</p><h1>{page}</h1></div>
          <div className="header-actions">
            <div className="avatar">{user.fullName.slice(0, 2).toUpperCase()}</div>
            <div className="person"><strong>{user.fullName}</strong><span>{user.role.replace('ROLE_', '')}</span></div>
            <button className="logout-button" onClick={onLogout}>Log out</button>
          </div>
        </header>
        <main>{children}</main>
      </div>
    </div>
  )
}
