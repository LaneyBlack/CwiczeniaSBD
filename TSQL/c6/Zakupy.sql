DROP TABLE KLIENT;
DROP TABLE PRODUKT;
DROP TABLE PRACOWNIK;
DROP TABLE SPRZEDAZ;
DROP TABLE MIASTO;
DROP TABLE KATEGORIA;

CREATE TABLE MIASTO(
	ID_MIASTO INTEGER NOT NULL,
	MIASTO VARCHAR(20) NOT NULL);

CREATE TABLE KLIENT(
	ID_KLIENT INTEGER NOT NULL,
	IMIE VARCHAR(20) NOT NULL,
	NAZWISKO VARCHAR(20) NOT NULL,
	ID_MIASTO INTEGER);
	
CREATE TABLE PRACOWNIK(
	ID_PRACOWNIK INTEGER NOT NULL,
	IMIE VARCHAR(20) NOT NULL,
	NAZWISKO VARCHAR(20) NOT NULL,
	PENSJA INTEGER,
	ID_MIASTO INTEGER);

CREATE TABLE KATEGORIA(
	ID_KATEGORIA INTEGER NOT NULL,
	KATEGORIA VARCHAR(20) NOT NULL);
	
CREATE TABLE PRODUKT(
	ID_PRODUKT INTEGER NOT NULL,
	NAZWA VARCHAR(20) NOT NULL,
	CENA INTEGER NOT NULL,
	ID_KATEGORIA INTEGER);
	
CREATE TABLE SPRZEDAZ(
	ID_SPRZEDAZ INTEGER NOT NULL,
	ID_KLIENT INTEGER NOT NULL,
	ID_PRACOWNIK INTEGER NOT NULL,
	ID_PRODUKT INTEGER NOT NULL,
	DATA_SPRZEDAZY DATE NOT NULL,
	ILOSC INTEGER NOT NULL);

INSERT INTO MIASTO VALUES(
	0, 'WARSZAWA');
INSERT INTO MIASTO VALUES(
	1, 'KRAKOW');
INSERT INTO MIASTO VALUES(
	2, 'GDANSK');

INSERT INTO KATEGORIA VALUES(
	0, 'NABIAL');
INSERT INTO KATEGORIA VALUES(
	1, 'PIECZYWO');

INSERT INTO KLIENT VALUES(
	0, 'MATEUSZ', 'TRUSKAWKA', 0);
INSERT INTO KLIENT VALUES(
	1, 'WIKTORIA', 'MALINA', 0);
INSERT INTO KLIENT VALUES(
	2, 'SZYMON', 'CZERESNIA', 1);
INSERT INTO KLIENT VALUES(
	3, 'NATALIA', 'SLIWKA', 1);
INSERT INTO KLIENT VALUES(
	4, 'MAGDALENA', 'JABLKO', 2);
INSERT INTO KLIENT VALUES(
	5, 'ADAM', 'WISNIA', 2);
INSERT INTO KLIENT VALUES(
	6, 'PIOTR', 'PORZECZKA', 1);
	
INSERT INTO PRACOWNIK VALUES(
	0, 'JAN', 'KALAFIOR', 1000, 0);
INSERT INTO PRACOWNIK VALUES(
	1, 'TOMASZ', 'SZPINAK', 2000, 0);
INSERT INTO PRACOWNIK VALUES(
	2, 'JULIA', 'ZIEMNIAK', 3000, 1);
	
INSERT INTO PRODUKT VALUES(
	0, 'CHLEB', 4, 1);
INSERT INTO PRODUKT VALUES(
	1, 'MLEKO', 5, 0);
INSERT INTO PRODUKT VALUES(
	2, 'SER', 9, 0);
INSERT INTO PRODUKT VALUES(
	3, 'MASLO', 5, 0);

INSERT INTO SPRZEDAZ VALUES(
	0, 0, 0, 0, CONVERT(DATETIME,'2019-SEP-03'), 3);
INSERT INTO SPRZEDAZ VALUES(
	1, 0, 0, 1, CONVERT(DATETIME,'2019-SEP-07'), 5);
INSERT INTO SPRZEDAZ VALUES(
	2, 1, 0, 2, CONVERT(DATETIME,'2019-OCT-23'), 1);
INSERT INTO SPRZEDAZ VALUES(
	3, 1, 1, 3, CONVERT(DATETIME,'2019-OCT-13'), 2);
INSERT INTO SPRZEDAZ VALUES(
	4, 1, 1, 0, CONVERT(DATETIME,'2019-NOV-08'), 4);
INSERT INTO SPRZEDAZ VALUES(
	5, 1, 2, 1, CONVERT(DATETIME,'2019-NOV-20'), 3);
INSERT INTO SPRZEDAZ VALUES(
	6, 2, 1, 2, CONVERT(DATETIME,'2019-SEP-11'), 3);
INSERT INTO SPRZEDAZ VALUES(
	7, 2, 1, 3, CONVERT(DATETIME,'2019-OCT-03'), 5);
INSERT INTO SPRZEDAZ VALUES(
	8, 2, 0, 0, CONVERT(DATETIME,'2019-SEP-04'), 7);
INSERT INTO SPRZEDAZ VALUES(
	9, 3, 2, 1, CONVERT(DATETIME,'2019-SEP-23'), 9);
INSERT INTO SPRZEDAZ VALUES(
	10, 3, 2, 2, CONVERT(DATETIME,'2019-SEP-25'), 4);
INSERT INTO SPRZEDAZ VALUES(
	11, 3, 2, 3, CONVERT(DATETIME,'2019-SEP-26'), 2);
INSERT INTO SPRZEDAZ VALUES(
	12, 3, 1, 0, CONVERT(DATETIME,'2019-NOV-03'), 5);
INSERT INTO SPRZEDAZ VALUES(
	13, 4, 1, 1, CONVERT(DATETIME,'2019-SEP-26'), 1);
INSERT INTO SPRZEDAZ VALUES(
	14, 4, 2, 2, CONVERT(DATETIME,'2019-SEP-16'), 1);
INSERT INTO SPRZEDAZ VALUES(
	15, 5, 0, 3, CONVERT(DATETIME,'2019-NOV-15'), 6);
INSERT INTO SPRZEDAZ VALUES(
	16, 5, 0, 0, CONVERT(DATETIME,'2019-OCT-13'), 7);
