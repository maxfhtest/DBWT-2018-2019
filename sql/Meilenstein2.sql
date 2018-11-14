-- DROP DATABASE IF EXISTS Meilenstein2;
-- CREATE DATABASE Meilenstein2; 
USE Meilenstein2;
-- SET sql_mode='STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE';
-- SHOW ENGINE;
			-- DROP TABLE IF EXISTS Kunden;
			-- CREATE TABLE TESTINVORLESUNG (
			-- 	Nummer INT UNSIGNED AUTO_INCREMENT,	
			-- 	`Vorname` VARCHAR(100),			
			-- 	`Nachname` VARCHAR(50) NOT NULL,
			-- 	`E-Mail` VARCHAR(255) UNIQUE,
			-- 	`Portrait` BLOB,				
			-- 	PRIMARY KEY(Nummer) -- Künstlich --> Surrogate Key
			-- );

DROP USER IF EXISTS 'feschmit'@'localhost';
CREATE USER 'feschmit'@'localhost' IDENTIFIED BY 'feschmit';
GRANT USAGE ON *.* To 'feschmit'@'localhost';
GRANT SELECT, DELETE, INSERT, UPDATE ON `Meilenstein2`.* TO 'feschmit'@'localhost';

DROP USER IF EXISTS 'jverkerk'@'localhost';
CREATE User 'jverkerk'@'localhost' IDENTIFIED BY 'jverkerk';
GRANT USAGE ON *.* To 'jverkerk'@'localhost';
GRANT SELECT, DELETE, INSERT, UPDATE ON `Meilenstein2`.* TO 'jverkerk'@'localhost';

-- =======================================================



CREATE TABLE users (
	id              INT UNSIGNED AUTO_INCREMENT NOT NULL,
	-- `NAME`
    firstname       VARCHAR(100)            NOT NULL,
    lastname        VARCHAR(100)            NOT NULL,
	active          TINYINT(1) DEFAULT TRUE NOT NULL,
	created_at      DATE DEFAULT CURRENT_DATE,
	salt            CHAR(32)                NOT NULL,
	`hash`          CHAR(24)                NOT NULL,
    loginname       VARCHAR(50)             NOT NULL,
	last_login      DATETIME DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
	mail            VARCHAR(255)            NOT NULL,
	birth           DATE,            
	age             INT(3) AS (year(CURRENT_TIMESTAMP) - year(birth)) DEFAULT NULL,
	PRIMARY KEY (id),
	CONSTRAINT uk UNIQUE (loginname, mail)
);

CREATE TABLE IF NOT EXISTS members (
    id      INT UNSIGNED AUTO_INCREMENT     NOT NULL ,
    FOREIGN KEY (id) REFERENCES users(id) ON DELETE CASCADE,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS guests (
    id             INT UNSIGNED             NOT NULL,
    reason         VARCHAR(200)             NOT NULL,
    expiry_date    DATE DEFAULT (CURDATE()+7),
    FOREIGN KEY (id) REFERENCES users(id) ON DELETE CASCADE,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS students (
    id             INT UNSIGNED             NOT NULL,
    course         ENUM ('ET', 'INF', 'ISE', 'MCD', 'WI')  NOT NULL,
    matric_no      INT UNSIGNED UNIQUE CHECK( id > 9999999 AND id < 1000000000),
    FOREIGN KEY (id) REFERENCES members(id) ON DELETE CASCADE,
    PRIMARY KEY (id)
	-- 	CONSTRAINT `chk_matrikelnummer` CHECK (`Matrikelnummer` > 9999999 OR `Matrikelnummer` < 1000000000)
);

CREATE TABLE IF NOT EXISTS courses (
    id             INT UNSIGNED             NOT NULL,
    designation    VARCHAR(64)              NOT NULL,
	website        VARCHAR(128)             NOT NULL,
	PRIMARY KEY (id)	
)

CREATE TABLE IF NOT EXISTS enrolment (
	student_id     INT UNSIGNED             NOT NULL,
	course_id      INT UNSIGNED             NOT NULL,
	FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
	FOREIGN KEY (course_id) REFERENCES courses(id),
)

CREATE TABLE IF NOT EXISTS employees (
    id             INT UNSIGNED             NOT NULL,
    phone_number   VARCHAR (64),
    office         VARCHAR(3) UNSIGNED,
    FOREIGN KEY (id) REFERENCES members(id) ON DELETE CASCADE,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS orders (
    id             INT UNSIGNED AUTO_INCREMENT NOT NULL,
    order_time     TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
	pickup_time    TIMESTAMP DEFAULT NULL CHECK (pickup_time > order_time),
    user_id        INT UNSIGNED                NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    PRIMARY KEY (id)
	-- CONSTRAINT chk_abholzeitpunkt CHECK (pickup_time > order_time),
	-- Endpreis ToDo!
);

CREATE TABLE IF NOT EXISTS products (
   	id            INT AUTO_INCREMENT       NOT NULL,
	description   TEXT                     NOT NULL,
	stock         INT UNSIGNED DEFAULT 0   NOT NULL,
	available     TINYINT(1) DEFAULT 0     NOT NULL CHECK (CASE WHEN stock IS NOT `0` THEN available IS `1` ELSE `0` END),
    category_id   INT UNSIGNED             NOT NULL,	
    FOREIGN KEY (image_id) REFERENCES images(id),
    FOREIGN KEY (category_id) REFERENCES categorys(id),
    PRIMARY KEY (id)
	-- CONSTRAINT chk_avail CHECK (CASE WHEN stock IS NOT `0` THEN available IS `1` ELSE `0` END),
);

CREATE TABLE IF NOT EXISTS order_items (
    product_id     INT UNSIGNED            NOT NULL,
	quantity       INT DEFAULT 0           NOT NULL,
    order_id       INT UNSIGNED            NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (order_id) REFERENCES orders(id)
);

CREATE TABLE IF NOT EXISTS categorys (
    id            INT UNSIGNED AUTO_INCREMENT NOT NULL,
    designation   VARCHAR(100),
    upper_category_id INT UNSIGNED DEFAULT NULL,
    image_id INT UNSIGNED,
    FOREIGN KEY (image_id) REFERENCES images(id),
    PRIMARY KEY (id),
	CONSTRAINT upper_category FOREIGN KEY (upper_category_id) REFERENCES categorys(id),
);

CREATE TABLE IF NOT EXISTS prices (
    guest         DECIMAL(4,2)             NOT NULL,
    student       DECIMAL(4,2),
    employee      DECIMAL (4,2),
    id INT UNSIGNED NOT NULL,
    FOREIGN KEY (id) REFERENCES products(id),
	CONSTRAINT ck_studentenpreis CHECK (student < employee)
	-- Jahr ?!
);

CREATE TABLE IF NOT EXISTS label (
	symbol        VARCHAR(2)               NOT NULL,
	label         VARCHAR(32)              NOT NULL,
	PRIMARY KEY (symbol)
)

CREATE TABLE IF NOT EXISTS product_label (
	products_id    INT                     NOT NULL,
	label_symbol   INT                     NOT NULL,
	FOREIGN KEY (product_id) REFERENCES products(id),
	FOREIGN KEY (label_symbol) REFERENCES label(symbol)
)

CREATE TABLE IF NOT EXISTS images (
    id             INT UNSIGNED AUTO_INCREMENT,
    blob_data      BLOB                    NOT NULL,
    alttext        VARCHAR(60)             NOT NULL,
    title          VARCHAR(60),
    PRIMARY KEY(ID)
);

CREATE TABLE IF NOT EXISTS product_image (
	product_id     INT                     NOT NULL,
	image_id       INT                     NOT NULL,
	FOREIGN KEY (product_id) REFERENCES products(id),
	FOREIGN KEY (image_id) REFERENCES images(id)
)

CREATE TABLE IF NOT EXISTS ingredients (
    id             INT UNSIGNED AUTO_INCREMENT NOT NULL,
	`name`    	   VARCHAR(50)          NOT NULL,
	bio            TINYINT(1) Default 0 NOT NULL,
	vegetarian     TINYINT(1) Default 0 NOT NULL,
	vegan          TINYINT(1) Default 0 NOT NULL,
	gluten-free    TINYINT(1) Default 0 NOT NULL,
	PRIMARY KEY (id)
);
-- INSERT INTO `ingredients` (`id`, `name`, `Beschreibung`, `vegan`, `vegetarian`, `bio`, `gluten-free`) VALUES
--	(1, 'Tomate', 'Das ist ein rotes, essbares, rundes Gemüse', 1, 1, 1, 1),
--	(2, 'Zwiebel', 'Rundet alles ab', 1, 1, 1, 1),
--	(3, 'Rinderfleisch', 'Zartes und saftiges Rinderfleisch', 0, 0, 1, 1),
--	(4, 'Hähnchen', 'Auf engsten Raum gehalten.', 0, 0, 0, 1),
--	(5, 'Brötchen', 'Frisch gebacken.', 1, 1, 0, 0),
--	(6, 'Ketchup', 'Heinz leistet da gute arbeit.', 0, 0, 0, 0),
--	(7, 'Eisberg Salat', 'Bauer Heinz beliefert uns täglich.', 1, 1, 1, 1),
--	(8, 'Eier', 'Jeden Tag frische Eier.', 1, 1, 1, 1),
--	(9, 'Curry', 'Curry aus Indien.', 1, 1, 1, 1),
--	(10, 'Karotten', 'Frische Karotten.', 1, 1, 1, 1),
--	(11, 'Bratrolle', 'Aus den Niederlanden.', 0, 0, 0, 1),
--	(12, 'Schweinefleisch', 'Massenhaltung für Billigpreis', 0, 0, 0, 1),
--	(13, 'Pommes', 'Kartoffelsticks', 0, 0, 0, 0);

CREATE TABLE IF NOT EXISTS products_ingredients (
    product_id     INT UNSIGNED         NOT NULL,
    ingredient_id  INT UNSIGNED         NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(id)
);

CREATE TABLE IF NOT EXISTS comments (
    id             INT UNSIGNED AUTO_INCREMENT NOT NULL,	
	comment        VARCHAR(255),
	rating         ENUM ('Poor', 'Fair', 'Average', 'Good', 'Excellent', 'It`s only food' )  NOT NULL,
	student_id     INT UNSIGNED         NOT NULL,
	product_id    INT UNSIGNED         NOT NULL,
	FOREIGN KEY (product_id) REFERENCES products(id),
	FOREIGN KEY (student_id) REFERENCES students(id)
)

CREATE TABLE friends(
	friendone	 INT,
	friendtwo	 INT,
	FOREIGN KEY (friendone) REFERENCES Benutzer(Nummer),
	FOREIGN KEY (friendtwo) REFERENCES Benutzer(Nummer),
	CONSTRAINT chk_friends CHECK (friendone != friendtwo)
);
