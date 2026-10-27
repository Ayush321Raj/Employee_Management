
CREATE DATABASE employee_db1;

USE employee_db1;

CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    department VARCHAR(100) NOT NULL,
    salary DECIMAL(10,2) NOT NULL
);

INSERT INTO employees (name, email, department, salary)
VALUES
('Rahul', 'rahul@gmail.com', 'IT', 30000),
('Priya', 'priya@gmail.com', 'HR', 35000);

