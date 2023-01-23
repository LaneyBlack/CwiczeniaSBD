--1
BEGIN
    FOR row IN (SELECT ename, sal FROM emp) LOOP
        IF row.sal < 1000 THEN
            UPDATE emp SET emp.sal= row.sal*0.1 + row.sal WHERE emp.ename = row.ename;
        ELSE 
            IF row.sal > 1500 THEN
                UPDATE emp SET emp.sal = row.sal - row.sal*0.1 WHERE emp.ename = row.ename;
            END IF;
        END IF;
    END LOOP;
END;
--2
CREATE OR REPLACE PROCEDURE ex2(fromSal INT, toSal INT)
AS BEGIN
FOR row IN (SELECT ename, sal FROM emp) LOOP
        IF row.sal < 1000 THEN
            UPDATE emp SET emp.sal= row.sal*0.1 + row.sal WHERE emp.ename = row.ename;
        ELSE 
            IF row.sal > 1500 THEN
                UPDATE emp SET emp.sal = row.sal - row.sal*0.1 WHERE emp.ename = row.ename;
            END IF;
        END IF;
    END LOOP;
END;

EXECUTE ex2(1000,1500);
--3
CREATE OR REPLACE PROCEDURE ex3
AS
    average INT;
    BEGIN
        SELECT AVG(sal) INTO average FROM emp;
        FOR row IN (SELECT empno, sal FROM emp) LOOP
            IF row.sal < average THEN
                UPDATE emp SET emp.comm = emp.comm + emp.sal*0.05 WHERE emp.empno = row.empno;
            END IF;
        END LOOP;
    END;
--4
CREATE TABLE warehouse(
    IdPos INT,
    NamePos VARCHAR(20),
    CountPos INT
);
DECLARE maxCount INT;
BEGIN
    SELECT MAX(CountPos) INTO maxCount FROM warehouse;
    IF maxCount>5 THEN
        UPDATE warehouse SET CountPos = CountPos - 5 WHERE IdPos = (SELECT IdPos FROM warehouse WHERE CountPos = maxCount);
    ELSE
        dbms_output.put_line('Za malo produktow');
    END IF;
END;
--5
CREATE OR REPLACE PROCEDURE ex5 (toMinus INT)
AS
    maxCount INT;
BEGIN
SELECT MAX(CountPos) INTO maxCount FROM warehouse;
    IF maxCount>toMinus THEN
        UPDATE warehouse SET CountPos = CountPos - toMinus WHERE IdPos = (SELECT IdPos FROM warehouse WHERE CountPos = maxCount);
    ELSE
        dbms_output.put_line('Za malo produktow');
    END IF;
END;
