-- DROP DATABASE IF EXISTS Meilenstein2;
-- CREATE DATABASE Meilenstein2; 
USE Meilenstein2;

			-- DROP TABLE IF EXISTS Kunden;
			-- CREATE TABLE TESTINVORLESUNG (
			-- 	Nummer INT UNSIGNED AUTO_INCREMENT,	
			-- 	`Vorname` VARCHAR(100),			
			-- 	`Nachname` VARCHAR(50) NOT NULL,
			-- 	`E-Mail` VARCHAR(255) UNIQUE,
			-- 	`Portrait` BLOB,				
			-- 	PRIMARY KEY(Nummer) -- Künstlich --> Surrogate Key
			-- );

-- =======================================================
DROP TABLE IF EXISTS Benutzer;
CREATE TABLE Benutzer(
	`Nummer` INT UNSIGNED NOT NULL AUTO_INCREMENT ,
	-- `NAME`
		`Vorname` VARCHAR(100) NOT NULL,			
		`Nachname` VARCHAR(50) NOT NULL,
	`Aktiv` TINYINT(1) NOT NULL DEFAULT 0,
	`Anlegedatum` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	-- `Auth`
		`Salt` VARCHAR(32) NOT NULL,
		`Hash` VARCHAR(24) NOT NULL,
	`Nutzername` VARCHAR(1000) NOT NULL,
	`Letzter Login` DATETIME DEFAULT NULL, -- ist optional
	`E-Mail` VARCHAR(255) NOT NULL,
	`Geburtsdatum` DATE, -- ist Optional
	`Alter` INT(3) AS (year(CURRENT_TIMESTAMP) - year(`Geburtsdatum`)),
	PRIMARY KEY (`Nummer`),
  	UNIQUE KEY (`E-mail`,`Nutzername`)
);
DESCRIBE Benutzer;


DROP TABLE IF EXISTS Bestellungen;
CREATE TABLE Bestellungen(
	`Nummer` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`Abholzeitpunkt` DATETIME DEFAULT NULL, -- ist optional! --ToDo: Muss wenn er angegeben wird später als der Bestellzeitpunkt
	`Bestellzeitpunkt` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- oder besser CURRENT_DATE ?
	-- `Endpreis` DECIMAL --ToDo ! -- mehr als 99,99€
	PRIMARY KEY (`Nummer`)
);
DESCRIBE Bestellungen;


DROP TABLE IF EXISTS Mahlzeiten;
CREATE TABLE Mahlzeiten(
	`ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`Beschreibung` VARCHAR(1024) NOT NULL,
	`Verfügbar` TINYINT(1) NOT NULL Default 0,
	`Vorrat` INT UNSIGNED NOT NULL DEFAULT 0,
	PRIMARY KEY(`ID`)
);
DESCRIBE Mahlzeiten;


DROP TABLE IF EXISTS Deklarationen;
CREATE TABLE Deklarationen(
	`Zeichen` VARCHAR(2) NOT NULL,
	`Beschriftung` VARCHAR(32) NOT NULL,
	PRIMARY KEY(`Zeichen`)
);
DESCRIBE Deklarationen;


DROP TABLE IF EXISTS Preise;
CREATE TABLE Preise(
	`Gastpreis` DECIMAL(4,2) NOT NULL,
	`Studentpreis` DECIMAL (4,2), -- Optional
	`MA-Preis` DECIMAL (4,2), -- Optional
	`Jahr` INT(3) NOT NULL -- Fremdschlüssel ?!
	-- FOREIGN Key Jahr
);
DESCRIBE Preise;


DROP TABLE IF EXISTS Kategorien;
CREATE TABLE Kategorien(
	`ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`Bezeichnung` VARCHAR(50) NOT NULL,
	PRIMARY KEY (`ID`)
);
DESCRIBE Kategorien;


DROP TABLE IF EXISTS Bilder;
CREATE TABLE Bilder(
	`ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`Alt-Text` VARCHAR(100) NOT NULL,
	`Titel` VARCHAR(100),-- Optional
	`Binärdaten` BLOB NOT NULL,
	PRIMARY KEY (`ID`)
);
DESCRIBE Bilder;


DROP TABLE IF EXISTS Zutaten;
CREATE TABLE Zutaten(
	`ID` INT(5) UNSIGNED NOT NULL,
	`Nachname` VARCHAR(50) NOT NULL,
	`Bio` TINYINT(1) NOT NULL Default 0,
	`Vegetarisch` TINYINT(1) NOT NULL Default 0,
	`Vegan` TINYINT(1) NOT NULL Default 0,
	`Glutenfrei` TINYINT(1) NOT NULL Default 0,
	PRIMARY KEY (`ID`)
);
DESCRIBE Zutaten;


DROP TABLE IF EXISTS Kommentare;
CREATE TABLE Kommentare(
	`ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
	`Bemerkung` VARCHAR(255), -- optional
	`Bewertung` VARCHAR(255),
	PRIMARY KEY (`ID`)
);
DESCRIBE Kommentare;


DROP TABLE IF EXISTS Deklarationen;
CREATE TABLE Deklarationen(
);

-- Ablaufdatum standardmäßig eine Woche in der Zukunft
-- der Grund wird nicht länger als 255 Zeichen lang
DROP TABLE IF EXISTS Gäste;
CREATE TABLE Gäste(
);

DROP TABLE IF EXISTS FH Angehörige;
CREATE TABLE FH Angehörige(
);

DROP TABLE IF EXISTS Fachbereiche;
CREATE TABLE Fachbereiche(
);

DROP TABLE IF EXISTS Mitarbeiter;
CREATE TABLE Mitarbeiter(
);

DROP TABLE IF EXISTS Studenten;
CREATE TABLE Studenten(
);