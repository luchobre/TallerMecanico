--Base de datos de un taller mecanico
CREATE DATABASE TallerMecanicoUTNFRGP;
GO

USE TallerMecanicoUTNFRGP;
GO

-- Tabla Cliente

CREATE TABLE Cliente (
    IDCliente INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Apellido VARCHAR(50) NOT NULL,
    Telefono VARCHAR(20) UNIQUE,
    Email VARCHAR(100) UNIQUE,
    Direccion VARCHAR(100) NOT NULL
);
GO

--Tabla Marca

CREATE TABLE Marca (
    IDMarca INT IDENTITY(1,1) PRIMARY KEY,
    NombreDeMarca VARCHAR(20) UNIQUE NOT NULL
);
GO

--Tabla Modelo

CREATE TABLE Modelo (
    IDModelo INT IDENTITY(1,1) PRIMARY KEY,
    IDMarca INT NOT NULL,
    NombreModelo VARCHAR(50) NOT NULL
    FOREIGN KEY (IDMarca) REFERENCES Marca (IDMarca)
);
GO

--Tabla Combustible

CREATE TABLE Combustible (
    IDCombustible INT IDENTITY(1,1) PRIMARY KEY,
    TipoDeCombustible VARCHAR(20) UNIQUE NOT NULL
);
GO

--Tasbla Vehiculo

CREATE TABLE Vehiculo (
    IDVehiculo INT IDENTITY(1,1) PRIMARY KEY,
    IDCliente INT NOT NULL,
    IDModelo INT NOT NULL,
    Patente VARCHAR(15) UNIQUE NOT NULL,
    Anio  SMALLINT CHECK(Anio>=1900),
    IDCombustible INT NOT NULL,
    FOREIGN KEY (IDCliente) REFERENCES Cliente(IDCliente),
    FOREIGN KEY (IDCombustible) REFERENCES Combustible (IDCombustible),
    FOREIGN KEY (IDModelo) REFERENCES Modelo (IDModelo)
);
GO

--Tabla Especialidad Del Mecanico

CREATE TABLE Especialidad (
    IDEspecialidad INT PRIMARY KEY IDENTITY(1,1),
    NombreDeEspecialidad VARCHAR(50) NOT NULL UNIQUE
);
GO

--Tabla Mecanico

CREATE TABLE Mecanico (
    IDMecanico INT IDENTITY(1,1) PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    IDEspecialidad INT NOT NULL,
    Telefono VARCHAR(20),
    Email VARCHAR(100)
    FOREIGN KEY(IDEspecialidad) REFERENCES Especialidad (IDEspecialidad)
);
GO


--Tabla Servicio

CREATE TABLE Servicio (
    IDServicio INT PRIMARY KEY IDENTITY(1,1),
    Descripcion VARCHAR(100) NOT NULL,
    Costo DECIMAL(10,2) NOT NULL,
    DuracionEstimada INT -- en minutos
);
GO


--Tabla Repuestos

CREATE TABLE Repuesto (
    IDRepuesto INT IDENTITY(1,1) PRIMARY KEY,
    Descripcion VARCHAR(100) NOT NULL,
    Precio DECIMAL(10,2) NOT NULL,
    Stock INT NOT NULL
);
GO

--Tabla Estado de la orden de trabajo

CREATE TABLE EstadoDeOrdenTrabajo (
    IDEstadoOrden INT PRIMARY KEY IDENTITY (1,1),
    NombreDeEstado VARCHAR(20) NOT NULL UNIQUE
);
GO

--Tabla orden de trabajo

CREATE TABLE OrdenTrabajo (
    IDOrden INT PRIMARY KEY IDENTITY(1,1),
    IDVehiculo INT NOT NULL,
    IDMecanico INT NOT NULL,
    FechaIngreso DATE NOT NULL,
    FechaEgreso DATE,
    IDEstadoOrden INT NOT NULL,
    Total DECIMAL(10,2),
    FOREIGN KEY (IDVehiculo) REFERENCES Vehiculo(IDVehiculo),
    FOREIGN KEY (IDMecanico) REFERENCES Mecanico(IDMecanico),
    FOREIGN KEY (IDEstadoOrden) REFERENCES EstadoDeOrdenTrabajo(IDEstadoOrden)
);
GO


--Tabla del detalle de las ordenes

CREATE TABLE DetalleOrden (
    IDDetalle INT IDENTITY(1,1) PRIMARY KEY,
    IDOrden INT NOT NULL,
    IDServicio INT NOT NULL,
    IDRepuesto INT NULL,
    Cantidad INT DEFAULT 1,
    Subtotal DECIMAL(10,2),
    FOREIGN KEY (IDOrden) REFERENCES OrdenTrabajo(IDOrden),
    FOREIGN KEY (IDServicio) REFERENCES Servicio(IDServicio),
    FOREIGN KEY (IDRepuesto) REFERENCES Repuesto(IDRepuesto)
);
GO

