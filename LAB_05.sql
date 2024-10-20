-- Task 01
-- (a)
CREATE TYPE student_type AS OBJECT(
sid CHAR(8),
sname VARCHAR(15),
phone CHAR(10)
) NOT FINAL
/

CREATE TYPE ug_type UNDER student_type(
gpa REAL,
deptid CHAR(6),
course VARCHAR(10)
)
/


-- (b)
CREATE TABLE students OF student_type
/

INSERT INTO students VALUES(
	ug_type('12354326', 'Janet Paeres', null, 3.2, 'CS01', 'Info Tech')
)
/


-- (c)
SELECT s.sid, s.sname 
FROM students s 
WHERE TREAT(VALUE(s) AS ug_type).deptid = 'CS01'
/



-- Task 02
CREATE TYPE Customer_t AS OBJECT(
cid CHAR(6),
name varchar(15),
birthdate DATE,
phone CHAR(10),
address VARCHAR(50)
)
/

CREATE TYPE Car_t AS OBJECT(
regno CHAR(9),
make VARCHAR(12),
model VARCHAR(10),
mdate DATE,
owner REF Customer_t,
value NUMBER(8,2)
)
/

CREATE TYPE Claim_t AS OBJECT(
claimno CHAR(12),
cdate DATE,
amount NUMBER(8,2),
claimant REF Customer_t
)
/

CREATE TYPE Claim_ntab AS TABLE OF Claim_t
/

CREATE TYPE Policy_t AS OBJECT(
pid CHAR(7),
sdate DATE,
edate DATE,
inscar REF Car_t,
premium NUMBER(6,2),
claims Claim_ntab
)
/

CREATE TABLE Customers OF Customer_t(
cid PRIMARY KEY
)
/

CREATE TABLE Cars OF Car_t(
regno PRIMARY KEY,
owner REFERENCES Customers
)
/

CREATE TABLE Policies OF policy_t(
pid PRIMARY KEY,
inscar REFERENCES Cars
)
NESTED TABLE Claims STORE AS Claims_ntable
/

-- (a)
-- (i)
SELECT AVG(p.premium) AS Average_Premium
FROM Policies p
WHERE MONTHS_BETWEEN(SYSDATE, p.inscar.owner.birthdate) / 12 >= 20 
  AND MONTHS_BETWEEN(SYSDATE, p.inscar.owner.birthdate) / 12 <= 25
/

-- (ii)
SELECT p.inscar.make, p.inscar.model, SUM(c.amount) AS Total_Claim_Amnt
FROM Policies p, TABLE(p.claims) c
WHERE p.edate > TO_DATE('2004-01-01', 'YYYY-MM-DD') AND p.edate < TO_DATE('2004-12-31', 'YYYY-MM-DD')
GROUP BY p.inscar.make, p.inscar.model;
/

-- (b)
INSERT INTO TABLE(
	SELECT p.claims
	FROM Policies p
	WHERE p.pid = 'SL12354'
)
VALUES(
	Claim_t('001', TO_DATE('2004-07-12', 'YYYY-MM-DD'), 2000, (SELECT REF(c) FROM Customers c WHERE c.cid = 'S25431'))
);

-- (c)
ALTER TYPE Policy_t ADD MEMBER FUNCTION getRenewalPremium RETURN FLOAT CASCADE;
/

CREATE OR REPLACE TYPE BODY Policy_t AS
   MEMBER FUNCTION getRenewalPremium RETURN FLOAT IS
      total_claim_amnt NUMBER := 0;
   BEGIN
      IF SELF.claims.COUNT > 0 THEN
         FOR i IN 1..SELF.claims.COUNT LOOP
            total_claim_amnt := total_claim_amnt + SELF.claims(i).amount;
         END LOOP;
      END IF;

      IF total_claim_amnt < 1000 THEN
         RETURN SELF.premium;
      ELSE
         RETURN (SELF.premium + (SELF.premium * 0.2));
      END IF;
   END;
END;
/

-- (d)
SELECT p.getRenewalPremium() AS Renewal_Premium
FROM Policies p
WHERE p.inscar.regno = 'SLA984';
/


