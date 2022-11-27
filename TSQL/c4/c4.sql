-- Example
DECLARE kursor CURSOR FOR SELECT ename, sal
                          FROM emp;
DECLARE @nazwisko VARCHAR(20), @pensja INT
OPEN kursor;
FETCH NEXT FROM kursor INTO @nazwisko, @pensja;
WHILE @@fetch_status = 0
    BEGIN
        PRINT @nazwisko + ' zarabia ' + CONVERT(VARCHAR, @pensja);
        FETCH NEXT FROM kursor INTO @nazwisko, @pensja;
    END;
CLOSE kursor;
DEALLOCATE kursor;
GO

-- Exercise 1
DECLARE employees CURSOR FOR SELECT empno, ename, sal
                             FROM emp;
DECLARE @id INT, @surname VARCHAR(20), @salary INT;
OPEN employees;
FETCH NEXT FROM employees INTO @id, @surname, @salary;
WHILE @@fetch_status = 0
    BEGIN
        PRINT @surname;
        IF @salary < 1000
            BEGIN
                PRINT 'Salary is lower than 1000.'
                SET @salary *= 1.1;
            END;
        ELSE
            BEGIN
                IF @salary > 1500
                    BEGIN
                        PRINT 'Salary is higher than 1500.'
                        SET @salary *= 0.9;
                    END;
            END;
        PRINT 'Salary is ' + CONVERT(VARCHAR, @salary) + '.';
        UPDATE emp SET sal=@salary WHERE empno = @id;
        FETCH NEXT FROM employees INTO @id, @surname, @salary;
    END;
CLOSE employees;
DEALLOCATE employees;
GO

--Exercise 2
DROP PROCEDURE flatEmp;
CREATE PROCEDURE flatEmp @higher INT,
                         @lower INT,
                         @percent FLOAT
AS
BEGIN
    DECLARE employees CURSOR FOR SELECT empno, ename, sal
                                 FROM emp;
    DECLARE @id INT, @surname VARCHAR(20), @salary INT;
    OPEN employees;
    FETCH NEXT FROM employees INTO @id, @surname, @salary;
    WHILE @@fetch_status = 0
        BEGIN
            PRINT @surname;
            IF @salary < @lower
                BEGIN
                    PRINT 'Salary is lower than 1000.'
                    SET @salary *= (1 + @percent);
                END;
            ELSE
                BEGIN
                    IF @salary > @higher
                        BEGIN
                            PRINT 'Salary is higher than 1500.'
                            SET @salary *= (1 - @percent);
                        END;
                END;
            PRINT 'Salary is ' + CONVERT(VARCHAR, @salary) + '.';
            UPDATE emp SET sal=@salary WHERE empno = @id;
            FETCH NEXT FROM employees INTO @id, @surname, @salary;
        END;
    CLOSE employees;
    DEALLOCATE employees;
END;
GO
--Exercise 3
CREATE PROCEDURE increaseCommForDept @deptNo INT, @percentOfSal FLOAT
AS
BEGIN
    DECLARE @empno INT, @ename VARCHAR(20), @sal INT, @comm INT, @eDept INT, @avgDeptSal INT; --variables
    SELECT @avgDeptSal = AVG(sal)
    FROM dept
             INNER JOIN emp e on dept.deptno = e.deptno
    WHERE dept.deptno = @deptNo; --finding average salary
    PRINT CONVERT(VARCHAR, @avgDeptSal) + ' is an average salary for dept number ' + CONVERT(VARCHAR, @deptNo);
    IF (SELECT COUNT(empno)
        FROM dept
                 INNER JOIN emp e on dept.deptno = e.deptno
        WHERE dept.deptno = @deptNo
          AND e.sal < @avgDeptSal) > 0 --if there are emp with
        BEGIN
            DECLARE empCur CURSOR FOR SELECT empno, ename, sal, comm, deptno FROM emp;
            OPEN empCur;
            FETCH NEXT FROM empCur INTO @empno, @ename, @sal, @comm, @eDept;
            WHILE @@fetch_status = 0
                BEGIN
                    IF @eDept = @deptNo AND @sal < @avgDeptSal
                        BEGIN
                            PRINT CONVERT(VARCHAR, @sal);
                            PRINT CONVERT(VARCHAR, @percentOfSal);
                            PRINT CONVERT(VARCHAR, @sal * @percentOfSal);
                            UPDATE emp SET comm = CONVERT(INT, (@sal * @percentOfSal)) WHERE empno = @empno;
                        END;
                    FETCH NEXT FROM empCur INTO @empno, @ename, @sal, @comm, @eDept;
                END;
            CLOSE empCur;
            DEALLOCATE empCur;
        END;
END;
GO
--Exercise 4
CREATE TABLE shop
(
    pNo     INT,
    pName   VARCHAR(20),
    pNumber INT
)
INSERT INTO shop
VALUES (1, 'Cactus', 7);
INSERT INTO shop
VALUES (2, 'Rose', 48);
INSERT INTO shop
VALUES (3, 'SunFlower', 12);
INSERT INTO shop
VALUES (4, 'Chamomile', 33);

CREATE PROCEDURE buyBiggestFromShop @number INT
AS
BEGIN
    DECLARE @pNo INT;
    SELECT @pNo = pNo FROM shop s WHERE s.pNumber = (SELECT MAX(s2.pNumber) FROM shop s2)
    BEGIN
        UPDATE shop SET pNumber-=@number WHERE pNo = @pNo
    END;
END;
GO
--Executes and Drops
--DROPS
DROP PROCEDURE increaseCommForDept;
DROP PROCEDURE flatEmp;
GO
--Executes
EXECUTE increaseCommForDept 10, 0.05;
EXECUTE buyBiggestFromShop 5;
GO