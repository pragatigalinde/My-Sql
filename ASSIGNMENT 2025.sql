USE classicmodels;


-- Q1. SELECT clause with WHERE, AND, DISTINCT, Wild Card (LIKE)
-- a)
select employeenumber, firstname, lastname
from employees
where jobtitle='sales rep' and reportsto=1102;

-- b)
select distinct productline
from products
where productline like '%cars';

-- Q2. CASE STATEMENTS for Segmentation
select customernumber, customername,
case 
when country in ('USA','canada') then "North America"
when country in ('UK','france','germany') then "Europe"
else "Other" 
end as CustomerSegment
from customers;

-- Q3. Group By with Aggregation functions and Having clause, Date and Time functions
-- a)
select productcode, sum(quantityordered) as total_ordered
from orderdetails
group by productcode
order by total_ordered desc
limit 10;

-- b)
select * from payments;
select monthname(paymentdate) as payment_month,
count(paymentdate) as num_payments
from payments
group by payment_month
having num_payments>20;

-- Q4. CONSTRAINTS: Primary, key, foreign key, Unique, check, not null, default
-- a)
-- Create the database
create database Customers_Orders;
use Customers_Orders;
create table Customers (
customer_id int primary key auto_increment,
first_name varchar(50) not null,
last_name varchar(50) not null,
email varchar(255) unique,
phone_number varchar(20)
);
DESC CUSTOMERS;

-- b)
-- Create the Orders table
create table Orders (
order_id int primary key auto_increment,
customer_id int,
order_date date,
total_amount decimal (10,2)
);
Alter table Orders
Add Constraint fk_OC
Foreign Key (customer_id)
references Customers(customer_id),
Add Constraint check_num
check(total_amount>0);
desc orders;

-- Q5. JOINS
select country, count(orderDate) as order_count
from customers inner join Orders
on customers.customernumber=orders.customernumber
group by country
order by order_count desc
limit 5;

-- Q6. SELF JOIN
create table project
(
EmployeeID int primary key auto_increment,
FullName varchar(50) not null,
Gender varchar(10) check (Gender in ('Male','Female')),
ManagerID int
);
insert into project (FullName,Gender,ManagerID) values 
('Pranaya','Male',3),
('Priyanka','Female',1),
('Preety','Female',null),
('Anurag','Male',1),
('Sambit','Male',1),
('Rajesh','Male',3),
('Hina','Female',3);

Select M1.FullName as 'Manager Name', E1.FullName as 'Emp Name'
from project M1 join project E1
on M1.employeeid=E1.managerid
order by M1.Fullname asc;

-- Q7.- -DDL Commands: Create, Alter, Rename
Create table facility
(
Facility_ID int,
Name varchar(100),
State varchar(100),
Country varchar(100)
);
desc facility;
alter table facility
modify column Facility_ID int Primary Key auto_increment;
alter table facility
add column City varchar(100) not null after Name;

-- Q8. Views in SQL
create view product_category_sales as
select p1.productline, 
sum(od.quantityOrdered*od.priceEach) as total_sales, 
count(distinct o.orderNumber) as number_of_orders
from productlines p1 join products p join orderdetails od join orders o 
on p1.productline=p.productline and p.productcode=od.productcode
and od.ordernumber=o.ordernumber
group by p.productline;

select * from product_category_sales;

-- Q9. Stored Procedures in SQL with parameters
DELIMITER $$

CREATE PROCEDURE Get_country_payments(
    IN input_year INT,
    IN input_country VARCHAR(50)
)
BEGIN
    SELECT 
        input_year AS payment_year,
        input_country AS customer_country,
        ROUND(SUM(p.amount) / 1000, 2) AS total_amount_K
    FROM 
        Customers c
    JOIN 
        Payments p ON c.customerNumber = p.customerNumber
    WHERE 
        YEAR(p.paymentDate) = input_year
        AND c.country = input_country
    GROUP BY 
        input_year, input_country;
END $$

DELIMITER ;

CALL Get_country_payments(2022, 'USA');

-- Q10. Window functions - Rank, dense_rank, lead and lag
-- a)
select c.customerName, count(o.orderNumber) as Order_count,
rank() over (order by count(o.orderNumber) desc) as order_frequency_rnk
from customers c join orders o
on c.customerNumber=o.customerNumber
group by c.customername
order by Order_count desc;

-- b)
select * from orders;
WITH OrderCounts AS (
    SELECT 
        YEAR(orderDate) AS Year, 
        MONTHNAME(orderDate) AS Month,
        COUNT(orderNumber) AS Total_Orders
    FROM Orders
    GROUP BY Year, Month
),
YoY AS (
    SELECT 
        Year, 
        Month, 
        Total_Orders, 
        LAG(Total_Orders) OVER (ORDER BY Year) AS Prev_Year_Orders,
        CASE 
            WHEN LAG(Total_Orders) OVER (ORDER BY Year) IS NOT NULL 
            THEN CONCAT(ROUND(((Total_Orders - LAG(Total_Orders) OVER (ORDER BY Year)) 
            / LAG(Total_Orders) OVER (ORDER BY Year)) * 100, 0), '%') 
            ELSE NULL
        END AS YoY_Change
    FROM OrderCounts
)
SELECT Year, Month, Total_Orders as 'Total Orders', YoY_Change as '% YoY Change'
FROM YoY
ORDER BY Year, 
    FIELD(Month, 'January', 'February', 'March', 'April', 'May', 'June', 
                  'July', 'August', 'September', 'October', 'November', 'December');
                  
                  
 -- Q11.Subqueries and their applications
DELIMITER $$
CREATE PROCEDURE Insert_Emp_EH(
    IN p_EmpID INT,
    IN p_EmpName VARCHAR(100),
    IN p_EmailAddress VARCHAR(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback if any error occurs
        ROLLBACK;
        SELECT 'Error occurred' AS ErrorMessage;
    END;
    
    -- Start transaction
    START TRANSACTION;

    -- Insert values into the table
    INSERT INTO Emp_EH (EmpID, EmpName, EmailAddress) 
    VALUES (p_EmpID, p_EmpName, p_EmailAddress);

    -- Commit the transaction
    COMMIT;
END $$
DELIMITER ;

CALL Insert_Emp_EH(1, 'John Doe', 'john.doe@example.com');
CALL Insert_Emp_EH(2, 'Jane Smith', 'jane.smith@example.com');

-- Q13. TRIGGERS
create table Emp_BIT (
Name varchar(10),
Occupation varchar(20),
Working_date date,
Working_hours int
);

INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);

/*
CREATE DEFINER=`root`@`localhost` TRIGGER `emp_bit_BEFORE_INSERT` BEFORE INSERT ON `emp_bit` FOR EACH ROW BEGIN
if new.Working_hours<0 then
set new.Working_hours=-new.Working_hours;
end if;
END
*/

select * from emp_bit;
insert into emp_bit values
('Raju','Actor','2025-10-01',-15);