-- Course Registration System Schema and Seed Data

CREATE DATABASE IF NOT EXISTS course_db;
USE course_db;

-- Drop existing tables in reverse dependency order to enable a clean reset
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS admins;

-- 1. Students Table
CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. Admins Table
CREATE TABLE admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Courses Table
CREATE TABLE courses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(150) NOT NULL,
    description TEXT,
    credits INT DEFAULT 3,
    capacity INT DEFAULT 30,
    instructor VARCHAR(100),
    schedule VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. Enrollments Table
CREATE TABLE enrollments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrolled_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses(id) ON DELETE CASCADE,
    UNIQUE KEY uq_enrollment (student_id, course_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------
-- Seed Data for Testing
-- --------------------------------------------------------

-- Seed Administrators (Password is MD5 hash of 'admin123')
INSERT INTO admins (username, password) 
VALUES ('admin', MD5('admin123'));

-- Seed Sample Courses
INSERT INTO courses (course_name, description, credits, capacity, instructor, schedule)
VALUES
  ('Java Programming', 'Object-Oriented Programming, Exception Handling, Collections, Servlets, and JSP.', 4, 30, 'Dr. Sarah Jenkins', 'Mon/Wed 09:00 AM - 11:00 AM'),
  ('Data Structures & Algorithms', 'In-depth analysis of Arrays, Linked Lists, Stacks, Queues, Trees, Graphs, Sorting, and Searching.', 3, 25, 'Dr. Alan Turing', 'Tue/Thu 02:00 PM - 03:30 PM'),
  ('Full-Stack Web Development', 'Building dynamic web apps using HTML5, CSS3, JavaScript, Java Servlets, and RESTful APIs.', 4, 35, 'Prof. Linus Patel', 'Friday 10:00 AM - 01:00 PM'),
  ('Database Management Systems', 'Relational database concepts, SQL queries, normalization, indexing, transaction handling, and JDBC.', 3, 20, 'Dr. Grace Hopper', 'Mon/Wed 02:00 PM - 03:30 PM'),
  ('Introduction to Artificial Intelligence', 'Exploring Search Algorithms, Machine Learning, Neural Networks, and Natural Language Processing.', 3, 15, 'Dr. John McCarthy', 'Tue/Thu 10:00 AM - 11:30 AM');

-- Seed Sample Students (Password is MD5 hash of 'student123')
INSERT INTO students (name, email, password)
VALUES
  ('Alice Johnson', 'alice@university.edu', MD5('student123')),
  ('Bob Smith', 'bob@university.edu', MD5('student123')),
  ('Charlie Davis', 'charlie@university.edu', MD5('student123'));

-- Seed Sample Enrollments
-- Alice (ID: 1) enrolls in Java (ID: 1) and DBMS (ID: 4)
-- Bob (ID: 2) enrolls in Java (ID: 1) and DSA (ID: 2)
INSERT INTO enrollments (student_id, course_id)
VALUES
  (1, 1),
  (1, 4),
  (2, 1),
  (2, 2);
