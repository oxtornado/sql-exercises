CREATE DATABASE IF NOT EXISTS 'alquilerDeVehiculos';

USE DATABASE 'alquilerDeVehiculos';

CREATE TABLE IF NOT EXISTS 'marca' (
    'idMarca' INT AUTO_INCREMENT,
    'nombreMarcaVehiculo' VARCHAR(50),
    PRIMARY KEY ('idMarca')
);

CREATE TABLE IF NOT EXISTS 'estado' (
    'idEstado' INT AUTO_INCREMENT,
    'descripcionDelEstado' VARCHAR(50),
    PRIMARY KEY ('idEstado')
);

CREATE TABLE IF NOT EXISTS 'tipo' (
    'idTipo' INT AUTO_INCREMENT,
    'descripcionCortaTipo' VARCHAR(50),
    'descripcionAmpliaTipo' VARCHAR(100),
    'precioActualDeAlquilerTipo' DECIMAL(10, 2),
    PRIMARY KEY ('idTipo')
);

CREATE TABLE IF NOT EXISTS 'vehiculos'(
    'idVehiculo' INT AUTO_INCREMENT,
    'placaDeVehiculo' INT,
    'idMarca' INT,
    'idTipo' INT,
    'idEstado' INT,
    FOREIGN KEY ('idMarca') REFERENCES 'marca' ('idMarca'),
    FOREIGN KEY ('idTipo') REFERENCES 'tipo' ('idTipo'),
    FOREIGN KEY ('idEstado') REFERENCES 'estado' ('idEstado'),
    PRIMARY KEY ('idVehiculo')
);

CREATE TABLE IF NOT EXISTS 'cliente'(
    'idCliente' INT AUTO_INCREMENT,
    'nombreDelCliente' VARCHAR(50),
    'apellidoDelCliente' VARCHAR(50),
    'emailDelCliente' VARCHAR(100) NOT NULL,
    'telefonoDelCliente' INT NOT NULL,
    PRIMARY KEY ('idCliente')
);

CREATE TABLE IF NOT EXISTS 'empleado'(
    'idEmpleado' INT AUTO_INCREMENT,
    'nombreDelEmpleado' VARCHAR(50),
    'cargoDelEmpleado' VARCHAR(50),
    'salario' INT,
    PRIMARY KEY ('idEmpleado')
);

CREATE TABLE IF NOT EXISTS 'alquiler' (
    'idAlquiler' INT AUTO_INCREMENT,
    'idVehiculo' INT,
    'idCliente' INT,
    'idEmpleado' INT UNIQUE, -- de esta manera cada alquieler esta asociado a un empleado
    'fechaDeInicio' DATE,
    'tarifaAPlicada' DECIMAL(10, 2),
    'fechaDeFin' DATE,
    'precio' DECIMAL(10, 2),
    PRIMARY KEY ('idAlquiler'),
    FOREIGN KEY ('idVehiculo') REFERENCES 'vehiculos' ('idVehiculo'),
    FOREIGN KEY ('idCliente') REFERENCES 'cliente' ('idCliente'),
    FOREIGN KEY ('idEmpleado') REFERENCES 'empleado' ('idEmpleado') 
);

CREATE TABLE IF NOT EXISTS 'metodos' (
    'idMetodo' INT AUTO_INCREMENT,
    'tipoDeMetodo' VARCHAR(100),
    'descripcionDelMetodo' VARCHAR(150),
    PRIMARY KEY ('idMetodo')
);

CREATE TABLE IF NOT EXISTS 'pago' (
    'idPago' INT AUTO_INCREMENT,
    'idAlquiler' INT,
    'idMetodo' INT NOT NULL,
    'fechaDePago' DATE,
    'monto' DECIMAL(10, 2),
    PRIMARY KEY ('idPago'),
    FOREIGN KEY ('idAlquiler') REFERENCES 'alquiler' ('idAlquiler') ON UPDATE CASCADE,
    FOREIGN KEY ('idMetodo') REFERENCES 'metodos' ('idMetodo')
);

DELIMITER $$

    CREATE TRIGGER 'antesDeIngresarAlquiler'
    BEFORE INSERT ON 'alquiler'
    FOR EACH ROW
    BEGIN
    
    -- verificar si el vehiculo esta disponible
    IF (SELECT COUNT(*) FROM alquiler WHERE idVehiculo = NEW.idVehiculo)
    THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'El vehiculo ya esta alquilado';
    END IF;
    
    IF NEW.ID_Vendedora IS NULL THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'La factura debe tener una vendedora';
    END IF;

    --verificar que el email y numero de telefono no sean nulos
    IF (SELECT NEW.emailDelCliente AND NEW.telefonoDelCliente  
    FROM cliente 
    WHERE NEW.idCliente IS NULL AND NEW.idCliente IS NULL)
    THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'El email o el telefono no pueden ser nulos';
    END

    CREATE TRIGGER updateDelAlquiler
    AFTER UPDATE ON alquiler
    FOR EACH ROW
    BEGIN
        -- update the monto in pagos to match the precio in alquiler
        UPDATE pago
        SET monto = NEW.precio
        WHERE idAlquiler = NEW.idAlquiler;
    END

$$ DELIMITER























/*
1. before insert into alquiler
2. email and phone number must not be null
3. calculate the total price of the rental based on 
    tipos:
    - 1: 1000
    - 2: 1500
    - 3: 2000
from this we can make that an alert or a sql message appears and says something like 'su vehhiculo es de tipo (equis) y la tarifa del alquiler es de (equis * dias de alquiler)' 
4. start and ending dates must be not null
5. 
*/