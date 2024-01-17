CREATE SCHEMA IF NOT EXISTS `Youtube` DEFAULT CHARACTER SET utf8 ;
USE `Youtube` ;

-- -----------------------------------------------------
-- Table `Youtube`.`Usuari`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Youtube`.`Usuari` (
  `usuari_id` INT NOT NULL AUTO_INCREMENT,
  `email` VARCHAR(255) NULL,
  `password` VARCHAR(32) NOT NULL,
  `nomUsuari` VARCHAR(45) NOT NULL,
  `dataNaixement` DATE NOT NULL,
  `sexe` VARCHAR(45) NOT NULL,
  `pais` VARCHAR(45) NOT NULL,
  `codiPostal` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`usuari_id`));


-- -----------------------------------------------------
-- Table `Youtube`.`Video`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Youtube`.`Video` (
  `video_id` INT NOT NULL AUTO_INCREMENT,
  `titol` VARCHAR(255) NOT NULL,
  `descripcio` VARCHAR(32) NULL,
  `grandaria` VARCHAR(45) NULL,
  `nomArxiu` VARCHAR(45) NOT NULL,
  `duaradaVideo` VARCHAR(45) NOT NULL,
  `thumbnail` VARCHAR(45) NULL,
  `numRepro` INT NOT NULL,
  `numLikes` INT NOT NULL,
  `numDislikes` INT NOT NULL,
  `tipus` ENUM('PUBLIC', 'OCULT', 'PRIVAT') NULL,
  `dataPublicacio` DATETIME NOT NULL,
  `Usuari_usuari_id` INT NOT NULL,
  PRIMARY KEY (`video_id`),
  INDEX `fk_Video_Usuari_idx` (`Usuari_usuari_id` ASC) VISIBLE,
  CONSTRAINT `fk_Video_Usuari`
    FOREIGN KEY (`Usuari_usuari_id`)
    REFERENCES `Youtube`.`Usuari` (`usuari_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `Youtube`.`Etiqueta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Youtube`.`Etiqueta` (
  `etiqueta_id` INT NOT NULL AUTO_INCREMENT,
  `nomEtiqueta` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`etiqueta_id`));


-- -----------------------------------------------------
-- Table `Youtube`.`Canal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Youtube`.`Canal` (
  `canal_id` INT NOT NULL AUTO_INCREMENT,
  `nomCanal` VARCHAR(255) NOT NULL,
  `descripcioCanal` VARCHAR(32) NULL,
  `dataCreacio` DATETIME NOT NULL,
  `Usuari_usuari_id` INT NOT NULL,
  PRIMARY KEY (`canal_id`),
  INDEX `fk_Canal_Usuari1_idx` (`Usuari_usuari_id` ASC) VISIBLE,
  CONSTRAINT `fk_Canal_Usuari1`
    FOREIGN KEY (`Usuari_usuari_id`)
    REFERENCES `Youtube`.`Usuari` (`usuari_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `Youtube`.`subscripcioCanal`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Youtube`.`subscripcioCanal` (
  `Usuari_usuari_id` INT NOT NULL,
  `Canal_canal_id` INT NOT NULL,
  INDEX `fk_user_Usuari1_idx` (`Usuari_usuari_id` ASC) VISIBLE,
  INDEX `fk_user_Canal1_idx` (`Canal_canal_id` ASC) VISIBLE,
  CONSTRAINT `fk_user_Usuari1`
    FOREIGN KEY (`Usuari_usuari_id`)
    REFERENCES `Youtube`.`Usuari` (`usuari_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_Canal1`
    FOREIGN KEY (`Canal_canal_id`)
    REFERENCES `Youtube`.`Canal` (`canal_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `Youtube`.`Playlist`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Youtube`.`Playlist` (
  `playlist_id` INT NOT NULL AUTO_INCREMENT,
  `nom` VARCHAR(255) NOT NULL,
  `dataCreacio` DATETIME NOT NULL,
  `estat` ENUM('PUBLICA', 'PRIVADA') NOT NULL,
  `Usuari_usuari_id` INT NOT NULL,
  PRIMARY KEY (`playlist_id`),
  INDEX `fk_Playlist_Usuari1_idx` (`Usuari_usuari_id` ASC) VISIBLE,
  CONSTRAINT `fk_Playlist_Usuari1`
    FOREIGN KEY (`Usuari_usuari_id`)
    REFERENCES `Youtube`.`Usuari` (`usuari_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `Youtube`.`Comentari`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Youtube`.`Comentari` (
  `comentari_id` INT NOT NULL AUTO_INCREMENT,
  `textComentari` VARCHAR(255) NULL,
  `dataComentari` DATETIME NOT NULL,
  `Video_video_id` INT NOT NULL,
  `Usuari_usuari_id` INT NOT NULL,
  PRIMARY KEY (`comentari_id`),
  INDEX `fk_UsuariComentaris_Video1_idx` (`Video_video_id` ASC) VISIBLE,
  CONSTRAINT `fk_UsuariComentaris_Video1`
    FOREIGN KEY (`Video_video_id`)
    REFERENCES `Youtube`.`Video` (`video_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `Youtube`.`UsuariValoraComentari`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Youtube`.`UsuariValoraComentari` (
  `tipus` ENUM('LIKE', 'DISLIKE') NOT NULL,
  `dataValoracio` DATETIME NULL DEFAULT CURRENT_TIMESTAMP,
  `Usuari_usuari_id` INT NOT NULL,
  `Comentari_comentari_id` INT NOT NULL,
  INDEX `fk_UsuariValoraComentari_Usuari1_idx` (`Usuari_usuari_id` ASC) VISIBLE,
  INDEX `fk_UsuariValoraComentari_Comentari1_idx` (`Comentari_comentari_id` ASC) VISIBLE,
  CONSTRAINT `fk_UsuariValoraComentari_Usuari1`
    FOREIGN KEY (`Usuari_usuari_id`)
    REFERENCES `Youtube`.`Usuari` (`usuari_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_UsuariValoraComentari_Comentari1`
    FOREIGN KEY (`Comentari_comentari_id`)
    REFERENCES `Youtube`.`Comentari` (`comentari_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `Youtube`.`Playlist_has_Video`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Youtube`.`Playlist_has_Video` (
  `Playlist_playlist_id` INT NOT NULL,
  `Video_video_id` INT NOT NULL,
  PRIMARY KEY (`Playlist_playlist_id`, `Video_video_id`),
  INDEX `fk_Playlist_has_Video_Video1_idx` (`Video_video_id` ASC) VISIBLE,
  INDEX `fk_Playlist_has_Video_Playlist1_idx` (`Playlist_playlist_id` ASC) VISIBLE,
  CONSTRAINT `fk_Playlist_has_Video_Playlist1`
    FOREIGN KEY (`Playlist_playlist_id`)
    REFERENCES `Youtube`.`Playlist` (`playlist_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Playlist_has_Video_Video1`
    FOREIGN KEY (`Video_video_id`)
    REFERENCES `Youtube`.`Video` (`video_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `Youtube`.`Usuari_Valora_Video`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Youtube`.`Usuari_Valora_Video` (
  `Usuari_usuari_id` INT NOT NULL,
  `Video_video_id` INT NOT NULL,
  `tipus` ENUM('LIKE', 'DISLIKE') NOT NULL,
  `dataValoracio` DATETIME NOT NULL,
  PRIMARY KEY (`Usuari_usuari_id`, `Video_video_id`),
  INDEX `fk_Usuari_has_Video_Video1_idx` (`Video_video_id` ASC) VISIBLE,
  INDEX `fk_Usuari_has_Video_Usuari1_idx` (`Usuari_usuari_id` ASC) VISIBLE,
  CONSTRAINT `fk_Usuari_has_Video_Usuari1`
    FOREIGN KEY (`Usuari_usuari_id`)
    REFERENCES `Youtube`.`Usuari` (`usuari_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Usuari_has_Video_Video1`
    FOREIGN KEY (`Video_video_id`)
    REFERENCES `Youtube`.`Video` (`video_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `Youtube`.`Video_has_Etiqueta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Youtube`.`Video_has_Etiqueta` (
  `Video_video_id` INT NOT NULL,
  `Etiqueta_etiqueta_id` INT NOT NULL,
  PRIMARY KEY (`Video_video_id`, `Etiqueta_etiqueta_id`),
  INDEX `fk_Video_has_Etiqueta_Etiqueta1_idx` (`Etiqueta_etiqueta_id` ASC) VISIBLE,
  INDEX `fk_Video_has_Etiqueta_Video1_idx` (`Video_video_id` ASC) VISIBLE,
  CONSTRAINT `fk_Video_has_Etiqueta_Video1`
    FOREIGN KEY (`Video_video_id`)
    REFERENCES `Youtube`.`Video` (`video_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Video_has_Etiqueta_Etiqueta1`
    FOREIGN KEY (`Etiqueta_etiqueta_id`)
    REFERENCES `Youtube`.`Etiqueta` (`etiqueta_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
INSERT INTO `Usuari` (`email`, `password`, `nomUsuari`, `dataNaixement`, `sexe`, `pais`, `codiPostal`) 
VALUES 
    ('Christian@mail.com', 'password1', 'Christian03', '1990-01-01', 'Masculino', 'España', '08001'),
    ('Claudia@mail.com', 'password2', 'Claudia11', '1985-05-15', 'Femenino', 'España', '08026');

INSERT INTO `Video` (`titol`, `descripcio`, `grandaria`, `nomArxiu`, `duaradaVideo`, `thumbnail`, `numRepro`, `numLikes`, `numDislikes`, `tipus`, `dataPublicacio`, `Usuari_usuari_id`) 
VALUES 
    ('Nacimiento Christian', 'Videos del nacimiento', '720p', 'nacimientoChris.mp4', '00:10:30', 'thumbnail1.jpg', 1000, 500, 20, 'PUBLIC', '2024-01-09 12:00:00', 1),
    ('Cumple CLaudia', 'Videos del cumple', '1080p', 'umpleCla.mp4', '00:15:45', 'thumbnail2.jpg', 800, 300, 10, 'PRIVAT', '2024-01-09 12:30:00', 2);

INSERT INTO `Etiqueta` (`nomEtiqueta`) 
VALUES 
    ('Entretenimiento'),
    ('Familiar'),
    ('Música');

INSERT INTO `Canal` (`nomCanal`, `descripcioCanal`, `dataCreacio`, `Usuari_usuari_id`) 
VALUES 
    ('Christian Amor', 'Descripción1', '2024-01-08 11:00:00', 1),
    ('Claudia Pernazza', 'Descripción2', '2024-01-08 10:30:00', 2);

INSERT INTO `subscripcioCanal` (`Usuari_usuari_id`, `Canal_canal_id`) 
VALUES 
    (1, 2),
    (2, 1);

INSERT INTO `Playlist` (`nom`, `dataCreacio`, `estat`, `Usuari_usuari_id`) 
VALUES 
    ('Playlist Christian', '2024-01-09 14:00:00', 'PUBLICA', 1),
    ('Playlist Claudia', '2024-01-09 14:30:00', 'PRIVADA', 2);

INSERT INTO `Comentari` (`textComentari`, `dataComentari`, `Video_video_id`, `Usuari_usuari_id`) 
VALUES 
    ('Comentario1 en video Christian', '2024-01-09 15:00:00', 1, 1),
    ('Comentario1 en videos Claudia', '2024-01-09 15:30:00', 2, 2);

INSERT INTO `UsuariValoraComentari` (`tipus`, `dataValoracio`, `Usuari_usuari_id`, `Comentari_comentari_id`) 
VALUES 
    ('LIKE', '2024-01-09 16:00:00', 1, 2),
    ('DISLIKE', '2024-01-09 16:30:00', 2, 1);

INSERT INTO `Playlist_has_Video` (`Playlist_playlist_id`, `Video_video_id`) 
VALUES 
    (1, 1),
    (2, 2);

INSERT INTO `Usuari_Valora_Video` (`Usuari_usuari_id`, `Video_video_id`, `tipus`, `dataValoracio`) 
VALUES 
	(1, 1, 'LIKE', '2024-01-09 17:00:00'),
	(1, 2, 'LIKE', '2024-01-09 18:00:00'),
    (2, 2, 'DISLIKE', '2024-01-09 17:30:00');
    

INSERT INTO `Video_has_Etiqueta` (`Video_video_id`, `Etiqueta_etiqueta_id`) 
VALUES 
    (1, 1),
    (1, 2),
    (2, 1),
    (2, 2);
    
SELECT v.titol AS TITULO, u.nomUsuari FROM Video v 
JOIN Usuari u ON v.Usuari_usuari_id=u.usuari_id;

SELECT COUNT(v.video_id) AS NUMERO_DE_VIDEOS, u.nomUsuari FROM Video v
JOIN Usuari u ON v.Usuari_usuari_id=u.usuari_id GROUP BY u.usuari_id;

SELECT COUNT(p.playlist_id) AS NUM_DE_PLAYLISTS, u.nomUsuari FROM Playlist p
JOIN Usuari u ON p.Usuari_usuari_id=u.usuari_id GROUP BY u.usuari_id;

SELECT uv.tipus, u.nomUsuari, v.titol FROM Usuari_Valora_Video uv 
JOIN Usuari u ON uv.Usuari_usuari_id=u.usuari_id
JOIN Video v ON uv.Video_video_id=v.video_id GROUP BY uv.Usuari_usuari_id, v.video_id;

SELECT v.titol, e.nomEtiqueta FROM video v 
JOIN video_has_etiqueta vhe ON v.video_id=vhe.Video_video_id
JOIN etiqueta e ON vhe.Etiqueta_etiqueta_id=e.etiqueta_id
GROUP BY v.video_id, e.etiqueta_id;