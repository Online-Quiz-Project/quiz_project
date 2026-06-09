import { useState } from 'react';

export default function Login({ onLogin }) {
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');

  const onSubmit = (event) => {
    event.preventDefault();
    onLogin({ username, password });
  };

  return (
    <div className="card page-card">
      <h2>Login</h2>
      <form onSubmit={onSubmit} className="form-grid">
        <label>
          Username
          <input value={username} onChange={(e) => setUsername(e.target.value)} placeholder="student1" required />
        </label>
        <label>
          Password
          <input type="password" value={password} onChange={(e) => setPassword(e.target.value)} placeholder="student123" required />
        </label>
        <button className="primary-btn" type="submit">Sign In</button>
      </form>
      <p className="hint-text">Try student1 / student123, instructor1 / instructor123, or admin1 / admin123.</p>
    </div>
  );
}
