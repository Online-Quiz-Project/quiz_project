-- Meaningful sample data for the nine-table role-separated Quizly schema.
-- Password hashing is currently disabled, so every sample account below uses:
-- password123

SET FOREIGN_KEY_CHECKS = 0;

TRUNCATE TABLE activity_logs;
TRUNCATE TABLE attempt_responses;
TRUNCATE TABLE quiz_attempts;
TRUNCATE TABLE question_options;
TRUNCATE TABLE questions;
TRUNCATE TABLE quizzes;
TRUNCATE TABLE course_enrollments;
TRUNCATE TABLE courses;
TRUNCATE TABLE instructors;
TRUNCATE TABLE students;
TRUNCATE TABLE users;

SET FOREIGN_KEY_CHECKS = 1;

-- Shared login and identity information.
INSERT INTO users (id, full_name, email, password_hash, role, created_at, updated_at) VALUES
(1, 'System Administrator', 'admin@quizly.local', 'password123', 'ROLE_ADMIN', NOW(), NOW()),
(2, 'Dr. Maya Sharma', 'maya.instructor@quizly.local', 'password123', 'ROLE_INSTRUCTOR', NOW(), NOW()),
(3, 'Prof. Daniel Lee', 'daniel.instructor@quizly.local', 'password123', 'ROLE_INSTRUCTOR', NOW(), NOW()),
(4, 'Aarav Patel', 'aarav.student@quizly.local', 'password123', 'ROLE_STUDENT', NOW(), NOW()),
(5, 'Sara Khan', 'sara.student@quizly.local', 'password123', 'ROLE_STUDENT', NOW(), NOW()),
(6, 'Noah Williams', 'noah.student@quizly.local', 'password123', 'ROLE_STUDENT', NOW(), NOW()),
(7, 'Meera Joshi', 'meera.student@quizly.local', 'password123', 'ROLE_STUDENT', NOW(), NOW());

INSERT INTO activity_logs (id, event_type, message, user_id, created_at, updated_at) VALUES
(1, 'QUIZ_SUBMITTED', 'Web Essentials scored 100.00%', 6, DATE_SUB(NOW(), INTERVAL 1 HOUR), NOW()),
(2, 'QUIZ_SUBMITTED', 'Java Foundations scored 100.00%', 5, DATE_SUB(NOW(), INTERVAL 3 HOUR), NOW()),
(3, 'USER_LOGIN', 'User logged in', 4, DATE_SUB(NOW(), INTERVAL 5 HOUR), NOW());

-- Role-specific profile information.
INSERT INTO instructors (user_id, department, qualifications) VALUES
(2, 'Computer Science', 'M.Tech in Computer Science; Java and database systems'),
(3, 'Information Technology', 'M.Sc. in Information Technology; web and cloud development');

INSERT INTO students (user_id, branch, graduation_year) VALUES
(4, 'Computer Science', 2027),
(5, 'Software Engineering', 2026),
(6, 'Information Technology', 2028),
(7, 'Data Science', 2027);

-- Each instructor teaches more than one subject across this sample catalog.
INSERT INTO courses (id, course_name, description, instructor_id, created_at, updated_at) VALUES
(1, 'Java Programming', 'Core Java, object-oriented programming, collections, and exceptions.', 2, NOW(), NOW()),
(2, 'Database Fundamentals', 'Relational design, SQL queries, keys, and normalization.', 2, NOW(), NOW()),
(3, 'Modern Web Development', 'HTML, CSS, JavaScript, React, and REST API basics.', 3, NOW(), NOW()),
(4, 'Cloud Computing Basics', 'Cloud services, deployment concepts, scaling, and availability.', 3, NOW(), NOW());

-- Students are enrolled in different combinations to test multi-course access.
INSERT INTO course_enrollments
    (id, course_id, student_id, enrolled_at, created_at, updated_at) VALUES
(1, 1, 4, NOW(), NOW(), NOW()),
(2, 2, 4, NOW(), NOW(), NOW()),
(3, 1, 5, NOW(), NOW(), NOW()),
(4, 3, 5, NOW(), NOW(), NOW()),
(5, 3, 6, NOW(), NOW(), NOW()),
(6, 4, 6, NOW(), NOW(), NOW()),
(7, 2, 7, NOW(), NOW(), NOW()),
(8, 3, 7, NOW(), NOW(), NOW());

-- Published quizzes appear to enrolled students; the draft remains editable.
INSERT INTO quizzes
    (id, course_id, created_by, title, description, time_limit_minutes,
     pass_percentage, status, created_at, updated_at) VALUES
(1, 1, 2, 'Java Foundations', 'A short check of Java and object-oriented basics.', 10, 60, 'PUBLISHED', NOW(), NOW()),
(2, 2, 2, 'SQL and Relational Design', 'Practice basic SQL and database relationships.', 12, 70, 'PUBLISHED', NOW(), NOW()),
(3, 3, 3, 'Web Essentials', 'HTML, CSS, JavaScript, and React fundamentals.', 10, 60, 'PUBLISHED', NOW(), NOW()),
(4, 4, 3, 'Cloud Services Draft', 'An unfinished quiz instructors can continue editing.', 15, 65, 'DRAFT', NOW(), NOW());

-- Both supported question types are represented.
INSERT INTO questions
    (id, quiz_id, question_text, question_type, points, display_order, created_at, updated_at) VALUES
(1, 1, 'Which keyword creates a class that inherits from another Java class?', 'MCQ', 1, 1, NOW(), NOW()),
(2, 1, 'Java supports object-oriented programming.', 'TRUE_FALSE', 1, 2, NOW(), NOW()),
(3, 2, 'Which SQL command reads rows from a table?', 'MCQ', 1, 1, NOW(), NOW()),
(4, 2, 'A primary key may contain duplicate values.', 'TRUE_FALSE', 1, 2, NOW(), NOW()),
(5, 3, 'Which React feature stores changing component data?', 'MCQ', 1, 1, NOW(), NOW()),
(6, 3, 'CSS is used to control the visual presentation of a web page.', 'TRUE_FALSE', 1, 2, NOW(), NOW()),
(7, 4, 'What does horizontal scaling usually add?', 'MCQ', 1, 1, NOW(), NOW());

INSERT INTO question_options
    (id, question_id, option_text, is_correct, display_order, created_at, updated_at) VALUES
(1, 1, 'extends', b'1', 1, NOW(), NOW()),
(2, 1, 'imports', b'0', 2, NOW(), NOW()),
(3, 1, 'implements', b'0', 3, NOW(), NOW()),
(4, 1, 'inherits', b'0', 4, NOW(), NOW()),
(5, 2, 'True', b'1', 1, NOW(), NOW()),
(6, 2, 'False', b'0', 2, NOW(), NOW()),
(7, 3, 'SELECT', b'1', 1, NOW(), NOW()),
(8, 3, 'UPDATE', b'0', 2, NOW(), NOW()),
(9, 3, 'DELETE', b'0', 3, NOW(), NOW()),
(10, 3, 'DROP', b'0', 4, NOW(), NOW()),
(11, 4, 'True', b'0', 1, NOW(), NOW()),
(12, 4, 'False', b'1', 2, NOW(), NOW()),
(13, 5, 'State', b'1', 1, NOW(), NOW()),
(14, 5, 'Route', b'0', 2, NOW(), NOW()),
(15, 5, 'Style sheet', b'0', 3, NOW(), NOW()),
(16, 5, 'Database table', b'0', 4, NOW(), NOW()),
(17, 6, 'True', b'1', 1, NOW(), NOW()),
(18, 6, 'False', b'0', 2, NOW(), NOW()),
(19, 7, 'More server instances', b'1', 1, NOW(), NOW()),
(20, 7, 'More memory in one server', b'0', 2, NOW(), NOW()),
(21, 7, 'A longer password', b'0', 3, NOW(), NOW()),
(22, 7, 'A local text file', b'0', 4, NOW(), NOW());

-- Completed attempts provide meaningful pass/fail and average-score metrics.
INSERT INTO quiz_attempts
    (id, quiz_id, student_id, started_at, server_deadline, submitted_at,
     score, total_questions, correct_answers, status, created_at, updated_at) VALUES
(1, 1, 4, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 10 MINUTE),
 DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 6 MINUTE), 100.00, 2, 2, 'SUBMITTED', NOW(), NOW()),
(2, 2, 4, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 12 MINUTE),
 DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 8 MINUTE), 50.00, 2, 1, 'SUBMITTED', NOW(), NOW()),
(3, 1, 5, DATE_SUB(NOW(), INTERVAL 3 HOUR), DATE_ADD(DATE_SUB(NOW(), INTERVAL 3 HOUR), INTERVAL 10 MINUTE),
 DATE_ADD(DATE_SUB(NOW(), INTERVAL 3 HOUR), INTERVAL 7 MINUTE), 100.00, 2, 2, 'SUBMITTED', NOW(), NOW()),
(4, 3, 5, DATE_SUB(NOW(), INTERVAL 2 HOUR), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 HOUR), INTERVAL 10 MINUTE),
 DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 HOUR), INTERVAL 10 MINUTE), 50.00, 2, 1, 'AUTO_SUBMITTED', NOW(), NOW()),
(5, 3, 6, DATE_SUB(NOW(), INTERVAL 1 HOUR), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 HOUR), INTERVAL 10 MINUTE),
 DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 HOUR), INTERVAL 5 MINUTE), 100.00, 2, 2, 'SUBMITTED', NOW(), NOW());
