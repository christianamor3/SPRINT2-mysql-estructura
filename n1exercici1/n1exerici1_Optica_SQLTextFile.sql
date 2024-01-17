CREATE SCHEMA IF NOT EXISTS `Optica` DEFAULT CHARACTER SET utf8 ;
USE `Optica` ;

-- -----------------------------------------------------
-- Table `Optica`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Optica`.`user` (
  `username` VARCHAR(16) NOT NULL,
  `email` VARCHAR(255) NULL,
  `password` VARCHAR(32) NOT NULL,
  `create_time` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP);


-- -----------------------------------------------------
-- Table `Optica`.`Adreça`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Optica`.`Adreça` (
  `adreça_id` INT NOT NULL,
  `carrer` VARCHAR(255) NOT NULL,
  `numero` VARCHAR(32) NOT NULL,
  `pis` VARCHAR(45) NOT NULL,
  `porta` VARCHAR(45) NOT NULL,
  `ciutat` VARCHAR(45) NOT NULL,
  `codiPostal` VARCHAR(45) NOT NULL,
  `pais` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`adreça_id`));


-- -----------------------------------------------------
-- Table `Optica`.`Proveidor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Optica`.`Proveidor` (
  `proveidor_id` INT NOT NULL,
  `nom` VARCHAR(16) NOT NULL,
  `telefon` VARCHAR(45) NOT NULL,
  `fax` INT NOT NULL,
  `Adreça_adreça_id` INT NOT NULL,
  PRIMARY KEY (`proveidor_id`),
  INDEX `fk_Proveidor_Adreça1_idx` (`Adreça_adreça_id` ASC) VISIBLE,
  CONSTRAINT `fk_Proveidor_Adreça1`
    FOREIGN KEY (`Adreça_adreça_id`)
    REFERENCES `Optica`.`Adreça` (`adreça_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `Optica`.`marca`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Optica`.`marca` (
  `marca_id` INT NOT NULL,
  `proveidor` INT NOT NULL,
  `nomMarca` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`marca_id`),
  INDEX `proveidor_idx` (`proveidor` ASC) VISIBLE,
  CONSTRAINT `proveidor`
    FOREIGN KEY (`proveidor`)
    REFERENCES `Optica`.`Proveidor` (`proveidor_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `Optica`.`Ulleres`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Optica`.`Ulleres` (
  `ullera_id` INT NOT NULL,
  `marca` INT NOT NULL,
  `adreçaCodiPostal` VARCHAR(255) NOT NULL,
  `graduacioVidre1` INT NOT NULL,
  `graduacioVidre2` INT NOT NULL,
  `tipusMontura` ENUM('FLOTANT', 'DEPASTA', 'METALICA') NOT NULL,
  `colorMontura` VARCHAR(45) NOT NULL,
  `colorVidre1` VARCHAR(45) NOT NULL,
  `colorVidre2` VARCHAR(45) NOT NULL,
  `preu` INT NOT NULL,
  PRIMARY KEY (`ullera_id`),
  INDEX `marca_idx` (`marca` ASC) VISIBLE,
  CONSTRAINT `marca`
    FOREIGN KEY (`marca`)
    REFERENCES `Optica`.`marca` (`marca_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `Optica`.`Clients`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Optica`.`Clients` (
  `client_id` INT NOT NULL,
  `nom` VARCHAR(16) NOT NULL,
  `telefon` INT NOT NULL,
  `correuElectronic` VARCHAR(45) NOT NULL,
  `dataRegistre` DATETIME NOT NULL,
  `Adreça_adreça_id` INT NOT NULL,
  PRIMARY KEY (`client_id`),
  INDEX `fk_Clients_Adreça1_idx` (`Adreça_adreça_id` ASC) VISIBLE,
  CONSTRAINT `fk_Clients_Adreça1`
    FOREIGN KEY (`Adreça_adreça_id`)
    REFERENCES `Optica`.`Adreça` (`adreça_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `Optica`.`Empleat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Optica`.`Empleat` (
  `empleat_id` INT NOT NULL,
  `nomEmpleat` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`empleat_id`));


-- -----------------------------------------------------
-- Table `Optica`.`CompraUllera`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Optica`.`CompraUllera` (
  `compraUllera_id` INT NOT NULL,
  `ullera_id` INT NOT NULL,
  `client_id` INT NOT NULL,
  `empleat_id` INT NOT NULL,
  `quantitat` INT NOT NULL DEFAULT 1,
  `dataCompra` DATETIME NOT NULL,
  INDEX `ullera_id_idx` (`ullera_id` ASC) VISIBLE,
  INDEX `user_id_idx` (`client_id` ASC) VISIBLE,
  INDEX `empleat_id_idx` (`empleat_id` ASC) VISIBLE,
  PRIMARY KEY (`compraUllera_id`),
  CONSTRAINT `ullera_id`
    FOREIGN KEY (`ullera_id`)
    REFERENCES `Optica`.`Ulleres` (`ullera_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `user_id`
    FOREIGN KEY (`client_id`)
    REFERENCES `Optica`.`Clients` (`client_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `empleat_id`
    FOREIGN KEY (`empleat_id`)
    REFERENCES `Optica`.`Empleat` (`empleat_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `Optica`.`ClientRecomanador`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Optica`.`ClientRecomanador` (
  `client_id` INT NOT NULL,
  `clientRecomanador_id` INT NOT NULL,
  INDEX `client_id_idx` (`client_id` ASC) VISIBLE,
  INDEX `clientRecomanat_id_idx` (`clientRecomanador_id` ASC) VISIBLE,
  CONSTRAINT `client_id`
    FOREIGN KEY (`client_id`)
    REFERENCES `Optica`.`Clients` (`client_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `clientRecomanat_id`
    FOREIGN KEY (`clientRecomanador_id`)
    REFERENCES `Optica`.`Clients` (`client_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

INSERT INTO `Adreça` (`adreça_id`, `carrer`, `numero`, `pis`, `porta`, `ciutat`, `codiPostal`, `pais`)
VALUES 
    (1, 'Llagostera', '123', '2', 'A', 'Barcelona', '08001', 'España'),
    (2, 'Valencia', '456', '1', 'B', 'Madrid', '28002', 'España');
    
INSERT INTO `Adreça` (`adreça_id`, `carrer`, `numero`, `pis`, `porta`, `ciutat`, `codiPostal`, `pais`)
VALUES 
    (3, 'Mallorca', '123', '2', 'A', 'Barcelona', '08001', 'España'),
    (4, 'Av Madrid', '456', '1', 'B', 'Madrid', '28002', 'España');

INSERT INTO `Proveidor` (`proveidor_id`, `nom`, `telefon`, `fax`, `Adreça_adreça_id`) 
VALUES 
	(1, 'GafasEU', '123456789', 1234,3),
    (2, 'GafasUS', '985432', 4321,4);

INSERT INTO `marca` (`marca_id`, `proveidor`, `nomMarca`) 
VALUES 
	(1, 1, 'Rayban'),
    (2, 2, 'Hawkers');

INSERT INTO `Ulleres` (`ullera_id`, `marca`, `adreçaCodiPostal`, `graduacioVidre1`, `graduacioVidre2`, `tipusMontura`, `colorMontura`, `colorVidre1`, `colorVidre2`, `preu`) 
VALUES 
	(1, 1, '08001', 2, 3, 'FLOTANT', 'Negro', 'Azul', 'Verde', 100),
    (2, 2, '08026', 3, 2, 'DEPASTA', 'Azul', 'Normal', 'Normal', 99);

INSERT INTO `Clients` (`client_id`, `nom`, `telefon`, `correuElectronic`, `dataRegistre`, `Adreça_adreça_id`) 
VALUES 
	(1, 'Christian', 658383344, 'Christian@mail.com', '2024-01-08 00:00:00', 1),
    (2, 'Bran', 658383344, 'Bran@mail.com', '2024-01-08 00:00:00', 2);

INSERT INTO `Empleat` (`empleat_id`, `nomEmpleat`) 
VALUES 
	(1, 'Claudia'),
    (2, 'Andreu');

INSERT INTO `CompraUllera` (`compraUllera_id`, `ullera_id`, `client_id`, `empleat_id`, `quantitat`,`dataCompra`) 
VALUES 
	(1, 1, 1, 1, 1, '2023-01-08 12:34:56'),
    (2, 2, 2, 2, 1, '2024-01-08 12:34:56');

INSERT INTO `CompraUllera` (`compraUllera_id`, `ullera_id`, `client_id`, `empleat_id`, `quantitat`,`dataCompra`) 
VALUES 
    (3, 2, 2, 2, 1, '2024-01-08 12:34:56');

select COUNT(cu.compraUllera_id) AS total_Facturas, c.nom FROM CompraUllera cu 
JOIN Clients c ON cu.client_id=c.client_id GROUP BY cu.client_id;

select u.ullera_id, u.colorMontura, u.tipusMontura, e.nomEmpleat, cu.dataCompra FROM Ulleres u
JOIN CompraUllera cu ON u.ullera_id=cu.ullera_id
JOIN Empleat e ON cu.empleat_id=e.empleat_id
WHERE YEAR(cu.dataCompra)='2023';

select p.nom AS NOM_PROVEIDOR, COUNT(cu.compraUllera_id) AS Numero_Ventes FROM Proveidor p
JOIN Marca m ON p.proveidor_id=m.proveidor
JOIN Ulleres u ON m.marca_id=u.marca
JOIN CompraUllera cu ON u.ullera_id=cu.ullera_id 
GROUP BY p.proveidor_id;

-- Consulta extra per saber quantes ulleres s'han venut en 2023
select COUNT(cu.compraUllera_id) AS total_Facturas, cu.dataCompra FROM CompraUllera cu 
JOIN empleat e ON cu.empleat_id=e.empleat_id WHERE YEAR(cu.dataCompra)='2023' GROUP BY cu.dataCompra;
