-- Data Exploration

SELECT *
FROM Visitors$

SELECT COUNT(DISTINCT VisitorID)
FROM Visitors$

SELECT MIN(VisitDate) as Min_Visit_Date, MAX(VisitDate) as Max_Visit_Date
FROM Visitors$

SELECT DISTINCT TicketType, COUNT(*) as Num_of_Purchases
FROM Visitors$
GROUP BY TicketType
ORDER BY Count(*) DESC;

SELECT DISTINCT TicketType, ROUND(AVG(GroupSize), 0) as AVG_Group_Size
FROM Visitors$
GROUP BY TicketType
ORDER BY AVG_Group_Size DESC;

SELECT CASE
WHEN PromotionCode IS NULL
	 OR LTRIM(RTRIM(PromotionCode)) = '' THEN 'No Promotion'
	 ELSE 'Has Promotion'
END AS Promotion_Status,
COUNT(*) AS Num_of_Visitors
FROM Visitors$
GROUP BY
CASE
WHEN PromotionCode IS NULL
	 OR LTRIM(RTRIM(PromotionCode)) = '' THEN 'No Promotion'
	 ELSE 'Has Promotion'
END
ORDER BY Num_of_Visitors DESC;

SELECT DISTINCT TicketType, CASE
WHEN PromotionCode IS NULL
	 OR LTRIM(RTRIM(PromotionCode)) = '' THEN 'No Promotion'
	 ELSE 'Has Promotion'
END AS Promotion_Status,
COUNT(*) AS Num_of_Visitors
FROM Visitors$
GROUP BY TicketType,CASE
WHEN PromotionCode IS NULL
	 OR LTRIM(RTRIM(PromotionCode)) = '' THEN 'No Promotion'
	 ELSE 'Has Promotion'
END
HAVING CASE
WHEN PromotionCode IS NULL
	 OR LTRIM(RTRIM(PromotionCode)) = '' THEN 'No Promotion'
	 ELSE 'Has Promotion'
END = 'Has Promotion'
ORDER BY COUNT(*) DESC;

SELECT DISTINCT AgeGroup,
COUNT(*) AS Num_of_Visitors,
ROUND(100.0*COUNT(*) / CAST ((SELECT COUNT(*) FROM Visitors$) AS FLOAT), 0) AS Visitors_Percentage
FROM Visitors$
GROUP BY AgeGroup
ORDER BY COUNT(*) DESC;

SELECT DISTINCT TicketType, ROUND(AVG(VisitDuration), 2) AS AVG_Visit_Duration
FROM Visitors$
GROUP BY TicketType
ORDER BY ROUND(AVG(VisitDuration), 2) DESC;

SELECT DISTINCT AgeGroup, ROUND(AVG(VisitDuration), 2) AS AVG_Visit_Duration
FROM Visitors$
GROUP BY AgeGroup
ORDER BY ROUND(AVG(VisitDuration), 2) DESC;

SELECT DISTINCT(Residence)
FROM Visitors$

SELECT US_State, 
COUNT(*) AS Num_of_Visitors, 
ROUND(
(COUNT(*)*100.0 / CAST((SELECT COUNT(*) FROM Visitors$) AS FLOAT)),
2
) AS Percentage_of_Visitors
FROM Visitors$
GROUP BY US_State
ORDER BY COUNT(*) DESC;

SELECT Country, 
COUNT(*) AS Num_of_International_Visitors,
ROUND(COUNT(*)*100 / CAST((SELECT COUNT(*) FROM Visitors$) AS FLOAT),
2
) AS Percentage_of_International_Visitors
FROM Visitors$
WHERE COUNTRY <> 'United States'
GROUP BY Country
ORDER BY COUNT(*) DESC;

-- Data Cleaning

EXEC sp_help 'Visitors$';

SELECT * INTO Visitors_Backup FROM Visitors$;

SELECT VisitorID
FROM Visitors$
WHERE TRY_CAST(VisitorID AS INT) IS NULL
      AND VisitorID IS NOT NULL;


ALTER TABLE Visitors$
ALTER COLUMN VisitorID VARCHAR(15);

ALTER TABLE Visitors$
ALTER COLUMN VisitDate DATE;

ALTER TABLE Visitors$
ALTER COLUMN TicketType VARCHAR(20);

ALTER TABLE Visitors$
ALTER COLUMN GroupSize INT;

ALTER TABLE Visitors$
ALTER COLUMN AgeGroup VARCHAR(10);

ALTER TABLE Visitors$
ALTER COLUMN Residence VARCHAR(100);

ALTER TABLE Visitors$
ALTER COLUMN EntryTime TIME(0);

ALTER TABLE Visitors$
ALTER COLUMN ExitTime TIME(0);

ALTER TABLE Visitors$
ALTER COLUMN VisitDuration DECIMAL(6,3);

ALTER TABLE Visitors$
ALTER COLUMN PromotionCode VARCHAR(30);

ALTER TABLE Visitors$
ADD Country VARCHAR(100);

UPDATE Visitors$
SET Country = 
    CASE 
        WHEN Residence = 'Springfield' THEN 'United States'
        WHEN Residence = 'Forest Glen' THEN 'United States'
        WHEN Residence = 'International-Germany' THEN 'Germany'
        WHEN Residence = 'River Bend' THEN 'United States'
        WHEN Residence = 'Crystal Lake' THEN 'United States'
        WHEN Residence = 'Cedar Rapids' THEN 'United States'
        WHEN Residence = 'Sunset Bay' THEN 'United States'
        WHEN Residence = 'Harbor View' THEN 'United States'
        WHEN Residence = 'Riverside' THEN 'United States'
        WHEN Residence = 'Willow Park' THEN 'United States'
        WHEN Residence = 'Green Valley' THEN 'United States'
        WHEN Residence = 'Pine City' THEN 'United States'
        WHEN Residence = 'Brighton' THEN 'United States'
        WHEN Residence = 'Mountain Creek' THEN 'United States'
        WHEN Residence = 'Milltown' THEN 'United States'
        WHEN Residence = 'Meadowville' THEN 'United States'
        WHEN Residence = 'International-UK' THEN 'United Kingdom'
        WHEN Residence = 'International-Japan' THEN 'Japan'
        WHEN Residence = 'International-Canada' THEN 'Canada'
        WHEN Residence = 'Lake Shore' THEN 'United States'
        WHEN Residence = 'International-Australia' THEN 'Australia'
        WHEN Residence = 'Pleasant Hills' THEN 'United States'
        WHEN Residence = 'Oakton' THEN 'United States'
        WHEN Residence = 'Maple Grove' THEN 'United States'
        WHEN Residence = 'Stone Bridge' THEN 'United States'
        ELSE NULL
    END;

SELECT Residence, Country
FROM Visitors$
GROUP BY Residence, Country
ORDER BY Residence;

ALTER TABLE Visitors$
ADD US_State VARCHAR(50);

UPDATE Visitors$
SET US_State =
    CASE 
        WHEN Residence = 'Springfield' THEN 'Illinois'
        WHEN Residence = 'Forest Glen' THEN 'Maryland'
        WHEN Residence = 'River Bend' THEN 'North Carolina'
        WHEN Residence = 'Crystal Lake' THEN 'Illinois'
        WHEN Residence = 'Cedar Rapids' THEN 'Iowa'
        WHEN Residence = 'Sunset Bay' THEN 'New York'
        WHEN Residence = 'Harbor View' THEN 'Ohio'
        WHEN Residence = 'Riverside' THEN 'California'
        WHEN Residence = 'Willow Park' THEN 'Texas'
        WHEN Residence = 'Green Valley' THEN 'Arizona'
        WHEN Residence = 'Pine City' THEN 'Minnesota'
        WHEN Residence = 'Brighton' THEN 'Michigan'
        WHEN Residence = 'Mountain Creek' THEN 'New Jersey'
        WHEN Residence = 'Milltown' THEN 'New Jersey'
        WHEN Residence = 'Meadowville' THEN 'Virginia'
        WHEN Residence = 'Lake Shore' THEN 'Maryland'
        WHEN Residence = 'Pleasant Hills' THEN 'Pennsylvania'
        WHEN Residence = 'Oakton' THEN 'Virginia'
        WHEN Residence = 'Maple Grove' THEN 'Minnesota'
        WHEN Residence = 'Stone Bridge' THEN 'Virginia'
        ELSE NULL
    END;

SELECT Residence, Country, US_State
FROM Visitors$
WHERE US_State IS NOT NULL
ORDER BY Residence;

SELECT COUNT(US_State)
FROM Visitors$

SELECT *
FROM Visitors$
WHERE ExitTime <= EntryTime;

UPDATE Visitors$ SET Residence = LTRIM(RTRIM(Residence));
UPDATE Visitors$ SET PromotionCode = NULL WHERE LTRIM(RTRIM(PromotionCode)) = '';

-- Data Analysis

-- Q1. What are the monthly and yearly trends in total visitor counts to identify peak seasons and overall growth in attendance?

SELECT YEAR(VisitDate) AS Year_of_Visit, MONTH(VisitDate) Month_of_Visit, COUNT(*) AS Num_of_Visitors
FROM Visitors$
GROUP BY YEAR(VisitDate), MONTH(VisitDate)
ORDER BY YEAR(VisitDate), MONTH(VisitDate)

SELECT YEAR(VisitDate) AS Year_of_Visit, MONTH(VisitDate) Month_of_Visit, COUNT(*) AS Num_of_Visitors
FROM Visitors$
GROUP BY YEAR(VisitDate), MONTH(VisitDate)
HAVING COUNT(*) > 580
ORDER BY COUNT(*) DESC;

-- Q2. What are the top countries and US states from which visitors originate?

SELECT Country, US_State, COUNT(*) AS Num_of_Visitors
FROM Visitors$
GROUP BY Country, US_State
ORDER BY COUNT(*) DESC;

-- Q3. How effective are different promotion codes in attracting visitors, measured by the number of uses per code?

SELECT PromotionCode, COUNT(*) AS Num_of_Uses
FROM Visitors$
GROUP BY PromotionCode
HAVING PromotionCode IS NOT NULL
ORDER BY COUNT(*) DESC;

-- Q4. What is the average group size across all visits, and how does it vary by age group or ticket type?

SELECT ROUND(AVG(GroupSize), 0) AS Avg_Group_Size, AgeGroup, TicketType
FROM Visitors$
GROUP BY AgeGroup, TicketType
ORDER BY AgeGroup, TicketType

-- Q5. What are the average entry and exit times, and how do they help identify peak crowd hours?

SELECT DATEPART(HOUR, EntryTime) AS Entry_Hour, ROUND(AVG(CAST(DATEPART(HOUR, ExitTime) AS FLOAT)), 2)  AS Avg_Exit_Time, COUNT(*) AS Num_of_Visitors
FROM Visitors$
GROUP BY DATEPART(HOUR, EntryTime)
ORDER BY COUNT(*) DESC;

-- Q6. What is the average visit duration by month to assess visitor engagement and satisfaction levels?

SELECT CASE 
    WHEN MONTH(VisitDate) = 1 THEN 'January'
    WHEN MONTH(VisitDate) = 2 THEN 'February'
    WHEN MONTH(VisitDate) = 3 THEN 'March'
    WHEN MONTH(VisitDate) = 4 THEN 'April'
    WHEN MONTH(VisitDate) = 5 THEN 'May'
    WHEN MONTH(VisitDate) = 6 THEN 'June'
    WHEN MONTH(VisitDate) = 7 THEN 'July'
    WHEN MONTH(VisitDate) = 8 THEN 'August'
    WHEN MONTH(VisitDate) = 9 THEN 'September'
    WHEN MONTH(VisitDate) = 10 THEN 'October'
    WHEN MONTH(VisitDate) = 11 THEN 'November'
    ELSE 'December'
END AS Month,
ROUND(CAST(AVG(VisitDuration) AS FLOAT), 2) AS Avg_Visit_Duration
FROM Visitors$
GROUP BY CASE 
    WHEN MONTH(VisitDate) = 1 THEN 'January'
    WHEN MONTH(VisitDate) = 2 THEN 'February'
    WHEN MONTH(VisitDate) = 3 THEN 'March'
    WHEN MONTH(VisitDate) = 4 THEN 'April'
    WHEN MONTH(VisitDate) = 5 THEN 'May'
    WHEN MONTH(VisitDate) = 6 THEN 'June'
    WHEN MONTH(VisitDate) = 7 THEN 'July'
    WHEN MONTH(VisitDate) = 8 THEN 'August'
    WHEN MONTH(VisitDate) = 9 THEN 'September'
    WHEN MONTH(VisitDate) = 10 THEN 'October'
    WHEN MONTH(VisitDate) = 11 THEN 'November'
    ELSE 'December'
END
ORDER BY MONTH(MIN(VisitDate))

-- Q7. How do visit patterns, such as duration and group size, differ between US and international visitors to tailor marketing strategies?

SELECT 
    CASE 
        WHEN Country = 'United States' THEN 'US'
        ELSE 'International'
    END AS Visitor_Type,
    ROUND(AVG(CAST(VisitDuration AS FLOAT)), 2) AS Avg_Visit_Duration,
    ROUND(AVG(CAST(GroupSize AS FLOAT)), 2) AS Avg_Group_Size,
    COUNT(*) AS Num_Visits
FROM Visitors$
GROUP BY 
    CASE 
        WHEN Country = 'United States' THEN 'US'
        ELSE 'International'
    END;
				
