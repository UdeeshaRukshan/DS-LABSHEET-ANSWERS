-- Question 01

-- (a)
CREATE TYPE emp_t
/

CREATE TYPE dept_t AS OBJECT(
DEPTNO CHAR(3),
DEPTNAME VARCHAR(36),
MGRNO REF emp_t,
ADMRDEPT REF dept_t
)
/

CREATE TYPE emp_t AS OBJECT(
EMPNO CHAR(6),
FIRSTNAME VARCHAR(12),
LASTNAME VARCHAR(15),
WORKDEPT REF dept_t,
SEX CHAR(1),
BIRTHDATE DATE,
SALARY NUMBER(8,2)
)
/

-- (b)
CREATE TABLE OREMP OF emp_t(
EMPNO PRIMARY KEY,
FIRSTNAME NOT NULL,
LASTNAME NOT NULL
)
/

CREATE TABLE ORDEPT OF dept_t(
DEPTNO PRIMARY KEY,
DEPTNAME NOT NULL
)
/

-- (c)
INSERT INTO OREMP VALUES(emp_t('000010','CHRISTINE', 'HAAS', NULL, 'F', '14/AUG/53', 72750));
INSERT INTO OREMP VALUES(emp_t('000020','MICHAEL', 'THOMPSON', NULL, 'M', '02/FEB/68', 61250));
INSERT INTO OREMP VALUES(emp_t('000030','SALLY', 'KWAN', NULL, 'F', '11/MAY/71', 58250));
INSERT INTO OREMP VALUES(emp_t('000060','IRVING', 'STERN', NULL, 'M', '07/JUL/65', 55555));
INSERT INTO OREMP VALUES(emp_t('000070','EVA', 'PULASKI', NULL, 'F', '26/MAY/73', 56170));
INSERT INTO OREMP VALUES(emp_t('000050','JOHN', 'GEYER', NULL, 'M', '15/SEP/55', 60175));
INSERT INTO OREMP VALUES(emp_t('000090','EILEEN', 'HENDERSON', NULL, 'F', '15/MAY/61', 49750));
INSERT INTO OREMP VALUES(emp_t('000100','THEODORE', 'SPENSER', NULL, 'M', '18/DEC/76', 46150));

INSERT INTO ORDEPT VALUES(dept_t('A00','SPIFFY COMPUTER SERVICE DIV.', NULL, NULL));
INSERT INTO ORDEPT VALUES(dept_t('B01','PLANNING', NULL, NULL));
INSERT INTO ORDEPT VALUES(dept_t('C01','INFORMATION CENTRE', NULL, NULL));
INSERT INTO ORDEPT VALUES(dept_t('D01','DEVELOPMENT CENTRE', NULL, NULL));


UPDATE OREMP
SET WORKDEPT = (SELECT REF(D) FROM ORDEPT D WHERE D.DEPTNO = 'A00')
WHERE EMPNO = '000010';

UPDATE OREMP
SET WORKDEPT = (SELECT REF(D) FROM ORDEPT D WHERE D.DEPTNO = 'B01')
WHERE EMPNO = '000020';

UPDATE OREMP
SET WORKDEPT = (SELECT REF(D) FROM ORDEPT D WHERE D.DEPTNO = 'C01')
WHERE EMPNO = '000030';

UPDATE OREMP
SET WORKDEPT = (SELECT REF(D) FROM ORDEPT D WHERE D.DEPTNO = 'D01')
WHERE EMPNO = '000060';

UPDATE OREMP
SET WORKDEPT = (SELECT REF(D) FROM ORDEPT D WHERE D.DEPTNO = 'D01')
WHERE EMPNO = '000070';

UPDATE OREMP
SET WORKDEPT = (SELECT REF(D) FROM ORDEPT D WHERE D.DEPTNO = 'C01')
WHERE EMPNO = '000050';

UPDATE OREMP
SET WORKDEPT = (SELECT REF(D) FROM ORDEPT D WHERE D.DEPTNO = 'B01')
WHERE EMPNO = '000090';

UPDATE OREMP
SET WORKDEPT = (SELECT REF(D) FROM ORDEPT D WHERE D.DEPTNO = 'B01')
WHERE EMPNO = '000100';


UPDATE ORDEPT
SET ADMRDEPT = (SELECT REF(D) FROM ORDEPT D WHERE D.DEPTNO = 'A00'),
MGRNO = (SELECT REF(E) FROM OREMP E WHERE E.EMPNO = '000010')
WHERE DEPTNO = 'A00';

UPDATE ORDEPT
SET ADMRDEPT = (SELECT REF(D) FROM ORDEPT D WHERE D.DEPTNO = 'A00'),
MGRNO = (SELECT REF(E) FROM OREMP E WHERE E.EMPNO = '000020')
WHERE DEPTNO = 'B01';

UPDATE ORDEPT
SET ADMRDEPT = (SELECT REF(D) FROM ORDEPT D WHERE D.DEPTNO = 'A00'),
MGRNO = (SELECT REF(E) FROM OREMP E WHERE E.EMPNO = '000030')
WHERE DEPTNO = 'C01';

UPDATE ORDEPT
SET ADMRDEPT = (SELECT REF(D) FROM ORDEPT D WHERE D.DEPTNO = 'C01'),
MGRNO = (SELECT REF(E) FROM OREMP E WHERE E.EMPNO = '000060')
WHERE DEPTNO = 'D01';



-- Question 02

-- (a)
SELECT D.DEPTNAME, D.MGRNO.LASTNAME FROM ORDEPT D;

-- (b)
SELECT E.EMPNO, E.LASTNAME, E.WORKDEPT.DEPTNAME FROM OREMP E;

-- (c)
SELECT D.DEPTNO, D.DEPTNAME, D.ADMRDEPT.DEPTNAME FROM ORDEPT D;

-- (d)
SELECT D.DEPTNO, D.DEPTNAME, D.ADMRDEPT.DEPTNAME, D.ADMRDEPT.MGRNO.LASTNAME FROM ORDEPT D;

-- (e)
SELECT E.EMPNO, E.FIRSTNAME, E.LASTNAME, E.SALARY, E.WORKDEPT.MGRNO.LASTNAME, E.WORKDEPT.MGRNO.SALARY FROM OREMP E;

-- (f)
SELECT E.WORKDEPT.DEPTNO, E.WORKDEPT.DEPTNAME, E.SEX, AVG(E.SALARY) 
FROM OREMP E
GROUP BY E.WORKDEPT.DEPTNO, E.WORKDEPT.DEPTNAME, E.SEX
ORDER BY E.WORKDEPT.DEPTNO;




