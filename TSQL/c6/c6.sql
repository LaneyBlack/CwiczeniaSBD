--Task1
CREATE TRIGGER task1
    ON PRACOWNIK
    FOR delete AS
BEGIN
    ROLLBACK;
end
GO
--Task2
ALTER PROCEDURE getNumberOfDeals @cname VARCHAR(20), @csurname VARCHAR(20), @count INT OUTPUT
AS
BEGIN
    SELECT @count = COUNT(*)
    FROM SPRZEDAZ
    WHERE ID_KLIENT = (SELECT ID_KLIENT FROM KLIENT WHERE IMIE = @cname AND NAZWISKO = @csurname);
end
GO
DECLARE @number INT;
EXECUTE getNumberOfDeals 'MATEUSZ', 'TRUSKAWKA', @number OUTPUT;
PRINT 'For client Truskawka number of deals is ' + CONVERT(VARCHAR, @number);
GO
--Task3
CREATE TRIGGER task3
    ON PRODUKT
    FOR delete AS
BEGIN
    IF EXISTS(SELECT deleted.ID_PRODUKT
              FROM deleted
                       INNER JOIN SPRZEDAZ ON deleted.ID_PRODUKT = SPRZEDAZ.ID_PRODUKT)
        ROLLBACK;
end
GO

DELETE
FROM PRODUKT
WHERE ID_PRODUKT = 4;
GO
--Task4
ALTER PROCEDURE task4 @cityName VARCHAR(20)
AS
BEGIN
    IF NOT EXISTS(SELECT ID_MIASTO FROM MIASTO WHERE MIASTO = @cityName)
        INSERT INTO MIASTO VALUES ((SELECT MAX(ID_MIASTO) + 1 FROM MIASTO), @cityName);
    UPDATE KLIENT
    SET ID_MIASTO = (SELECT ID_MIASTO FROM MIASTO WHERE MIASTO = @cityName)
    WHERE (SELECT ID_MIASTO FROM KLIENT) IS NULL;
end
GO
--Task5
CREATE TRIGGER task5
    ON PRACOWNIK
    FOR insert AS
BEGIN
    DECLARE cursor CURSOR FOR SELECT ID_PRACOWNIK FROM inserted;
    DECLARE @empID INT;
    OPEN cursor;
    FETCH NEXT FROM cursor INTO @empID;
    WHILE @@fetch_status = 0
        BEGIN
            IF (EXISTS(SELECT NAZWISKO
                       FROM PRACOWNIK
                       WHERE NAZWISKO = (SELECT NAZWISKO FROM inserted
                                            WHERE inserted.ID_PRACOWNIK = @empID)))
             DELETE FROM PRACOWNIK WHERE ID_PRACOWNIK = @empID;
             FETCH NEXT FROM cursor INTO @empID;
        end
end