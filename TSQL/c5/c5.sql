--Przykład
CREATE TRIGGER trigger1
    ON EMP
    FOR INSERT
    AS
BEGIN
    ROLLBACK
end
    SELECT *
    FROM EMP
    INSERT INTO emp
    VALUES (9999, 'TEST2', 'SALESMAN', null, null, 3000, null, 10)
--This will be rolled back because of the trigger
GO
--Exercise1
CREATE TRIGGER cancelDelEmpTrigger
    ON EMP
    FOR DELETE AS
BEGIN
    ROLLBACK;
END
GO
DELETE
FROM emp
WHERE EMPNO = 7934;
GO
--Exercise2
CREATE TRIGGER commEmpNullTrigger
    ON EMP
    FOR INSERT AS
BEGIN
    UPDATE emp SET comm = 0 WHERE EMPNO IN (SELECT empno FROM inserted WHERE comm IS NULL);
end
GO
INSERT INTO EMP
VALUES (9999, 'TEST2', 'SALESMAN', null, null, 3000, null, 10)
GO
--Exercise3
CREATE TRIGGER checkForSalary
    ON EMP
    FOR UPDATE AS
BEGIN
    DECLARE cursor2 CURSOR FOR SELECT empno FROM inserted;
    DECLARE @empno INT;
    OPEN cursor2;
    FETCH NEXT FROM cursor2 INTO @empno;
    WHILE @@FETCH_STATUS = 0
        BEGIN
            IF (SELECT SAL FROM inserted WHERE EMPNO = @empno AND SAL < 1000)
                ROLLBACK;
            FETCH NEXT FROM cursor2 INTO @empno
        end
    CLOSE cursor2;
    DEALLOCATE cursor2;
end
Go
--Exercise 4
-- CREATE TABLE budget (value INT NOT NULL)
-- INSERT INTO budget (value) SELECT SUM(sal) FROM emp
-- CREATE TRIGGER budgetCheck ON EMP