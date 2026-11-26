# Employee & Department Salary Analysis

A beginner-to-intermediate SQL portfolio project using MySQL 8.0+.

## Project overview

This project explores a small fictional employee dataset to answer business questions about:

- Employee and department salary distribution
- Department-level salary expenditure
- Salary rankings and comparisons
- Active and inactive workforce composition
- Employee distribution by city and state

The goal is to demonstrate SQL analysis skills and explain what query results may mean for business decision-making.

## Tools

- MySQL 8.0+
- MySQL Workbench
- SQL

## Repository files

- `Employee_Department_Salary_Analysis.sql` — database setup, fictional sample data, validation checks, and 26 business analysis queries.

## How to run

1. Install MySQL 8.0 or later and open MySQL Workbench.
2. Open `Employee_Department_Salary_Analysis.sql`.
3. Execute the script to create the `employee_department_salary_analysis` database and load the sample data.
4. Run the validation queries first.
5. Run the business analysis queries one at a time.
6. Record actual query outputs and write insights based on those results.

> The setup script drops and recreates the `employees` and `departments` tables inside this dedicated project database each time it is run. It does not modify any other database.

## Dataset

The project contains 30 fictional employee records and 5 departments. The records are created for SQL practice and portfolio demonstration; they are not real company data.

## SQL concepts demonstrated

- SELECT, WHERE, ORDER BY, LIMIT
- Aggregate functions: COUNT, SUM, AVG, MIN, MAX
- GROUP BY and HAVING
- INNER JOIN and LEFT JOIN
- CASE expressions
- Subqueries and derived tables
- Common Table Expressions (CTEs)
- Window functions: RANK and DENSE_RANK
- Data validation and foreign-key relationships

## Important data limitations

- The sample has only 30 records, so findings should not be generalized to a real organization.
- The salary field has no stated pay period; interpret it only as the amount recorded in this sample.
- There are no dates, so time-based trends cannot be analyzed.
- There are no performance ratings, productivity measures, targets, revenue, or operating costs.
- Profit, employee productivity, and employee performance cannot be calculated from these fields.

## Business insights

Add a separate insight for each selected query after running it. Use this structure:

1. **Business question:** What are we trying to understand?
2. **SQL approach:** Which SQL concepts did we use?
3. **Key result:** What did the actual output show?
4. **Business insight:** Why does that result matter?
5. **Recommendation:** What could a manager review or consider?
6. **Limitation:** What additional data would make the analysis stronger?

Do not add assumed or invented findings. Every insight should be supported by an actual query result.

## Future improvements

The project can be expanded with a larger, credible dataset and additional fields such as hire date, exit date, performance rating, attendance, targets, and actual sales. These fields would enable deeper workforce and business analysis.
