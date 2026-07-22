-- =============================================
-- COMPREHENSIVE SAMPLE DATA - LARGE DATASET
-- =============================================

-- Disable foreign key checks for clean insertion
SET FOREIGN_KEY_CHECKS = 0;

-- Clean existing data (optional - uncomment if you want to clear first)
-- TRUNCATE TABLE attempt_answers;
-- TRUNCATE TABLE quiz_attempts;
-- TRUNCATE TABLE question_options;
-- TRUNCATE TABLE questions;
-- TRUNCATE TABLE quizzes;
-- TRUNCATE TABLE course_enrollments;
-- TRUNCATE TABLE courses;
-- TRUNCATE TABLE users;

-- =============================================
-- 1. USERS (5 Instructors, 20 Students)
-- =============================================
INSERT INTO `users` (`email`, `full_name`, `password_hash`, `role`, `created_at`, `updated_at`) VALUES
-- Instructors
('prof.smith@university.edu', 'Prof. John Smith', '$2a$10$YourHashedPasswordHere1', 'ROLE_INSTRUCTOR', NOW(), NOW()),
('prof.jones@university.edu', 'Dr. Sarah Jones', '$2a$10$YourHashedPasswordHere2', 'ROLE_INSTRUCTOR', NOW(), NOW()),
('prof.wilson@university.edu', 'Dr. Michael Wilson', '$2a$10$YourHashedPasswordHere3', 'ROLE_INSTRUCTOR', NOW(), NOW()),
('prof.brown@university.edu', 'Prof. Emily Brown', '$2a$10$YourHashedPasswordHere4', 'ROLE_INSTRUCTOR', NOW(), NOW()),
('prof.davis@university.edu', 'Dr. Robert Davis', '$2a$10$YourHashedPasswordHere5', 'ROLE_INSTRUCTOR', NOW(), NOW()),

-- Students
('alice@student.edu', 'Alice Johnson', '$2a$10$YourHashedPasswordHere6', 'ROLE_STUDENT', NOW(), NOW()),
('bob@student.edu', 'Bob Williams', '$2a$10$YourHashedPasswordHere7', 'ROLE_STUDENT', NOW(), NOW()),
('carol@student.edu', 'Carol Davis', '$2a$10$YourHashedPasswordHere8', 'ROLE_STUDENT', NOW(), NOW()),
('dave@student.edu', 'Dave Martinez', '$2a$10$YourHashedPasswordHere9', 'ROLE_STUDENT', NOW(), NOW()),
('eve@student.edu', 'Eve Thompson', '$2a$10$YourHashedPasswordHere10', 'ROLE_STUDENT', NOW(), NOW()),
('frank@student.edu', 'Frank Garcia', '$2a$10$YourHashedPasswordHere11', 'ROLE_STUDENT', NOW(), NOW()),
('grace@student.edu', 'Grace Rodriguez', '$2a$10$YourHashedPasswordHere12', 'ROLE_STUDENT', NOW(), NOW()),
('henry@student.edu', 'Henry Wilson', '$2a$10$YourHashedPasswordHere13', 'ROLE_STUDENT', NOW(), NOW()),
('ivy@student.edu', 'Ivy Anderson', '$2a$10$YourHashedPasswordHere14', 'ROLE_STUDENT', NOW(), NOW()),
('jack@student.edu', 'Jackson Thomas', '$2a$10$YourHashedPasswordHere15', 'ROLE_STUDENT', NOW(), NOW()),
('karen@student.edu', 'Karen Moore', '$2a$10$YourHashedPasswordHere16', 'ROLE_STUDENT', NOW(), NOW()),
('leo@student.edu', 'Leo Martin', '$2a$10$YourHashedPasswordHere17', 'ROLE_STUDENT', NOW(), NOW()),
('mia@student.edu', 'Mia Jackson', '$2a$10$YourHashedPasswordHere18', 'ROLE_STUDENT', NOW(), NOW()),
('noah@student.edu', 'Noah White', '$2a$10$YourHashedPasswordHere19', 'ROLE_STUDENT', NOW(), NOW()),
('olivia@student.edu', 'Olivia Harris', '$2a$10$YourHashedPasswordHere20', 'ROLE_STUDENT', NOW(), NOW()),
('peter@student.edu', 'Peter Lee', '$2a$10$YourHashedPasswordHere21', 'ROLE_STUDENT', NOW(), NOW()),
('quinn@student.edu', 'Quinn Taylor', '$2a$10$YourHashedPasswordHere22', 'ROLE_STUDENT', NOW(), NOW()),
('rose@student.edu', 'Rose Green', '$2a$10$YourHashedPasswordHere23', 'ROLE_STUDENT', NOW(), NOW()),
('sam@student.edu', 'Sam Adams', '$2a$10$YourHashedPasswordHere24', 'ROLE_STUDENT', NOW(), NOW()),
('tina@student.edu', 'Tina Nelson', '$2a$10$YourHashedPasswordHere25', 'ROLE_STUDENT', NOW(), NOW());

-- =============================================
-- 2. COURSES (10 Courses across departments)
-- =============================================
INSERT INTO `courses` (`course_name`, `description`, `instructor_id`, `created_at`, `updated_at`) VALUES
                                                                                                      ('Introduction to Computer Science', 'Fundamental concepts of programming and computer science', 1, NOW(), NOW()),
                                                                                                      ('Data Structures and Algorithms', 'Advanced data structures and algorithm design', 1, NOW(), NOW()),
                                                                                                      ('Database Systems', 'Relational databases, SQL, and database design', 1, NOW(), NOW()),
                                                                                                      ('Web Development', 'Building modern web applications with HTML, CSS, and JavaScript', 2, NOW(), NOW()),
                                                                                                      ('Machine Learning Basics', 'Introduction to machine learning and AI concepts', 2, NOW(), NOW()),
                                                                                                      ('Network Security', 'Cybersecurity fundamentals and network protection', 3, NOW(), NOW()),
                                                                                                      ('Operating Systems', 'OS concepts, processes, memory management', 3, NOW(), NOW()),
                                                                                                      ('Software Engineering', 'Software development lifecycle and methodologies', 4, NOW(), NOW()),
                                                                                                      ('Cloud Computing', 'Cloud architecture, AWS, Azure fundamentals', 4, NOW(), NOW()),
                                                                                                      ('Mobile App Development', 'Android and iOS app development basics', 5, NOW(), NOW());

-- =============================================
-- 3. COURSE ENROLLMENTS (60+ enrollments)
-- =============================================
INSERT INTO `course_enrollments` (`course_id`, `student_id`, `enrolled_at`, `created_at`, `updated_at`) VALUES
-- Course 1: CS101 (10 students)
(1, 6, NOW(), NOW(), NOW()), (1, 7, NOW(), NOW(), NOW()), (1, 8, NOW(), NOW(), NOW()),
(1, 9, NOW(), NOW(), NOW()), (1, 10, NOW(), NOW(), NOW()), (1, 11, NOW(), NOW(), NOW()),
(1, 12, NOW(), NOW(), NOW()), (1, 13, NOW(), NOW(), NOW()), (1, 14, NOW(), NOW(), NOW()),
(1, 15, NOW(), NOW(), NOW()),

-- Course 2: Data Structures (8 students)
(2, 6, NOW(), NOW(), NOW()), (2, 7, NOW(), NOW(), NOW()), (2, 8, NOW(), NOW(), NOW()),
(2, 9, NOW(), NOW(), NOW()), (2, 10, NOW(), NOW(), NOW()), (2, 16, NOW(), NOW(), NOW()),
(2, 17, NOW(), NOW(), NOW()), (2, 18, NOW(), NOW(), NOW()),

-- Course 3: Database Systems (9 students)
(3, 6, NOW(), NOW(), NOW()), (3, 8, NOW(), NOW(), NOW()), (3, 10, NOW(), NOW(), NOW()),
(3, 11, NOW(), NOW(), NOW()), (3, 12, NOW(), NOW(), NOW()), (3, 16, NOW(), NOW(), NOW()),
(3, 19, NOW(), NOW(), NOW()), (3, 20, NOW(), NOW(), NOW()), (3, 21, NOW(), NOW(), NOW()),

-- Course 4: Web Development (7 students)
(4, 7, NOW(), NOW(), NOW()), (4, 9, NOW(), NOW(), NOW()), (4, 13, NOW(), NOW(), NOW()),
(4, 14, NOW(), NOW(), NOW()), (4, 17, NOW(), NOW(), NOW()), (4, 22, NOW(), NOW(), NOW()),
(4, 23, NOW(), NOW(), NOW()),

-- Course 5: Machine Learning (6 students)
(5, 6, NOW(), NOW(), NOW()), (5, 10, NOW(), NOW(), NOW()), (5, 15, NOW(), NOW(), NOW()),
(5, 18, NOW(), NOW(), NOW()), (5, 20, NOW(), NOW(), NOW()), (5, 24, NOW(), NOW(), NOW()),

-- Course 6: Network Security (5 students)
(6, 8, NOW(), NOW(), NOW()), (6, 12, NOW(), NOW(), NOW()), (6, 19, NOW(), NOW(), NOW()),
(6, 22, NOW(), NOW(), NOW()), (6, 25, NOW(), NOW(), NOW()),

-- Course 7: Operating Systems (4 students)
(7, 9, NOW(), NOW(), NOW()), (7, 11, NOW(), NOW(), NOW()), (7, 16, NOW(), NOW(), NOW()),
(7, 21, NOW(), NOW(), NOW()),

-- Course 8: Software Engineering (6 students)
(8, 7, NOW(), NOW(), NOW()), (8, 13, NOW(), NOW(), NOW()), (8, 17, NOW(), NOW(), NOW()),
(8, 23, NOW(), NOW(), NOW()), (8, 24, NOW(), NOW(), NOW()), (8, 25, NOW(), NOW(), NOW()),

-- Course 9: Cloud Computing (3 students)
(9, 14, NOW(), NOW(), NOW()), (9, 18, NOW(), NOW(), NOW()), (9, 22, NOW(), NOW(), NOW()),

-- Course 10: Mobile App Development (4 students)
(10, 15, NOW(), NOW(), NOW()), (10, 19, NOW(), NOW(), NOW()), (10, 20, NOW(), NOW(), NOW()),
(10, 21, NOW(), NOW(), NOW());

-- =============================================
-- 4. QUIZZES (20 Quizzes across courses)
-- =============================================
INSERT INTO `quizzes` (`title`, `description`, `course_id`, `created_by`, `time_limit_minutes`, `pass_percentage`, `status`, `created_at`, `updated_at`) VALUES
-- Course 1: CS101 Quizzes
('CS101 - Week 1: Basics', 'Basic programming concepts', 1, 1, 30, 60, 'PUBLISHED', NOW(), NOW()),
('CS101 - Week 2: Variables', 'Variables and data types', 1, 1, 30, 70, 'PUBLISHED', NOW(), NOW()),
('CS101 - Week 3: Control Flow', 'If statements, loops, and conditionals', 1, 1, 45, 65, 'PUBLISHED', NOW(), NOW()),
('CS101 - Week 4: Functions', 'Functions, methods, and parameters', 1, 1, 40, 70, 'DRAFT', NOW(), NOW()),

-- Course 2: Data Structures Quizzes
('DS - Week 1: Arrays', 'Array operations and manipulation', 2, 1, 30, 60, 'PUBLISHED', NOW(), NOW()),
('DS - Week 2: Linked Lists', 'Singly and doubly linked lists', 2, 1, 45, 65, 'PUBLISHED', NOW(), NOW()),

-- Course 3: Database Quizzes
('DB - Week 1: SQL Basics', 'SQL SELECT, INSERT, UPDATE', 3, 1, 30, 60, 'PUBLISHED', NOW(), NOW()),
('DB - Week 2: Joins', 'INNER, LEFT, RIGHT, FULL joins', 3, 1, 45, 70, 'PUBLISHED', NOW(), NOW()),
('DB - Week 3: Normalization', 'Database normalization forms 1NF-3NF', 3, 1, 40, 65, 'DRAFT', NOW(), NOW()),

-- Course 4: Web Development Quizzes
('Web - HTML Basics', 'HTML tags and structure', 4, 2, 30, 60, 'PUBLISHED', NOW(), NOW()),
('Web - CSS Styling', 'CSS selectors, flexbox, grid', 4, 2, 45, 65, 'PUBLISHED', NOW(), NOW()),
('Web - JavaScript Intro', 'JS basics, DOM manipulation', 4, 2, 45, 70, 'PUBLISHED', NOW(), NOW()),

-- Course 5: Machine Learning Quizzes
('ML - Week 1: Introduction', 'ML concepts and terminology', 5, 2, 30, 60, 'PUBLISHED', NOW(), NOW()),
('ML - Week 2: Regression', 'Linear and logistic regression', 5, 2, 45, 65, 'DRAFT', NOW(), NOW()),

-- Course 6: Network Security Quizzes
('Sec - Week 1: Basics', 'Network security fundamentals', 6, 3, 30, 60, 'PUBLISHED', NOW(), NOW()),

-- Course 7: Operating Systems Quizzes
('OS - Week 1: Processes', 'Process management and scheduling', 7, 3, 30, 65, 'PUBLISHED', NOW(), NOW()),

-- Course 8: Software Engineering Quizzes
('SE - Week 1: Agile', 'Agile methodologies and Scrum', 8, 4, 30, 60, 'PUBLISHED', NOW(), NOW()),

-- Course 9: Cloud Computing Quizzes
('Cloud - Week 1: AWS', 'AWS services and EC2 basics', 9, 4, 30, 60, 'DRAFT', NOW(), NOW()),

-- Course 10: Mobile App Development Quizzes
('Mobile - Week 1: Android', 'Android Studio and basic UI', 10, 5, 30, 60, 'PUBLISHED', NOW(), NOW());

-- =============================================
-- 5. QUESTIONS (40+ Questions)
-- =============================================
-- Quiz 1: CS101 Week 1 (4 questions)
INSERT INTO `questions` (`quiz_id`, `question_text`, `question_type`, `points`, `display_order`, `created_at`, `updated_at`) VALUES
                                                                                                                                 (1, 'What is the correct extension for a Java source file?', 'MCQ', 10, 1, NOW(), NOW()),
                                                                                                                                 (1, 'Which of the following is NOT a primitive data type?', 'MCQ', 10, 2, NOW(), NOW()),
                                                                                                                                 (1, 'What is the main function in Java?', 'MCQ', 10, 3, NOW(), NOW()),
                                                                                                                                 (1, 'Java is a compiled language.', 'TRUE_FALSE', 10, 4, NOW(), NOW());

-- Quiz 2: CS101 Week 2 (4 questions)
INSERT INTO `questions` (`quiz_id`, `question_text`, `question_type`, `points`, `display_order`, `created_at`, `updated_at`) VALUES
                                                                                                                                 (2, 'What is the result of: 10 / 3 in Java?', 'MCQ', 10, 1, NOW(), NOW()),
                                                                                                                                 (2, 'Which keyword is used to define a constant in Java?', 'MCQ', 10, 2, NOW(), NOW()),
                                                                                                                                 (2, 'What is the default value of int variable in Java?', 'MCQ', 10, 3, NOW(), NOW()),
                                                                                                                                 (2, 'Strings are mutable in Java.', 'TRUE_FALSE', 10, 4, NOW(), NOW());

-- Quiz 3: CS101 Week 3 (4 questions)
INSERT INTO `questions` (`quiz_id`, `question_text`, `question_type`, `points`, `display_order`, `created_at`, `updated_at`) VALUES
                                                                                                                                 (3, 'Which loop guarantees at least one execution?', 'MCQ', 10, 1, NOW(), NOW()),
                                                                                                                                 (3, 'What is the syntax for an if-else statement?', 'MCQ', 10, 2, NOW(), NOW()),
                                                                                                                                 (3, 'What does "break" do in a loop?', 'MCQ', 10, 3, NOW(), NOW()),
                                                                                                                                 (3, 'In Java, "continue" skips the current iteration.', 'TRUE_FALSE', 10, 4, NOW(), NOW());

-- Quiz 4: CS101 Week 4 (3 questions - DRAFT)
INSERT INTO `questions` (`quiz_id`, `question_text`, `question_type`, `points`, `display_order`, `created_at`, `updated_at`) VALUES
                                                                                                                                 (4, 'What is a method signature?', 'MCQ', 10, 1, NOW(), NOW()),
                                                                                                                                 (4, 'What is method overloading?', 'MCQ', 10, 2, NOW(), NOW()),
                                                                                                                                 (4, 'Can a method return multiple values in Java?', 'TRUE_FALSE', 10, 3, NOW(), NOW());

-- Quiz 5: Data Structures Week 1 (3 questions)
INSERT INTO `questions` (`quiz_id`, `question_text`, `question_type`, `points`, `display_order`, `created_at`, `updated_at`) VALUES
                                                                                                                                 (5, 'What is the index of the first element in an array?', 'MCQ', 10, 1, NOW(), NOW()),
                                                                                                                                 (5, 'What is the time complexity of accessing an array element?', 'MCQ', 10, 2, NOW(), NOW()),
                                                                                                                                 (5, 'Arrays are fixed size in Java.', 'TRUE_FALSE', 10, 3, NOW(), NOW());

-- Quiz 6: Data Structures Week 2 (3 questions)
INSERT INTO `questions` (`quiz_id`, `question_text`, `question_type`, `points`, `display_order`, `created_at`, `updated_at`) VALUES
                                                                                                                                 (6, 'What is a linked list?', 'MCQ', 10, 1, NOW(), NOW()),
                                                                                                                                 (6, 'What is the time complexity of inserting at beginning of linked list?', 'MCQ', 10, 2, NOW(), NOW()),
                                                                                                                                 (6, 'Linked lists use contiguous memory.', 'TRUE_FALSE', 10, 3, NOW(), NOW());

-- Quiz 7: Database Week 1 (4 questions)
INSERT INTO `questions` (`quiz_id`, `question_text`, `question_type`, `points`, `display_order`, `created_at`, `updated_at`) VALUES
                                                                                                                                 (7, 'What does SQL stand for?', 'MCQ', 10, 1, NOW(), NOW()),
                                                                                                                                 (7, 'Which command is used to retrieve data?', 'MCQ', 10, 2, NOW(), NOW()),
                                                                                                                                 (7, 'What is a primary key?', 'MCQ', 10, 3, NOW(), NOW()),
                                                                                                                                 (7, 'A table can have multiple primary keys.', 'TRUE_FALSE', 10, 4, NOW(), NOW());

-- Quiz 8: Database Week 2 (3 questions)
INSERT INTO `questions` (`quiz_id`, `question_text`, `question_type`, `points`, `display_order`, `created_at`, `updated_at`) VALUES
                                                                                                                                 (8, 'What does INNER JOIN return?', 'MCQ', 10, 1, NOW(), NOW()),
                                                                                                                                 (8, 'Which join returns all records from left table?', 'MCQ', 10, 2, NOW(), NOW()),
                                                                                                                                 (8, 'FULL JOIN returns all records from both tables.', 'TRUE_FALSE', 10, 3, NOW(), NOW());

-- Quiz 9: Database Week 3 (2 questions - DRAFT)
INSERT INTO `questions` (`quiz_id`, `question_text`, `question_type`, `points`, `display_order`, `created_at`, `updated_at`) VALUES
                                                                                                                                 (9, 'What is 1NF?', 'MCQ', 10, 1, NOW(), NOW()),
                                                                                                                                 (9, 'What is the purpose of normalization?', 'MCQ', 10, 2, NOW(), NOW());

-- Quiz 10: Web HTML (4 questions)
INSERT INTO `questions` (`quiz_id`, `question_text`, `question_type`, `points`, `display_order`, `created_at`, `updated_at`) VALUES
                                                                                                                                 (10, 'Which HTML tag is used for the largest heading?', 'MCQ', 10, 1, NOW(), NOW()),
                                                                                                                                 (10, 'What does HTML stand for?', 'MCQ', 10, 2, NOW(), NOW()),
                                                                                                                                 (10, 'Which tag is used for hyperlinks?', 'MCQ', 10, 3, NOW(), NOW()),
                                                                                                                                 (10, 'HTML is a programming language.', 'TRUE_FALSE', 10, 4, NOW(), NOW());

-- Quiz 11: Web CSS (3 questions)
INSERT INTO `questions` (`quiz_id`, `question_text`, `question_type`, `points`, `display_order`, `created_at`, `updated_at`) VALUES
                                                                                                                                 (11, 'CSS stands for Cascading Style Sheets.', 'TRUE_FALSE', 10, 1, NOW(), NOW()),
                                                                                                                                 (11, 'Which property is used for font size?', 'MCQ', 10, 2, NOW(), NOW()),
                                                                                                                                 (11, 'What is flexbox used for?', 'MCQ', 10, 3, NOW(), NOW());

-- Quiz 12: Web JavaScript (3 questions)
INSERT INTO `questions` (`quiz_id`, `question_text`, `question_type`, `points`, `display_order`, `created_at`, `updated_at`) VALUES
                                                                                                                                 (12, 'Which keyword is used to declare a variable in JS?', 'MCQ', 10, 1, NOW(), NOW()),
                                                                                                                                 (12, 'What is the DOM?', 'MCQ', 10, 2, NOW(), NOW()),
                                                                                                                                 (12, 'JavaScript is a statically typed language.', 'TRUE_FALSE', 10, 3, NOW(), NOW());

-- Quiz 13: ML Week 1 (2 questions)
INSERT INTO `questions` (`quiz_id`, `question_text`, `question_type`, `points`, `display_order`, `created_at`, `updated_at`) VALUES
                                                                                                                                 (13, 'What is supervised learning?', 'MCQ', 10, 1, NOW(), NOW()),
                                                                                                                                 (13, 'What is overfitting?', 'MCQ', 10, 2, NOW(), NOW());

-- Quiz 14: ML Week 2 (2 questions - DRAFT)
INSERT INTO `questions` (`quiz_id`, `question_text`, `question_type`, `points`, `display_order`, `created_at`, `updated_at`) VALUES
                                                                                                                                 (14, 'What is linear regression?', 'MCQ', 10, 1, NOW(), NOW()),
                                                                                                                                 (14, 'Logistic regression is for classification.', 'TRUE_FALSE', 10, 2, NOW(), NOW());

-- Quiz 15: Network Security (2 questions)
INSERT INTO `questions` (`quiz_id`, `question_text`, `question_type`, `points`, `display_order`, `created_at`, `updated_at`) VALUES
                                                                                                                                 (15, 'What is a firewall?', 'MCQ', 10, 1, NOW(), NOW()),
                                                                                                                                 (15, 'What is encryption?', 'MCQ', 10, 2, NOW(), NOW());

-- Quiz 16: OS Processes (2 questions)
INSERT INTO `questions` (`quiz_id`, `question_text`, `question_type`, `points`, `display_order`, `created_at`, `updated_at`) VALUES
                                                                                                                                 (16, 'What is a process?', 'MCQ', 10, 1, NOW(), NOW()),
                                                                                                                                 (16, 'What is scheduling?', 'MCQ', 10, 2, NOW(), NOW());

-- Quiz 17: SE Agile (2 questions)
INSERT INTO `questions` (`quiz_id`, `question_text`, `question_type`, `points`, `display_order`, `created_at`, `updated_at`) VALUES
                                                                                                                                 (17, 'What is Agile?', 'MCQ', 10, 1, NOW(), NOW()),
                                                                                                                                 (17, 'What is Scrum?', 'MCQ', 10, 2, NOW(), NOW());

-- Quiz 18: Cloud AWS (2 questions - DRAFT)
INSERT INTO `questions` (`quiz_id`, `question_text`, `question_type`, `points`, `display_order`, `created_at`, `updated_at`) VALUES
                                                                                                                                 (18, 'What is EC2?', 'MCQ', 10, 1, NOW(), NOW()),
                                                                                                                                 (18, 'What is S3?', 'MCQ', 10, 2, NOW(), NOW());

-- Quiz 19: Mobile Android (2 questions)
INSERT INTO `questions` (`quiz_id`, `question_text`, `question_type`, `points`, `display_order`, `created_at`, `updated_at`) VALUES
                                                                                                                                 (19, 'What is Android Studio?', 'MCQ', 10, 1, NOW(), NOW()),
                                                                                                                                 (19, 'What is an Activity?', 'MCQ', 10, 2, NOW(), NOW());

-- Quiz 20: Extra - Software Engineering (2 questions)
INSERT INTO `questions` (`quiz_id`, `question_text`, `question_type`, `points`, `display_order`, `created_at`, `updated_at`) VALUES
                                                                                                                                 (20, 'What is a software development lifecycle?', 'MCQ', 10, 1, NOW(), NOW()),
                                                                                                                                 (20, 'What is version control?', 'MCQ', 10, 2, NOW(), NOW());

-- =============================================
-- 6. QUESTION OPTIONS (80+ options)
-- =============================================
-- Quiz 1: CS101 Week 1
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `display_order`, `created_at`, `updated_at`) VALUES
                                                                                                                             (1, '.java', 1, 1, NOW(), NOW()), (1, '.class', 0, 2, NOW(), NOW()), (1, '.js', 0, 3, NOW(), NOW()), (1, '.cpp', 0, 4, NOW(), NOW()),
                                                                                                                             (2, 'int', 0, 1, NOW(), NOW()), (2, 'boolean', 0, 2, NOW(), NOW()), (2, 'String', 1, 3, NOW(), NOW()), (2, 'double', 0, 4, NOW(), NOW()),
                                                                                                                             (3, 'main', 1, 1, NOW(), NOW()), (3, 'Main', 0, 2, NOW(), NOW()), (3, 'start', 0, 3, NOW(), NOW()), (3, 'run', 0, 4, NOW(), NOW()),
                                                                                                                             (4, 'True', 1, 1, NOW(), NOW()), (4, 'False', 0, 2, NOW(), NOW());

-- Quiz 2: CS101 Week 2
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `display_order`, `created_at`, `updated_at`) VALUES
                                                                                                                             (5, '3.0', 0, 1, NOW(), NOW()), (5, '3.3333333333333335', 1, 2, NOW(), NOW()), (5, '3', 0, 3, NOW(), NOW()), (5, '3.33', 0, 4, NOW(), NOW()),
                                                                                                                             (6, 'static', 0, 1, NOW(), NOW()), (6, 'final', 1, 2, NOW(), NOW()), (6, 'const', 0, 3, NOW(), NOW()), (6, 'constant', 0, 4, NOW(), NOW()),
                                                                                                                             (7, '0', 1, 1, NOW(), NOW()), (7, 'null', 0, 2, NOW(), NOW()), (7, 'undefined', 0, 3, NOW(), NOW()), (7, 'No default', 0, 4, NOW(), NOW()),
                                                                                                                             (8, 'True', 0, 1, NOW(), NOW()), (8, 'False', 1, 2, NOW(), NOW());

-- Quiz 3: CS101 Week 3
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `display_order`, `created_at`, `updated_at`) VALUES
                                                                                                                             (9, 'do-while', 1, 1, NOW(), NOW()), (9, 'while', 0, 2, NOW(), NOW()), (9, 'for', 0, 3, NOW(), NOW()), (9, 'if-else', 0, 4, NOW(), NOW()),
                                                                                                                             (10, 'if (condition) { } else { }', 1, 1, NOW(), NOW()), (10, 'if { } else { }', 0, 2, NOW(), NOW()), (10, 'if (condition) { }', 0, 3, NOW(), NOW()), (10, 'else if', 0, 4, NOW(), NOW()),
                                                                                                                             (11, 'Exits loop', 1, 1, NOW(), NOW()), (11, 'Continues loop', 0, 2, NOW(), NOW()), (11, 'Restarts loop', 0, 3, NOW(), NOW()), (11, 'Does nothing', 0, 4, NOW(), NOW()),
                                                                                                                             (12, 'True', 1, 1, NOW(), NOW()), (12, 'False', 0, 2, NOW(), NOW());

-- Quiz 4: CS101 Week 4
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `display_order`, `created_at`, `updated_at`) VALUES
                                                                                                                             (13, 'Method name and parameters', 1, 1, NOW(), NOW()), (13, 'Return type only', 0, 2, NOW(), NOW()), (13, 'Method body', 0, 3, NOW(), NOW()), (13, 'All of above', 0, 4, NOW(), NOW()),
                                                                                                                             (14, 'Multiple methods same name', 1, 1, NOW(), NOW()), (14, 'Multiple return types', 0, 2, NOW(), NOW()), (14, 'Multiple classes', 0, 3, NOW(), NOW()), (14, 'None', 0, 4, NOW(), NOW()),
                                                                                                                             (15, 'True', 0, 1, NOW(), NOW()), (15, 'False', 1, 2, NOW(), NOW());

-- Quiz 5: Data Structures Week 1
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `display_order`, `created_at`, `updated_at`) VALUES
                                                                                                                             (16, '0', 1, 1, NOW(), NOW()), (16, '1', 0, 2, NOW(), NOW()), (16, '-1', 0, 3, NOW(), NOW()), (16, 'Any', 0, 4, NOW(), NOW()),
                                                                                                                             (17, 'O(1)', 1, 1, NOW(), NOW()), (17, 'O(n)', 0, 2, NOW(), NOW()), (17, 'O(log n)', 0, 3, NOW(), NOW()), (17, 'O(n^2)', 0, 4, NOW(), NOW()),
                                                                                                                             (18, 'True', 1, 1, NOW(), NOW()), (18, 'False', 0, 2, NOW(), NOW());

-- Quiz 6: Data Structures Week 2
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `display_order`, `created_at`, `updated_at`) VALUES
                                                                                                                             (19, 'Dynamic data structure', 1, 1, NOW(), NOW()), (19, 'Static data structure', 0, 2, NOW(), NOW()), (19, 'Array based', 0, 3, NOW(), NOW()), (19, 'None', 0, 4, NOW(), NOW()),
                                                                                                                             (20, 'O(1)', 1, 1, NOW(), NOW()), (20, 'O(n)', 0, 2, NOW(), NOW()), (20, 'O(log n)', 0, 3, NOW(), NOW()), (20, 'O(n^2)', 0, 4, NOW(), NOW()),
                                                                                                                             (21, 'True', 0, 1, NOW(), NOW()), (21, 'False', 1, 2, NOW(), NOW());

-- Quiz 7: Database Week 1
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `display_order`, `created_at`, `updated_at`) VALUES
                                                                                                                             (22, 'Structured Query Language', 1, 1, NOW(), NOW()), (22, 'Standard Query Language', 0, 2, NOW(), NOW()), (22, 'System Query Language', 0, 3, NOW(), NOW()), (22, 'Sequential Query Language', 0, 4, NOW(), NOW()),
                                                                                                                             (23, 'SELECT', 1, 1, NOW(), NOW()), (23, 'INSERT', 0, 2, NOW(), NOW()), (23, 'UPDATE', 0, 3, NOW(), NOW()), (23, 'DELETE', 0, 4, NOW(), NOW()),
                                                                                                                             (24, 'Unique identifier', 1, 1, NOW(), NOW()), (24, 'Foreign key', 0, 2, NOW(), NOW()), (24, 'Any column', 0, 3, NOW(), NOW()), (24, 'Not needed', 0, 4, NOW(), NOW()),
                                                                                                                             (25, 'True', 0, 1, NOW(), NOW()), (25, 'False', 1, 2, NOW(), NOW());

-- Quiz 8: Database Week 2
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `display_order`, `created_at`, `updated_at`) VALUES
                                                                                                                             (26, 'Only matching rows', 1, 1, NOW(), NOW()), (26, 'All rows from left', 0, 2, NOW(), NOW()), (26, 'All rows from right', 0, 3, NOW(), NOW()), (26, 'All rows from both', 0, 4, NOW(), NOW()),
                                                                                                                             (27, 'LEFT JOIN', 1, 1, NOW(), NOW()), (27, 'RIGHT JOIN', 0, 2, NOW(), NOW()), (27, 'INNER JOIN', 0, 3, NOW(), NOW()), (27, 'FULL JOIN', 0, 4, NOW(), NOW()),
                                                                                                                             (28, 'True', 1, 1, NOW(), NOW()), (28, 'False', 0, 2, NOW(), NOW());

-- Quiz 10: Web HTML
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `display_order`, `created_at`, `updated_at`) VALUES
                                                                                                                             (33, '<h1>', 1, 1, NOW(), NOW()), (33, '<h6>', 0, 2, NOW(), NOW()), (33, '<head>', 0, 3, NOW(), NOW()), (33, '<header>', 0, 4, NOW(), NOW()),
                                                                                                                             (34, 'HyperText Markup Language', 1, 1, NOW(), NOW()), (34, 'HighText Markup Language', 0, 2, NOW(), NOW()), (34, 'HyperLink Markup Language', 0, 3, NOW(), NOW()), (34, 'HighLink Markup Language', 0, 4, NOW(), NOW()),
                                                                                                                             (35, '<a>', 1, 1, NOW(), NOW()), (35, '<link>', 0, 2, NOW(), NOW()), (35, '<href>', 0, 3, NOW(), NOW()), (35, '<url>', 0, 4, NOW(), NOW()),
                                                                                                                             (36, 'True', 0, 1, NOW(), NOW()), (36, 'False', 1, 2, NOW(), NOW());

-- Quiz 11: Web CSS
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `display_order`, `created_at`, `updated_at`) VALUES
                                                                                                                             (37, 'True', 1, 1, NOW(), NOW()), (37, 'False', 0, 2, NOW(), NOW()),
                                                                                                                             (38, 'font-size', 1, 1, NOW(), NOW()), (38, 'text-size', 0, 2, NOW(), NOW()), (38, 'font-style', 0, 3, NOW(), NOW()), (38, 'size', 0, 4, NOW(), NOW()),
                                                                                                                             (39, 'Layout and alignment', 1, 1, NOW(), NOW()), (39, 'Font styling', 0, 2, NOW(), NOW()), (39, 'Colors only', 0, 3, NOW(), NOW()), (39, 'Animations', 0, 4, NOW(), NOW());

-- Quiz 12: JavaScript
INSERT INTO `question_options` (`question_id`, `option_text`, `is_correct`, `display_order`, `created_at`, `updated_at`) VALUES
                                                                                                                             (40, 'var, let, const', 1, 1, NOW(), NOW()), (40, 'variable only', 0, 2, NOW(), NOW()), (40, 'declare', 0, 3, NOW(), NOW()), (40, 'All of above', 0, 4, NOW(), NOW()),
                                                                                                                             (41, 'Document Object Model', 1, 1, NOW(), NOW()), (41, 'Data Object Model', 0, 2, NOW(), NOW()), (41, 'Display Object Model', 0, 3, NOW(), NOW()), (41, 'Dynamic Object Model', 0, 4, NOW(), NOW()),
                                                                                                                             (42, 'True', 0, 1, NOW(), NOW()), (42, 'False', 1, 2, NOW(), NOW());

-- =============================================
-- 7. QUIZ ATTEMPTS (100+ attempts)
-- =============================================
-- Generate attempts for each student across various quizzes

INSERT INTO `quiz_attempts` (`quiz_id`, `student_id`, `started_at`, `server_deadline`, `submitted_at`, `status`, `score`, `correct_answers`, `total_questions`, `created_at`, `updated_at`) VALUES
-- Attempts for Quiz 1 (CS101 Week 1) - 15 students
(1, 6, DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 5 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 5 DAY), INTERVAL 20 MINUTE), 'SUBMITTED', 100.00, 4, 4, NOW(), NOW()),
(1, 7, DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 5 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 5 DAY), INTERVAL 15 MINUTE), 'SUBMITTED', 75.00, 3, 4, NOW(), NOW()),
(1, 8, DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 5 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 5 DAY), INTERVAL 25 MINUTE), 'SUBMITTED', 50.00, 2, 4, NOW(), NOW()),
(1, 9, DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 5 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 5 DAY), INTERVAL 18 MINUTE), 'SUBMITTED', 75.00, 3, 4, NOW(), NOW()),
(1, 10, DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 5 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 5 DAY), INTERVAL 22 MINUTE), 'SUBMITTED', 100.00, 4, 4, NOW(), NOW()),
(1, 11, DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 5 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 5 DAY), INTERVAL 30 MINUTE), 'SUBMITTED', 25.00, 1, 4, NOW(), NOW()),
(1, 12, DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 5 DAY), INTERVAL 30 MINUTE), NULL, 'IN_PROGRESS', NULL, NULL, NULL, NOW(), NOW()),
(1, 13, DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 5 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 5 DAY), INTERVAL 28 MINUTE), 'SUBMITTED', 50.00, 2, 4, NOW(), NOW()),
(1, 14, DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 5 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 5 DAY), INTERVAL 12 MINUTE), 'SUBMITTED', 100.00, 4, 4, NOW(), NOW()),
(1, 15, DATE_SUB(NOW(), INTERVAL 5 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 5 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 5 DAY), INTERVAL 16 MINUTE), 'SUBMITTED', 75.00, 3, 4, NOW(), NOW()),

-- Attempts for Quiz 2 (CS101 Week 2) - 12 students
(2, 6, DATE_SUB(NOW(), INTERVAL 4 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 4 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 4 DAY), INTERVAL 20 MINUTE), 'SUBMITTED', 75.00, 3, 4, NOW(), NOW()),
(2, 7, DATE_SUB(NOW(), INTERVAL 4 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 4 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 4 DAY), INTERVAL 18 MINUTE), 'SUBMITTED', 50.00, 2, 4, NOW(), NOW()),
(2, 8, DATE_SUB(NOW(), INTERVAL 4 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 4 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 4 DAY), INTERVAL 25 MINUTE), 'SUBMITTED', 25.00, 1, 4, NOW(), NOW()),
(2, 9, DATE_SUB(NOW(), INTERVAL 4 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 4 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 4 DAY), INTERVAL 15 MINUTE), 'SUBMITTED', 100.00, 4, 4, NOW(), NOW()),
(2, 10, DATE_SUB(NOW(), INTERVAL 4 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 4 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 4 DAY), INTERVAL 22 MINUTE), 'SUBMITTED', 75.00, 3, 4, NOW(), NOW()),
(2, 11, DATE_SUB(NOW(), INTERVAL 4 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 4 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 4 DAY), INTERVAL 20 MINUTE), 'SUBMITTED', 50.00, 2, 4, NOW(), NOW()),
(2, 12, DATE_SUB(NOW(), INTERVAL 4 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 4 DAY), INTERVAL 30 MINUTE), NULL, 'IN_PROGRESS', NULL, NULL, NULL, NOW(), NOW()),
(2, 13, DATE_SUB(NOW(), INTERVAL 4 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 4 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 4 DAY), INTERVAL 28 MINUTE), 'SUBMITTED', 100.00, 4, 4, NOW(), NOW()),
(2, 14, DATE_SUB(NOW(), INTERVAL 4 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 4 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 4 DAY), INTERVAL 30 MINUTE), 'SUBMITTED', 75.00, 3, 4, NOW(), NOW()),
(2, 16, DATE_SUB(NOW(), INTERVAL 4 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 4 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 4 DAY), INTERVAL 25 MINUTE), 'SUBMITTED', 50.00, 2, 4, NOW(), NOW()),
(2, 17, DATE_SUB(NOW(), INTERVAL 4 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 4 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 4 DAY), INTERVAL 20 MINUTE), 'SUBMITTED', 25.00, 1, 4, NOW(), NOW()),
(2, 18, DATE_SUB(NOW(), INTERVAL 4 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 4 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 4 DAY), INTERVAL 22 MINUTE), 'SUBMITTED', 100.00, 4, 4, NOW(), NOW()),

-- Attempts for Quiz 3 (CS101 Week 3) - 10 students
(3, 6, DATE_SUB(NOW(), INTERVAL 3 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 3 DAY), INTERVAL 45 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 3 DAY), INTERVAL 30 MINUTE), 'SUBMITTED', 75.00, 3, 4, NOW(), NOW()),
(3, 7, DATE_SUB(NOW(), INTERVAL 3 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 3 DAY), INTERVAL 45 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 3 DAY), INTERVAL 35 MINUTE), 'SUBMITTED', 50.00, 2, 4, NOW(), NOW()),
(3, 8, DATE_SUB(NOW(), INTERVAL 3 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 3 DAY), INTERVAL 45 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 3 DAY), INTERVAL 40 MINUTE), 'SUBMITTED', 25.00, 1, 4, NOW(), NOW()),
(3, 9, DATE_SUB(NOW(), INTERVAL 3 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 3 DAY), INTERVAL 45 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 3 DAY), INTERVAL 25 MINUTE), 'SUBMITTED', 100.00, 4, 4, NOW(), NOW()),
(3, 10, DATE_SUB(NOW(), INTERVAL 3 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 3 DAY), INTERVAL 45 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 3 DAY), INTERVAL 30 MINUTE), 'SUBMITTED', 75.00, 3, 4, NOW(), NOW()),
(3, 13, DATE_SUB(NOW(), INTERVAL 3 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 3 DAY), INTERVAL 45 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 3 DAY), INTERVAL 28 MINUTE), 'SUBMITTED', 100.00, 4, 4, NOW(), NOW()),
(3, 14, DATE_SUB(NOW(), INTERVAL 3 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 3 DAY), INTERVAL 45 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 3 DAY), INTERVAL 40 MINUTE), 'SUBMITTED', 50.00, 2, 4, NOW(), NOW()),
(3, 15, DATE_SUB(NOW(), INTERVAL 3 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 3 DAY), INTERVAL 45 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 3 DAY), INTERVAL 30 MINUTE), 'SUBMITTED', 75.00, 3, 4, NOW(), NOW()),
(3, 12, DATE_SUB(NOW(), INTERVAL 3 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 3 DAY), INTERVAL 45 MINUTE), NULL, 'IN_PROGRESS', NULL, NULL, NULL, NOW(), NOW()),
(3, 8, DATE_SUB(NOW(), INTERVAL 3 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 3 DAY), INTERVAL 45 MINUTE), NULL, 'EXPIRED', 0.00, 0, 4, NOW(), NOW()),

-- Attempts for Quiz 7 (Database Week 1) - 12 students
(7, 6, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 25 MINUTE), 'SUBMITTED', 100.00, 4, 4, NOW(), NOW()),
(7, 8, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 20 MINUTE), 'SUBMITTED', 75.00, 3, 4, NOW(), NOW()),
(7, 10, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 15 MINUTE), 'SUBMITTED', 100.00, 4, 4, NOW(), NOW()),
(7, 11, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 28 MINUTE), 'SUBMITTED', 50.00, 2, 4, NOW(), NOW()),
(7, 12, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 18 MINUTE), 'SUBMITTED', 75.00, 3, 4, NOW(), NOW()),
(7, 16, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 22 MINUTE), 'SUBMITTED', 100.00, 4, 4, NOW(), NOW()),
(7, 19, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 20 MINUTE), 'SUBMITTED', 25.00, 1, 4, NOW(), NOW()),
(7, 20, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 25 MINUTE), 'SUBMITTED', 50.00, 2, 4, NOW(), NOW()),
(7, 21, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 30 MINUTE), 'SUBMITTED', 75.00, 3, 4, NOW(), NOW()),
(7, 13, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 30 MINUTE), NULL, 'IN_PROGRESS', NULL, NULL, NULL, NOW(), NOW()),
(7, 14, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 35 MINUTE), 'EXPIRED', 0.00, 0, 4, NOW(), NOW()),
(7, 15, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 20 MINUTE), 'SUBMITTED', 100.00, 4, 4, NOW(), NOW()),

-- Attempts for Quiz 10 (Web HTML) - 10 students
(10, 7, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 15 MINUTE), 'SUBMITTED', 100.00, 4, 4, NOW(), NOW()),
(10, 9, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 20 MINUTE), 'SUBMITTED', 75.00, 3, 4, NOW(), NOW()),
(10, 13, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 25 MINUTE), 'SUBMITTED', 50.00, 2, 4, NOW(), NOW()),
(10, 14, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 28 MINUTE), 'SUBMITTED', 75.00, 3, 4, NOW(), NOW()),
(10, 17, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 15 MINUTE), 'SUBMITTED', 100.00, 4, 4, NOW(), NOW()),
(10, 22, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 22 MINUTE), 'SUBMITTED', 25.00, 1, 4, NOW(), NOW()),
(10, 23, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 18 MINUTE), 'SUBMITTED', 50.00, 2, 4, NOW(), NOW()),
(10, 6, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 30 MINUTE), NULL, 'IN_PROGRESS', NULL, NULL, NULL, NOW(), NOW()),
(10, 8, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 30 MINUTE), 'SUBMITTED', 100.00, 4, 4, NOW(), NOW()),
(10, 11, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 40 MINUTE), 'EXPIRED', 0.00, 0, 4, NOW(), NOW()),

-- More attempts for Quiz 8 (Database Week 2) - 8 students
(8, 6, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 45 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 30 MINUTE), 'SUBMITTED', 100.00, 3, 3, NOW(), NOW()),
(8, 8, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 45 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 35 MINUTE), 'SUBMITTED', 66.67, 2, 3, NOW(), NOW()),
(8, 10, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 45 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 40 MINUTE), 'SUBMITTED', 100.00, 3, 3, NOW(), NOW()),
(8, 11, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 45 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 35 MINUTE), 'SUBMITTED', 33.33, 1, 3, NOW(), NOW()),
(8, 12, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 45 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 30 MINUTE), 'SUBMITTED', 66.67, 2, 3, NOW(), NOW()),
(8, 16, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 45 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 45 MINUTE), 'SUBMITTED', 100.00, 3, 3, NOW(), NOW()),
(8, 19, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 45 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 30 MINUTE), 'SUBMITTED', 33.33, 1, 3, NOW(), NOW()),
(8, 20, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 45 MINUTE), NULL, 'IN_PROGRESS', NULL, NULL, NULL, NOW(), NOW()),

-- Quiz 5 (Data Structures Week 1) - 6 students
(5, 6, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 25 MINUTE), 'SUBMITTED', 100.00, 3, 3, NOW(), NOW()),
(5, 7, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 28 MINUTE), 'SUBMITTED', 66.67, 2, 3, NOW(), NOW()),
(5, 8, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 20 MINUTE), 'SUBMITTED', 33.33, 1, 3, NOW(), NOW()),
(5, 9, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 30 MINUTE), 'SUBMITTED', 100.00, 3, 3, NOW(), NOW()),
(5, 10, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 25 MINUTE), 'SUBMITTED', 66.67, 2, 3, NOW(), NOW()),
(5, 16, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 30 MINUTE), NULL, 'IN_PROGRESS', NULL, NULL, NULL, NOW(), NOW()),

-- Quiz 11 (Web CSS) - 5 students
(11, 7, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 45 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 30 MINUTE), 'SUBMITTED', 100.00, 3, 3, NOW(), NOW()),
(11, 9, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 45 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 40 MINUTE), 'SUBMITTED', 66.67, 2, 3, NOW(), NOW()),
(11, 13, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 45 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 30 MINUTE), 'SUBMITTED', 33.33, 1, 3, NOW(), NOW()),
(11, 14, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 45 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 35 MINUTE), 'SUBMITTED', 100.00, 3, 3, NOW(), NOW()),
(11, 17, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 45 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 45 MINUTE), 'SUBMITTED', 66.67, 2, 3, NOW(), NOW()),

-- Quiz 13 (ML Week 1) - 4 students
(13, 6, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 25 MINUTE), 'SUBMITTED', 100.00, 2, 2, NOW(), NOW()),
(13, 10, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 20 MINUTE), 'SUBMITTED', 50.00, 1, 2, NOW(), NOW()),
(13, 15, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 28 MINUTE), 'SUBMITTED', 50.00, 1, 2, NOW(), NOW()),
(13, 18, DATE_SUB(NOW(), INTERVAL 2 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 2 DAY), INTERVAL 30 MINUTE), 'SUBMITTED', 100.00, 2, 2, NOW(), NOW()),

-- Quiz 15 (Network Security) - 4 students
(15, 8, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 20 MINUTE), 'SUBMITTED', 100.00, 2, 2, NOW(), NOW()),
(15, 12, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 25 MINUTE), 'SUBMITTED', 50.00, 1, 2, NOW(), NOW()),
(15, 19, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 28 MINUTE), 'SUBMITTED', 100.00, 2, 2, NOW(), NOW()),
(15, 22, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 30 MINUTE), 'SUBMITTED', 0.00, 0, 2, NOW(), NOW()),

-- Quiz 16 (OS Processes) - 4 students
(16, 9, DATE_SUB(NOW(), INTERVAL 3 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 3 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 3 DAY), INTERVAL 25 MINUTE), 'SUBMITTED', 100.00, 2, 2, NOW(), NOW()),
(16, 11, DATE_SUB(NOW(), INTERVAL 3 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 3 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 3 DAY), INTERVAL 20 MINUTE), 'SUBMITTED', 50.00, 1, 2, NOW(), NOW()),
(16, 16, DATE_SUB(NOW(), INTERVAL 3 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 3 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 3 DAY), INTERVAL 28 MINUTE), 'SUBMITTED', 100.00, 2, 2, NOW(), NOW()),
(16, 21, DATE_SUB(NOW(), INTERVAL 3 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 3 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 3 DAY), INTERVAL 30 MINUTE), 'SUBMITTED', 50.00, 1, 2, NOW(), NOW()),

-- Quiz 17 (Software Engineering Agile) - 5 students
(17, 7, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 20 MINUTE), 'SUBMITTED', 100.00, 2, 2, NOW(), NOW()),
(17, 13, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 25 MINUTE), 'SUBMITTED', 50.00, 1, 2, NOW(), NOW()),
(17, 17, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 28 MINUTE), 'SUBMITTED', 100.00, 2, 2, NOW(), NOW()),
(17, 23, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 30 MINUTE), 'SUBMITTED', 50.00, 1, 2, NOW(), NOW()),
(17, 24, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 30 MINUTE), NULL, 'IN_PROGRESS', NULL, NULL, NULL, NOW(), NOW()),

-- Quiz 19 (Mobile Android) - 3 students
(19, 15, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 25 MINUTE), 'SUBMITTED', 100.00, 2, 2, NOW(), NOW()),
(19, 19, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 20 MINUTE), 'SUBMITTED', 50.00, 1, 2, NOW(), NOW()),
(19, 20, DATE_SUB(NOW(), INTERVAL 1 DAY), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 30 MINUTE), DATE_ADD(DATE_SUB(NOW(), INTERVAL 1 DAY), INTERVAL 28 MINUTE), 'SUBMITTED', 100.00, 2, 2, NOW(), NOW());

-- =============================================
-- 8. ATTEMPT ANSWERS (Detailed responses)
-- =============================================
-- Insert attempt answers for Quiz 1 attempts (Students 6-15)
INSERT INTO `attempt_answers` (`attempt_id`, `question_id`, `selected_option_id`, `is_correct`, `points_earned`, `created_at`, `updated_at`) VALUES
-- Attempt 1: Student 6, Quiz 1 (100%)
(1, 1, 1, 1, 10, NOW(), NOW()),
(1, 2, 7, 1, 10, NOW(), NOW()),
(1, 3, 9, 1, 10, NOW(), NOW()),
(1, 4, 13, 1, 10, NOW(), NOW()),

-- Attempt 2: Student 7, Quiz 1 (75%)
(2, 1, 1, 1, 10, NOW(), NOW()),
(2, 2, 7, 1, 10, NOW(), NOW()),
(2, 3, 10, 0, 0, NOW(), NOW()),
(2, 4, 13, 1, 10, NOW(), NOW()),

-- Attempt 3: Student 8, Quiz 1 (50%)
(3, 1, 1, 1, 10, NOW(), NOW()),
(3, 2, 5, 0, 0, NOW(), NOW()),
(3, 3, 10, 0, 0, NOW(), NOW()),
(3, 4, 13, 1, 10, NOW(), NOW()),

-- Attempt 5: Student 10, Quiz 1 (100%)
(5, 1, 1, 1, 10, NOW(), NOW()),
(5, 2, 7, 1, 10, NOW(), NOW()),
(5, 3, 9, 1, 10, NOW(), NOW()),
(5, 4, 13, 1, 10, NOW(), NOW()),

-- Attempt 6: Student 11, Quiz 1 (25%)
(6, 1, 2, 0, 0, NOW(), NOW()),
(6, 2, 5, 0, 0, NOW(), NOW()),
(6, 3, 10, 0, 0, NOW(), NOW()),
(6, 4, 14, 0, 0, NOW(), NOW()),

-- Attempt 10: Student 15, Quiz 1 (75%)
(10, 1, 1, 1, 10, NOW(), NOW()),
(10, 2, 7, 1, 10, NOW(), NOW()),
(10, 3, 10, 0, 0, NOW(), NOW()),
(10, 4, 13, 1, 10, NOW(), NOW());

-- More attempt answers for Quiz 2 attempts
INSERT INTO `attempt_answers` (`attempt_id`, `question_id`, `selected_option_id`, `is_correct`, `points_earned`, `created_at`, `updated_at`) VALUES
-- Attempt 11: Student 6, Quiz 2 (75%)
(11, 5, 10, 1, 10, NOW(), NOW()),
(11, 6, 14, 1, 10, NOW(), NOW()),
(11, 7, 16, 0, 0, NOW(), NOW()),
(11, 8, 27, 0, 0, NOW(), NOW()),

-- Attempt 14: Student 9, Quiz 2 (100%)
(14, 5, 10, 1, 10, NOW(), NOW()),
(14, 6, 14, 1, 10, NOW(), NOW()),
(14, 7, 15, 1, 10, NOW(), NOW()),
(14, 8, 28, 1, 10, NOW(), NOW()),

-- Attempt 18: Student 13, Quiz 2 (100%)
(18, 5, 10, 1, 10, NOW(), NOW()),
(18, 6, 14, 1, 10, NOW(), NOW()),
(18, 7, 15, 1, 10, NOW(), NOW()),
(18, 8, 28, 1, 10, NOW(), NOW()),

-- Attempt 20: Student 18, Quiz 2 (100%)
(20, 5, 10, 1, 10, NOW(), NOW()),
(20, 6, 14, 1, 10, NOW(), NOW()),
(20, 7, 15, 1, 10, NOW(), NOW()),
(20, 8, 28, 1, 10, NOW(), NOW());

-- Quiz 3 attempt answers
INSERT INTO `attempt_answers` (`attempt_id`, `question_id`, `selected_option_id`, `is_correct`, `points_earned`, `created_at`, `updated_at`) VALUES
-- Attempt 21: Student 6, Quiz 3 (75%)
(21, 9, 25, 1, 10, NOW(), NOW()),
(21, 10, 30, 0, 0, NOW(), NOW()),
(21, 11, 33, 1, 10, NOW(), NOW()),
(21, 12, 36, 1, 10, NOW(), NOW()),

-- Attempt 24: Student 9, Quiz 3 (100%)
(24, 9, 25, 1, 10, NOW(), NOW()),
(24, 10, 29, 1, 10, NOW(), NOW()),
(24, 11, 33, 1, 10, NOW(), NOW()),
(24, 12, 36, 1, 10, NOW(), NOW()),

-- Attempt 26: Student 13, Quiz 3 (100%)
(26, 9, 25, 1, 10, NOW(), NOW()),
(26, 10, 29, 1, 10, NOW(), NOW()),
(26, 11, 33, 1, 10, NOW(), NOW()),
(26, 12, 36, 1, 10, NOW(), NOW());

-- Quiz 7 (Database Week 1) attempt answers
INSERT INTO `attempt_answers` (`attempt_id`, `question_id`, `selected_option_id`, `is_correct`, `points_earned`, `created_at`, `updated_at`) VALUES
-- Attempt 31: Student 6, Quiz 7 (100%)
(31, 22, 38, 1, 10, NOW(), NOW()),
(31, 23, 39, 1, 10, NOW(), NOW()),
(31, 24, 41, 1, 10, NOW(), NOW()),
(31, 25, 44, 1, 10, NOW(), NOW()),

-- Attempt 33: Student 10, Quiz 7 (100%)
(33, 22, 38, 1, 10, NOW(), NOW()),
(33, 23, 39, 1, 10, NOW(), NOW()),
(33, 24, 41, 1, 10, NOW(), NOW()),
(33, 25, 44, 1, 10, NOW(), NOW()),

-- Attempt 36: Student 16, Quiz 7 (100%)
(36, 22, 38, 1, 10, NOW(), NOW()),
(36, 23, 39, 1, 10, NOW(), NOW()),
(36, 24, 41, 1, 10, NOW(), NOW()),
(36, 25, 44, 1, 10, NOW(), NOW()),

-- Attempt 40: Student 20, Quiz 7 (50%)
(40, 22, 38, 1, 10, NOW(), NOW()),
(40, 23, 42, 0, 0, NOW(), NOW()),
(40, 24, 43, 0, 0, NOW(), NOW()),
(40, 25, 44, 1, 10, NOW(), NOW()),

-- Attempt 42: Student 15, Quiz 7 (100%)
(42, 22, 38, 1, 10, NOW(), NOW()),
(42, 23, 39, 1, 10, NOW(), NOW()),
(42, 24, 41, 1, 10, NOW(), NOW()),
(42, 25, 44, 1, 10, NOW(), NOW());

-- =============================================
-- Re-enable foreign key checks
-- =============================================
SET FOREIGN_KEY_CHECKS = 1;

-- =============================================
-- Summary: Data Inserted (Fixed the syntax error)
-- =============================================
SELECT '========================================' as '';
SELECT 'SAMPLE DATA INSERTED SUCCESSFULLY!' as '';
SELECT '========================================' as '';

SELECT
    'Users' AS `Table_Name`,
    COUNT(*) AS `Record_Count`
FROM users
UNION ALL
SELECT 'Courses', COUNT(*) FROM courses
UNION ALL
SELECT 'Enrollments', COUNT(*) FROM course_enrollments
UNION ALL
SELECT 'Quizzes', COUNT(*) FROM quizzes
UNION ALL
SELECT 'Questions', COUNT(*) FROM questions
UNION ALL
SELECT 'Question Options', COUNT(*) FROM question_options
UNION ALL
SELECT 'Quiz Attempts', COUNT(*) FROM quiz_attempts
UNION ALL
SELECT 'Attempt Answers', COUNT(*) FROM attempt_answers;

SELECT '========================================' as '';
SELECT 'SUMMARY COMPLETE' as '';
SELECT '========================================' as '';