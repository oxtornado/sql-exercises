CREATE DATABASE IF NOT EXISTS `EstudiantesMatriculadosEnCursos` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4  _unicode_ci;

USE `EstudiantesMatriculadosEnCursos`;

CREATE TABLE IF NOT EXISTS `Estudiantes` (
    `idEstudiante` INT NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(45) NOT NULL,
    `apellido` VARCHAR(45) NOT NULL,
    `fechaDeNacimiento` DATE NOT NULL,
    `correoElectronico` VARCHAR(45) NOT NULL,
    `telefono` INT NOT NULL,
    PRIMARY KEY (`id`));

CREATE TABLE IF NOT EXISTS `Cursos` (
    `idCurso` INT NOT NULL AUTO_INCREMENT,
    `nombreDelCurso` VARCHAR(45) NOT NULL,
    `descripcion` VARCHAR(45) NOT NULL,
    `fechaDeInicio` DATE NOT NULL,
    `fechaDeFinalizacion` DATE NOT NULL,
    `creditos` INT NOT NULL,
    PRIMARY KEY (`idCurso`));