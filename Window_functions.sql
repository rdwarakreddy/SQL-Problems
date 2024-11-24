-- Create the employees1 table
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10, 2)
);
--Create Employees 2 table
CREATE TABLE employees2 (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10, 2)
);
-- Insert sample data into the employees1 table
INSERT INTO employees (emp_id, name, department, salary)
VALUES
    (1, 'Alice', 'HR', 5000),
    (2, 'Bob', 'IT', 7000),
    (3, 'Charlie', 'HR', 5500),
    (4, 'David', 'IT', 8000),
    (5, 'Eva', 'HR', 5200);
-- Insert sample data into the employees2 table
INSERT INTO employees2 (emp_id, name, department, salary)
VALUES
    (1, 'Alice', 'HR', 5000),
    (2, 'Bob', 'IT', 7000),
    (3, 'Charlie', 'HR', 5500),
    (4, 'David', 'IT', 8000),
    (5, 'Eva', 'HR', 5200);

	
-- Add some Duplicated Elements in the employees1 table

ALTER TABLE employees DROP CONSTRAINT employees_pkey;
INSERT INTO employees (emp_id, name, department, salary)
SELECT emp_id, name, department, salary
FROM employees;

select * from employees


--ROW NUMBER()
--The Salary is same for Few departments but it gives different rank for the same salary
SELECT 
    department, 
    name, 
    salary, 
    ROW_NUMBER() OVER (PARTITION BY department) AS row_number
FROM employees;

--RANK()
-- if the salary is same for two rows, then the rank will be same,
-- if the first row and second row got the rank 1, now the third row will get rank 3,Gives the OutPut with gaps
SELECT 
    department, 
    name, 
    salary, 
    RANK() OVER (PARTITION BY department order by salary) AS rank
FROM employees;

--Dense_RANK
-- this is also same as rank, it dosen't skip the rank numbers. 
-- if the both row 1 and row 2 get the rank 1, Rank for Row  3 stars from rank 2
SELECT 
    department, 
    name, 
    salary, 
    DENSE_RANK() OVER (PARTITION BY department order by salary) AS d_rank
FROM employees;

--SUM of Salaries for Each deparment
-- Here we get the Total salary for Each Department.
-- Step 1: Create the CTE with department-wise salary totals
WITH cte AS (
    SELECT
        department,
        SUM(salary) OVER (PARTITION BY department) AS s_salary
    FROM employees
)
--Here we perform Dense_rank and Rank for Clear Observation.
-- Numbers in the Rank will have gaps, but the order of the numbers in dense_rank will not have any gaps
-- in the Below code we used partition, so that we get the same rank for all the rows, Why???
-- Because, we are doing partition for s_salary, it makes all the s_salaries into one group and assing the rank for each.
-- Here salaries are same for so that for HR we get the 1, for IT we get the Rank as 1.
SELECT 
    department,
    s_salary,
    DENSE_RANK() OVER (PARTITION by s_salary order by s_salary desc) AS s_rank
FROM cte


--Lead Function
select * from employees;
-- if you are trying to use LEAD function in department, then 
-- 1. With Partitioning - LEAD function will calculate the next salary with each department, 
-- 2. With out Partitioning - LEAD function will calculate the next salary globally
select
	name,
	department,
	salary,
	lead(salary) over(order by salary) as l_salary
from employees;

-- LAG
-- it caluclates the before salary for each salary
-- it also follows the same principle which i mentioned above, With or with out partitioning
select 
	name,
	department,
	salary,
	LAG(salary) over( order by salary) as l_salary
from employees;

-- Cummulative sum - to get the running sum in the every row
select distinct
	name,
	department,
	salary,
	sum(salary) over(partition by department order by salary ) as c_salary
from employees2
order by salary;

--FIRST_VALUE
-- Return first and last value in the window.
select
	name,
	department,
	salary,
	FIRST_VALUE(salary) OVER (PARTITION BY department ORDER BY salary ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS first_salary,
	LAST_VALUE(salary) OVER (PARTITION BY department ORDER BY salary ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS last_salary
from employees

--Percent Rank
(rank-1)/(total_partitions-1)












