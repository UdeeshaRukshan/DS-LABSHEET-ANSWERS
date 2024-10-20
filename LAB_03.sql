-- Question 01
CREATE TYPE addrs_t AS OBJECT(
streetno INTEGER,
streetname VARCHAR(10),
suburb VARCHAR(10),
state VARCHAR(10),
pin INTEGER
)
/

CREATE TYPE exchange_arr AS VARRAY(5) OF VARCHAR(10)
/

CREATE TYPE stock_t AS OBJECT(
company VARCHAR(10),
currprice FLOAT,
exchtraded exchange_arr,
lstdividend FLOAT,
eps FLOAT
)
/

CREATE TYPE investment_t AS OBJECT(
company REF stock_t,
purprice FLOAT,
invstdate DATE,
qty INTEGER
)
/

CREATE TYPE investment_list AS TABLE OF investment_t
/

CREATE TYPE client_t AS OBJECT(
cno CHAR(3),
name VARCHAR(50),
address addrs_t,
investments investment_list
)
/


CREATE TABLE STOCKS OF stock_t(
company PRIMARY KEY
)
/

CREATE TABLE CLIENTS OF client_t(
cno PRIMARY KEY
)
NESTED TABLE investments STORE AS investment_table
/



-- Question 02
INSERT INTO STOCKS
VALUES(stock_t('BHP', 10.50, exchange_arr('Sydney', 'New York'), 1.50, 3.20))
/
INSERT INTO STOCKS
VALUES(stock_t('IBM', 70.00, exchange_arr('New York', 'London', 'Tokyo'), 4.25, 10.00))
/
INSERT INTO STOCKS
VALUES(stock_t('INTEL', 76.50, exchange_arr('New York', 'London'), 5.00, 12.40))
/
INSERT INTO STOCKS
VALUES(stock_t('FORD', 40.00, exchange_arr('New York'), 2.00, 8.50))
/
INSERT INTO STOCKS
VALUES(stock_t('GM', 60.00, exchange_arr('New York'), 2.50, 9.20))
/
INSERT INTO STOCKS
VALUES(stock_t('INFOSYS', 45.00, exchange_arr('New York'), 3.00, 7.80))
/

INSERT INTO CLIENTS
VALUES(
	client_t(
		'001', 	
		'John Smith',
		addrs_t(
			3, 
			'East Av', 
			'Bentley', 
			'WA', 
			6102
		),
		investment_list(
			investment_t(
				(SELECT REF(d) FROM STOCKS d WHERE d.company = 'BHP'),
				12.00,
				TO_DATE('02/10/01', 'DD/MM/YY'),
				1000
			),
			investment_t(
				(SELECT REF(d) FROM STOCKS d WHERE d.company = 'BHP'),
				10.50,
				TO_DATE('08/06/02', 'DD/MM/YY'),
				2000
			),
			investment_t(
				(SELECT REF(d) FROM STOCKS d WHERE d.company = 'IBM'),
				58.00,
				TO_DATE('12/02/00', 'DD/MM/YY'),
				500
			),
			investment_t(
				(SELECT REF(d) FROM STOCKS d WHERE d.company = 'IBM'),
				65.00,
				TO_DATE('10/04/01', 'DD/MM/YY'),
				1200
			),
			investment_t(
				(SELECT REF(d) FROM STOCKS d WHERE d.company = 'INFOSYS'),
				64.00,
				TO_DATE('11/08/01', 'DD/MM/YY'),
				1000
			)
		)
	)
)
/

INSERT INTO CLIENTS
VALUES(
	client_t(
		'002', 	
		'Jill Brody',
		addrs_t(
			42, 
			'Bent St', 
			'Perth', 
			'WA', 
			6001
		),
		investment_list(
			investment_t(
				(SELECT REF(d) FROM STOCKS d WHERE d.company = 'INTEL'),
				35.00,
				TO_DATE('30/01/00', 'DD/MM/YY'),
				300
			),
			investment_t(
				(SELECT REF(d) FROM STOCKS d WHERE d.company = 'INTEL'),
				54.00,
				TO_DATE('30/01/01', 'DD/MM/YY'),
				400
			),
			investment_t(
				(SELECT REF(d) FROM STOCKS d WHERE d.company = 'INTEL'),
				60.00,
				TO_DATE('02/10/01', 'DD/MM/YY'),
				200
			),
			investment_t(
				(SELECT REF(d) FROM STOCKS d WHERE d.company = 'FORD'),
				40.00,
				TO_DATE('05/10/99', 'DD/MM/YY'),
				300
			),
			investment_t(
				(SELECT REF(d) FROM STOCKS d WHERE d.company = 'GM'),
				55.50,
				TO_DATE('12/12/00', 'DD/MM/YY'),
				500
			)
		)
	)
)
/



-- Question 03
-- (a)
SELECT c.name, i.company.company AS STOCK_NAME, i.company.currprice AS C_PRICE, i.company.lstdividend AS L_DIVIDEND, i.company.eps AS EPS
FROM CLIENTS c, TABLE(c.investments) i
GROUP BY c.name, i.company.company, i.company.currprice, i.company.lstdividend, i.company.eps
ORDER BY c.name
/

-- (b)
SELECT c.name, i.company.company AS STOCK_NAME, SUM(i.qty) AS TOTAL_SHARES, SUM(i.qty*i.purprice)/SUM(i.qty) AS AVG_PRICE 
FROM CLIENTS c, TABLE(c.investments) i
GROUP BY c.name, i.company.company
ORDER BY c.name
/

-- (c)
SELECT i.company.company AS STOCK_NAME, c.name, SUM(i.qty) AS TOTAL_SHARES, SUM(i.qty*i.company.currprice) AS CURRENT_VALUE 
FROM CLIENTS c, TABLE(c.investments) i
GROUP BY i.company.company, c.name
ORDER BY i.company.company
/

-- (d)
SELECT c.name, SUM(i.qty*i.purprice) AS Total_value
FROM CLIENTS c, TABLE(c.investments) i
GROUP BY c.name
ORDER BY c.name
/


-- (e)
SELECT c.name, SUM(i.qty*i.company.currprice)-SUM(i.qty*i.purprice) AS Book_Profit
FROM CLIENTS c, TABLE(c.investments) i
GROUP BY c.name
/



-- Question 04
DELETE TABLE(
	SELECT c.investments
	FROM CLIENTS c
	WHERE c.cno = '001'
) i
WHERE i.company.company = 'INFOSYS'
/

INSERT INTO TABLE(
	SELECT c.investments
	FROM CLIENTS c
	WHERE c.cno = '002'
)
VALUES(
	investment_t(
		(SELECT REF(d) FROM STOCKS d WHERE d.company = 'INFOSYS'),
		45.00,
		TO_DATE(SYSDATE, 'DD/MM/YY'),
		1000
	)
)
/

DELETE TABLE(
	SELECT c.investments
	FROM CLIENTS c
	WHERE c.cno = '002'
) i
WHERE i.company.company = 'GM'
/

INSERT INTO TABLE(
	SELECT c.investments
	FROM CLIENTS c
	WHERE c.cno = '001'
)
VALUES(
	investment_t(
		(SELECT REF(d) FROM STOCKS d WHERE d.company = 'GM'),
		60.00,
		TO_DATE(SYSDATE, 'DD/MM/YY'),
		500
	)
)
/