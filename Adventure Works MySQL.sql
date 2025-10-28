create database Project;
use project;
desc sales;
select * from sales;
desc dimcustomer;
select * from dimcustomer;
desc dimdate;
select * from dimdate;
desc dimproduct;
select * from dimproduct;
desc dimproductcategory;
select * from dimproductcategory;
desc dimproductsubcategory;
select * from dimproductsubcategory;


#_______Total Profit_______#
select sum(salesamount-totalproductcost) as `Total Profit`
from sales;

#_______Totoal Quantity______#
select sum(orderquantity) as `Total Quantity`
from sales;

#_______Total Sales________#
select sum(salesamount) as `Total Sales` from sales;

#_______Total Orders_______#	
select count(distinct salesordernumber) as `Total Orders` from sales;

#________Top 10 Customers_______#
SELECT CONCAT(FirstName, ' ', LastName) AS CustomerName,
SUM(SalesAmount) AS TotalSales FROM Sales S
JOIN DimCustomer dc ON s.CustomerKey = dc.CustomerKey
GROUP BY S.CustomerKey, CONCAT(FirstName, ' ', LastName)
ORDER BY TotalSales DESC LIMIT 10;

#_________Top 10 Products_______#
select productname as `Product Name` , sum(salesamount) as `Total Sales` from sales
group by productname, salesamount 
order by `Total Sales` desc limit 10;

#_________Bottom 10 Products______#
select productname as `Product Name` , sum(salesamount) as `Total Sales` from sales
group by productname, salesamount 
order by `Total Sales` asc limit 10;

#________Month Wise Sales________#
select date_format(orderdate, '%Y-%M') as Month,
sum(Salesamount) as `Total Sales` from sales
group by date_format(orderdate, '%Y-%M')
order by date_format(orderdate, '%Y-%M');

#________Month Wise Orders________#
select date_format(`orderdate`, '%Y-%M') as Month,
count(distinct salesordernumber) as `Total Orders` from sales
group by date_format(`orderdate`, '%Y-%M')
order by date_format(`orderdate`, '%Y-%M');

#________Year Wise Profit_________#
select year(`orderdate`) as Year,
sum(salesamount-totalproductcost) as `Total Profit` from sales
group by year(`orderdate`)
order by year(`orderdate`);

#________Year Wise and Quarter Wise Profit_________#
select 
      year(`orderdate`) as Year, 
      quarter(`orderdate`) as Quarter,
sum(salesamount-totalproductcost) as `Total Profit` from sales
group by year(`orderdate`), quarter(`orderdate`) 
order by year(`orderdate`), quarter(`orderdate`);

#________Year Wise, Quarter Wise and Month wise Profit_________#
select 
      year(`orderdate`) as Year, 
      quarter(`orderdate`) as Quarter,
      month(`orderdate`) as Month,
sum(salesamount-totalproductcost) as `Total Profit` from sales
group by year(`orderdate`), quarter(`orderdate`), month(`orderdate`)
order by year(`orderdate`), quarter(`orderdate`), month(`orderdate`);

#________Region Wise Sales_______#
SELECT dt.SalesTerritoryRegion as `Sales Territory Region`,
       SUM(s.SalesAmount) AS `Total Sales`
FROM sales s
JOIN DimSalesterritory dt ON s.SalesTerritoryKey = dt.SalesTerritoryKey
GROUP BY dt.SalesTerritoryRegion;

#________Region Wise Profit_______#
SELECT dt.SalesTerritoryRegion as `Sales Territory Region`,
       SUM(s.SalesAmount-totalproductcost) AS `Total Profit`
FROM sales s
JOIN DimSalesterritory dt ON s.SalesTerritoryKey = dt.SalesTerritoryKey
GROUP BY dt.SalesTerritoryRegion;

#_________Total Sales By Quarter_______#
select concat(year(`orderdate`),'Q', quarter(`orderdate`)) as Quarter,
sum(salesamount) as `Total sales` from sales
group by year(`orderdate`), quarter(`orderdate`)
order by year(`orderdate`), quarter(`orderdate`);

#________Year Wise, Quarter Wise and Month wise Sales_________#
select 
      year(`orderdate`) as Year, 
      quarter(`orderdate`) as Quarter,
      month(`orderdate`) as Month,
sum(salesamount) as `Total Sales` from sales
group by year(`orderdate`), quarter(`orderdate`), month(`orderdate`)
order by year(`orderdate`), quarter(`orderdate`), month(`orderdate`);

