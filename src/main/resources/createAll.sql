DROP SCHEMA IF EXISTS a_cara_de_perro_aterrizar;
CREATE SCHEMA a_cara_de_perro_aterrizar;

USE a_cara_de_perro_aterrizar;

CREATE TABLE user (
 firstName VARCHAR(255) NOT NULL,
 lastName VARCHAR(255) NOT NULL,
 userName VARCHAR(255) NOT NULL PRIMARY KEY,
 pasword VARCHAR(255) NOT NULL,
 mail VARCHAR(255) NOT NULL UNIQUE,
 birthDate MEDIUMTEXT NOT NULL,
 validate BOOLEAN NOT NULL
)
ENGINE = InnoDB;
