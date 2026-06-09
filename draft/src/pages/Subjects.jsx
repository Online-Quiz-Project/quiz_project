export default function Subjects({ visible, subjects, onDemo }) {
  if (!visible) return null;

  return (
    <div className="card page-card">
      <h2>CS Subjects</h2>
      <div className="subject-grid">
        {subjects.map((subject) => (
          <article key={subject.id} className="subject-card">
            <h3>{subject.name}</h3>
            <p>{subject.description}</p>
            <p><strong>Instructor:</strong> {subject.instructor}</p>
            <p><strong>Quiz:</strong> {subject.quiz.title}</p>
          </article>
        ))}
      </div>
      <div className="cta-row">
        <button className="primary-btn" onClick={onDemo}>Login to try sample dashboards</button>
      </div>
    </div>
  );
}
