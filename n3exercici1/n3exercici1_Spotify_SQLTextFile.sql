CREATE SCHEMA IF NOT EXISTS `Spotify` DEFAULT CHARACTER SET utf8 ;
USE `Spotify` ;

-- -----------------------------------------------------
-- Table `Spotify`.`Usuari`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Spotify`.`Usuari` (
  `usuari_id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(255) NULL,
  `password` VARCHAR(32) NOT NULL,
  `nomUsuari` VARCHAR(45) NOT NULL,
  `dataNaixement` DATETIME NOT NULL,
  `sexe` VARCHAR(45) NOT NULL,
  `pais` VARCHAR(45) NOT NULL,
  `codiPostal` VARCHAR(45) NOT NULL,
  `tipus` ENUM('FREE', 'PREMIUM') NOT NULL,
  PRIMARY KEY (`usuari_id`));


-- -----------------------------------------------------
-- Table `Spotify`.`TargetesCredit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Spotify`.`TargetesCredit` (
  `targetaCredit_id` INT NOT NULL AUTO_INCREMENT,
  `numTargeta` VARCHAR(16) NOT NULL,
  `anyCaducitat` YEAR NOT NULL,
  `codiSeguretat` VARCHAR(32) NOT NULL,
  PRIMARY KEY (`targetaCredit_id`));


-- -----------------------------------------------------
-- Table `Spotify`.`Paypal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Spotify`.`Paypal` (
  `paypal_id` INT NOT NULL AUTO_INCREMENT,
  `nomUsuari` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`paypal_id`));


-- -----------------------------------------------------
-- Table `Spotify`.`Pagament`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Spotify`.`Pagament` (
  `pagament_id` INT NOT NULL AUTO_INCREMENT,
  `dataPagament` DATETIME NOT NULL,
  `numOrdre` INT NOT NULL,
  `total` INT NULL,
  `tipus` ENUM('PAYPAL', 'TARGETA') NOT NULL,
  `TargetesCredit_targetaCredit_id` INT NOT NULL,
  `Paypal_paypal_id` INT NOT NULL,
  PRIMARY KEY (`pagament_id`),
  UNIQUE INDEX `numOrdre_UNIQUE` (`numOrdre` ASC) VISIBLE,
  INDEX `fk_Pagament_TargetesCredit1_idx` (`TargetesCredit_targetaCredit_id` ASC) VISIBLE,
  INDEX `fk_Pagament_Paypal1_idx` (`Paypal_paypal_id` ASC) VISIBLE,
  CONSTRAINT `fk_Pagament_TargetesCredit1`
    FOREIGN KEY (`TargetesCredit_targetaCredit_id`)
    REFERENCES `Spotify`.`TargetesCredit` (`targetaCredit_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Pagament_Paypal1`
    FOREIGN KEY (`Paypal_paypal_id`)
    REFERENCES `Spotify`.`Paypal` (`paypal_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `Spotify`.`Subscripcio`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Spotify`.`Subscripcio` (
  `subscripcio_id` INT NOT NULL AUTO_INCREMENT,
  `dataInici` DATETIME NOT NULL,
  `dataRenovacio` DATETIME NOT NULL,
  `formaPagament` ENUM('CREDIT', 'PAYPAL') NOT NULL,
  `Usuari_usuari_id` INT NOT NULL,
  `Pagament_pagament_id` INT NOT NULL,
  PRIMARY KEY (`subscripcio_id`),
  INDEX `fk_Subscripcio_Usuari_idx` (`Usuari_usuari_id` ASC) VISIBLE,
  INDEX `fk_Subscripcio_Pagament1_idx` (`Pagament_pagament_id` ASC) VISIBLE,
  CONSTRAINT `fk_Subscripcio_Usuari`
    FOREIGN KEY (`Usuari_usuari_id`)
    REFERENCES `Spotify`.`Usuari` (`usuari_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Subscripcio_Pagament1`
    FOREIGN KEY (`Pagament_pagament_id`)
    REFERENCES `Spotify`.`Pagament` (`pagament_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `Spotify`.`Playlist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Spotify`.`Playlist` (
  `playlist_id` INT NOT NULL AUTO_INCREMENT,
  `titol` VARCHAR(255) NOT NULL,
  `numCançons` INT NOT NULL,
  `dataCreacio` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `estatPlaylist` ENUM('ELIMINADA', 'ACTIVA') NOT NULL,
  `dataEliminacio` DATETIME NOT NULL,
  `Usuari_usuari_id` INT NOT NULL,
  PRIMARY KEY (`playlist_id`),
  INDEX `fk_Palylist_Usuari1_idx` (`Usuari_usuari_id` ASC) VISIBLE,
  CONSTRAINT `fk_Palylist_Usuari1`
    FOREIGN KEY (`Usuari_usuari_id`)
    REFERENCES `Spotify`.`Usuari` (`usuari_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `Spotify`.`Artista`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Spotify`.`Artista` (
  `artista_id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(255) NOT NULL,
  `imatgeArtista` VARCHAR(32) NOT NULL,
  PRIMARY KEY (`artista_id`));


-- -----------------------------------------------------
-- Table `Spotify`.`Album`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Spotify`.`Album` (
  `album_id` INT NOT NULL AUTO_INCREMENT,
  `titol` VARCHAR(255) NULL,
  `anyPublicacio` YEAR NOT NULL,
  `imatgePortada` VARCHAR(45) NULL,
  `Artista_artista_id` INT NOT NULL,
  PRIMARY KEY (`album_id`),
  INDEX `fk_Album_Artista1_idx` (`Artista_artista_id` ASC) VISIBLE,
  CONSTRAINT `fk_Album_Artista1`
    FOREIGN KEY (`Artista_artista_id`)
    REFERENCES `Spotify`.`Artista` (`artista_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `Spotify`.`Cançons`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Spotify`.`Cançons` (
  `canço_id` INT NOT NULL AUTO_INCREMENT,
  `titol` VARCHAR(255) NOT NULL,
  `durada` VARCHAR(32) NOT NULL,
  `numReproduccions` INT NOT NULL,
  `Album_album_id` INT NOT NULL,
  PRIMARY KEY (`canço_id`),
  INDEX `fk_Cançons_Album1_idx` (`Album_album_id` ASC) VISIBLE,
  CONSTRAINT `fk_Cançons_Album1`
    FOREIGN KEY (`Album_album_id`)
    REFERENCES `Spotify`.`Album` (`album_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `Spotify`.`PlaylistCompartida`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Spotify`.`PlaylistCompartida` (
  `Usuari_usuari_id` INT NOT NULL,
  `Playlist_playlist_id` INT NOT NULL,
  `Cançons_canço_id` INT NOT NULL,
  `dataIntroduccio` DATETIME NOT NULL,
  PRIMARY KEY (`Usuari_usuari_id`, `Playlist_playlist_id`, `Cançons_canço_id`),
  INDEX `fk_Usuari_has_Playlist_Playlist1_idx` (`Playlist_playlist_id` ASC) VISIBLE,
  INDEX `fk_Usuari_has_Playlist_Usuari1_idx` (`Usuari_usuari_id` ASC) VISIBLE,
  INDEX `fk_Usuari_has_Playlist_Cançons1_idx` (`Cançons_canço_id` ASC) VISIBLE,
  CONSTRAINT `fk_Usuari_has_Playlist_Usuari1`
    FOREIGN KEY (`Usuari_usuari_id`)
    REFERENCES `Spotify`.`Usuari` (`usuari_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Usuari_has_Playlist_Playlist1`
    FOREIGN KEY (`Playlist_playlist_id`)
    REFERENCES `Spotify`.`Playlist` (`playlist_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Usuari_has_Playlist_Cançons1`
    FOREIGN KEY (`Cançons_canço_id`)
    REFERENCES `Spotify`.`Cançons` (`canço_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `Spotify`.`Favorit`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Spotify`.`Favorit` (
  `Cançons_canço_id` INT NOT NULL,
  `Usuari_usuari_id` INT NOT NULL,
  `Album_album_id` INT NOT NULL,
  PRIMARY KEY (`Cançons_canço_id`, `Usuari_usuari_id`, `Album_album_id`),
  INDEX `fk_Cançons_has_Usuari_Usuari1_idx` (`Usuari_usuari_id` ASC) VISIBLE,
  INDEX `fk_Cançons_has_Usuari_Cançons1_idx` (`Cançons_canço_id` ASC) VISIBLE,
  INDEX `fk_Cançons_has_Usuari_Album1_idx` (`Album_album_id` ASC) VISIBLE,
  CONSTRAINT `fk_Cançons_has_Usuari_Cançons1`
    FOREIGN KEY (`Cançons_canço_id`)
    REFERENCES `Spotify`.`Cançons` (`canço_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Cançons_has_Usuari_Usuari1`
    FOREIGN KEY (`Usuari_usuari_id`)
    REFERENCES `Spotify`.`Usuari` (`usuari_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Cançons_has_Usuari_Album1`
    FOREIGN KEY (`Album_album_id`)
    REFERENCES `Spotify`.`Album` (`album_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `Spotify`.`UsuariSegueixArtista`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Spotify`.`UsuariSegueixArtista` (
  `Usuari_usuari_id` INT NOT NULL,
  `Artista_artista_id` INT NOT NULL,
  PRIMARY KEY (`Usuari_usuari_id`, `Artista_artista_id`),
  INDEX `fk_Usuari_has_Artista_Artista1_idx` (`Artista_artista_id` ASC) VISIBLE,
  INDEX `fk_Usuari_has_Artista_Usuari1_idx` (`Usuari_usuari_id` ASC) VISIBLE,
  CONSTRAINT `fk_Usuari_has_Artista_Usuari1`
    FOREIGN KEY (`Usuari_usuari_id`)
    REFERENCES `Spotify`.`Usuari` (`usuari_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Usuari_has_Artista_Artista1`
    FOREIGN KEY (`Artista_artista_id`)
    REFERENCES `Spotify`.`Artista` (`artista_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `Spotify`.`ArtistaRelacionat`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Spotify`.`ArtistaRelacionat` (
  `Artista_artista_id` INT NOT NULL,
  `Artista_artista_id1` INT NOT NULL,
  PRIMARY KEY (`Artista_artista_id`, `Artista_artista_id1`),
  INDEX `fk_Artista_has_Artista_Artista2_idx` (`Artista_artista_id1` ASC) VISIBLE,
  INDEX `fk_Artista_has_Artista_Artista1_idx` (`Artista_artista_id` ASC) VISIBLE,
  CONSTRAINT `fk_Artista_has_Artista_Artista1`
    FOREIGN KEY (`Artista_artista_id`)
    REFERENCES `Spotify`.`Artista` (`artista_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Artista_has_Artista_Artista2`
    FOREIGN KEY (`Artista_artista_id1`)
    REFERENCES `Spotify`.`Artista` (`artista_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

INSERT INTO `Usuari` (`email`, `password`, `nomUsuari`, `dataNaixement`, `sexe`, `pais`, `codiPostal`, `tipus`) 
VALUES 
	('Christian@example.com', '12345', 'Christian03', '1998-01-09 12:00:00', 'Masculino', 'España', '12345', 'PREMIUM');

INSERT INTO `Usuari` (`email`, `password`, `nomUsuari`, `dataNaixement`, `sexe`, `pais`, `codiPostal`, `tipus`) 
VALUES 
	('Claudia@example.com', '56789', 'Claudia11', '199-08-11 12:00:00', 'Femenino', 'España', '08046', 'FREE');

INSERT INTO `TargetesCredit` (`numTargeta`, `anyCaducitat`, `codiSeguretat`) 
VALUES 
	('1234567890123456', 2027, '123');

INSERT INTO `Paypal` (`nomUsuari`) 
VALUES 
	('ChristianA3');

INSERT INTO `Pagament` (`dataPagament`, `numOrdre`, `total`, `tipus`, `TargetesCredit_targetaCredit_id`, `Paypal_paypal_id`) 
VALUES 
	('2024-01-09 12:00:00', 1, 10, 'TARGETA', 1, 1);
    

INSERT INTO `Subscripcio` (`dataInici`, `dataRenovacio`, `formaPagament`, `Usuari_usuari_id`, `Pagament_pagament_id`) 
VALUES 
	('2024-01-09 12:00:00', '2025-01-09 12:00:00', 'CREDIT', 1, 2);

INSERT INTO `Playlist` (`titol`, `numCançons`, `estatPlaylist`, `dataEliminacio`, `Usuari_usuari_id`) 
VALUES 
	('MiPlaylist', 5, 'ACTIVA', '2024-01-09 12:00:00', 1);

INSERT INTO `Artista` (`nom`, `imatgeArtista`) 
VALUES 
	('Joan Dausa', 'imagen.jpg'),
    ('Alfred Garcia', 'imagen.jpg');

INSERT INTO `Album` (`titol`, `anyPublicacio`, `imatgePortada`, `Artista_artista_id`) 
VALUES 
    ('Ho Tenim Tot', 2022, 'portada.jpg', 1),
	('Vull Veuret Riure', 2023, 'portada.jpg', 2);

INSERT INTO `Cançons` (`titol`, `durada`, `numReproduccions`, `Album_album_id`) 
VALUES 
	   ('Ho tenim tot', '03:30', 100, 1),
       ('Vull veuret riure', '04:15', 150, 2),
       ('Nunca es tarde', '03:50', 120, 1),
       ('Lo que dejan las luces', '05:00', 200, 2);
       
INSERT INTO `Favorit` (`Cançons_canço_id`, `Usuari_usuari_id`, `Album_album_id`) 
VALUES 
	   (1, 1, 1),
       (2, 1, 1),
       (3, 1, 2),
       (4, 1, 2);
       
INSERT INTO `PlaylistCompartida` (`Usuari_usuari_id`, `Playlist_playlist_id`, `Cançons_canço_id`, `dataIntroduccio`) 
VALUES 
    (1, 1, 1, '2024-01-09 13:00:00'),
    (1, 1, 2, '2024-01-09 13:01:00');

SELECT * FROM usuari u LEFT JOIN playlist p ON u.usuari_id=p.Usuari_usuari_id;

SELECT * FROM usuari u LEFT JOIN subscripcio s ON u.usuari_id=s.Usuari_usuari_id LEFT JOIN pagament p ON s.Pagament_pagament_id=p.pagament_id;

SELECT * FROM subscripcio s LEFT JOIN usuari u ON s.Usuari_usuari_id=u.usuari_id;

SELECT a.titol as TITOL_ALBUM, c.titol AS TITOL_CANÇO FROM Album a
JOIN Cançons c ON a.album_id=c.Album_album_id GROUP BY c.titol, a.titol;

SELECT s.*, u.nomUsuari FROM subscripcio s LEFT JOIN Usuari u
ON s.Usuari_usuari_id=u.usuari_id;

SELECT tc.numTargeta, p.numOrdre, s.subscripcio_id, u.nomUsuari FROM targetescredit tc
JOIN pagament p ON tc.targetacredit_id=p.Targetescredit_targetacredit_id
JOIN subscripcio s ON p.pagament_id=s.Pagament_pagament_id
JOIN usuari u ON s.Usuari_usuari_id=u.usuari_id;

SELECT ar.nom AS NOM_ARTISTA, a.titol as TITOL_ALBUM FROM Album a
JOIN artista ar ON a.Artista_artista_id=ar.artista_id
GROUP BY a.titol, ar.artista_id;


