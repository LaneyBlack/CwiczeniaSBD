--Task1
CREATE TRIGGER task1
    ON PRACOWNIK
    FOR delete AS
BEGIN
    ROLLBACK;
end
GO
--Task2
Create PROCEDURE getNumberOfDeals @cname VARCHAR(20), @csurname VARCHAR(20), @count INT OUTPUT
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
    DELETE
    FROM PRACOWNIK
    WHERE ID_PRACOWNIK IN (SELECT ID_PRACOWNIK
                           FROM inserted
                                    INNER JOIN PRACOWNIK ON PRACOWNIK.NAZWISKO = inserted.NAZWISKO
                           WHERE inserted.ID_PRACOWNIK != PRACOWNIK.ID_PRACOWNIK)
end
GO
--Task6
CREATE PROCEDURE task6 @name VARCHAR(20), @surname VARCHAR(20), @city VARCHAR(20)
AS
BEGIN
    If NOT EXISTS(SELECT * FROM MIASTO WHERE MIASTO = @city)
        INSERT INTO MIASTO VALUES ((SELECT MAX(ID_MIASTO) + 1 FROM MIASTO), @city);
    If NOT EXISTS(SELECT IMIE, NAZWISKO FROM PRACOWNIK WHERE IMIE = @name AND NAZWISKO = @surname)
        INSERT INTO PRACOWNIK
        VALUES ((SELECT MAX(ID_PRACOWNIK) + 1 FROM PRACOWNIK),
                @name, @surname, 0,
                (SELECT MAX(ID_MIASTO) FROM MIASTO));
    ELSE
        UPDATE PRACOWNIK
        SET ID_MIASTO = (SELECT ID_MIASTO FROM MIASTO WHERE MIASTO = @city)
        WHERE IMIE = @name
          AND NAZWISKO = @surname;
end
GO
--Task7
CREATE TRIGGER task7
    ON KLIENT
    FOR insert AS
BEGIN
    UPDATE KLIENT
    SET ID_MIASTO = (SELECT TOP 1 ID_MIASTO FROM MIASTO ORDER BY MIASTO)
    WHERE ID_KLIENT IN (SELECT ID_KLIENT FROM inserted WHERE KLIENT.ID_MIASTO IS NULL);
end
GO
--Task8
CREATE PROCEDURE task8 @name VARCHAR(20), @surname VARCHAR(20)
AS
BEGIN
    IF NOT EXISTS(SELECT * FROM KLIENT WHERE IMIE = @name AND NAZWISKO = @surname)
        PRINT 'Klient does not exists'
    ELSE
        BEGIN
            DECLARE @number INT;
            SELECT @number = SUM(ILOSC)
            FROM SPRZEDAZ
                     INNER JOIN KLIENT K on SPRZEDAZ.ID_KLIENT = K.ID_KLIENT
            WHERE IMIE = @name
              AND NAZWISKO = @surname;
            PRINT 'Klient has ' + CONVERT(VARCHAR, @number) + ' number of products';
        end
end
GO