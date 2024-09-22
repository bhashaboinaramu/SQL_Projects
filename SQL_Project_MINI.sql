select concat(first_name,' ',last_name) as fullname from employees where salary > 3000;

select first_name , last_name as fullname from employees where salary > 3000;

select * from employees;

update employees 
set phone_number = '000.000.0000' where phone_number = null;

select  ifnull(nullif(phone_number, null),'999.999.9999') from employees;
select ifnull(nullif(manager_id, null),'No Manager_id') as man from employees;

select * from employees;

select * from employees where phone_number = null;
-- 1). From the following table, write a SQL query to find the unique designations of the employees. Return job name.

select  e.employee_id, concat(upper(e.first_name),'  ', upper(e.last_name)) as full_name , j.job_title
from employees e inner join jobs j on e.job_id = j.job_id order by e.employee_id asc;

--  Write a query in SQL to produce the output of employees as follows. Employee like empplees(jod_name) in mysql.


SELECT 
    CONCAT(e.first_name, ' ', e.last_name, '(', LOWER(j.job_title), ')') AS jobname
FROM 
    employees e
INNER JOIN 
    jobs j ON e.job_id = j.job_id
ORDER BY 
    e.employee_id 
ASC;

-- write a SQL query to count the number of characters except the spaces for each employee name. Return employee name length.

select concat('  ',first_name,'     ' ,'   ', last_name) as full_name, 
length(trim(concat(first_name,' ' ,last_name))) as full_name_length from employees;


--  SQL query to find those employees with hire date in the format like February 22, 1991. 
-- Return employee ID, employee name, salary, hire date.

select * from employees;

select employee_id, first_name, last_name, salary, date_format(hire_date, '%M %d, %y') as hdate
FROM employees;

-- write a SQL query to list the employees’ name, increased their salary by 15%, and expressed as number of Dollars or rupees.

select concat(first_name,' ' ,last_name) as EMP_FULLNAME, salary,  CONCAT('₹', FORMAT((salary+salary*0.15), 2)) AS formatted_salary
FROM employees;

SHOW TABLES;

-- write a SQL query to find those employees who joined before 1991. Return complete information about the employees.

select * from employees where hire_date <'1991-01-01';

SELECT * 
FROM employees 
WHERE  EXTRACT(YEAR FROM hire_date) < 1991;

/* write a  SQL query to find those employees
 who were hired between November 5th, 2007 and July 5th, 2009. Return full name (first and last), job id and hire date.  */
 
 select concat(first_name,' ',last_name) as employee_name, job_id, hire_date 
from employees where hire_date between '1990-11-05' AND '1995-07-05' order by hire_date;

select * from employees;

-- write a SQL query to calculate the average salary of employees who work as accountant from jobs table. Return average salary.

select  avg(e.salary) as avgsaloOfAcountant  from employees e join jobs j on e.job_id = j.job_id where j.job_title='Accountant' ;

SELECT 
    e.first_name, e.last_name, e.salary,  
  dense_rank() over(order by e.salary) as ranking ,
  AVG(e.salary) OVER (PARTITION BY j.job_title) AS average_salary, j.job_title
FROM
    employees e
JOIN
    jobs j ON e.job_id = j.job_id
WHERE
    j.job_title = 'Accountant';
    
-- show the phone number in masked format of last 6 digits by create  views from employees table
select * from employees;

 create or replace view masked_data1 as
 select first_name, last_name,
 CONCAT(SUBSTRING(phone_number, 1, LENGTH(phone_number) - 4),REPEAT('*', 4) ) AS masked_phone
from employees;

select * from masked_data1;

create or replace view masked_data2 as
 select first_name, last_name, ifnull(nullif(phone_number,null),'999.999.9999'),
 CONCAT(
        SUBSTRING(phone_number, 1, LENGTH(phone_number) - 4),
        REPEAT('*', 4)
    ) AS masked_phone

from employees;

select * from masked_data2;

-- WAQ set salary ranges 'highest salary', lowest salary, midium salary from employees table using CTE

with range_salary as
(select first_name, last_name, salary, 
CASE
	WHEN salary < 3000 THEN 'Low'
	WHEN salary BETWEEN 3000 AND 6000 THEN 'Medium'
	WHEN salary > 6000 THEN 'High'
           ELSE 'Unknown'
	END AS salary_range from employees)       
-- select * from range_salary where salary_range='high';

select * from range_salary where salary_range='low';

select * from employees;

-- find the address of the employees who all are doing Job in Finance department

with findlocationFinance as(
select
     e.first_name,
     e.last_name,
     d.department_name,
     l.street_address ,
	l.postal_code ,
	l.city ,
	l.state_province ,
	l.country_id 
from 
employees e 
join departments d on e.department_id=d.department_id
join locations l on l.location_id=d.location_id 
where d.department_name='Finance' )
select * from findlocationFinance;


select * from departments;

select department_id from employees 

where salary >(select avg(salary) from employees group by department_id order by salary ); -- error

WITH DepartmentAverage AS (
    SELECT department_id, AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department_id
),
RankedSalaries AS (
    SELECT e.*,
           da.avg_salary,
           DENSE_RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS applyrank
    FROM employees e
    JOIN DepartmentAverage da ON e.department_id = da.department_id
)
SELECT *
FROM RankedSalaries
WHERE salary > avg_salary;

-- find the average salary by department wise and who are getting max salary by department wise.
select e.employee_id,e.first_name,e.last_name, d.department_name ,e.salary,
DENSE_RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS applyrank ,
avg(e.salary) over(PARTITION BY e.department_id) as avgSalaryByDep
from employees e 
JOIN departments d ON e.department_id = d.department_id;
-- where applyrank <2;
-- where avgSalaryByDep>e.salary;


WITH SalaryWithAverage AS (
    SELECT
        employee_id,
	concat(first_name,' ', last_name) as emp_name,
        salary,
        department_id,        
        AVG(salary) OVER (PARTITION BY department_id) AS avg_salary
    FROM employees
)
SELECT *
FROM SalaryWithAverage
WHERE Salary > avg_salary;

-- who all are getting more than average salray of all employees by department wise.
		SELECT
        employee_id,
		concat(first_name,' ', last_name) as emp_name,
        salary,
        department_id,    
        AVG(salary) OVER (PARTITION BY department_id order by salary desc ) AS avg_salary
        FROM employees  WHERE salary > 
        (select AVG(salary) from employees);
        
        select * from employees;
        
     /*   write a  SQL query to find those employees who earn above 11000 or the seventh 
     character in their  phone number is 3. Sort the result-set in descending order by 
     first name. Return full name (first name and last name), hire date, 
     email, and telephone separated by '-', and salary. */
SELECT concat(first_name,' ',last_name) AS Full_Name, hire_date,
        concat(email,'  - ',phone_number) AS Contact_Details, salary FROM employees 
        WHERE salary > 11000  OR phone_number LIKE '______3%' ORDER BY first_name DESC;
        



SET SQL_SAFE_UPDATES=0;

create table orders (order_id int primary key,  Item varchar(30));
insert into orders values
(1,'chow Men'),
(2,'Pizza'),
(3,'veg nuggets'),
(4,'paneer butter masala'),
(5,'spring rolls'),
(6,'veg burger'),
(7,'paneer tikka');

select * from orders;

-- to count the total order of orders

with orders_count as
(
select count(order_id) as count_no_items from
orders
)

select 
case 
when order_id%2!=0 and order_id!=count_no_items
then order_id+1
when order_id%2!=0 and order_id=count_no_items
then order_id
else order_id-1
end as real_order_num, item, count_no_items
from orders cross join orders_count order by real_order_num;




