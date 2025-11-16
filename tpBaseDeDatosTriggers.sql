--Triggers
USE TallerMecanicoUTNFRGP;
GO

--Trigger para evitar que se elimine un usuario que tiene un vehiculo en el taller
CREATE TRIGGER tr_evitarEliminarCliente 
ON Cliente
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM Vehiculo v
        INNER JOIN OrdenTrabajo ot ON v.IDVehiculo = ot.IDVehiculo
        INNER JOIN EstadoDeOrdenTrabajo eo ON ot.IDEstadoOrden = eo.IDEstadoOrden
        INNER JOIN deleted d ON v.IDCliente = d.IDCliente
        WHERE eo.NombreDeEstado IN ('Pendiente', 'En Proceso')
    )
    BEGIN
        RAISERROR('No está permitido eliminar el cliente ya que tiene vehículos con órdenes activas en el taller.', 16, 1);
        RETURN;
    END;

    DELETE FROM Cliente
    WHERE IDCliente IN (SELECT IDCliente FROM deleted);
END;
GO


--Trigger para evitar que se elimine un mecanico que tiene ordenes pendientes o en proceso
CREATE TRIGGER tr_evitarBajaMecanicoConOrdenesActivas 
ON Mecanico
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (
        SELECT 1 
        FROM OrdenTrabajo o
        INNER JOIN EstadoDeOrdenTrabajo e ON o.IDEstadoOrden = e.IDEstadoOrden
        INNER JOIN deleted d ON o.IDMecanico = d.IDMecanico
        WHERE e.NombreDeEstado IN ('Pendiente', 'En Proceso')
    )
    BEGIN
        RAISERROR('No se puede eliminar el mecánico, tiene órdenes activas.', 16, 1);
        RETURN;
    END;

    DELETE FROM Mecanico
    WHERE IDMecanico IN (SELECT IDMecanico FROM deleted);
END;
GO



