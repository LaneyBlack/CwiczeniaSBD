SET SERVEROUTPUT ON;
--Procedures============================================================================================================
--1Procedure
CREATE OR REPLACE PROCEDURE printMenu AS
    lastTypeId VARCHAR(20);
BEGIN
    dbms_output.put_line('---------------===Menu===---------------');
    FOR roww IN (SELECT DishType_ID, TypeName, Name, Description, Price FROM dish
                        INNER JOIN DishType DT on DT.ID = Dish.DishType_ID
                        ORDER BY DishType_ID) 
    LOOP
        IF NVL(lastTypeId,-1) != roww.DishType_ID THEN
            dbms_output.put_line('---'|| roww.TypeName ||'---');
            lastTypeId:=roww.DishType_ID;
        END IF;
        dbms_output.put_line(roww.Name || ' - ' || NVL(roww.Description,'')|| ' - ' || roww.Price || 'zl');
    END LOOP;
end;
EXECUTE printMenu;
--2Procedure
CREATE OR REPLACE PROCEDURE printIncome(datee VARCHAR) AS
    income INT;
    spends INT;
    BEGIN
        IF datee IS NOT NULL THEN
            SELECT SUM(D.Price) INTO income  FROM "ORDER"
                INNER JOIN DishToOrder DTO on "ORDER".ID = DTO.Order_ID
                INNER JOIN Dish D on D.ID = DTO.Dish_ID
                WHERE TO_CHAR(OrderTime,'YYYY-MM-DD') = '2022-02-09';
                SELECT SUM(Person.Salary) INTO spends FROM Person;
                income:=income-spends;
                dbms_output.put_line('Income on day ' || datee || ' is ' || income);
        ELSE
                SELECT SUM(D.Price) INTO income
                FROM "ORDER"
                         INNER JOIN DishToOrder DTO on "ORDER".ID = DTO.Order_ID
                         INNER JOIN Dish D on D.ID = DTO.Dish_ID;
                dbms_output.put_line('Income for right (without salary expencies) now is ' || income);
        END IF;
    END;
    EXECUTE printIncome('2022-02-09');
    EXECUTE printIncome(null);
End;
--3Procedure
CREATE OR REPLACE PROCEDURE fireDeliveryMan(ratingg smallint) AS
    counter SMALLINT;
    BEGIN
        SELECT COUNT(D.ID) INTO counter FROM Deliveryman D WHERE D.Rating < ratingg;
        IF counter > 0 THEN
            DELETE FROM DeliveryOrder
            WHERE Deliveryman_ID IN (SELECT D.ID FROM Deliveryman D WHERE Rating < ratingg);
            DELETE FROM Deliveryman WHERE ID IN (SELECT D.ID FROM Deliveryman D WHERE Rating < ratingg);
            dbms_output.put_line('Fired ' || counter || ' bad delivery mans');
        ELSE
            dbms_output.put_line('There is no delivery mans with rating lower than ' || ratingg);
        END IF;
    end;
EXECUTE fireDeliveryMan (9);
--Triggers============================================================================================================
--Trigger1
CREATE OR REPLACE TRIGGER noMoreSideDishes
    BEFORE INSERT
    ON Dish
    FOR EACH ROW
    DECLARE sideID INT;
    BEGIN
        SELECT DT.ID INTO sideID FROM DishType DT WHERE TypeName = 'Side';
        IF :NEW.DishType_ID = sideID THEN
            dbms_output.put_line( 'No more Side dishes!');
            ROLLBACK;
        end if;
    end;
INSERT INTO Dish VALUES (22, 'Bread', 'Just some bread', 2, (SELECT ID FROM DishType WHERE TypeName = 'Side'));
--Trigger2
    --inflacja
CREATE OR REPLACE TRIGGER noLowerPrices
    BEFORE UPDATE
    ON Dish
    FOR EACH ROW
    BEGIN
        IF :NEW.Price>:OLD.price THEN
            dbms_output.put_line('Enough inflation, no more bigger prices');
            ROLLBACK;
        END IF;
end;
UPDATE Dish SET Price=40 WHERE Name = 'Sushi';
--Trigger3
CREATE OR REPLACE TRIGGER dishPriceHigherAverage
    BEFORE DELETE
    ON Dish
    FOR EACH ROW --need to cover
--    DECLARE avgPrice INT;
--        counter INT;
    BEGIN
        IF :OLD.Price > 30 THEN
            raise_application_error(-20000,'Dish cost is higher than 30!');
        END IF;
--        SELECT AVG(dish.Price) INTO avgPrice FROM dish WHERE dish.DishType_ID IN (SELECT DishType_ID FROM DELETED);
--        SELECT COUNT(d.ID) INTO FROM DELETED d WHERE d.Price>avgPrice;
--        IF counter > 0 THEN
--            dbms_output.put_line('This dish cost is higher than average!');
--            ROLLBACK;
--        end IF;
    end;
DELETE FROM Dish WHERE Name = 'Pancake';