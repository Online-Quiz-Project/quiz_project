const data = {
  users: [
    { id: 's1', name: 'Alice Student', email: 'alice.student@example.com', username: 'student1', password: 'student123', role: 'Student' },
    { id: 'i1', name: 'Brian Instructor', email: 'brian.instructor@example.com', username: 'instructor1', password: 'instructor123', role: 'Instructor' },
    { id: 'a1', name: 'Carla Admin', email: 'carla.admin@example.com', username: 'admin1', password: 'admin123', role: 'Admin' }
  ],
  subjects: [
    {
      id: 'java',
      name: 'Java',
      description: 'Object-oriented programming, collections, exceptions, and Java basics.',
      instructor: 'Brian Instructor',
      published: true,
      quiz: {
        title: 'Java Basics',
        questions: [
          {
            text: 'What is the correct way to declare a Java class?',
            options: ['class MyApp {}', 'MyApp class {}', 'def MyApp {}', 'public MyApp {}'],
            answer: 'class MyApp {}'
          },
          {
            text: 'Which collection stores key-value pairs?',
            options: ['ArrayList', 'HashMap', 'LinkedList', 'Stack'],
            answer: 'HashMap'
          }
        ]
      }
    },
    {
      id: 'cpp',
      name: 'C++',
      description: 'Core C++ structures, memory management, classes, and standard templates.',
      instructor: 'Brian Instructor',
      published: true,
      quiz: {
        title: 'C++ Essentials',
        questions: [
          {
            text: 'Which operator is used for scope resolution in C++?',
            options: ['::', '->', '.', '=='],
            answer: '::'
          },
          {
            text: 'Which container class holds elements in sorted order?',
            options: ['vector', 'map', 'stack', 'queue'],
            answer: 'map'
          }
        ]
      }
    },
    {
      id: 'react',
      name: 'React',
      description: 'Basics of components, JSX, state, props, and hooks for UI development.',
      instructor: 'Brian Instructor',
      published: true,
      quiz: {
        title: 'React Fundamentals',
        questions: [
          {
            text: 'What hook is used to manage state in a functional component?',
            options: ['useEffect', 'useState', 'useMemo', 'useRef'],
            answer: 'useState'
          },
          {
            text: 'What is JSX in React?',
            options: ['A styling system', 'A templating language', 'JavaScript XML syntax', 'A routing library'],
            answer: 'JavaScript XML syntax'
          }
        ]
      }
    }
  ]
};

export default data;
