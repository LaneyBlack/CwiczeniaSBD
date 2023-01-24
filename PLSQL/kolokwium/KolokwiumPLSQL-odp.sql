SET SERVEROUTPUT ON;
--1. Napisz program, który policzy i wypisze (za pomoc? polecenia dbms_output.put_line) ilu jest pracowników. (1p)
DECLARE
    counter INT;
BEGIN
    SELECT COUNT(id_pracownik) INTO counter FROM pracownik;
    dbms_output.put_line('Database has ' || counter || ' pracownikow');
END;
--2. Napisz wyzwalacz, który zg?osi b??d, je?li modyfikowany jest jaki? produkt. (1p)
CREATE OR REPLACE TRIGGER ex2
BEFORE UPDATE ON produkt
BEGIN
    raise_application_error(-20500,'Update on produkt exception');
END;

UPDATE produkt SET id_kategoria = 0 WHERE id_produkt=1;
--3. Stwórz procedur?, która przyjmie jako parametr nazw? miasta. Wszyscy klienci bez miasta powinni zosta? do niego przypisani. Je?li miasto nie istnieje, to nale?y je wcze?niej utworzy?, z id dobranym tak, aby zapewni? unikalno??. (2p)
CREATE OR REPLACE PROCEDURE ex3 (cityName VARCHAR) AS
    counter INT;
BEGIN
    SELECT COUNT(id_miasto) INTO counter FROM miasto WHERE miasto.miasto = cityName;
    IF  counter = 0 THEN
        INSERT INTO miasto VALUES
        ((SELECT MAX(id_miasto)+1 FROM miasto), cityName);
    END IF;
    UPDATE klient SET klient.id_miasto=(SELECT id_miasto FROM miasto WHERE miasto=cityName)
    WHERE ID_MIASTO IS NULL;
END;

EXECUTE ex3 ('MINSK');
--4. Stwórz wyzwalacz, który nie pozwoli na wpisanie produktów, które ju? istniej? (czyli maj? tak? sam? nazw?), a tak?e nie pozwoli na zmian? nazwy produktu. (2p)
CREATE OR REPLACE TRIGGER ex4
BEFORE INSERT OR UPDATE ON produkt
FOR EACH ROW
DECLARE counter INT;
BEGIN
    IF INSERTING THEN
        SELECT COUNT(*) INTO counter FROM produkt WHERE :NEW.nazwa = produkt.nazwa;
        IF counter > 0 THEN
            raise_application_error(-20500,'Produkt with this name already exists!');
        END IF;
    END IF;
    IF UPDATING THEN
        IF :NEW.nazwa != :OLD.nazwa THEN
            raise_application_error(-20500,'You cannot change a produkt name!');
        END IF;
    END IF;
END;

UPDATE produkt SET produkt.nazwa='HOTDOG' WHERE produkt.id_produkt=1;
INSERT INTO produkt VALUES (6, 'CHLEB',5,1);
--5. Stwórz procedur?, która przyjmie jako parametr nazw? produktu. Je?li podany produkt nie istnieje, nale?y wypisa? komunikat. W przeciwnym przypadku procedura powinna wypisa? ile razy zosta? sprzedany ten produkt. (2p)
CREATE OR REPLACE PROCEDURE ex5(produktName VARCHAR) AS
    counter INT;
BEGIN
    SELECT COUNT(id_produkt) INTO counter FROM produkt WHERE nazwa = produktName;
    IF counter = 0 THEN
        dbms_output.put_line('There is no such produkt in database!');
    ELSE
        SELECT COUNT(id_sprzedaz) INTO counter FROM sprzedaz
        INNER JOIN produkt ON produkt.id_produkt = sprzedaz.id_produkt WHERE produkt.nazwa = produktName;
        dbms_output.put_line(produktName || ' was included into the deal ' || counter || ' times');
    END IF;
END;
EXECUTE ex5('HOTDOG');
EXECUTE ex5('CHLEB');
--6. Stwórz wyzwalacz (jeden), który:
--	a. Nie pozwoli usun?? produktu, je?li ma on cen? wi?ksz? od 0.
--	b. Nie pozwoli na wpisanie produktu, który nie ma przypisanej kategorii.
--	c. Nie pozwoli na modyfikacj? nazwy produktu. (2p)
CREATE OR REPLACE TRIGGER ex6
BEFORE DELETE OR INSERT OR UPDATE ON produkt
FOR EACH ROW
BEGIN
    IF DELETING THEN --a
        IF :OLD.cena > 0 THEN
            raise_application_error(-20500,'You cannot delete a produkt with cost > 0!');
        END IF;
    ELSIF INSERTING THEN --b
        IF :NEW.id_kategoria IS NULL THEN
            raise_application_error(-20500,'You cannot insert a produkt with no category!');
        END IF;
    ELSE --c
        IF :NEW.nazwa != :OLD.nazwa THEN
            raise_application_error(-20500,'You cannot change a produkt name!');
        END IF;
    END IF;
END;

DELETE FROM produkt WHERE id_produkt=0;
INSERT INTO produkt VALUES (6, 'CHLEB',5, null);
UPDATE produkt SET produkt.nazwa='HOTDOG' WHERE produkt.id_produkt=1;