CREATE DATABASE Stock_Market_Analysis;
USE Stock_Market_Analysis;

SELECT * FROM synthetic_stock_data;
-- *****************************************************************************************
-- Checking the Datatype of each filed

SELECT COLUMN_NAME, DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = "synthetic_stock_data";
-- *****************************************************************************************
-- Changing the Datatype of Date field from text Formate to date formate

ALTER TABLE synthetic_stock_data MODIFY COLUMN Date DATE;

-- *****************************************************************************************
-- NUMBER OF STOCKS IN synthetic_stock_data 

SELECT COUNT(DISTINCT(Ticker)) AS No_of_stocks
FROM synthetic_stock_data;

-- *****************************************************************************************
-- Calculating Average Daily Trading Volume

SELECT Ticker, 
CASE
    WHEN avg(Volume) >= 1000000 THEN CONCAT(ROUND(avg(Volume)/1000000,3),'M')
    WHEN avg(Volume) >= 1000 THEN CONCAT(ROUND(avg(Volume)/1000,3),'K') 
END AS Average_Daily_Trading_Volume
FROM synthetic_stock_data
GROUP BY Ticker
ORDER BY Average_Daily_Trading_Volume DESC;

-- *****************************************************************************************
-- Most Volatile Stocks are MSFT,AAPL,AMZN compare to GOOGL,FB 

SELECT Ticker,ROUND(avg(Beta),3) AS Avg_Beta
FROM synthetic_stock_data
GROUP BY Ticker
ORDER BY Avg_Beta DESC;
-- *****************************************************************************************
-- Stocks with Highest Dividend and Lowest Dividend: 

select Ticker,avg_dividend_amount,
    case 
    when avg_dividend_amount = highest_avg then "Highest_Dividend_Ticker"
	when avg_dividend_amount = lowest_avg then "Lowest_Dividend_Ticker"
    ELSE "Avg_Dividend_Ticker"
    end as comment
from (
    select
        Ticker,
        round(avg(Dividend_Amount),3) as avg_dividend_amount,
        max(round(avg(Dividend_Amount),3)) over () as highest_avg,
        min(round(avg(Dividend_Amount),3)) over () as lowest_avg
    from synthetic_stock_data
    group by Ticker
) subquery;
-- *****************************************************************************************
-- BY USING WHERE CLAUSE

select Ticker,avg_dividend_amount,
    case 
    when avg_dividend_amount = highest_avg then "Highest_Dividend_Ticker"
	when avg_dividend_amount = lowest_avg then "Lowest_Dividend_Ticker"
    ELSE "Avg_Dividend_Ticker"
    end as comment
from (
    select
        Ticker,
        round(avg(Dividend_Amount),3) as avg_dividend_amount,
        max(round(avg(Dividend_Amount),3)) over () as highest_avg,
        min(round(avg(Dividend_Amount),3)) over () as lowest_avg
    from synthetic_stock_data
    group by Ticker
) subquery
WHERE avg_dividend_amount = highest_avg OR
 avg_dividend_amount = lowest_avg;

-- *****************************************************************************************
-- Highest and Lowest P/E Ratios

(select Ticker, PE_Ratio from synthetic_stock_data  order by PE_Ratio desc limit 1)
union all
(select Ticker, PE_Ratio from synthetic_stock_data  order by PE_Ratio asc limit 1);
-- *****************************************************************************************

SELECT * FROM synthetic_stock_data;
-- Stocks with Highest Market Cap

select Ticker, AVG(Market_Cap) as Highest_Market_Cap 
from synthetic_stock_data
GROUP BY Ticker
ORDER BY  Highest_Market_Cap  DESC limit 1;

-- *****************************************************************************************
-- Stocks with Lowest Market Cap

select Ticker, AVG(Market_Cap) as Lowest_Market_Cap 
from synthetic_stock_data
GROUP BY Ticker 
ORDER BY  Lowest_Market_Cap  ASC limit 1;
-- *****************************************************************************************
-- AVG MARKET CAP BY WHERE CONDITION
 
select Ticker, avg(Market_Cap) as Avg_Market_Cap 
from synthetic_stock_data
WHERE Ticker = "GOOGL"
GROUP BY Ticker;
-- *****************************************************************************************
-- AVG MARKET CAP BY YEAR WISE

SELECT YEAR(Date) AS Year, Ticker, AVG(Market_Cap) AS Avg_Market_Cap 
FROM synthetic_stock_data
WHERE YEAR(Date) = 2023
GROUP BY YEAR(Date),Ticker;
    
 -- *****************************************************************************************
-- Stocks Near 52 Week High

SELECT Ticker, ROUND(AVG(52_Week_High),3) AS Stocks_52_week_High
 FROM synthetic_stock_data 
 group by Ticker
 order by Stocks_52_week_High desc;

-- *****************************************************************************************
-- Stocks Near 52 Week Low  

SELECT Ticker, ROUND(AVG(52_Week_High),3) AS Stocks_52_week_Low
 FROM synthetic_stock_data 
 group by Ticker
 order by Stocks_52_week_Low ASC;
-- *****************************************************************************************

-- Stocks with Strong Buy Signals and stocks with Strong Selling Signal

SELECT
    Ticker, Avg_RSI, 
    CASE
        WHEN Avg_RSI  < 45 THEN 'Oversold (Potential Buying Signal)'
        WHEN Avg_RSI  >= 69 THEN 'Overbought (Potential Selling Signal)'
        ELSE 'Neutral' 
    END AS Marketcondition
FROM (
SELECT
    Ticker, ROUND(Avg(RSI),3) AS Avg_RSI
   FROM synthetic_stock_data 
   GROUP BY Ticker
   )Subquery;

-- *****************************************************************************************

SELECT Ticker,RSI,
CASE WHEN RSI < 45 THEN "oversold"
     WHEN RSI >= 69 THEN "overbought"
     WHEN RSI  BETWEEN 45 AND 68 THEN "Neutral"
END AS Marketcondition
FROM synthetic_stock_data;     

-- *****************************************************************************************

SELECT
    Ticker, Avg_MACD, 
    CASE
        WHEN Avg_MACD  > 0 THEN 'Bullish (Potential Buying Signal)'
        WHEN Avg_MACD  < 0 THEN 'Bearish (Potential Selling Signal)'
        ELSE 'Neutral' 
    END AS comment
FROM (
SELECT
    Ticker, ROUND(Avg(MACD),3) AS Avg_MACD
   FROM synthetic_stock_data 
   GROUP BY Ticker
   )Subquery;
