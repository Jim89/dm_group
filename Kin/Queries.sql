DROP TABLE Contact;
CREATE TABLE Contact(CUST_ID INTEGER,ContactDate DATE,ContactType char(5));
COPY Contact FROM 'C:/Users/cheukkin.Warwick/Desktop/Digital Marketing/DMEFExtractContactsV01.CSV' DELIMITER ',' CSV HEADER NULL AS ' ';
DROP TABLE Lines;
CREATE TABLE Lines(CUST_ID INTEGER,OrderNum BIGINT,OrderDate DATE,LineDollars FLOAT,Gift CHAR(5),RecipNum INTEGER);
COPY Lines FROM 'C:/Users/cheukkin.Warwick/Desktop/Digital Marketing/DMEFExtractLinesV01.CSV' DELIMITER ',' CSV HEADER NULL AS ' ';
DROP TABLE Orders;
CREATE TABLE Orders(Cust_ID INTEGER,OrderNum BIGINT,OrderDate DATE,OrderMethod CHAR(5),PaymentType CHAR(5));
COPY Orders FROM 'C:/Users/cheukkin.Warwick/Desktop/Digital Marketing/DMEFExtractOrdersV01.CSV' DELIMITER ',' CSV HEADER NULL AS ' ';
DROP TABLE Summary;
CREATE TABLE Summary(Cust_ID INTEGER, SCF_Code INTEGER, RetF07Dollars INTEGER, RetF07Trips INTEGER, RetF07Lines INTEGER, RetS07Dollars INTEGER, RetS07Trips INTEGER, RetS07Lines INTEGER, RetF06Dollars INTEGER, RetF06Trips INTEGER, RetF06Lines INTEGER, RetS06Dollars INTEGER, RetS06Trips INTEGER, RetS06Lines INTEGER, RetF05Dollars INTEGER, RetF05Trips INTEGER, RetF05Lines INTEGER, RetS05Dollars INTEGER, RetS05Trips INTEGER, RetS05Lines INTEGER, RetF04Dollars INTEGER, RetF04Trips INTEGER, RetF04Lines INTEGER, RetS04Dollars INTEGER, RetS04Trips INTEGER, RetS04Lines INTEGER, RetPre04Dollars INTEGER, RetPre04Trips INTEGER, RetPre04Lines INTEGER, RetPre04Recency INTEGER, IntF07GDollars INTEGER, IntF07NGDollars INTEGER, IntF07Orders INTEGER, IntF07Lines INTEGER, IntS07GDollars INTEGER, IntS07NGDollars INTEGER, IntS07Orders INTEGER, IntS07Lines INTEGER, IntF06GDollars INTEGER, IntF06NGDollars INTEGER, IntF06Orders INTEGER, IntF06Lines INTEGER, IntS06GDollars INTEGER, IntS06NGDollars INTEGER, IntS06Orders INTEGER, IntS06Lines INTEGER, IntF05GDollars INTEGER, IntF05NGDollars INTEGER, IntF05Orders INTEGER, IntF05Lines INTEGER, IntS05GDollars INTEGER, IntS05NGDollars INTEGER, IntS05Orders INTEGER, IntS05Lines INTEGER, IntF04GDollars INTEGER, IntF04NGDollars INTEGER, IntF04Orders INTEGER, IntF04Lines INTEGER, IntS04GDollars INTEGER, IntS04NGDollars INTEGER, IntS04Orders INTEGER, IntS04Lines INTEGER, IntPre04GDollars INTEGER, IntPre04NGDollars INTEGER, IntPre04Orders INTEGER, IntPre04Lines INTEGER, IntPre04Recency INTEGER, CatF07GDollars INTEGER, CatF07NGDollars INTEGER, CatF07Orders INTEGER, CatF07Lines INTEGER, CatS07GDollars INTEGER, CatS07NGDollars INTEGER, CatS07Orders INTEGER, CatS07Lines INTEGER, CatF06GDollars INTEGER, CatF06NGDollars INTEGER, CatF06Orders INTEGER, CatF06Lines INTEGER, CatS06GDollars INTEGER, CatS06NGDollars INTEGER, CatS06Orders INTEGER, CatS06Lines INTEGER, CatF05GDollars INTEGER, CatF05NGDollars INTEGER, CatF05Orders INTEGER, CatF05Lines INTEGER, CatS05GDollars INTEGER, CatS05NGDollars INTEGER, CatS05Orders INTEGER, CatS05Lines INTEGER, CatF04GDollars INTEGER, CatF04NGDollars INTEGER, CatF04Orders INTEGER, CatF04Lines INTEGER, CatS04GDollars INTEGER, CatS04NGDollars INTEGER, CatS04Orders INTEGER, CatS04Lines INTEGER, CatPre04GDollars INTEGER, CatPre04NGDollars INTEGER, CatPre04Orders INTEGER, CatPre04Lines INTEGER, CatPre04Recency INTEGER, EmailsF07 INTEGER, EmailsS07 INTEGER, EmailsF06 INTEGER, EmailsS06 INTEGER, EmailsF05 INTEGER, EmailsS05 INTEGER, CatCircF07 INTEGER, CatCircS07 INTEGER, CatCircF06 INTEGER, CatCircS06 INTEGER, CatCircF05 INTEGER, CatCircS05 INTEGER, GiftRecF07 INTEGER, GiftRecS07 INTEGER, GiftRecF06 INTEGER, GiftRecS06 INTEGER, GiftRecF05 INTEGER, GiftRecS05 INTEGER, GiftRecF04 INTEGER, GiftRecS04 INTEGER, GiftRecPre04 INTEGER, NewGRF07 INTEGER, NewGRS07 INTEGER, NewGRF06 INTEGER, NewGRS06 INTEGER, NewGRF05 INTEGER, NewGRS05 INTEGER, NewGRF04 INTEGER, NewGRS04 INTEGER, NewGRPre04 INTEGER, FFYYMM date, FirstChannel CHAR(3), FirstDollar INTEGER, StoreDist decimal, AcqDate INTEGER, Email CHAR(1), OccupCd INTEGER, Travel CHAR(1), CurrAff CHAR(1), CurrEv CHAR(1), Wines CHAR(1), FineArts CHAR(1), Exercise CHAR(1), SelfHelp CHAR(1), Collect CHAR(1), Needle CHAR(1), Sewing CHAR(1), DogOwner CHAR(1), CarOwner CHAR(1), Cooking CHAR(1), Pets CHAR(1), Fashion CHAR(1), Camping CHAR(1), Hunting CHAR(1), Boating CHAR(1), AgeCode INTEGER, IncCode INTEGER, HomeCode INTEGER, Child0_2 CHAR(1), Child3_5 CHAR(1), Child6_11 CHAR(1), Child12_16 CHAR(1), Child17_18 CHAR(1), Dwelling INTEGER, LengthRes INTEGER, HomeValue BIGINT);
COPY Summary FROM 'C:/Users/cheukkin.Warwick/Desktop/Digital Marketing/DMEFExtractSummaryV01.CSV' DELIMITER ',' CSV HEADER NULL AS ' ';

SELECT SCF_Code,avg(Spend_per_order) AS regional_avg_spending 

FROM (
   (SELECT DISTINCT Cust_ID,SCF_Code FROM Summary) AS Area 
   RIGHT JOIN 
   (SELECT Cust_ID,sum(LineDollars) AS Spend_per_order FROM Lines GROUP BY Cust_ID,OrderNUM) AS OrdSpend 
   ON OrdSpend.Cust_ID=Area.Cust_ID) 

GROUP BY SCF_Code 
ORDER BY regional_avg_spending 
DESC 
LIMIT 5;



SELECT * FROM (
(SELECT Cust_ID,SUM(CASE WHEN ContactType='E' THEN 1 ELSE 0 END) as MailCount,SUM(CASE WHEN ContactType='C' THEN 1 ELSE 0 END) as CTLGCount,EXTRACT(YEAR FROM ContactDate) as ContactYear,EXTRACT(MONTH FROM ContactDate) as ContactMonth FROM Contact GROUP BY Cust_ID,ContactYear,ContactMonth) AS ContactCount
INNER JOIN
(SELECT Cust_ID,SUM(LineDollars) as Purchase,EXTRACT(YEAR FROM OrderDate) as OrderYear,EXTRACT(MONTH FROM OrderDate) as OrderMonth FROM Lines GROUP BY Cust_ID,OrderYear,OrderMonth) AS LinesCount
ON ContactCount.Cust_ID=LinesCount.Cust_ID AND ContactCount.ContactYear=LinesCount.OrderYear AND ContactCount.ContactMonth=LinesCount.OrderMonth
);

SELECT * FROM (
(SELECT Cust_ID,SUM(CASE WHEN ContactType='E' THEN 1 ELSE 0 END) as MailCount,SUM(CASE WHEN ContactType='C' THEN 1 ELSE 0 END) as CTLGCount,EXTRACT(YEAR FROM ContactDate) as ContactYear,EXTRACT(MONTH FROM ContactDate) as ContactMonth FROM Contact GROUP BY Cust_ID,ContactYear,ContactMonth) AS ContactCount
RIGHT JOIN
(SELECT Cust_ID,SUM(LineDollars) as Purchase,EXTRACT(YEAR FROM OrderDate) as OrderYear,EXTRACT(MONTH FROM OrderDate) as OrderMonth FROM Lines GROUP BY Cust_ID,OrderYear,OrderMonth) AS LinesCount
ON ContactCount.Cust_ID=LinesCount.Cust_ID AND ContactCount.ContactYear=LinesCount.OrderYear AND ContactCount.ContactMonth=LinesCount.OrderMonth
);

SELECT * FROM (
(SELECT Cust_ID,SUM(CASE WHEN ContactType='E' THEN 1 ELSE 0 END) as MailCount,SUM(CASE WHEN ContactType='C' THEN 1 ELSE 0 END) as CTLGCount,EXTRACT(YEAR FROM ContactDate) as ContactYear,EXTRACT(MONTH FROM ContactDate) as ContactMonth FROM Contact GROUP BY Cust_ID,ContactYear,ContactMonth) AS ContactCount
LEFT JOIN
(SELECT Cust_ID,SUM(LineDollars) as Purchase,EXTRACT(YEAR FROM OrderDate) as OrderYear,EXTRACT(MONTH FROM OrderDate) as OrderMonth FROM Lines GROUP BY Cust_ID,OrderYear,OrderMonth) AS LinesCount
ON ContactCount.Cust_ID=LinesCount.Cust_ID AND ContactCount.ContactYear=LinesCount.OrderYear AND ContactCount.ContactMonth=LinesCount.OrderMonth
);

SELECT * FROM (
(SELECT Cust_ID,SUM(CASE WHEN ContactType='E' THEN 1 ELSE 0 END) as MailCount,SUM(CASE WHEN ContactType='C' THEN 1 ELSE 0 END) as CTLGCount,EXTRACT(YEAR FROM ContactDate) as ContactYear,EXTRACT(MONTH FROM ContactDate) as ContactMonth FROM Contact GROUP BY Cust_ID,ContactYear,ContactMonth) AS ContactCount
FULL JOIN
(SELECT Cust_ID,SUM(LineDollars) as Purchase,EXTRACT(YEAR FROM OrderDate) as OrderYear,EXTRACT(MONTH FROM OrderDate) as OrderMonth FROM Lines GROUP BY Cust_ID,OrderYear,OrderMonth) AS LinesCount
ON ContactCount.Cust_ID=LinesCount.Cust_ID AND ContactCount.ContactYear=LinesCount.OrderYear AND ContactCount.ContactMonth=LinesCount.OrderMonth
);


SELECT Cust_ID,SUM(CASE WHEN ContactType='E' THEN 1 ELSE 0 END) as MailCount,SUM(CASE WHEN ContactType='C' THEN 1 ELSE 0 END) as CTLGCount,EXTRACT(YEAR FROM ContactDate) as ContactYear,EXTRACT(MONTH FROM ContactDate) as ContactMonth FROM Contact GROUP BY Cust_ID,ContactYear,ContactMonth;
SELECT Cust_ID,SUM(LineDollars) as Purchase,EXTRACT(YEAR FROM OrderDate) as OrderYear,EXTRACT(MONTH FROM OrderDate) as OrderMonth FROM Lines GROUP BY Cust_ID,OrderYear,OrderMonth;



