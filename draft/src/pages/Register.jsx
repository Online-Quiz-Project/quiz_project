import { useState } from 'react';

export default function Register({ onRegister }) {
  const [name, setName] = useState('');
  const [email, setEmail] = useState('');
  const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [role, setRole] = useState('Student');

  const onSubmit = (event) => {
    event.preventDefault();
    onRegister({ name, email, username, password, role });
  };

  return (
    <div className="card page-card">
      <h2>Register</h2>
      <form onSubmit={onSubmit} className="form-grid">
        <label>
          Name
          <input value={name} onChange={(e) => setName(e.target.value)} placeholder="Full Name" required />
        </label>
        <label>
          Email
          <input type="email" value={email} onChange={(e) => setEmail(e.target.value)} placeholder="name@example.com" required />
        </label>
        <label>
          Username
          <input value={username} onChange={(e) => setUsername(e.target.value)} placeholder="quizuser" required />
        </label>
        <label>
          Password
          <input type="password" value={password} onChange={(e) => setPassword(e.target.value)} placeholder="password" required />
        </label>
        <label>
          Role
          <select value={role} onChange={(e) => setRole(e.target.value)}>
            <option>Student</option>
            <option>Instructor</option>
            <option>Admin</option>
          </select>
        </label>
        <button className="primary-btn" type="submit">Create Account</button>
      </form>
    </div>
  );
}
