-- zum schnellen einspielen von Produkten in die DB
DROP TABLE IF EXISTS products;
CREATE TABLE IF NOT EXISTS products (
   	id            INT AUTO_INCREMENT       NOT NULL,
	description   TEXT                     NOT NULL,
	stock         INT UNSIGNED DEFAULT 0   NOT NULL,
	available     TINYINT(1) DEFAULT 0     NOT NULL,
    category_id   INT UNSIGNED             NOT NULL,	
    PRIMARY KEY (id)
);
INSERT INTO `products` (`description`,`stock`,`available`,`category_id`) VALUES
								('Curry Wok',	21			,1				,1),
								('Schnitzel',	2			,1				,1),
								('Bratrolle',	2			,0				,1),
								('Krautsalat',	2			,1				,1),
								('Falaffel'	,	2			,1				,1),
								('Currywurst',	2			,1				,1),
								('Kaesestulle',	2			,1				,1),
								('Spiegelei',	2			,1				,1);
SELECT * FROM products ORDER BY id Limit 4;



-- zum schnellen einspielen von Zutaten in die DB
 INSERT INTO `ingredients` (`id`, `name`, `Beschreibung`, `vegan`, `vegetarian`, `bio`, `gluten-free`) VALUES
	(1, 'Tomate', 'Das ist ein rotes, essbares, rundes Gemüse', 1, 1, 1, 1),
	(2, 'Zwiebel', 'Rundet alles ab', 1, 1, 1, 1),
	(3, 'Rinderfleisch', 'Zartes und saftiges Rinderfleisch', 0, 0, 1, 1),
	(4, 'Hähnchen', 'Auf engsten Raum gehalten.', 0, 0, 0, 1),
	(5, 'Brötchen', 'Frisch gebacken.', 1, 1, 0, 0),
	(6, 'Ketchup', 'Heinz leistet da gute arbeit.', 0, 0, 0, 0),
	(7, 'Eisberg Salat', 'Bauer Heinz beliefert uns täglich.', 1, 1, 1, 1),
	(8, 'Eier', 'Jeden Tag frische Eier.', 1, 1, 1, 1),
	(9, 'Curry', 'Curry aus Indien.', 1, 1, 1, 1),
	(10, 'Karotten', 'Frische Karotten.', 1, 1, 1, 1),
	(11, 'Bratrolle', 'Aus den Niederlanden.', 0, 0, 0, 1),
	(12, 'Schweinefleisch', 'Massenhaltung für Billigpreis', 0, 0, 0, 1),
	(13, 'Pommes', 'Kartoffelsticks', 0, 0, 0, 0);
