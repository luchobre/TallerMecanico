USE TallerMecanicoUTNFRGP;
GO

-- 1) CLIENTES
INSERT INTO Cliente (Nombre, Apellido, Telefono, Email, Direccion) VALUES
('Juan', 'Pérez', '1133445566', 'juan.perez@mail.com', 'Belgrano 123'),
('María', 'Gómez', '1122334455', 'maria.gomez@mail.com', 'San Martín 456'),
('Lucas', 'Rodríguez', '1144556677', 'lucas.rod@hotmail.com', 'Mitre 789'),
('Ana', 'López', '1166778899', 'ana.lopez@gmail.com', 'Lavalle 1500'),
('Carlos', 'Sosa', '1177889900', 'carlos.sosa@mail.com', 'Perón 2340');


-- 2) MARCAS

INSERT INTO Marca (NombreDeMarca) VALUES
('Toyota'),
('Ford'),
('Chevrolet'),
('Volkswagen'),
('Renault');


-- 3) MODELOS

INSERT INTO Modelo (IDMarca, NombreModelo) VALUES
(1, 'Corolla'),
(1, 'Hilux'),
(2, 'Fiesta'),
(2, 'Ranger'),
(3, 'Onix'),
(4, 'Gol'),
(5, 'Kangoo');


-- 4) COMBUSTIBLES

INSERT INTO Combustible (TipoDeCombustible) VALUES
('Nafta'),
('Diesel'),
('GNC'),
('Híbrido');

-- 5) VEHÍCULOS

INSERT INTO Vehiculo (IDCliente, IDModelo, Patente, Anio, IDCombustible) VALUES
(1, 1, 'AA123BB', 2018, 1),
(1, 2, 'AC456DD', 2022, 2),
(2, 3, 'AE789FF', 2016, 1),
(3, 4, 'AB234GH', 2020, 2),
(4, 5, 'AF567JK', 2021, 1),
(5, 6, 'AG890LM', 2014, 3);


-- 6) ESPECIALIDADES

INSERT INTO Especialidad (NombreDeEspecialidad) VALUES
('Motor'),
('Electricidad'),
('Frenos'),
('Transmisión'),
('Inyección Electrónica');


-- 7) MECÁNICOS

INSERT INTO Mecanico (Nombre, IDEspecialidad, Telefono, Email) VALUES
('Roberto Díaz', 1, '1155667788', 'roberto.d@mail.com'),
('Martín Silva', 2, '1144552233', 'martin.silva@mail.com'),
('Ezequiel Torres', 3, '1177445599', 'ezequiel.torres@mail.com'),
('Santiago López', 4, '1133221100', 'santiago.lopez@mail.com'),
('Fernando Ruiz', 5, '1188992211', 'fernando.ruiz@mail.com');


-- 8) SERVICIOS

INSERT INTO Servicio (Descripcion, Costo, DuracionEstimada) VALUES
('Cambio de aceite y filtro', 15000, 60),
('Alineación y balanceo', 18000, 90),
('Revisión general', 25000, 120),
('Cambio de pastillas de freno', 22000, 80),
('Diagnóstico por scanner', 12000, 45);


-- 9) REPUESTOS

INSERT INTO Repuesto (Descripcion, Precio, Stock) VALUES
('Filtro de aceite', 3500, 40),
('Pastillas de freno', 8500, 25),
('Aceite sintético 5W30', 9000, 50),
('Batería 65Ah', 45000, 10),
('Bujía Iridium', 6000, 30);


-- 10) ESTADOS DE ORDEN

INSERT INTO EstadoDeOrdenTrabajo (NombreDeEstado) VALUES
('Pendiente'),
('En Proceso'),
('Finalizada'),
('Cancelada');


-- 11) ÓRDENES DE TRABAJO

INSERT INTO OrdenTrabajo (IDVehiculo, IDMecanico, FechaIngreso, IDEstadoOrden, Total)
VALUES
(1, 1, '2025-01-10', 1, NULL),
(2, 2, '2025-01-15', 2, NULL),
(3, 3, '2025-01-20', 1, NULL),
(4, 4, '2025-01-22', 3, 35000),
(5, 5, '2025-01-25', 1, NULL);


-- 12) DETALLE DE ÓRDENES

INSERT INTO DetalleOrden (IDOrden, IDServicio, IDRepuesto, Cantidad, Subtotal) VALUES
(1, 1, 1, 1, 18500),  -- aceite + filtro
(1, 5, NULL, 1, 12000), -- scanner
(2, 2, NULL, 1, 18000), -- alineación
(3, 4, 2, 1, 30500),  -- pastillas + servicio
(4, 3, NULL, 1, 25000), -- revisión general
(5, 1, 3, 1, 24000);  -- aceite + filtro


-- 13) ORDEN FINALIZADA CON EGRESO

UPDATE OrdenTrabajo
SET FechaEgreso = '2025-01-23'
WHERE IDOrden = 4;


-- 14) ACTUALIZAR STOCK DE REPUESTOS

UPDATE Repuesto SET Stock = Stock - 1 WHERE IDRepuesto IN (1,2,3);


-- 15) CALCULAR TOTALES DE LAS ÓRDENES

UPDATE OrdenTrabajo
SET Total = (
    SELECT SUM(Subtotal)
    FROM DetalleOrden d
    WHERE d.IDOrden = OrdenTrabajo.IDOrden
)
WHERE IDOrden IN (1,2,3,5);