DROP DATABASE IF EXISTS Meilenstein2;
CREATE DATABASE Meilenstein2; 
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
	`Nummer` INT NOT NULL AUTO_INCREMENT,
	-- `NAME`
		`Vorname` VARCHAR(100) NOT NULL,			
		`Nachname` VARCHAR(50) NOT NULL,
	`Aktiv` tinyint(1) NOT NULL DEFAULT 0,
	`Anlegedatum` DATETIME NOT NULL DEFAULT curdate(), -- oder besser CURRENT_DATE ?
	-- `Auth`
		`Salt` VARCHAR(32) NOT NULL,
		`Hash` VARCHAR(24) NOT NULL,
	`Nutzername` VARCHAR(1000) NOT NULL,
	`Letzter Login` DATETIME DEFAULT NULL, -- ist optional
	`E-Mail` VARCHAR(255) NOT NULL,
	`Geburtsdatum` DATE, -- ist Optional
	PRIMARY KEY (`Nummer`),
  	UNIQUE KEY (`E-mail`,`Nutzername`)
);

DROP TABLE IF EXISTS Bestellungen;
CREATE TABLE Bestellungen(
	`Nummer` INT NOT NULL AUTO_INCREMENT,
	`Abholzeitpunkt` DATETIME DEFAULT NULL, -- ist optional!
	`Bestellzeitpunkt` DATETIME NOT NULL DEFAULT curdate(), -- oder besser CURRENT_DATE ?
	PRIMARY KEY (`Nummer`)
);

-- BIS HIERHIN..

DROP TABLE IF EXISTS Mahlzeiten;
CREATE TABLE Mahlzeiten(
);

DROP TABLE IF EXISTS Deklarationen;
CREATE TABLE Deklarationen(
);

DROP TABLE IF EXISTS Preise;
CREATE TABLE Preise(
);

DROP TABLE IF EXISTS Kategorien;
CREATE TABLE Kategorien(
);

DROP TABLE IF EXISTS Bilder;
CREATE TABLE Bilder(
);

DROP TABLE IF EXISTS Zutaten;
CREATE TABLE Zutaten(
);

DROP TABLE IF EXISTS Zutaten;
CREATE TABLE Zutaten(
);

DROP TABLE IF EXISTS Kommentare;
CREATE TABLE Kommentare(
);

DROP TABLE IF EXISTS Deklarationen;
CREATE TABLE Deklarationen(
);

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