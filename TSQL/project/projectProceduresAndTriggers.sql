--Procedures============================================================================================================
--1Procedure
BEGIN
    DROP PROCEDURE printMenu;
    CREATE PROCEDURE printMenu
    AS
    BEGIN
        DECLARE @dishTypeId INT,@lastTypeId INT, @dishTypeName VARCHAR(20), @dishName VARCHAR(20), @dishDesc VARCHAR(200), @dishPrice INT;
        DECLARE menuCur CURSOR FOR SELECT DishType_ID, TypeName, Name, Description, Price
                                   FROM dish
                                            INNER JOIN DishType DT on DT.ID = Dish.DishType_ID
                                   ORDER BY DishType_ID;
        OPEN menuCur;
        FETCH NEXT FROM menuCur INTO @dishTypeId, @dishTypeName, @dishName, @dishDesc, @dishPrice;
        PRINT '---------------===Menu===---------------';
        WHILE @@FETCH_STATUS = 0
            BEGIN
                IF (@dishTypeId != ISNULL(@lastTypeId, -1))
                    BEGIN
                        PRINT @dishTypeName + ': ';
                        SET @lastTypeId = @dishTypeId;
                    end;
                PRINT @dishName + ' - ' + ISNULL(@dishDesc, '') + ' - ' + CONVERT(VARCHAR, @dishPrice) + 'zl';
                FETCH NEXT FROM menuCur INTO @dishTypeId, @dishTypeName, @dishName, @dishDesc, @dishPrice;
            end;
        CLOSE menuCur;
        DEALLOCATE menuCur;
    end;
        EXECUTE printMenu;
end;
--2Procedure
BEGIN
    DROP PROCEDURE printIncome;
    CREATE PROCEDURE printIncome(@date DATE)
    AS
    BEGIN
        DECLARE @income money;
        IF @date IS NOT NULL
            BEGIN
                SELECT @income = SUM(D.Price)
                FROM [Order]
                         INNER JOIN DishToOrder DTO on [Order].ID = DTO.Order_ID
                         INNER JOIN Dish D on D.ID = DTO.Dish_ID
                WHERE CONVERT(DATE, OrderTime) = @date;
                SELECT @income -= SUM(Person.Salary) FROM Person;
                PRINT 'Income on day ' + CONVERT(VARCHAR, @date) + ' is ' + CONVERT(VARCHAR, @income);
            end;
        ELSE
            BEGIN
                SELECT @income = SUM(D.Price)
                FROM [Order]
                         INNER JOIN DishToOrder DTO on [Order].ID = DTO.Order_ID
                         INNER JOIN Dish D on D.ID = DTO.Dish_ID;
                PRINT 'Income for right (without salary expencies) now is ' + CONVERT(VARCHAR, @income);
            end;
    end;
    BEGIN
        DECLARE @procDate DATE;
        SET @procDate = CONVERT(DATE, '2022-02-09');
        EXECUTE printIncome @procDate;
    end;
End;
--3Procedure
BEGIN
    DROP PROCEDURE fireDeliveryMan;
    CREATE PROCEDURE fireDeliveryMan(@rating SMALLINT) AS
    BEGIN
        DECLARE @counter INT;
        SELECT @counter = COUNT(D.ID) FROM Deliveryman D WHERE D.Rating < @rating;
        IF @counter > 0
            BEGIN
                DELETE
                FROM DeliveryOrder
                WHERE Deliveryman_ID IN (SELECT D.ID FROM Deliveryman D WHERE Rating < @rating);
                DELETE FROM Deliveryman WHERE ID IN (SELECT D.ID FROM Deliveryman D WHERE Rating < @rating);
--                 DELETE FROM Person WHERE ID IN (SELECT D.Person_ID FROM Deliveryman D WHERE Rating < @rating);
                print 'Fired ' + CONVERT(VARCHAR, @counter) + ' bad delivery mans';
            end;
        ELSE
            BEGIN
                print 'There is no delivery mans with rating lower than ' + CONVERT(VARCHAR, @rating);
            end;
    end;
    BEGIN
        EXECUTE fireDeliveryMan 9;
    end;
End;
--Triggers============================================================================================================
--Trigger1
BEGIN
    DROP TRIGGER noMoreSideDishes;
    CREATE TRIGGER noMoreSideDishes
        ON Dish
        FOR INSERT AS
    BEGIN
        IF (SELECT DishType_ID FROM inserted) = (SELECT DishType_ID FROM DishType WHERE TypeName = 'Side')
            BEGIN
                print 'No more Side dishes!'
                ROLLBACK;
            end
    end;
        INSERT INTO Dish VALUES (22, 'Bread', 'Just some bread', 2, (SELECT ID FROM DishType WHERE TypeName = 'Side'));
END;
--Trigger2
BEGIN
    DROP TRIGGER noLowerPrices;
    --inflacja
    CREATE TRIGGER noLowerPrices
        ON Dish
        FOR UPDATE AS
    BEGIN
        IF EXISTS(SELECT i.Price, d.Price
                  FROM inserted i
                           INNER JOIN deleted d ON i.ID = d.ID
                  WHERE i.Price > d.Price)
            BEGIN
                print 'Enough inflation, no more bigger prices';
                ROLLBACK;
            end
    end;
        UPDATE Dish SET Price=40 WHERE Name = 'Sushi';
end
--Trigger3
BEGIN
    DROP TRIGGER dishPriceHigherAverage;
    CREATE TRIGGER dishPriceHigherAverage
        ON Dish
        FOR DELETE AS
    BEGIN
        IF EXISTS(SELECT Price
                  FROM deleted d
                  WHERE d.Price > (SELECT AVG(Price) FROM dish WHERE Dish.DishType_ID = d.DishType_ID))
            BEGIN
                ROLLBACK;
            end
    end;
end;