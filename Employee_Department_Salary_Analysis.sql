/*
PURPOSE
Analyze employee salaries, department salary expenditure, workforce status and geographic
distribution. Each analysis section includes a business question and an
insight prompt to help turn query results into a portfolio-ready project.

-- ============================================================================
-- 1. DATABASE AND TABLE SETUP
-- ============================================================================
**/
CREATE DATABASE IF NOT EXISTS employee_department_salary_analysis;
USE employee_department_salary_analysis;

-- Recreate only the tables in this dedicated project database.
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    department_id INT NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    status ENUM('Active', 'Inactive') NOT NULL,
    CONSTRAINT fk_employees_departments
        FOREIGN KEY (department_id)
        REFERENCES departments(department_id)
);

-- ============================================================================
-- 2. SAMPLE DATA
-- Fictional records created for SQL learning and portfolio demonstration.
-- ============================================================================

INSERT INTO departments (department_id, department_name) VALUES
(101, 'IT'),
(102, 'HR'),
(103, 'Finance'),
(104, 'Marketing'),
(105, 'Sales');

INSERT INTO employees
(employee_id, employee_name, salary, department_id, city, state, status)
VALUES
(1, 'Amit',   55000, 101, 'Pune',      'Maharashtra',     'Active'),
(2, 'Sneha',  72000, 101, 'Mumbai',    'Maharashtra',     'Active'),
(3, 'Priya',  45000, 102, 'Nashik',    'Maharashtra',     'Active'),
(4, 'Rohan',  68000, 103, 'Delhi',     'Delhi',           'Active'),
(5, 'Vikas',  38000, 104, 'Jaipur',    'Rajasthan',       'Inactive'),
(6, 'Anita',  62000, 101, 'Bengaluru', 'Karnataka',       'Active'),
(7, 'Rahul',  75000, 103, 'Mumbai',    'Maharashtra',     'Active'),
(8, 'Pooja',  42000, 102, 'Pune',      'Maharashtra',     'Active'),
(9, 'Sagar',  58000, 105, 'Kolhapur',  'Maharashtra',     'Active'),
(10,'Neha',   80000, 101, 'Hyderabad', 'Telangana',       'Active'),
(11,'Arjun',  47000, 104, 'Nagpur',    'Maharashtra',     'Active'),
(12,'Kavita', 65000, 102, 'Indore',    'Madhya Pradesh',  'Inactive'),
(13,'Manoj',  52000, 105, 'Surat',     'Gujarat',         'Active'),
(14,'Meera',  90000, 103, 'Pune',      'Maharashtra',     'Active'),
(15,'Karan',  35000, 104, 'Chennai',   'Tamil Nadu',      'Active'),
(16,'Asha',   48000, 102, 'Mumbai',    'Maharashtra',     'Active'),
(17,'Varun',  67000, 101, 'Delhi',     'Delhi',           'Active'),
(18,'Nisha',  56000, 105, 'Nashik',    'Maharashtra',     'Inactive'),
(19,'Ajay',   43000, 104, 'Pune',      'Maharashtra',     'Active'),
(20,'Divya',  71000, 103, 'Bengaluru', 'Karnataka',       'Active'),
(21,'Omkar',  39000, 105, 'Baramati',  'Maharashtra',     'Active'),
(22,'Riya',   60000, 102, 'Mumbai',    'Maharashtra',     'Active'),
(23,'Akash',  85000, 101, 'Hyderabad', 'Telangana',       'Active'),
(24,'Swati',  49000, 104, 'Pune',      'Maharashtra',     'Inactive'),
(25,'Harish', 54000, 105, 'Jaipur',    'Rajasthan',       'Active'),
(26,'Aarav',  76000, 103, 'Delhi',     'Delhi',           'Active'),
(27,'Mohan',  41000, 102, 'Nagpur',    'Maharashtra',     'Active'),
(28,'Sonia',  63000, 101, 'Chennai',   'Tamil Nadu',      'Active'),
(29,'Ramesh', 46000, 105, 'Kolhapur',  'Maharashtra',     'Active'),
(30,'Tanvi',  69000, 103, 'Pune',      'Maharashtra',     'Active');

-- ============================================================================

-- Q01. Check the number of records in each table.
SELECT 'employees' AS table_name, COUNT(*) AS record_count
FROM employees
UNION ALL
SELECT 'departments', COUNT(*)
FROM departments;

-- Q02. Check for duplicate employee IDs (should return no rows).
SELECT employee_id, COUNT(*) AS duplicate_count
FROM employees
GROUP BY employee_id
HAVING COUNT(*) > 1;

-- Q03. Check for missing values in important columns.
-- These columns are NOT NULL by design; this query verifies the loaded data.
SELECT
    SUM(employee_name IS NULL) AS missing_names,
    SUM(salary IS NULL) AS missing_salaries,
    SUM(department_id IS NULL) AS missing_department_ids,
    SUM(city IS NULL) AS missing_cities,
    SUM(state IS NULL) AS missing_states,
    SUM(status IS NULL) AS missing_statuses
FROM employees;

-- Q04. Check for employee records without a matching department (should be 0).
SELECT COUNT(*) AS unmatched_employee_records
FROM employees e
LEFT JOIN departments d
    ON e.department_id = d.department_id
WHERE d.department_id IS NULL;

-- ============================================================================

-- Q05. What is the overall employee and salary summary?
-- Insight prompt: What is the size of the workforce and its salary range?
SELECT
    COUNT(*) AS total_employees,
    SUM(status = 'Active') AS active_employees,
    SUM(status = 'Inactive') AS inactive_employees,
    ROUND(SUM(salary), 2) AS total_salary,
    ROUND(AVG(salary), 2) AS average_salary,
    MIN(salary) AS minimum_salary,
    MAX(salary) AS maximum_salary
FROM employees;

-- Q06. Which employees earn more than the company-wide average salary?
-- Insight prompt: How many employees are above the overall salary benchmark?
SELECT
    employee_name,
    salary,
    ROUND((SELECT AVG(salary) FROM employees), 2) AS company_average_salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
ORDER BY salary DESC;

-- Q07. Which are the five highest-paid employees?
-- Insight prompt: Are the highest salaries concentrated in particular teams?
SELECT
    e.employee_name,
    d.department_name,
    e.salary
FROM employees e
JOIN departments d
    ON e.department_id = d.department_id
ORDER BY e.salary DESC
LIMIT 5;

-- Q08. How are employees distributed across salary bands?
-- Insight prompt: Which salary band contains the largest number of employees?
SELECT
    CASE
        WHEN salary < 40000 THEN 'Below 40,000'
        WHEN salary < 60000 THEN '40,000-59,999'
        WHEN salary < 80000 THEN '60,000-79,999'
        ELSE '80,000 and above'
    END AS salary_band,
    COUNT(*) AS employee_count
FROM employees
GROUP BY salary_band
ORDER BY MIN(salary);

-- ---------------------------------------------------------------------------
-- B. DEPARTMENT PERFORMANCE AND COST
-- ---------------------------------------------------------------------------

-- Q09. What is the employee count and salary expenditure of each department?
-- Insight prompt: Which department has the largest headcount and salary expenditure?
SELECT
    d.department_name,
    COUNT(e.employee_id) AS employee_count,
    ROUND(SUM(e.salary), 2) AS total_salary,
    ROUND(AVG(e.salary), 2) AS average_salary
FROM departments d
LEFT JOIN employees e
    ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
ORDER BY total_salary DESC;

-- Q10. Which departments have total salary expenditure above 100,000?
-- Insight prompt: Which departments account for higher salary expenditure?
SELECT
    d.department_name,
    COUNT(e.employee_id) AS employee_count,
    SUM(e.salary) AS total_salary
FROM departments d
JOIN employees e
    ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
HAVING SUM(e.salary) > 100000
ORDER BY total_salary DESC;

-- Q11. Which department has the highest average salary among active employees?
-- Insight prompt: Compare average salary levels across active departments.
SELECT
    d.department_name,
    ROUND(AVG(e.salary), 2) AS active_average_salary
FROM departments d
JOIN employees e
    ON d.department_id = e.department_id
WHERE e.status = 'Active'
GROUP BY d.department_id, d.department_name
ORDER BY active_average_salary DESC
LIMIT 1;

-- Q12. Which departments have more than five active employees?
-- Insight prompt: Which teams have a larger active workforce?
SELECT
    d.department_name,
    COUNT(*) AS active_employee_count
FROM departments d
JOIN employees e
    ON d.department_id = e.department_id
WHERE e.status = 'Active'
GROUP BY d.department_id, d.department_name
HAVING COUNT(*) > 5
ORDER BY active_employee_count DESC;

-- Q13. Which departments have an average salary above 60,000?
-- Insight prompt: Which teams have higher average salary levels?
SELECT
    d.department_name,
    ROUND(AVG(e.salary), 2) AS average_salary
FROM departments d
JOIN employees e
    ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
HAVING AVG(e.salary) > 60000
ORDER BY average_salary DESC;

-- Q14. What is the salary gap between the highest- and lowest-paid employee
--      in each department?
-- Insight prompt: Which department has the widest internal salary range?
SELECT
    d.department_name,
    MIN(e.salary) AS minimum_salary,
    MAX(e.salary) AS maximum_salary,
    MAX(e.salary) - MIN(e.salary) AS salary_difference
FROM departments d
JOIN employees e
    ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
ORDER BY salary_difference DESC;

-- Q15. Which departments have a salary gap greater than 30,000?
-- Insight prompt: Which departments may need a closer review of salary spread?
SELECT
    d.department_name,
    MIN(e.salary) AS minimum_salary,
    MAX(e.salary) AS maximum_salary,
    MAX(e.salary) - MIN(e.salary) AS salary_difference
FROM departments d
JOIN employees e
    ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
HAVING MAX(e.salary) - MIN(e.salary) > 30000
ORDER BY salary_difference DESC;

-- Q16. What percentage of total salary expenditure belongs to each department?
-- Insight prompt: Which departments account for the largest share of payroll?
WITH department_payroll AS (
    SELECT
        department_id,
        SUM(salary) AS total_salary
    FROM employees
    GROUP BY department_id
)
SELECT
    d.department_name,
    dp.total_salary,
    ROUND(
        dp.total_salary * 100.0 /
        (SELECT SUM(salary) FROM employees),
        2
    ) AS payroll_percentage
FROM department_payroll dp
JOIN departments d
    ON dp.department_id = d.department_id
ORDER BY payroll_percentage DESC;

-- Q17. Rank departments by total salary expenditure.
-- Insight prompt: How do departments compare by total payroll commitment?
WITH department_payroll AS (
    SELECT
        d.department_id,
        d.department_name,
        SUM(e.salary) AS total_salary
    FROM departments d
    JOIN employees e
        ON d.department_id = e.department_id
    GROUP BY d.department_id, d.department_name
)
SELECT
    department_name,
    total_salary,
    DENSE_RANK() OVER (ORDER BY total_salary DESC) AS payroll_rank
FROM department_payroll
ORDER BY payroll_rank;

-- ---------------------------------------------------------------------------
-- C. EMPLOYEE-LEVEL SALARY ANALYSIS
-- ---------------------------------------------------------------------------

-- Q18. Which employees earn more than their own department's average salary?
-- Insight prompt: Identify employees above their department salary benchmark.
SELECT
    d.department_name,
    e.employee_name,
    e.salary,
    ROUND(dept_avg.average_salary, 2) AS department_average_salary
FROM employees e
JOIN departments d
    ON e.department_id = d.department_id
JOIN (
    SELECT
        department_id,
        AVG(salary) AS average_salary
    FROM employees
    GROUP BY department_id
) dept_avg
    ON e.department_id = dept_avg.department_id
WHERE e.salary > dept_avg.average_salary
ORDER BY d.department_name, e.salary DESC;

-- Q19. Find the second-highest distinct salary rank in each department.
-- Insight prompt: Compare the second salary tier across departments.
WITH salary_ranking AS (
    SELECT
        d.department_name,
        e.employee_name,
        e.salary,
        DENSE_RANK() OVER (
            PARTITION BY e.department_id
            ORDER BY e.salary DESC
        ) AS salary_rank
    FROM employees e
    JOIN departments d
        ON e.department_id = d.department_id
)
SELECT
    department_name,
    employee_name,
    salary,
    salary_rank
FROM salary_ranking
WHERE salary_rank = 2
ORDER BY department_name, employee_name;

-- Q20. Find the top two distinct salary ranks in each department.
-- Note: Ties can mean more than two employees appear for a department.
-- Insight prompt: Who belongs to each department's top salary tiers?
WITH salary_ranking AS (
    SELECT
        d.department_name,
        e.employee_name,
        e.salary,
        DENSE_RANK() OVER (
            PARTITION BY e.department_id
            ORDER BY e.salary DESC
        ) AS salary_rank
    FROM employees e
    JOIN departments d
        ON e.department_id = d.department_id
)
SELECT
    department_name,
    employee_name,
    salary,
    salary_rank
FROM salary_ranking
WHERE salary_rank <= 2
ORDER BY department_name, salary_rank, employee_name;

-- Q21. Rank all employees by salary within their department.
-- Insight prompt: Compare employee salary positions within each team.
SELECT
    d.department_name,
    e.employee_name,
    e.salary,
    RANK() OVER (
        PARTITION BY e.department_id
        ORDER BY e.salary DESC
    ) AS salary_rank
FROM employees e
JOIN departments d
    ON e.department_id = d.department_id
ORDER BY d.department_name, salary_rank;

-- Q22. Which employees earn more than the company average and are active?
-- Insight prompt: Identify active employees above the overall salary benchmark.
SELECT
    employee_name,
    salary,
    status
FROM employees
WHERE status = 'Active'
  AND salary > (SELECT AVG(salary) FROM employees)
ORDER BY salary DESC;

-- ---------------------------------------------------------------------------
-- D. WORKFORCE STATUS ANALYSIS
-- ---------------------------------------------------------------------------

-- Q23. Compare active and inactive employees in each department.
-- Insight prompt: Which departments have a higher inactive employee count?
SELECT
    d.department_name,
    SUM(e.status = 'Active') AS active_employees,
    SUM(e.status = 'Inactive') AS inactive_employees
FROM departments d
JOIN employees e
    ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
ORDER BY d.department_name;

-- Q24. Which departments have more active than inactive employees?
-- Insight prompt: Identify departments where active staff outnumber inactive staff.
SELECT
    d.department_name,
    SUM(e.status = 'Active') AS active_employees,
    SUM(e.status = 'Inactive') AS inactive_employees
FROM departments d
JOIN employees e
    ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
HAVING SUM(e.status = 'Active') > SUM(e.status = 'Inactive')
ORDER BY active_employees DESC;

-- Q25. What percentage of each department's workforce is active?
-- Insight prompt: Compare active workforce share across departments.
SELECT
    d.department_name,
    COUNT(*) AS total_employees,
    SUM(e.status = 'Active') AS active_employees,
    ROUND(
        SUM(e.status = 'Active') * 100.0 / COUNT(*),
        2
    ) AS active_workforce_percentage
FROM departments d
JOIN employees e
    ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
ORDER BY active_workforce_percentage DESC;

-- Q26. Compare average salary of active and inactive employees by department.
-- Insight prompt: Check whether salary averages differ by employee status.
SELECT
    d.department_name,
    ROUND(AVG(CASE WHEN e.status = 'Active' THEN e.salary END), 2)
        AS active_average_salary,
    ROUND(AVG(CASE WHEN e.status = 'Inactive' THEN e.salary END), 2)
        AS inactive_average_salary
FROM departments d
JOIN employees e
    ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
ORDER BY d.department_name;

-- ---------------------------------------------------------------------------
-- E. GEOGRAPHIC DISTRIBUTION
-- ---------------------------------------------------------------------------

-- Q27. Which cities have the highest number of employees?
-- Insight prompt: Identify cities with the largest workforce concentration.
SELECT
    city,
    COUNT(*) AS employee_count
FROM employees
GROUP BY city
ORDER BY employee_count DESC, city;

-- Q28. What is the employee distribution by state?
-- Insight prompt: Which states have the largest share of this sample workforce?
SELECT
    state,
    COUNT(*) AS employee_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM employees), 2)
        AS workforce_percentage
FROM employees
GROUP BY state
ORDER BY employee_count DESC;

-- Q29. Compare average salary across cities.
-- Insight prompt: Which cities show higher average salaries in this sample?
SELECT
    city,
    COUNT(*) AS employee_count,
    ROUND(AVG(salary), 2) AS average_salary
FROM employees
GROUP BY city
HAVING COUNT(*) >= 2
ORDER BY average_salary DESC;

-- Q30. Which departments have employees in the greatest number of cities?
-- Insight prompt: Which departments have the widest city distribution?
SELECT
    d.department_name,
    COUNT(DISTINCT e.city) AS cities_covered,
    COUNT(e.employee_id) AS employee_count
FROM departments d
JOIN employees e
    ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
ORDER BY cities_covered DESC, employee_count DESC;


