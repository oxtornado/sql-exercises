CREATE DATABASE IF NOT EXISTS `EstudiantesMatriculadosEnCursos` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4  _unicode_ci;

USE `EstudiantesMatriculadosEnCursos`;

CREATE TABLE IF NOT EXISTS `Estudiantes` (
    `idEstudiante` INT NOT NULL AUTO_INCREMENT,
    `nombre` VARCHAR(45) NOT NULL,
    `apellido` VARCHAR(45) NOT NULL,
    `fechaDeNacimiento` DATE NOT NULL,
    `correoElectronico` VARCHAR(45) NOT NULL,
    `telefono` INT NOT NULL,
    PRIMARY KEY (`idEstudiante`));

CREATE TABLE IF NOT EXISTS `Cursos` (
    `idCurso` INT NOT NULL AUTO_INCREMENT,
    `nombreDelCurso` VARCHAR(45) NOT NULL,
    `descripcion` VARCHAR(45) NOT NULL,
    `fechaDeInicio` DATE NOT NULL,
    `fechaDeFinalizacion` DATE NOT NULL,
    `creditos` INT NOT NULL,
    `capacidad` INT NOT NULL,
    PRIMARY KEY (`idCurso`));

CREATE TABLE IF NOT EXISTS `Matriculas` (
    `idMatricula` INT NOT NULL AUTO_INCREMENT,
    `idEstudiante` INT NOT NULL,
    `idCurso` INT NOT NULL,
    `fechaDeMatricula` DATE NOT NULL,
    PRIMARY KEY (`idMatricula`),
    FOREIGN KEY (`idEstudiante`) REFERENCES `Estudiantes`(`idEstudiante`),
    FOREIGN KEY (`idCurso`) REFERENCES `Cursos`(`idCurso`));

CREATE TRIGGER `EstudiantesMatriculadosEnCursos`.`before_insert` BEFORE INSERT ON `Matriculas` FOR EACH ROW
BEGIN
    IF EXISTS (SELECT COUNT(*) FROM Matriculas WHERE `idEstudiante` = NEW.`idEstudiante` AND `idCurso` = NEW.`idCurso`) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El estudiante ya está matriculado en el curso';
    END IF;
END;

CREATE TRIGGER `EstudiantesMatriculadosEnCursos`.`before_update` BEFORE INSERT ON `Matriculas` FOR EACH ROW
BEGIN
    IF EXISTS (SELECT COUNT(*) FROM Cursos c JOIN Matriculas m ON c.idCurso = m.idCurso WHERE NEW.idEstudiante > c.capacidad) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'El curso ha excedido la capacidad';
    END IF;
END;