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
-- Default Admin Account (Required for login)
-- --------------------------------------------------------
INSERT IGNORE INTO admins (username, password) 
VALUES ('admin', MD5('admin123'));

-- --------------------------------------------------------
-- Sample Courses Seed Data
-- --------------------------------------------------------
INSERT IGNORE INTO courses (id, course_name, description, credits, capacity, instructor, schedule) VALUES
(1, 'Artificial Intelligence', 'Foundational concepts of machine learning, neural networks, searching algorithms, and heuristics.', 4, 30, 'Dr. Jatin Kumar', 'Fri 09:00 AM - 12:00 PM'),
(2, 'Cloud Computing & DevOps', 'Introduction to microservices, Docker containment, Kubernetes orchestration, and AWS deployments.', 3, 20, 'Prof. Geeta Gupta', 'Tue/Thu 02:00 PM - 03:30 PM'),
(3, 'Database Systems', 'Relational database design, SQL syntax, index optimization, transactions, and normalization.', 3, 25, 'Dr. Amit Verma', 'Mon/Wed 01:00 PM - 02:30 PM'),
(4, 'Full-Stack Web Development', 'Building dynamic web apps using HTML5, CSS3, ES6+, Servlets, JSP, and MySQL database.', 4, 35, 'Prof. Aditi Patel', 'Tue/Thu 11:00 AM - 12:30 PM'),
(5, 'Information Security', 'Network security fundamentals, symmetric/asymmetric encryption, hashing algorithms, and threat modeling.', 3, 28, 'Prof. Chetan Rao', 'Mon 03:00 PM - 06:00 PM'),
(6, 'Java Programming', 'Introduction to Java language, OOP concepts, exceptions, collections, and multi-threading.', 4, 30, 'Dr. Anand Sharma', 'Mon/Wed 09:00 AM - 10:30 AM');

-- --------------------------------------------------------
-- Sample Students Seed Data (Default password: student123)
-- --------------------------------------------------------
INSERT IGNORE INTO students (id, name, email, password) VALUES
(1, 'Aarav Sharma', 'aarav@university.edu', MD5('student123')),
(2, 'Ananya Patel', 'ananya@university.edu', MD5('student123')),
(3, 'Arjun Verma', 'arjun@university.edu', MD5('student123')),
(4, 'Diya Gupta', 'diya@university.edu', MD5('student123')),
(5, 'Vihaan Kumar', 'vihaan@university.edu', MD5('student123'));

-- --------------------------------------------------------
-- Sample Enrollments Seed Data
-- --------------------------------------------------------
INSERT IGNORE INTO enrollments (id, student_id, course_id, enrolled_at) VALUES
(1, 1, 6, '2026-06-01 09:15:22'), -- Aarav in Java Programming
(2, 1, 4, '2026-06-01 10:30:45'), -- Aarav in Full-Stack Web Development
(3, 2, 4, '2026-06-01 11:05:12'), -- Ananya in Full-Stack Web Development
(4, 2, 3, '2026-06-01 12:20:01'), -- Ananya in Database Systems
(5, 3, 6, '2026-06-02 08:45:30'), -- Arjun in Java Programming
(6, 3, 1, '2026-06-02 09:15:18'), -- Arjun in Artificial Intelligence
(7, 4, 2, '2026-06-02 14:10:55'), -- Diya in Cloud Computing & DevOps
(8, 4, 5, '2026-06-02 16:30:00'); -- Diya in Information Security
