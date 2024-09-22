

-- 1). From the following table, write a SQL query to find the unique designations of the employees. Return job name.

SELECT  e.employee_id, CONCAT(upper(e.first_name),'  ', upper(e.last_name)) AS full_name , j.job_title
FROM employees e INNER JOIN jobs j ON e.job_id = j.job_id ORDER BY e.employee_id ASC;

--  2) Write a query in SQL to produce the output of employees as follows. Employee like employees_full_name(job_name) in mysql.


select concat(e.first_name, ' ', e.last_name, '(', lower(j.job_title), ')') as Employee_name_jobname
from employees e inner join  jobs j on e.job_id = j.job_id order by e.employee_id asc;

/*3) give the report who all employees
were hired between November 5th, 2007 and July 5th, 2009. Return full name (first and last), job id and hire date.  */
 
 select concat(first_name,' ',last_name) as employee_name, job_id, date_format(hire_date, '%M %d, %Y') as hire_Date 
from employees where hire_date between '1990-11-05' AND '1995-07-05' order by hire_date;

-- 4) give the report on employees table, the phone number in masked format of last 6 digits by create  views from employees table
	select * from employees;

	create or replace view masked_data1 as
 
	select first_name, last_name,
	CONCAT(SUBSTRING(phone_number, 1, LENGTH(phone_number) - 6),REPEAT('*', 6) ) AS masked_phone
	from employees;

select * from masked_data1;

desc employees;


-- 5) give report on  who all are getting more than average salaray of all employees by department wise.
	WITH SalaryWithAverage  AS (    SELECT  employee_id, concat(first_name,' ', last_name) as emp_name,   
     salary,  department_id,   AVG(salary) OVER (PARTITION BY department_id) AS avg_salary,     
     RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS applyrank     FROM employees)
	SELECT * FROM SalaryWithAverage WHERE Salary > avg_salary;



-- 6) Generate report who all are getting more than average salary of all employees in top 10 and find their region and country.

select e.employee_id, concat(e.first_name,' ',e.last_name) as Employees_name ,
e.salary,r.region_name,c.country_name,
        row_number() over (order by e.salary desc) as Top_10_employees 
        from employees e join departments d on e.department_id = d.department_id  
        join locations l on l.location_id=d.location_id
        join countries c on c.country_id=l.country_id
        join regions r on r.region_id = c.region_id
        where salary > (select avg(salary) from employees)  limit 10;
        
        
	   /* 7) find the average salary by department wise and who are getting 
	  max salary more than avg salary of employees department level, first position by department wise.  */
	WITH SalaryWithAverage AS (
		SELECT  employee_id,	concat(first_name,' ', last_name)
	 as emp_name,  salary, department_id,                
	 AVG(salary) OVER (PARTITION BY department_id) AS avg_salary,        
	 RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS applyrank     
	 FROM employees)
	SELECT * FROM SalaryWithAverage WHERE Salary > avg_salary and applyrank=1  ;

			
        
   -- 8) find the employees names, and departments names who all employees are in top1 position by department wise.
     
	WITH SalaryWithAverage AS (    

	SELECT   concat(e.first_name,' ', e.last_name) as emp_name, e.salary,       
	d.department_id, d.department_name ,             
	 max(salary) OVER (order by e.salary) AS max_salary,       
	 RANK() OVER (PARTITION BY d.department_id ORDER BY salary DESC)
	 AS applyrank     
	 FROM employees e
	 join departments d on 
	 e.department_id=d.department_id)
	 
	SELECT *FROM SalaryWithMax WHERE  applyrank=1  ;

/* 9)  Give the report of employees who earns above 11000 or the seventh 
     character in their  phone number is 3. Sort the result-set in descending order by 
     first name. Return full name (first name and last name), hire date, 
     email, and telephone separated by '-', and salary. */
     
		select concat(first_name,' ',last_name) as Full_Name, hire_date,
        concat(email,'  -  ', 'Cell: ',' ',phone_number) as Contact_Details, salary from employees 
        where salary > 11000  or phone_number like '______3%' order by first_name desc;
        
-- 10) write a SQL query to count the number of characters except the spaces for each employee name. Return employee name length.

		select concat('  ',first_name,'     ' ,'   ', last_name) as full_name, 
		length(trim(concat(first_name,' ' ,last_name))) as full_name_length from employees;
