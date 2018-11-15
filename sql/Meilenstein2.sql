USE Meilenstein2;

DROP TABLE IF EXISTS products_ingredients;
DROP TABLE IF EXISTS ingredients;
DROP TABLE IF EXISTS prices;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS products_label;
DROP TABLE IF EXISTS products_images;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categorys;
DROP TABLE IF EXISTS images;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS enrolment;
DROP TABLE IF EXISTS faculties;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS guests;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS users_friends;
DROP TABLE IF EXISTS users;

CREATE TABLE IF NOT EXISTS users (
	id              INT UNSIGNED AUTO_INCREMENT NOT NULL,
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
	age             INT(3) DEFAULT NULL,
	
	-- Select date_format(from_Days(DATEDIFF(CURDATE(), `Geburtsdatum`)+1) ,'%Y') as age,
	
	PRIMARY KEY (id),
	CONSTRAINT uk UNIQUE (loginname, mail)
);

CREATE TABLE users_friends(
	friendone	 INT UNSIGNED NOT NULL,
	friendtwo	 INT UNSIGNED NOT NULL,
	CONSTRAINT friends_1 FOREIGN KEY (friendone) REFERENCES users(id),
	CONSTRAINT friends_2 FOREIGN KEY (friendtwo) REFERENCES users(id),
	CONSTRAINT chk_friends CHECK (friendone != friendtwo)
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
    matric_no      INT(9) UNSIGNED UNIQUE,
    FOREIGN KEY (id) REFERENCES members(id) ON DELETE CASCADE,
    PRIMARY KEY (id),
	 CONSTRAINT `chk_matrikelnummer` CHECK (LENGTH(matric_no) >= 8)
);

CREATE TABLE IF NOT EXISTS faculties (
    id             INT UNSIGNED             NOT NULL,
    `name`    ENUM ('Architektur', 'Bauingenieurwesen', 'Chemie und Biotechnologie', 'Gestaltung', 'Elektrotechnik und Informationstechnik', 'Luft- und Raumfahrttechnik', 'Wirtschaftswissenschaften', 'Maschinenbau und Mechatronik', 'Medizintechnik und Technomathematik', 'Energietechnik') NOT NULL,
	website        VARCHAR(128)             NOT NULL,
	PRIMARY KEY (id)	
);

CREATE TABLE IF NOT EXISTS enrolment (
	student_id     INT UNSIGNED NOT NULL,
	course_id      INT UNSIGNED NOT NULL,
	FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE,
	FOREIGN KEY (course_id) REFERENCES faculties(id)
);

CREATE TABLE IF NOT EXISTS employees (
    id             INT UNSIGNED             NOT NULL,
    phone_number   INT UNSIGNED,
    office         VARCHAR(3),
    FOREIGN KEY (id) REFERENCES members(id) ON DELETE CASCADE,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS orders (
    id             INT UNSIGNED AUTO_INCREMENT NOT NULL,
    order_time     TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    pickup_time    TIMESTAMP DEFAULT 0 CHECK (pickup_time = 0 OR pickup_time > order_time),
    user_id        INT UNSIGNED NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id),
    PRIMARY KEY (id)
    -- CONSTRAINT chk_abholzeitpunkt CHECK (pickup_time > order_time),
    -- Endpreis ToDo
);

CREATE TABLE IF NOT EXISTS images (
    id             INT UNSIGNED AUTO_INCREMENT,
    blob_data      BLOB                    NOT NULL,
    alttext        VARCHAR(60)             NOT NULL,
    title          VARCHAR(60),
    PRIMARY KEY(ID)
);

CREATE TABLE IF NOT EXISTS categorys (
    id            INT UNSIGNED AUTO_INCREMENT NOT NULL,
    `name`   VARCHAR(100),
    upper_category_id INT UNSIGNED DEFAULT NULL,
    image_id INT UNSIGNED,
    FOREIGN KEY (image_id) REFERENCES images(id),
    PRIMARY KEY (id),
	 CONSTRAINT upper_category FOREIGN KEY (upper_category_id) REFERENCES categorys(id)
);

CREATE TABLE IF NOT EXISTS products (
    id           INT UNSIGNED AUTO_INCREMENT,
    description TEXT NOT NULL,
	 stock         INT UNSIGNED DEFAULT 0   NOT NULL,
    image_id INT UNSIGNED NOT NULL,
    available     TINYINT(1) DEFAULT FALSE  NOT NULL,
    category_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (image_id) REFERENCES images(id),
    FOREIGN KEY (category_id) REFERENCES categorys(id),
    PRIMARY KEY (id)
    -- CASE WHEN stock = 0 THEN available = FALSE ELSE available = TRUE END
);

CREATE TABLE IF NOT EXISTS products_images (
	product_id     INT UNSIGNED            NOT NULL,
	image_id       INT UNSIGNED            NOT NULL,
	FOREIGN KEY (product_id) REFERENCES products(id),
	FOREIGN KEY (image_id) REFERENCES images(id)
);

CREATE TABLE IF NOT EXISTS label (
	symbol        VARCHAR(2)               NOT NULL,
	label         VARCHAR(32)              NOT NULL,
	PRIMARY KEY (symbol)
);

CREATE TABLE IF NOT EXISTS products_label (
	product_id    INT UNSIGNED            NOT NULL,
	label_symbol   VARCHAR(2)           NOT NULL,
	FOREIGN KEY (product_id) REFERENCES products(id),
	FOREIGN KEY (label_symbol) REFERENCES label(symbol)
);

CREATE TABLE IF NOT EXISTS comments (
   id             INT UNSIGNED AUTO_INCREMENT NOT NULL,	
	comment        VARCHAR(255),
	rating         ENUM ('Poor', 'Fair', 'Average', 'Good', 'Excellent', 'It`s only food' )  NOT NULL,
	student_id     INT UNSIGNED         NOT NULL,
	product_id     INT UNSIGNED         NOT NULL,
	FOREIGN KEY (product_id) REFERENCES products(id),
	FOREIGN KEY (student_id) REFERENCES students(id),
	PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS order_items (
    product_id     INT UNSIGNED            NOT NULL,
	quantity       INT DEFAULT 0           NOT NULL,
    order_id       INT UNSIGNED            NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (order_id) REFERENCES orders(id)
);

CREATE TABLE IF NOT EXISTS prices (
    guest         DECIMAL(4,2)             NOT NULL,
    student       DECIMAL(4,2),
    employee      DECIMAL (4,2),
    id INT UNSIGNED NOT NULL,
    `year` YEAR,
    FOREIGN KEY (id) REFERENCES products(id),
	CONSTRAINT ck_studentenpreis CHECK (student < employee)
);

CREATE TABLE IF NOT EXISTS ingredients (
    id            INT UNSIGNED AUTO_INCREMENT NOT NULL,
    `name`    	   VARCHAR(50)          NOT NULL,
	 glutenfree    TINYINT(1) DEFAULT TRUE NOT NULL,
    bio           TINYINT(1) DEFAULT TRUE NOT NULL,
    vegetarian    TINYINT(1) DEFAULT TRUE NOT NULL,
    vegan         TINYINT(1) DEFAULT TRUE NOT NULL,
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
    product_id INT UNSIGNED NOT NULL,
    ingredient_id INT UNSIGNED NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (ingredient_id) REFERENCES ingredients(id)
);

REPLACE INTO `label` (`symbol`, `label`) VALUES
	('2', 'Konservierungsstoff'),
	('3', 'Antioxidationsmittel'),
	('4', 'Geschmacksverstärker'),
	('5', 'geschwefelt'),
	('6', 'geschwärzt'),
	('7', 'gewachst'),
	('8', 'Phosphat'),
	('9', 'Süßungsmittel'),
	('10', 'enthält eine Phenylalaninquelle'),
	('A', 'Gluten'),
	('A1', 'Weizen'),
	('A2', 'Roggen'),
	('A3', 'Gerste'),
	('A4', 'Hafer'),
	('A5', 'Dinkel'),
	('B', 'Sellerie'),
	('C', 'Krebstiere'),
	('D', 'Eier'),
	('E', 'Fische'),
	('F', 'Erdnüsse'),
	('G', 'Sojabohnen'),
	('H', 'Milch'),
	('I', 'Schalenfrüchte'),
	('I1', 'Mandeln'),
	('I2', 'Haselnüsse'),
	('I3', 'Walnüsse'),
	('I4', 'Kaschunüsse'),
	('I5', 'Pecannüsse'),
	('I6', 'Paranüsse'),
	('I7', 'Pistazien'),
	('I8', 'Macadamianüsse'),
	('J', 'Senf'),
	('K', 'Sesamsamen'),
	('L', 'Schwefeldioxid oder Sulfite'),
	('M', 'Lupinen'),
	('N', 'Weichtiere')
;

REPLACE INTO `ingredients` (id, `name`, bio, vegan, vegetarian, glutenfree) VALUES
	(00080, 'Aal', 0, 0, 0, 1),
	(00081, 'Forelle', 0, 0, 0, 1),
	(00082, 'Barsch', 0, 0, 0, 1),
	(00083, 'Lachs', 0, 0, 0, 1),
	(00084, 'Lachs', 1, 0, 0, 1),
	(00085, 'Heilbutt', 0, 0, 0, 1),
	(00086, 'Heilbutt', 1, 0, 0, 1),
	(00100, 'Kurkumin', 1, 1, 1, 1),
	(00101, 'Riboflavin', 0, 1, 1, 1),
	(00123, 'Amaranth', 1, 1, 1, 1),
	(00150, 'Zuckerkulör', 0, 1, 1, 1),
	(00171, 'Titandioxid', 0, 1, 1, 1),
	(00220, 'Schwefeldioxid', 0, 1, 1, 1),
	(00270, 'Milchsäure', 0, 1, 1, 1),
	(00322, 'Lecithin', 0, 1, 1, 1),
	(00330, 'Zitronensäure', 1, 1, 1, 1),
	(00999, 'Weizenmehl', 1, 1, 1, 0),
	(01000, 'Weizenmehl', 0, 1, 1, 0),
	(01001, 'Hanfmehl', 1, 1, 1, 1),
	(01010, 'Zucker', 0, 1, 1, 1),
	(01013, 'Traubenzucker', 0, 1, 1, 1),
	(01015, 'Branntweinessig', 0, 1, 1, 1),
	(02019, 'Karotten', 0, 1, 1, 1),
	(02020, 'Champignons', 0, 1, 1, 1),
	(02101, 'Schweinefleisch', 0, 0, 0, 1),
	(02102, 'Speck', 0, 0, 0, 1),
	(02103, 'Alginat', 0, 1, 1, 1),
	(02105, 'Paprika', 0, 1, 1, 1),
	(02107, 'Fenchel', 0, 1, 1, 1),
	(02108, 'Sellerie', 0, 1, 1, 1),
	(09020, 'Champignons', 1, 1, 1, 1),
	(09105, 'Paprika', 1, 1, 1, 1),
	(09107, 'Fenchel', 1, 1, 1, 1),
	(09110, 'Sojasprossen', 1, 1, 1, 1)
;

ALTER TABLE `faculties` ADD COLUMN IF NOT EXISTS `adress` VARCHAR(255);

REPLACE INTO `faculties` (id, `name`, `website`, `adress`) VALUES
	(1, 'Architektur', 'https://www.fh-aachen.de/fachbereiche/architektur/', 'Bayernallee 9, 52066 Aachen'),
	(2, 'Bauingenieurwesen', 'https://www.fh-aachen.de/fachbereiche/bauingenieurwesen/', 'Bayernallee 9, 52066 Aachen'),
	(3, 'Chemie und Biotechnologie', 'https://www.fh-aachen.de/fachbereiche/chemieundbiotechnologie/', 'Heinrich-Mußmann-Straße 1, 52428 Jülich'),
	(4, 'Gestaltung', 'https://www.fh-aachen.de/fachbereiche/gestaltung/', 'Boxgraben 100, 52064 Aachen'),
	(5, 'Elektrotechnik und Informationstechnik', 'https://www.fh-aachen.de/fachbereiche/elektrotechnik-und-informationstechnik/', 'Eupener Straße 70, 52066 Aachen'),
	(6, 'Luft- und Raumfahrttechnik', 'https://www.fh-aachen.de/fachbereiche/luft-und-raumfahrttechnik/', 'Hohenstaufenallee 6, 52064 Aachen'),
	(7, 'Wirtschaftswissenschaften', 'https://www.fh-aachen.de/fachbereiche/wirtschaft/', 'Eupener Straße 70, 52066 Aachen'),
	(8, 'Maschinenbau und Mechatronik', 'https://www.fh-aachen.de/fachbereiche/maschinenbau-und-mechatronik/', 'Goethestraße 1, 52064 Aachen'),
	(9, 'Medizintechnik und Technomathematik', 'https://www.fh-aachen.de/fachbereiche/medizintechnik-und-technomathematik/', 'Heinrich-Mußmann-Straße 1, 52428 Jülich'),
	(10, 'Energietechnik', 'https://www.fh-aachen.de/fachbereiche/energietechnik/', 'Heinrich-Mußmann-Straße 1, 52428 Jülich')
;

INSERT INTO `users` (`mail`, loginname, salt, `Hash`, active, firstname, lastname)
	VALUES ('Max@Mustermann.de', 'MaxMu', '12345678901234567890123456789012', '123456789012345678901234', '1', 'Max', 'Mustermann');

INSERT INTO `users` (`mail`, loginname, salt, `Hash`, active, firstname, lastname)
	VALUES ('Maria@Mustermann.de', 'MariaMu', '12345678901234567890123456789012', '123456789012345678901234', '1', 'Maria', 'Mustermann');
	
INSERT INTO `users` (`mail`, loginname, salt, `Hash`, active, firstname, lastname)
	VALUES ('Peter@Mastermann.de', 'PeterMa', '12345678901234567890123456789012', '123456789012345678901234', '1', 'Peter', 'Mastermann');
	
INSERT INTO `users` (`mail`, loginname, salt, `Hash`, active, firstname, lastname)
	VALUES ('Paul@Dealer.de', 'PaulDe', '12345678901234567890123456789012', '123456789012345678901234', '1', 'Paul', 'Dealer');	
	
INSERT INTO members(id)
	VALUES 
	('1'),
	('2'),
	('3');

ALTER TABLE `employees` ADD COLUMN IF NOT EXISTS `building` CHAR(1);
	
INSERT INTO `employees` (id, phone_number, building, office)
	VALUES ('1', '12345', 'E', '123');
	
	
INSERT INTO `students` (id, course, matric_no)
	VALUES ('2', 'ET', '12345678');
		
INSERT INTO `students` (ID, course, matric_no)
	VALUES ('3', 'MCD', '123456789');
	

DELETE FROM users WHERE id = ('4');
DELETE FROM users WHERE id = ('1');

/*INSERT INTO `products` (description, stock, available, image_id, category_id)
	VALUES 
	('Curry Wok', '10', '1', '1', '1'),
	('Schnitzel', '10', '1', '1', '1'),
	('Bratrolle', '10', '0', '1', '1'),
	('Krautsalat', '10', '1', '1', '1'),
	('Falafel', '10', '1', '1', '1'),
	('Currywurst', '10', '1', '1', '1'),
	('Käsestulle', '10', '1', '1', '1'),
	('Spiegelei', '10', '1', '1', '1');*/
/*	
INSERT INTO prices (id, `year`, guest)
	VALUES
	('1', '2018', '5.95'),
	('2', '2018', '5.95'),
	('3', '2018', '5.95'),
	('4', '2018', '5.95'),
	('5', '2018', '5.95'),
	('6', '2018', '5.95'),
	('7', '2018', '5.95'),
	('8', '2018', '5.95');*/
	
	INSERT INTO `categorys` (`name`)
	VALUES
	('Klassiker'), 
	('Vegetarisch'), 
	('Tellergericht');