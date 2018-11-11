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
	`Nummer`        INT AUTO_INCREMENT      NOT NULL,
	-- `NAME`
	    `Vorname`   VARCHAR(100)            NOT NULL,	
	    `Nachname`  VARCHAR(50)             NOT NULL,
	`Aktiv`         TINYINT(1)  DEFAULT 0   NOT NULL,
	`Anlegedatum`   TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
	-- `Auth`
	    `Salt`      CHAR(32)                NOT NULL,
	    `Hash`      CHAR(24)                NOT NULL,
	`Nutzername`    VARCHAR(50)             NOT NULL,
	`Letzter Login` DATETIME    DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,   -- optional
	`E-Mail`        VARCHAR(255)            NOT NULL,
	`Geburtsdatum`  DATE,                                                   -- optional
	`Alter`         INT(3) AS (year(CURRENT_TIMESTAMP) - year(`Geburtsdatum`)),
	CONSTRAINT pk_nummer PRIMARY KEY (`Nummer`)
	CONSTRAINT uk UNIQUE (`Nutzername`, `E-Mail`)
);
DESCRIBE Benutzer;


DROP TABLE IF EXISTS Bestellungen;
CREATE TABLE Bestellungen(
	`Nummer`            INT AUTO_INCREMENT      NOT NULL,
	`Abholzeitpunkt` 	DATETIME DEFAULT NULL,
	`Bestellzeitpunkt` 	DATETIME DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT pk_nummer PRIMARY KEY (`Nummer`),
	CONSTRAINT ck_abholzeitpunkt CHECK (Abholzeitpunkt > Bestellzeitpunkt)
	-- `Endpreis` DECIMAL --ToDo ! -- mehr als 99,99€
);
DESCRIBE Bestellungen;


DROP TABLE IF EXISTS Mahlzeiten;
CREATE TABLE Mahlzeiten(
	`ID`            INT AUTO_INCREMENT      NOT NULL,
	`Beschreibung`  TEXT                    NOT NULL,
	`Verfügbar`     TINYINT(1) DEFAULT 0    NOT NULL,
	`Vorrat`        INT UNSIGNED DEFAULT 0  NOT NULL,
	CONSTRAINT pk_ID PRIMARY KEY(`ID`),
	CONSTRAINT ck_verfügbar CHECK (Vorrat = CASE WHEN Vorrat IS NOT `0` THEN Verfügbar IS `1` ELSE `0` END),
);
DESCRIBE Mahlzeiten;


DROP TABLE IF EXISTS Deklarationen;
CREATE TABLE Deklarationen(
	`Zeichen`       VARCHAR(2)   NOT NULL,
	`Beschriftung`  VARCHAR(32)  NOT NULL,
	CONSTRAINT pk_zeichen PRIMARY KEY(`Zeichen`)
);
DESCRIBE Deklarationen;


DROP TABLE IF EXISTS Preise;
CREATE TABLE Preise(
	`Gastpreis`    DECIMAL(4,2)   NOT NULL,
	`Studentpreis` DECIMAL (4,2),           -- Optional
	`MA-Preis`     DECIMAL (4,2),           -- Optional
	`Jahr`         INT(3)         NOT NULL, -- Fremdschlüssel ?!
	CONSTRAINT ck_studentenpreis CHECK (Studentpreis < MA-Preis)
	-- FOREIGN Key Jahr
);
DESCRIBE Preise;


DROP TABLE IF EXISTS Kategorien;
CREATE TABLE Kategorien(
	`ID` INT UNSIGNED AUTO_INCREMENT    NOT NULL,
	`Bezeichnung` VARCHAR(50)           NOT NULL,
	CONSTRAINT pk_id PRIMARY KEY (`ID`)
);
DESCRIBE Kategorien;


DROP TABLE IF EXISTS Bilder;
CREATE TABLE Bilder(
	`ID` INT UNSIGNED AUTO_INCREMENT   NOT NULL,
	`Alt-Text`   VARCHAR(100)          NOT NULL,
	`Titel`      VARCHAR(100),                    -- Optional
	`Binärdaten` BLOB                  NOT NULL,
	CONSTRAINT pk_id PRIMARY KEY (`ID`)
);
DESCRIBE Bilder;


DROP TABLE IF EXISTS Zutaten;
CREATE TABLE Zutaten(
	`ID`          INT(5) UNSIGNED      NOT NULL,
	`Nachname`    VARCHAR(50)          NOT NULL,
	`Bio`         TINYINT(1) Default 0 NOT NULL,
	`Vegetarisch` TINYINT(1) Default 0 NOT NULL,
	`Vegan`       TINYINT(1) Default 0 NOT NULL,
	`Glutenfrei`  TINYINT(1) Default 0 NOT NULL,
	CONSTRAINT pk_id PRIMARY KEY (`ID`)
);
DESCRIBE Zutaten;


DROP TABLE IF EXISTS Kommentare;
CREATE TABLE Kommentare(
	`ID`        INT UNSIGNED AUTO_INCREMENT NOT NULL,
	`Bemerkung` VARCHAR(255),                         -- optional
	`Bewertung` VARCHAR(255),
	CONSTRAINT pk_id PRIMARY KEY (`ID`)
);
DESCRIBE Kommentare;

-- Ablaufdatum standardmäßig eine Woche in der Zukunft
-- der Grund wird nicht länger als 255 Zeichen lang
DROP TABLE IF EXISTS Gäste;
CREATE TABLE Gäste(
	`Ablaufdatum`  DATE DEFAULT now()+7,
	`Grund`        VARCHAR(255)
);

DROP TABLE IF EXISTS FH Angehörige;
CREATE TABLE FH Angehörige(
);

DROP TABLE IF EXISTS Fachbereiche;
CREATE TABLE Fachbereiche(
	`ID`          INT(5) UNSIGNED      NOT NULL,
	`Name`        VARCHAR(50)          NOT NULL,
	`Website`     VARCHAR(100)         NOT NULL,
	CONSTRAINT pk_id PRIMARY KEY (`ID`)
);

DROP TABLE IF EXISTS Mitarbeiter;
CREATE TABLE Mitarbeiter(
	`Büro`       INT(3) UNSIGNED,
	`Telefon`    INT(15) UNSIGNED
);

DROP TABLE IF EXISTS Studenten;
CREATE TABLE Studenten(
	`Studiengang`   ENUM (`ET`, `INF`, `ISE`, `MCD`, `WI`)  NOT NULL,
	`Matrikelnummer`INT                                     NOT NULL,
	CONSTRAINT ck_matrikelnummer CHECK (Matrikelnummer > 9999999 OR Matrikelnummer < 1000000000)
);