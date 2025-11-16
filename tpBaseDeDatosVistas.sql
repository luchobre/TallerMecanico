--Vistas
USE TallerMecanicoUTNFRGP;
GO

--Ordenes pendientes
--Lista de todas las ordenes de trabajo que estan en estado "Pendiente" o "En Proceso", junto con detalles del cliente, vehículo y mecanico asignado

CREATE VIEW Vista_OrdenesPendientes AS
SELECT
    o.IDOrden,
    c.Nombre + ' ' + c.Apellido AS Cliente,
    c.Email AS MailCliente,
    ma.NombreDeMarca + ' ' + mo.NombreModelo AS Vehiculo,
    m.Nombre AS Mecanico,
    o.FechaIngreso AS FechaOrden,
    e.NombreDeEstado AS Estado
FROM OrdenTrabajo o
INNER JOIN Vehiculo v ON o.IDVehiculo = v.IDVehiculo
INNER JOIN Modelo mo ON v.IDModelo = mo.IDModelo
INNER JOIN Marca ma ON mo.IDMarca = ma.IDMarca
INNER JOIN Cliente c ON v.IDCliente = c.IDCliente
INNER JOIN Mecanico m ON o.IDMecanico = m.IDMecanico
INNER JOIN EstadoDeOrdenTrabajo e ON o.IDEstadoOrden = e.IDEstadoOrden
WHERE e.NombreDeEstado IN ('Pendiente', 'En Proceso');
GO

--Historial de los vehiculos
--Muestra el historial de mantenimiento de cada auto, con cliente, ordenes, servicios y repuestos

CREATE VIEW Vista_HistorialVehiculos AS
SELECT 
    v.Patente,
    ma.NombreDeMarca AS Marca,
    mo.NombreModelo AS Modelo,
    c.Nombre + ' ' + c.Apellido AS Cliente,
    o.IDOrden,
    o.FechaIngreso,
    o.FechaEgreso,
    e.NombreDeEstado AS Estado,
    s.Descripcion AS Servicio,
    r.Descripcion AS Repuesto,
    d.Cantidad,
    d.Subtotal
FROM Vehiculo v
INNER JOIN Modelo mo ON v.IDModelo = mo.IDModelo
INNER JOIN Marca ma ON mo.IDMarca = ma.IDMarca
INNER JOIN Cliente c ON v.IDCliente = c.IDCliente
INNER JOIN OrdenTrabajo o ON v.IDVehiculo = o.IDVehiculo
INNER JOIN EstadoDeOrdenTrabajo e ON o.IDEstadoOrden = e.IDEstadoOrden
INNER JOIN DetalleOrden d ON o.IDOrden = d.IDOrden
INNER JOIN Servicio s ON d.IDServicio = s.IDServicio
LEFT JOIN Repuesto r ON d.IDRepuesto = r.IDRepuesto;
GO

--Resumen de ingresos mensuales
--Muestra el total de ingresos y numero de ordenes finalizadas por mes

CREATE VIEW Vista_ResumenIngresosMensuales AS
SELECT  
    YEAR(o.FechaEgreso) AS Anio,
    MONTH(o.FechaEgreso) AS Mes,
    SUM(o.Total) AS IngresosTotales,
    COUNT(o.IDOrden) AS NumeroOrdenes
FROM OrdenTrabajo o
INNER JOIN EstadoDeOrdenTrabajo e ON o.IDEstadoOrden = e.IDEstadoOrden
WHERE e.NombreDeEstado = 'Finalizada'
GROUP BY YEAR(o.FechaEgreso), MONTH(o.FechaEgreso);
GO

--Resumen de ingresos diarios
--Muestra el total de ingresos y numero de ordenes finalizadas por día  

CREATE VIEW Vista_IngresosDiarios AS
SELECT 
    CONVERT(date, o.FechaEgreso) AS Fecha,
    SUM(o.Total) AS TotalDia,
    COUNT(o.IDOrden) AS OrdenesFinalizadas
FROM OrdenTrabajo o
INNER JOIN EstadoDeOrdenTrabajo e ON o.IDEstadoOrden = e.IDEstadoOrden
WHERE e.NombreDeEstado = 'Finalizada'
GROUP BY CONVERT(date, o.FechaEgreso);
GO