CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Provincia`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Provincia` (
  `provincia_id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`provincia_id`));


-- -----------------------------------------------------
-- Table `mydb`.`Localitat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Localitat` (
  `localitat_id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(255) NOT NULL,
  `provincia` INT NOT NULL,
  PRIMARY KEY (`localitat_id`),
  INDEX `provincia_idx` (`provincia` ASC) VISIBLE,
  CONSTRAINT `provincia`
    FOREIGN KEY (`provincia`)
    REFERENCES `mydb`.`Provincia` (`provincia_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mydb`.`Client`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Client` (
   `client_id` INT NOT NULL AUTO_INCREMENT,
   `nom` VARCHAR(16) NOT NULL,
   `cognom` VARCHAR(32) NOT NULL,
   `adreça` VARCHAR(45) NULL,
   `codiPostal` VARCHAR(45) NULL,
   `provincia` INT NOT NULL,
   `localitat` INT NOT NULL,
   `numTelefon` VARCHAR(45) NOT NULL,
   PRIMARY KEY (`client_id`),
   INDEX `provincia_idx` (`provincia` ASC) VISIBLE,
   INDEX `localitat_idx` (`localitat` ASC) VISIBLE,
   CONSTRAINT `fk_client_provincia`
     FOREIGN KEY (`provincia`)
     REFERENCES `mydb`.`Provincia` (`provincia_id`)
     ON DELETE NO ACTION
     ON UPDATE NO ACTION,
   CONSTRAINT `fk_client_localitat`
     FOREIGN KEY (`localitat`)
     REFERENCES `mydb`.`Localitat` (`localitat_id`)
     ON DELETE NO ACTION
     ON UPDATE NO ACTION
);


-- -----------------------------------------------------
-- Table `mydb`.`Botiga`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Botiga` (
  `botiga_id` INT NOT NULL AUTO_INCREMENT,
  `adreça` VARCHAR(255) NOT NULL,
  `codiPostal` VARCHAR(45) NOT NULL,
  `localitat` INT NOT NULL,
  `provincia` INT NOT NULL,
  PRIMARY KEY (`botiga_id`),
  INDEX `localitat_idx` (`localitat` ASC) VISIBLE,
  INDEX `provincia_idx` (`provincia` ASC) VISIBLE,
  CONSTRAINT `fk_client_localitat2`
    FOREIGN KEY (`localitat`)
    REFERENCES `mydb`.`Localitat` (`localitat_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_client_provincia2`
    FOREIGN KEY (`provincia`)
    REFERENCES `mydb`.`Provincia` (`provincia_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mydb`.`Empleats`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Empleats` (
  `empleat_id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(255) NOT NULL,
  `cognom` VARCHAR(32) NOT NULL,
  `NIF` VARCHAR(45) NULL,
  `telefon` VARCHAR(45) NULL,
  `tipus` ENUM('Cuiner', 'Repartidor') NOT NULL,
  `Botiga_botiga_id` INT NOT NULL,
  PRIMARY KEY (`empleat_id`),
  INDEX `fk_Empleats_Botiga1_idx` (`Botiga_botiga_id` ASC) VISIBLE,
  CONSTRAINT `fk_Empleats_Botiga1`
    FOREIGN KEY (`Botiga_botiga_id`)
    REFERENCES `mydb`.`Botiga` (`botiga_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mydb`.`Comanda`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Comanda` (
  `comanda_id` INT NOT NULL AUTO_INCREMENT,
  `data/hora` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `tipus` ENUM('Recollir', 'Domicili') NOT NULL,
  `preuTotal` INT NOT NULL,
  `Client_client_id` INT NOT NULL,
  `Botiga_botiga_id` INT NOT NULL,
  `empleat_id` INT NOT NULL,
  `dataHoraLliurament` DATETIME NULL,
  INDEX `fk_Comanda_Client1_idx` (`Client_client_id` ASC) VISIBLE,
  PRIMARY KEY (`comanda_id`),
  INDEX `fk_Comanda_Botiga1_idx` (`Botiga_botiga_id` ASC) VISIBLE,
  INDEX `empleat_id_idx` (`empleat_id` ASC) VISIBLE,
  CONSTRAINT `fk_Comanda_Client1`
    FOREIGN KEY (`Client_client_id`)
    REFERENCES `mydb`.`Client` (`client_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Comanda_Botiga1`
    FOREIGN KEY (`Botiga_botiga_id`)
    REFERENCES `mydb`.`Botiga` (`botiga_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `empleat_id`
    FOREIGN KEY (`empleat_id`)
    REFERENCES `mydb`.`Empleats` (`empleat_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`CategoriaPizza`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`CategoriaPizza` (
  `categoriaPizza_id` INT NOT NULL,
  `nom` VARCHAR(255) NULL,
  PRIMARY KEY (`categoriaPizza_id`));


-- -----------------------------------------------------
-- Table `mydb`.`Categories`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Categories` (
  `categories_id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(45) NOT NULL,
  `CategoriaPizza_id` INT NULL,
  PRIMARY KEY (`categories_id`),
  INDEX `fk_Categories_CategoriaPizza1_idx` (`CategoriaPizza_id` ASC) VISIBLE,
  CONSTRAINT `fk_Categories_CategoriaPizza1`
    FOREIGN KEY (`CategoriaPizza_id`)
    REFERENCES `mydb`.`CategoriaPizza` (`categoriaPizza_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

-- -----------------------------------------------------
-- Table `mydb`.`Producte`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`Producte` (
  `producte_id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(255) NOT NULL,
  `descripcio` VARCHAR(32) NULL,
  `preu` INT NOT NULL,
  `imatge` VARCHAR(45) NULL,
  `Categories_categories_id` INT NOT NULL,
  `tipus` ENUM('Pizza', 'Hamburguesa', 'Beguda') NOT NULL,
  PRIMARY KEY (`producte_id`),
  INDEX `fk_Pizzes_Categories1_idx` (`Categories_categories_id` ASC) VISIBLE,
  CONSTRAINT `fk_Pizzes_Categories1`
    FOREIGN KEY (`Categories_categories_id`)
    REFERENCES `mydb`.`Categories` (`categories_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `mydb`.`ComandaAmbProducte`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`ComandaAmbProducte` (
  `comandaAmbProducte_id` INT AUTO_INCREMENT NOT NULL,
  `comanda_id` INT NOT NULL,
  `producte_id` INT NOT NULL,
  `quantitat` INT NOT NULL DEFAULT 1,
  PRIMARY KEY (`comandaAmbProducte_id`),
  INDEX `comanda_id_idx` (`comanda_id` ASC) VISIBLE,
  INDEX `producte_id_idx` (`producte_id` ASC) VISIBLE,
  CONSTRAINT `comanda_id`
    FOREIGN KEY (`comanda_id`)
    REFERENCES `mydb`.`Comanda` (`comanda_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `producte_id`
    FOREIGN KEY (`producte_id`)
    REFERENCES `mydb`.`Producte` (`producte_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

insert into Provincia (provincia_id, nom)
values
	(1, 'Barcelona');
    
insert into Localitat (localitat_id, nom, provincia) 
values 
	(1, 'Barcelona', 1),
    (2, 'Badalona', 1);
    
insert into Botiga (botiga_id, adreça, codiPostal, localitat, provincia)
values
	(1, 'Llagostera', '8026', 1, 1),
    (2, 'BadaPompeuFabra', '08045', 2, 1);

insert into Client (client_id, nom, cognom, provincia, localitat, numTelefon)
values
	(1, 'Christian', 'Amor Lopez', 1,1, '658264546');

insert into Client (client_id, nom, cognom, provincia, localitat, numTelefon)
values
	(2, 'Andreu', 'Lopez', 1,2, '658264546');
    
insert into Empleats (empleat_id, nom, cognom, tipus, Botiga_botiga_id)
values
	(1, 'Claudia', 'Pernazza', 'REPARTIDOR', 1);

insert into Comanda (comanda_id, tipus, preuTotal, Client_client_id, Botiga_botiga_id, empleat_id)
values
	(1, 'DOMICILI', 10, 1,1,1),
	(2, 'DOMICILI', 10, 1,1,1),
	(3, 'DOMICILI', 10, 1,1,1),
    (4, 'DOMICILI', 10, 1,2,1);

insert into Comanda (comanda_id, tipus, preuTotal, Client_client_id, Botiga_botiga_id, empleat_id)
values
	(5, 'DOMICILI', 10, 2,1,1);

insert into CategoriaPizza (categoriaPizza_id, nom)
values
	(1, 'Margarita'),
    (2, 'Carbonara');
    
insert into Categories (categories_id, nom, CategoriaPizza_id)
values
    (1, 'BEGUDA', NULL),
    (2, 'HAMBURGUESA', NULL),
	(3, 'PIZZA', 1 ),
    (4, 'PIZZA', 2);
    
insert into Producte (producte_id, nom, preu, Categories_categories_id, tipus)
values 
	(1, 'Margarita', 5, 3, 'PIZZA'),
    (2, 'Carbonara', 7, 4, 'PIZZA');

insert into Producte (producte_id, nom, preu, Categories_categories_id, tipus)
values 
	(5, 'CocaCola', 2, 1, 'BEGUDA'),
    (6, 'Agua', 1, 1, 'BEGUDA');
    
insert into ComandaAmbProducte (comanda_id, producte_id, quantitat)
values
	(1, 6, 2),
    (2, 6, 3),
    (3, 5, 3),
    (4, 1, 3),
    (5, 6, 5);
    
insert into ComandaAmbProducte (comanda_id, producte_id, quantitat)
values
	(1, 1, 2);
    
insert into ComandaAmbProducte (comanda_id, producte_id, quantitat)
values
	(5, 1, 5);
    
SELECT SUM(cap.quantitat) AS quantitatBegudes, L.nom AS localitat
FROM ComandaAmbProducte cap
JOIN Producte P ON cap.producte_id = P.producte_id
JOIN Categories cs ON P.Categories_categories_id = cs.categories_id
JOIN Comanda C ON cap.comanda_id = C.comanda_id
JOIN Client cl ON C.Client_client_id = cl.client_id
JOIN Localitat L ON cl.localitat = L.localitat_id
WHERE cs.nom = 'BEGUDA' AND L.nom = 'Barcelona';

SELECT SUM(cap.quantitat) AS quantitatBegudes, L.nom AS localitat
FROM ComandaAmbProducte cap
JOIN Producte P ON cap.producte_id = P.producte_id
JOIN Categories cs ON P.Categories_categories_id = cs.categories_id
JOIN Comanda C ON cap.comanda_id = C.comanda_id
JOIN Client cl ON C.Client_client_id = cl.client_id
JOIN Localitat L ON cl.localitat = L.localitat_id
WHERE cs.nom = 'BEGUDA' AND L.nom = 'Badalona';


SELECT COUNT(c.comanda_id), e.nom FROM Comanda c JOIN Empleats e 
ON e.empleat_id=c.empleat_id group by c.empleat_id;

-- Consulta extra per comprobar les subcategories de pizzes.

SELECT c.comanda_id, cl.nom, SUM(cap.quantitat) AS quantitatPizzes, cp.nom AS NOM_PIZZA
FROM ComandaAmbProducte cap
JOIN Producte P ON cap.producte_id = P.producte_id
JOIN Categories cs ON P.Categories_categories_id = cs.categories_id
JOIN CategoriaPizza cp ON cs.CategoriaPizza_id=cp.categoriaPizza_id
JOIN Comanda C ON cap.comanda_id = C.comanda_id
JOIN Client cl ON C.Client_client_id = cl.client_id
JOIN Localitat L ON cl.localitat = L.localitat_id
WHERE cs.nom = 'PIZZA' AND cp.nom='Margarita' GROUP BY p.producte_id, cs.categories_id, cp.categoriaPizza_id, C.comanda_id, cl.client_id, L.localitat_id;