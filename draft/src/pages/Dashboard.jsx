import { useEffect, useMemo, useState } from 'react';

export default function Dashboard({ user, subjects, users, logout, setPage, addOrUpdateSubject }) {
  const [panel, setPanel] = useState('overview');
  const [quizSubjectId, setQuizSubjectId] = useState('');
  const [answers, setAnswers] = useState({});
  const [quizResult, setQuizResult] = useState(null);
  const [selectedCreateSubjectId, setSelectedCreateSubjectId] = useState('new');
  const [newSubject, setNewSubject] = useState('');
  const [newDescription, setNewDescription] = useState('');
  const [newQuizTitle, setNewQuizTitle] = useState('');
  const [newQuestions, setNewQuestions] = useState([]);
  const [newQuestionText, setNewQuestionText] = useState('');
  const [newQuestionOptions, setNewQuestionOptions] = useState(['', '', '', '']);
  const [newQuestionAnswer, setNewQuestionAnswer] = useState('');

  const userSubjects = useMemo(() => {
    if (user.role === 'Student') {
      return subjects.filter((item) => item.published);
    }
    if (user.role === 'Instructor') {
      return subjects.filter((item) => item.instructor === user.name);
    }
    return subjects.filter((item) => item.published);
  }, [user, subjects]);

  const students = useMemo(() => users.filter((item) => item.role === 'Student'), [users]);
  const instructors = useMemo(() => users.filter((item) => item.role === 'Instructor'), [users]);

  useEffect(() => {
    if (!quizSubjectId && userSubjects.length > 0) {
      setQuizSubjectId(userSubjects[0].id);
      setAnswers({});
      setQuizResult(null);
    }
  }, [quizSubjectId, userSubjects]);

  const selectedQuiz = userSubjects.find((subject) => subject.id === quizSubjectId) || userSubjects[0];
  const selectedCreateSubject = selectedCreateSubjectId === 'new'
    ? null
    : userSubjects.find((subject) => subject.id === selectedCreateSubjectId);

  const currentDraftQuestion = newQuestionText && !newQuestionOptions.some((option) => !option) && newQuestionAnswer
    ? {
      text: newQuestionText,
      options: [...newQuestionOptions],
      answer: newQuestionAnswer,
    }
    : null;

  const handleAnswer = (questionIndex, option) => {
    setAnswers((prev) => ({ ...prev, [questionIndex]: option }));
  };

  const submitQuiz = (event) => {
    event.preventDefault();
    if (!selectedQuiz) return;
    const score = selectedQuiz.quiz.questions.reduce((count, question, index) => {
      return count + (answers[index] === question.answer ? 1 : 0);
    }, 0);
    setQuizResult({ score, total: selectedQuiz.quiz.questions.length });
  };

  const handleNewOption = (index, value) => {
    setNewQuestionOptions((prev) => prev.map((item, idx) => (idx === index ? value : item)));
  };

  const addQuestion = (event) => {
    event.preventDefault();
    if (!newQuestionText || newQuestionOptions.some((option) => !option) || !newQuestionAnswer) {
      return;
    }
    setNewQuestions((prev) => [
      ...prev,
      {
        text: newQuestionText,
        options: [...newQuestionOptions],
        answer: newQuestionAnswer,
      },
    ]);
    setNewQuestionText('');
    setNewQuestionOptions(['', '', '', '']);
    setNewQuestionAnswer('');
  };

  const addQuizSubject = (event) => {
    event.preventDefault();

    const draftQuestion = currentDraftQuestion;
    const questionsToSave = [...newQuestions];
    if (draftQuestion) {
      questionsToSave.push(draftQuestion);
    }

    if (selectedCreateSubject) {
      if (questionsToSave.length === 0) {
        return;
      }
      addOrUpdateSubject({
        ...selectedCreateSubject,
        pendingQuestions: [
          ...(selectedCreateSubject.pendingQuestions || []),
          ...questionsToSave,
        ],
      });
    } else {
      if (!newSubject || !newQuizTitle || questionsToSave.length === 0) {
        return;
      }
      const nextId = `${newSubject.toLowerCase().replace(/[^a-z0-9]+/g, '-')}-${Date.now()}`;
      addOrUpdateSubject({
        id: nextId,
        name: newSubject,
        description: newDescription || 'New quiz subject added by instructor.',
        instructor: user.name,
        published: false,
        quiz: {
          title: newQuizTitle,
          questions: [],
        },
        pendingQuestions: questionsToSave,
      });
      setSelectedCreateSubjectId(nextId);
    }

    setNewQuestions([]);
    setNewQuestionText('');
    setNewQuestionOptions(['', '', '', '']);
    setNewQuestionAnswer('');
  };

  const publishSubject = (event) => {
    event.preventDefault();

    const draftQuestion = currentDraftQuestion;
    const questionsToPublish = [...newQuestions];
    if (draftQuestion) {
      questionsToPublish.push(draftQuestion);
    }

    if (selectedCreateSubject) {
      const storedPending = selectedCreateSubject.pendingQuestions || [];
      const finalQuestions = [...storedPending, ...questionsToPublish];
      if (finalQuestions.length === 0) {
        return;
      }
      addOrUpdateSubject({
        ...selectedCreateSubject,
        pendingQuestions: [],
        published: true,
        quiz: {
          ...selectedCreateSubject.quiz,
          questions: [
            ...(selectedCreateSubject.quiz.questions || []),
            ...finalQuestions,
          ],
        },
      });
    } else {
      if (!newSubject || !newQuizTitle || questionsToPublish.length === 0) {
        return;
      }
      const nextId = `${newSubject.toLowerCase().replace(/[^a-z0-9]+/g, '-')}-${Date.now()}`;
      addOrUpdateSubject({
        id: nextId,
        name: newSubject,
        description: newDescription || 'New quiz subject added by instructor.',
        instructor: user.name,
        published: true,
        quiz: {
          title: newQuizTitle,
          questions: questionsToPublish,
        },
      });
      setSelectedCreateSubjectId(nextId);
    }

    setNewQuestions([]);
    setNewQuestionText('');
    setNewQuestionOptions(['', '', '', '']);
    setNewQuestionAnswer('');
  };

  return (
    <div className="card dashboard-card">
      <div className="dashboard-header">
        <div>
          <h2>Welcome back, {user.name}</h2>
          <p className="muted">Role: {user.role}</p>
        </div>
        <div>
          <button className="secondary-btn" onClick={logout}>Logout</button>
        </div>
      </div>

      <div className="tabs-row">
        <button className={panel === 'overview' ? 'tab active' : 'tab'} onClick={() => setPanel('overview')}>
          Overview
        </button>
        <button className={panel === 'subjects' ? 'tab active' : 'tab'} onClick={() => setPanel('subjects')}>
          Subjects
        </button>
        <button className={panel === 'quiz' ? 'tab active' : 'tab'} onClick={() => setPanel('quiz')}>
          {user.role === 'Student' ? 'Take Quiz' : 'Quiz Preview'}
        </button>
        {user.role === 'Instructor' && (
          <button className={panel === 'create' ? 'tab active' : 'tab'} onClick={() => setPanel('create')}>
            Add Quiz
          </button>
        )}
        {user.role === 'Admin' && (
          <button className={panel === 'users' ? 'tab active' : 'tab'} onClick={() => setPanel('users')}>
            Users
          </button>
        )}
      </div>

      {panel === 'overview' && (
        <section className="panel-content">
          {user.role === 'Student' && (
            <>
              <h3>Student overview</h3>
              <p>Select the subject you want to quiz yourself on and answer the questions.</p>
              <div className="summary-grid">
                <div className="summary-card">
                  <strong>{subjects.length}</strong>
                  <span>Available subjects</span>
                </div>
                <div className="summary-card">
                  <strong>2</strong>
                  <span>Completed quizzes</span>
                </div>
                <div className="summary-card">
                  <strong>82%</strong>
                  <span>Average score</span>
                </div>
              </div>
            </>
          )}

          {user.role === 'Instructor' && (
            <>
              <h3>Instructor overview</h3>
              <p>Create a new quiz topic, then share it with students right from the dashboard.</p>
              <div className="summary-grid">
                <div className="summary-card">
                  <strong>{userSubjects.length}</strong>
                  <span>Your subjects</span>
                </div>
                <div className="summary-card">
                  <strong>3</strong>
                  <span>Active quizzes</span>
                </div>
                <div className="summary-card">
                  <strong>{students.length}</strong>
                  <span>Students</span>
                </div>
              </div>
            </>
          )}

          {user.role === 'Admin' && (
            <>
              <h3>Admin overview</h3>
              <p>Manage users, monitor roles, and keep the quiz system running smoothly.</p>
              <div className="summary-grid">
                <div className="summary-card">
                  <strong>{users.length}</strong>
                  <span>Total users</span>
                </div>
                <div className="summary-card">
                  <strong>{students.length}</strong>
                  <span>Students</span>
                </div>
                <div className="summary-card">
                  <strong>{instructors.length}</strong>
                  <span>Instructors</span>
                </div>
              </div>
            </>
          )}
        </section>
      )}

      {panel === 'subjects' && (
        <section className="panel-content">
          <h3>Subject list</h3>
          <div className="subject-grid">
            {userSubjects.map((subject) => (
              <article key={subject.id} className="subject-card">
                <h4>{subject.name}</h4>
                <p>{subject.description}</p>
                <p><strong>Instructor:</strong> {subject.instructor}</p>
                <p><strong>Quiz:</strong> {subject.quiz.title}</p>
              </article>
            ))}
          </div>
        </section>
      )}

      {panel === 'quiz' && (
        <section className="panel-content">
          <h3>{user.role === 'Student' ? 'Choose a quiz and answer questions' : 'Quiz preview'}</h3>
          {selectedQuiz ? (
            <div className="quiz-card">
              <label>
                Select subject
                <select
                  value={quizSubjectId}
                  onChange={(e) => {
                    setQuizSubjectId(e.target.value);
                    setAnswers({});
                    setQuizResult(null);
                  }}
                >
                  {userSubjects.map((subject) => (
                    <option key={subject.id} value={subject.id}>{subject.name}</option>
                  ))}
                </select>
              </label>

              <h4>{selectedQuiz.quiz.title}</h4>
              <p><strong>Subject:</strong> {selectedQuiz.name}</p>

              <form onSubmit={submitQuiz} className="form-grid">
                {selectedQuiz.quiz.questions.map((question, index) => (
                  <div key={index} className="question-block">
                    <p>{index + 1}. {question.text}</p>
                    <div className="options-grid">
                      {question.options.map((option) => (
                        <label key={option} className={answers[index] === option ? 'option selected' : 'option'}>
                          <input
                            type="radio"
                            name={`question-${index}`}
                            value={option}
                            checked={answers[index] === option}
                            onChange={() => handleAnswer(index, option)}
                          />
                          {option}
                        </label>
                      ))}
                    </div>
                  </div>
                ))}
                {user.role === 'Student' && <button className="primary-btn" type="submit">Submit Answers</button>}
              </form>
              {quizResult && (
                <div className="message-banner">
                  You scored {quizResult.score} out of {quizResult.total} for {selectedQuiz.name}.
                </div>
              )}
            </div>
          ) : (
            <p>No quizzes available for your role.</p>
          )}
        </section>
      )}

      {panel === 'create' && user.role === 'Instructor' && (
        <section className="panel-content">
          <h3>Add questions to a subject</h3>
          <form className="form-grid" onSubmit={addQuizSubject}>
            <label>
              Select subject
              <select value={selectedCreateSubjectId} onChange={(e) => setSelectedCreateSubjectId(e.target.value)}>
                <option value="new">Create new subject</option>
                {userSubjects.map((subject) => (
                  <option key={subject.id} value={subject.id}>{subject.name}</option>
                ))}
              </select>
            </label>

            {!selectedCreateSubject && (
              <>
                <label>
                  Subject name
                  <input value={newSubject} onChange={(e) => setNewSubject(e.target.value)} placeholder="Python or Algorithms" required />
                </label>
                <label>
                  Description
                  <input value={newDescription} onChange={(e) => setNewDescription(e.target.value)} placeholder="Short subject description" />
                </label>
                <label>
                  Quiz title
                  <input value={newQuizTitle} onChange={(e) => setNewQuizTitle(e.target.value)} placeholder="Intro quiz" required />
                </label>
              </>
            )}

            {selectedCreateSubject && (
              <div className="subject-preview">
                <p><strong>Adding to:</strong> {selectedCreateSubject.name}</p>
                <p>{selectedCreateSubject.description}</p>
                <p><strong>Current quiz:</strong> {selectedCreateSubject.quiz.title}</p>
                <p><strong>Status:</strong> {selectedCreateSubject.published ? 'Published' : 'Draft'}</p>
                {selectedCreateSubject.pendingQuestions?.length > 0 && (
                  <p><strong>Pending questions:</strong> {selectedCreateSubject.pendingQuestions.length}</p>
                )}
              </div>
            )}

            <div className="question-builder">
              <h4>Add questions</h4>
              <label>
                Question text
                <input value={newQuestionText} onChange={(e) => setNewQuestionText(e.target.value)} placeholder="Example: What is ..." />
              </label>
              <div className="options-grid">
                {newQuestionOptions.map((option, index) => (
                  <label key={index} className="option-block">
                    Option {index + 1}
                    <input value={option} onChange={(e) => handleNewOption(index, e.target.value)} />
                  </label>
                ))}
              </div>
              <label>
                Correct answer
                <input value={newQuestionAnswer} onChange={(e) => setNewQuestionAnswer(e.target.value)} placeholder="Exact option text" />
              </label>
              <button className="secondary-btn" type="button" onClick={addQuestion}>Add Question</button>
            </div>

            {newQuestions.length > 0 && (
              <div className="question-review">
                <h4>Questions added</h4>
                {newQuestions.map((question, index) => (
                  <div key={index} className="question-block">
                    <p><strong>Q{index + 1}:</strong> {question.text}</p>
                    <p><strong>Answer:</strong> {question.answer}</p>
                  </div>
                ))}
              </div>
            )}

            <div className="action-row">
              <button className="secondary-btn" type="button" onClick={addQuizSubject}>Save draft</button>
              <button className="primary-btn" type="button" onClick={publishSubject}>
                {selectedCreateSubject ? 'Publish changes' : 'Publish quiz'}
              </button>
            </div>
          </form>
        </section>
      )}

      {panel === 'users' && user.role === 'Admin' && (
        <section className="panel-content">
          <h3>User management</h3>
          <div className="table-card">
            <table>
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Username</th>
                  <th>Email</th>
                  <th>Role</th>
                </tr>
              </thead>
              <tbody>
                {users.map((person) => (
                  <tr key={person.id}>
                    <td>{person.name}</td>
                    <td>{person.username}</td>
                    <td>{person.email}</td>
                    <td>{person.role}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
          <p className="hint-text">Admins can view registered users and system roles for showcase use.</p>
        </section>
      )}

      <footer className="dashboard-footer">
        <button className="secondary-btn" onClick={() => setPage('subjects')}>Browse available subjects</button>
      </footer>
    </div>
  );
}
