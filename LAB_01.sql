-- Q1

CREATE TABLE client (
    clno CHAR(3) PRIMARY KEY,
    name VARCHAR(12),
    address VARCHAR(30)
);

CREATE TABLE stock (
    company CHAR(7) PRIMARY KEY,
    price NUMBER(6,2),
    dividend NUMBER(4,2),
    eps NUMBER(4,2)
);

CREATE TABLE trading (
    company CHAR(7),
    exchange VARCHAR(12),
    FOREIGN KEY (company) REFERENCES stock(company)
);

CREATE TABLE purchase (
    clno CHAR(3),
    company CHAR(7),
    pdate DATE,
    qty NUMBER(6),
    price NUMBER(6,2),
    FOREIGN KEY (clno) REFERENCES client(clno),
    FOREIGN KEY (company) REFERENCES stock(company)
);

-- Q2

INSERT INTO client VALUES ('c01', 'John Smith', '3 East Av, Bentley, WA 6102');
INSERT INTO client VALUES ('c02', 'Jill Brody', '42 Bent St, Perth, WA 6001');

INSERT INTO stock VALUES ('BHP', 10.50, 1.50, 3.20);
INSERT INTO stock VALUES ('IBM', 70.00, 4.25, 10.00);
INSERT INTO stock VALUES ('INTEL', 76.50, 5.00, 12.40);
INSERT INTO stock VALUES ('FORD', 40.00, 2.00, 8.50);
INSERT INTO stock VALUES ('GM', 60.00, 2.50, 9.20);
INSERT INTO stock VALUES ('INFOSYS', 45.00, 3.00, 7.80);

INSERT INTO trading VALUES ('BHP', 'Sydney');
INSERT INTO trading VALUES ('BHP', 'New York');
INSERT INTO trading VALUES ('IBM', 'New York');
INSERT INTO trading VALUES ('IBM', 'London');
INSERT INTO trading VALUES ('IBM', 'Tokyo');
INSERT INTO trading VALUES ('INTEL', 'New York');
INSERT INTO trading VALUES ('INTEL', 'London');
INSERT INTO trading VALUES ('FORD', 'New York');
INSERT INTO trading VALUES ('GM', 'New York');
INSERT INTO trading VALUES ('INFOSYS', 'New York');


-- Purchases by clients
INSERT INTO purchase VALUES ('c01', 'BHP', TO_DATE('02/10/2001', 'DD/MM/YYYY'), 1000, 12.00);
INSERT INTO purchase VALUES ('c01', 'BHP', TO_DATE('08/06/2002', 'DD/MM/YYYY'), 2000, 10.50);
INSERT INTO purchase VALUES ('c01', 'IBM', TO_DATE('12/02/2000', 'DD/MM/YYYY'), 500, 58.00);
INSERT INTO purchase VALUES ('c01', 'IBM', TO_DATE('10/04/2001', 'DD/MM/YYYY'), 1200, 65.00);
INSERT INTO purchase VALUES ('c01', 'INFOSYS', TO_DATE('11/08/2001', 'DD/MM/YYYY'), 1000, 64.00);
INSERT INTO purchase VALUES ('c02', 'INTEL', TO_DATE('30/01/2000', 'DD/MM/YYYY'), 300, 35.00);
INSERT INTO purchase VALUES ('c02', 'INTEL', TO_DATE('30/01/2001', 'DD/MM/YYYY'), 400, 54.00);
INSERT INTO purchase VALUES ('c02', 'INTEL', TO_DATE('02/10/2001', 'DD/MM/YYYY'), 200, 60.00);
INSERT INTO purchase VALUES ('c02', 'FORD', TO_DATE('05/10/1999', 'DD/MM/YYYY'), 300, 40.00);
INSERT INTO purchase VALUES ('c02', 'GM', TO_DATE('12/12/2000', 'DD/MM/YYYY'), 500, 55.50);

-- Q3

-- a)
SELECT c.name, s.company, s.price, s.dividend, s.eps
FROM client c
JOIN purchase p ON c.clno = p.clno
JOIN stock s ON p.company = s.company
ORDER BY c.name;

-- b)
SELECT c.name, p.company, SUM(p.qty) AS total_shares, SUM(p.qty * p.price) / SUM(p.qty) AS avg_purchase_price
FROM client c
JOIN purchase p ON c.clno = p.clno
GROUP BY c.name, p.company;


-- c)
SELECT s.company, c.name, SUM(p.qty) AS shares_held, SUM(p.qty * s.price) AS current_value
FROM client c
JOIN purchase p ON c.clno = p.clno
JOIN stock s ON p.company = s.company
JOIN trading t ON s.company = t.company
WHERE t.exchange = 'New York'
GROUP BY s.company, c.name;
/

-- d)
SELECT c.name, SUM(p.qty * p.price) AS total_purchase_value
FROM client c
JOIN purchase p ON c.clno = p.clno
GROUP BY c.name;

/
--e)
SELECT c.name, SUM(p.qty * s.price) - SUM(p.qty * p.price) AS book_profit_loss
FROM client c
JOIN purchase p ON c.clno = p.clno
JOIN stock s ON p.company = s.company
GROUP BY c.name;




