import { useMemo, useState } from 'react';
import Login from './pages/Login';
import Register from './pages/Register';
import Dashboard from './pages/Dashboard';
import Subjects from './pages/Subjects';
import data from './data';

function App() {
  const [page, setPage] = useState('landing');
  const [currentUser, setCurrentUser] = useState(null);
  const [users, setUsers] = useState(data.users);
  const [subjects, setSubjects] = useState(data.subjects);
  const [message, setMessage] = useState('');

  const login = ({ username, password }) => {
    const user = users.find(u => u.username === username && u.password === password);
    if (!user) {
      setMessage('Invalid username or password.');
      return false;
    }
    setCurrentUser(user);
    setPage('dashboard');
    setMessage('');
    return true;
  };

  const register = ({ name, email, username, password, role }) => {
    if (users.some(u => u.username === username)) {
      setMessage('This username is already taken.');
      return false;
    }
    const newUser = { id: `${Date.now()}`, name, email, username, password, role };
    setUsers(prev => [...prev, newUser]);
    setCurrentUser(newUser);
    setPage('dashboard');
    setMessage('');
    return true;
  };

  const logout = () => {
    setCurrentUser(null);
    setPage('landing');
    setMessage('You have logged out successfully.');
  };

  const addOrUpdateSubject = (subject) => {
    setSubjects((prev) => {
      const existingIndex = prev.findIndex((item) => item.id === subject.id);
      if (existingIndex >= 0) {
        const next = [...prev];
        next[existingIndex] = subject;
        return next;
      }
      return [...prev, subject];
    });
    setMessage(`Subject saved: ${subject.name}`);
  };

  const dashboardProps = useMemo(
    () => ({
      user: currentUser,
      subjects,
      users,
      logout,
      setPage,
      addOrUpdateSubject,
    }),
    [currentUser, users, subjects]
  );

  return (
    <div className="app-shell">
      <header className="topbar">
        <div>
          <strong>Quiz Showcase</strong>
        </div>
        <nav>
          {!currentUser && (
            <>
              <button onClick={() => { setPage('login'); setMessage(''); }}>Login</button>
              <button onClick={() => { setPage('register'); setMessage(''); }}>Register</button>
              <button onClick={() => setPage('subjects')}>Subjects</button>
            </>
          )}
          {currentUser && (
            <>
              <button onClick={() => setPage('dashboard')}>Dashboard</button>
              <button onClick={() => setPage('subjects')}>Subjects</button>
              <button onClick={logout}>Logout</button>
            </>
          )}
        </nav>
      </header>

      <main className="page-content">
        {message && <div className="message-banner">{message}</div>}

        {!currentUser && page === 'landing' && (
          <section className="hero-card">
            <h1>Online Quiz App for Students, Instructors and Admin</h1>
            <p>Browse CS subjects, sign in, and see role-specific dashboards with sample quizzes.</p>
            <div className="hero-actions">
              <button onClick={() => setPage('login')}>Login</button>
              <button onClick={() => setPage('register')}>Register</button>
            </div>
          </section>
        )}

        {!currentUser && page === 'login' && <Login onLogin={login} />}
        {!currentUser && page === 'register' && <Register onRegister={register} />}
        <Subjects
          visible={page === 'subjects'}
          subjects={subjects.filter((subject) => subject.published)}
          onDemo={() => setPage('login')}
        />

        {currentUser && page === 'dashboard' && <Dashboard {...dashboardProps} />}
      </main>
    </div>
  );
}

export default App;
