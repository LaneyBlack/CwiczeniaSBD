-- Drop ------------------------------------------------------------------------
-- Drop FK
BEGIN
    BEGIN
        ALTER TABLE Cook
            DROP CONSTRAINT Cook_cook;

        ALTER TABLE Cook
            DROP CONSTRAINT Cook_Staff;

        ALTER TABLE DeliveryOrder
            DROP CONSTRAINT DeliveryOrder_Delivery;

        ALTER TABLE DeliveryOrder
            DROP CONSTRAINT DeliveryOrder_Order;

        ALTER TABLE Deliveryman
            DROP CONSTRAINT Delivery_Person;

        ALTER TABLE DishToOrder
            DROP CONSTRAINT DishToOrder_Cook;

        ALTER TABLE DishToOrder
            DROP CONSTRAINT DishToOrder_Menu;

        ALTER TABLE DishToOrder
            DROP CONSTRAINT DishToOrder_Order;

        ALTER TABLE Dish
            DROP CONSTRAINT Menu_DishType;

        ALTER TABLE StationaryOrder
            DROP CONSTRAINT StationaryOrder_Order;

        ALTER TABLE StationaryOrder
            DROP CONSTRAINT StationaryOrder_Waiter;

        ALTER TABLE Waiter
            DROP CONSTRAINT Waiter_Person;
    END;
-- Drop Tables
    BEGIN
        DROP TABLE Cook;

        DROP TABLE DeliveryOrder;

        DROP TABLE Deliveryman;

        DROP TABLE Dish;

        DROP TABLE DishToOrder;

        DROP TABLE DishType;

        DROP TABLE "Order";

        DROP TABLE Person;

        DROP TABLE StationaryOrder;

        DROP TABLE Waiter;
    END;
END;
-- Tables ----------------------------------------------------------------------
BEGIN
    BEGIN
        CREATE TABLE Cook
        (
            ID         integer  NOT NULL,
            Person_ID  integer  NOT NULL,
            Expirience smallint NULL,
            Mentor_ID  integer  NULL,
            CONSTRAINT Cook_pk PRIMARY KEY (ID)
        );

-- Table: DeliveryOrder
        CREATE TABLE DeliveryOrder
        (
            Deliveryman_ID integer       NOT NULL,
            Order_ID       integer       NOT NULL,
            DeliveryTime   smalldatetime NULL,
            Address        varchar(20)   NOT NULL,
            CONSTRAINT DeliveryOrder_pk PRIMARY KEY (Deliveryman_ID, Order_ID)
        );

-- Table: Deliveryman
        CREATE TABLE Deliveryman
        (
            ID          integer    NOT NULL,
            Person_ID   integer    NOT NULL,
            PhoneNumber varchar(9) NOT NULL,
            Rating      integer    NOT NULL,
            CONSTRAINT Deliveryman_pk PRIMARY KEY (ID)
        );

-- Table: Dish
        CREATE TABLE Dish
        (
            ID          integer      NOT NULL,
            Name        varchar(20)  NOT NULL,
            Description varchar(200) NULL,
            Price       smallint     NOT NULL,
            DishType_ID integer      NOT NULL,
            CONSTRAINT Dish_pk PRIMARY KEY (ID)
        );

-- Table: DishToOrder
        CREATE TABLE DishToOrder
        (
            ID       integer NOT NULL,
            Dish_ID  integer NOT NULL,
            Order_ID integer NOT NULL,
            Cook_ID  integer NOT NULL,
            CONSTRAINT DishToOrder_pk PRIMARY KEY (ID)
        );

-- Table: DishType
        CREATE TABLE DishType
        (
            ID       integer     NOT NULL,
            TypeName varchar(20) NOT NULL,
            CONSTRAINT DishType_pk PRIMARY KEY (ID)
        );

-- Table: Order
        CREATE TABLE "Order"
        (
            ID         integer       NOT NULL,
            OrderTime  smalldatetime NULL,
            CookedTime smalldatetime NULL,
            CONSTRAINT Order_pk PRIMARY KEY (ID)
        );

-- Table: Person
        CREATE TABLE Person
        (
            ID          integer     NOT NULL,
            FirstName   varchar(20) NOT NULL,
            LastName    varchar(20) NOT NULL,
            Salary      money       NOT NULL,
            YearsOfWork smallint,
            CONSTRAINT Person_pk PRIMARY KEY (ID)
        );

-- Table: StationaryOrder
        CREATE TABLE StationaryOrder
        (
            Waiter_ID integer NOT NULL,
            Order_ID  integer NOT NULL,
            CONSTRAINT StationaryOrder_pk PRIMARY KEY (Waiter_ID, Order_ID)
        );

-- Table: Waiter
        CREATE TABLE Waiter
        (
            ID          integer    NOT NULL,
            Person_ID   integer    NOT NULL,
            PhoneNumber varchar(9) NOT NULL,
            CONSTRAINT Waiter_pk PRIMARY KEY (ID)
        );
    END;
    -- foreign keys
-- Reference: Cook_Cook (table: Cook)
    BEGIN
        ALTER TABLE Cook
            ADD CONSTRAINT Cook_Cook
                FOREIGN KEY (Mentor_ID)
                    REFERENCES Cook (ID);

-- Reference: Cook_Staff (table: Cook)
        ALTER TABLE Cook
            ADD CONSTRAINT Cook_Staff
                FOREIGN KEY (Person_ID)
                    REFERENCES Person (ID);

-- Reference: DeliveryOrder_Delivery (table: DeliveryOrder)
        ALTER TABLE DeliveryOrder
            ADD CONSTRAINT DeliveryOrder_Delivery
                FOREIGN KEY (Deliveryman_ID)
                    REFERENCES Deliveryman (ID);

-- Reference: DeliveryOrder_Order (table: DeliveryOrder)
        ALTER TABLE DeliveryOrder
            ADD CONSTRAINT DeliveryOrder_Order
                FOREIGN KEY (Order_ID)
                    REFERENCES "ORDER" (ID);

-- Reference: Delivery_Person (table: Deliveryman)
        ALTER TABLE Deliveryman
            ADD CONSTRAINT Delivery_Person
                FOREIGN KEY (Person_ID)
                    REFERENCES Person (ID);

-- Reference: DishToOrder_Cook (table: DishToOrder)
        ALTER TABLE DishToOrder
            ADD CONSTRAINT DishToOrder_Cook
                FOREIGN KEY (Cook_ID)
                    REFERENCES Cook (ID);

-- Reference: DishToOrder_Menu (table: DishToOrder)
        ALTER TABLE DishToOrder
            ADD CONSTRAINT DishToOrder_Menu
                FOREIGN KEY (Dish_ID)
                    REFERENCES Dish (ID);

-- Reference: DishToOrder_Order (table: DishToOrder)
        ALTER TABLE DishToOrder
            ADD CONSTRAINT DishToOrder_Order
                FOREIGN KEY (Order_ID)
                    REFERENCES "ORDER" (ID);

-- Reference: Menu_DishType (table: Dish)
        ALTER TABLE Dish
            ADD CONSTRAINT Menu_DishType
                FOREIGN KEY (DishType_ID)
                    REFERENCES DishType (ID);

-- Reference: StationaryOrder_Order (table: StationaryOrder)
        ALTER TABLE StationaryOrder
            ADD CONSTRAINT StationaryOrder_Order
                FOREIGN KEY (Order_ID)
                    REFERENCES "ORDER" (ID);

-- Reference: StationaryOrder_Waiter (table: StationaryOrder)
        ALTER TABLE StationaryOrder
            ADD CONSTRAINT StationaryOrder_Waiter
                FOREIGN KEY (Waiter_ID)
                    REFERENCES Waiter (ID);

-- Reference: Waiter_Person (table: Waiter)
        ALTER TABLE Waiter
            ADD CONSTRAINT Waiter_Person
                FOREIGN KEY (Person_ID)
                    REFERENCES Person (ID);
    END;
END;
-- End of creating -------------------------------------------------------------

-- Inserting values ------------------------------------------------------------
BEGIN
    INSERT INTO Person
    VALUES (NVL((SELECT MAX(ID) FROM Person) + 1, 1), 'John', 'Smith', 200, 2);
    INSERT INTO Person
    VALUES (NVL((SELECT MAX(ID) FROM Person) + 1, 1), 'Jack', 'Richer', 180, 4);
    INSERT INTO Person
    VALUES (NVL((SELECT MAX(ID) FROM Person) + 1, 1), 'Mikle', 'Asher', 120, 1);
    INSERT INTO Person
    VALUES (NVL((SELECT MAX(ID) FROM Person) + 1, 1), 'Maximus', 'Kicker', 130, null);
    INSERT INTO Person
    VALUES (NVL((SELECT MAX(ID) FROM Person) + 1, 1), 'Kile', 'Walker', 100, 3);
    INSERT INTO Person
    VALUES (NVL((SELECT MAX(ID) FROM Person) + 1, 1), 'Mitchel', 'Fisher', 115, 1);


    INSERT INTO Cook
    VALUES (NVL((SELECT MAX(ID) FROM Cook) + 1, 1), (SELECT ID FROM Person WHERE firstname = 'John'), 6, null);
    INSERT INTO Cook
    VALUES (NVL((SELECT MAX(ID) FROM Cook) + 1, 1), (SELECT ID FROM Person WHERE firstname = 'Jack'), 2,
            (SELECT ID FROM Person WHERE firstname = 'John'));


    INSERT INTO Waiter
    VALUES (NVL((SELECT MAX(ID) FROM Waiter) + 1, 1), (SELECT ID FROM Person WHERE firstname = 'Mikle'),
            '536820930');
    INSERT INTO Waiter
    VALUES (NVL((SELECT MAX(ID) FROM Waiter) + 1, 1), (SELECT ID FROM Person WHERE firstname = 'Maximus'),
            '533221930');


    INSERT INTO Deliveryman
    VALUES (NVL((SELECT MAX(ID) FROM Deliveryman) + 1, 1), (SELECT ID FROM Person WHERE firstname = 'Kile'),
            '512375930', 9);
    INSERT INTO Deliveryman
    VALUES (NVL((SELECT MAX(ID) FROM Deliveryman) + 1, 1), (SELECT ID FROM Person WHERE firstname = 'Mitchel'),
            '533501930', 8);


    INSERT INTO DishType
    VALUES (NVL((SELECT MAX(ID) FROM DishType) + 1, 1), 'Main');
    INSERT INTO DishType
    VALUES (NVL((SELECT MAX(ID) FROM DishType) + 1, 1), 'Side');
    INSERT INTO DishType
    VALUES (NVL((SELECT MAX(ID) FROM DishType) + 1, 1), 'Dessert');
    INSERT INTO DishType
    VALUES (NVL((SELECT MAX(ID) FROM DishType) + 1, 1), 'Drink');


    INSERT INTO Dish
    VALUES (NVL((SELECT MAX(ID) FROM Dish) + 1, 1), 'Pizza', 'Old as this world. Round but so yammy', 32,
            (SELECT ID FROM DishType WHERE typename = 'Main'));
    INSERT INTO Dish
    VALUES (NVL((SELECT MAX(ID) FROM Dish) + 1, 1), 'Sushi', 'Japanese', 26,
            (SELECT ID FROM DishType WHERE typename = 'Main'));
    INSERT INTO Dish
    VALUES (NVL((SELECT MAX(ID) FROM Dish) + 1, 1), 'Bread', 'White garlic bread', 12,
            (SELECT ID FROM DishType WHERE typename = 'Side'));
    INSERT INTO Dish
    VALUES (NVL((SELECT MAX(ID) FROM Dish) + 1, 1), 'Onigiri', 'Just perfect', 13,
            (SELECT ID FROM DishType WHERE typename = 'Side'));
    INSERT INTO Dish
    VALUES (NVL((SELECT MAX(ID) FROM Dish) + 1, 1), 'Pancake', 'So sweet', 46,
            (SELECT ID FROM DishType WHERE typename = 'Dessert'));
    INSERT INTO Dish
    VALUES (NVL((SELECT MAX(ID) FROM Dish) + 1, 1), 'Honey', null, 12,
            (SELECT ID FROM DishType WHERE typename = 'Side'));
    INSERT INTO Dish
    VALUES (NVL((SELECT MAX(ID) FROM Dish) + 1, 1), 'Cupcake', null, 12,
            (SELECT ID FROM DishType WHERE typename = 'Dessert'));
    INSERT INTO Dish
    VALUES (NVL((SELECT MAX(ID) FROM Dish) + 1, 1), 'Mohito', 'From natural products', 14,
            (SELECT ID FROM DishType WHERE typename = 'Drink'));
    INSERT INTO Dish
    VALUES (NVL((SELECT MAX(ID) FROM Dish) + 1, 1), 'Coca-Cola', null, 8,
            (SELECT ID FROM DishType WHERE typename = 'Drink'));
    INSERT INTO Dish
    VALUES (NVL((SELECT MAX(ID) FROM Dish) + 1, 1), 'Juice', 'Apple, carrot, orange, pineapple', 9,
            (SELECT ID FROM DishType WHERE typename = 'Drink'));
    INSERT INTO Dish
    VALUES (NVL((SELECT MAX(ID) FROM Dish) + 1, 1), 'Spaghetti Carbonara', 'Great and tasty', 32,
            (SELECT ID FROM DishType WHERE typename = 'Main'));
    INSERT INTO Dish
    VALUES (NVL((SELECT MAX(ID) FROM Dish) + 1, 1), 'Spaghetti Bolognese', 'Perfect main dish', 30,
            (SELECT ID FROM DishType WHERE typename = 'Main'));

    INSERT INTO "ORDER"
    VALUES (NVL((SELECT MAX(ID) FROM "ORDER") + 1, 1), CONVERT(SMALLDATETIME, '2022-02-09 07:00:00'),
            CONVERT(SMALLDATETIME, '2022-02-09 07:30:00'));
    INSERT INTO "ORDER"
    VALUES (NVL((SELECT MAX(ID) FROM "ORDER") + 1, 1), CONVERT(SMALLDATETIME, '2022-02-09 07:40:00'),
            CONVERT(SMALLDATETIME, '2022-02-09 07:45:00'));
    INSERT INTO "ORDER"
    VALUES (NVL((SELECT MAX(ID) FROM "ORDER") + 1, 1), CONVERT(SMALLDATETIME, '2022-02-09 07:57:00'),
            CONVERT(SMALLDATETIME, '2022-02-09 08:03:00'));
    INSERT INTO "ORDER"
    VALUES (NVL((SELECT MAX(ID) FROM "ORDER") + 1, 1), CONVERT(SMALLDATETIME, '2022-04-02 12:02:00'),
            CONVERT(SMALLDATETIME, '2022-04-02 12:06:00'));
    INSERT INTO "ORDER"
    VALUES (NVL((SELECT MAX(ID) FROM "ORDER") + 1, 1), CONVERT(SMALLDATETIME, '2022-04-02 12:56:00'),
            CONVERT(SMALLDATETIME, '2022-04-02 13:00:00'));


    INSERT INTO StationaryOrder
    VALUES (1, 2);
    INSERT INTO StationaryOrder
    VALUES (2, 3);
    INSERT INTO StationaryOrder
    VALUES (2, 5);

    INSERT INTO DeliveryOrder
    VALUES (1, 1, CONVERT(SMALLDATETIME, '2022-02-09 07:40:00'), 'ul. Mieszkancow 2');
    INSERT INTO DeliveryOrder
    VALUES (2, 4, CONVERT(SMALLDATETIME, '2022-04-02 12:15:00'), 'ul. Kierbiedza 12');

    INSERT INTO DishToOrder
    VALUES (NVL((SELECT MAX(ID) FROM DishToOrder) + 1, 1), 1, 1, 1);
    INSERT INTO DishToOrder
    VALUES (NVL((SELECT MAX(ID) FROM DishToOrder) + 1, 1), 3, 1, 2);
    INSERT INTO DishToOrder
    VALUES (NVL((SELECT MAX(ID) FROM DishToOrder) + 1, 1), 6, 1, 2);
    INSERT INTO DishToOrder
    VALUES (NVL((SELECT MAX(ID) FROM DishToOrder) + 1, 1), 8, 1, 1);

    INSERT INTO DishToOrder
    VALUES (NVL((SELECT MAX(ID) FROM DishToOrder) + 1, 1), 1, 2, 2);
    INSERT INTO DishToOrder
    VALUES (NVL((SELECT MAX(ID) FROM DishToOrder) + 1, 1), 1, 2, 2);
    INSERT INTO DishToOrder
    VALUES (NVL((SELECT MAX(ID) FROM DishToOrder) + 1, 1), 1, 2, 2);
    INSERT INTO DishToOrder
    VALUES (NVL((SELECT MAX(ID) FROM DishToOrder) + 1, 1), 4, 2, 2);
    INSERT INTO DishToOrder
    VALUES (NVL((SELECT MAX(ID) FROM DishToOrder) + 1, 1), 10, 2, 2);
    INSERT INTO DishToOrder
    VALUES (NVL((SELECT MAX(ID) FROM DishToOrder) + 1, 1), 4, 2, 2);
    INSERT INTO DishToOrder
    VALUES (NVL((SELECT MAX(ID) FROM DishToOrder) + 1, 1), 2, 2, 2);

    INSERT INTO DishToOrder
    VALUES (NVL((SELECT MAX(ID) FROM DishToOrder) + 1, 1), 1, 4, 1);
    INSERT INTO DishToOrder
    VALUES (NVL((SELECT MAX(ID) FROM DishToOrder) + 1, 1), 1, 4, 2);
    INSERT INTO DishToOrder
    VALUES (NVL((SELECT MAX(ID) FROM DishToOrder) + 1, 1), 8, 4, 1);
    INSERT INTO DishToOrder
    VALUES (NVL((SELECT MAX(ID) FROM DishToOrder) + 1, 1), 8, 4, 2);
END;