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


--Trigger para descontar automáticamente el stock del repuesto evitando que sea negativo

DROP TRIGGER IF EXISTS tr_descontarStockRepuesto;
GO

CREATE TRIGGER tr_descontarStockRepuesto
ON DetalleOrden
AFTER INSERT
AS
BEGIN
    -- Actualizar stock solo para repuestos válidos
    UPDATE r
    SET r.Stock = r.Stock - i.Cantidad
    FROM Repuesto r
    INNER JOIN inserted i ON r.IDRepuesto = i.IDRepuesto
    WHERE i.IDRepuesto IS NOT NULL;

    -- Evitar stock negativo
    IF EXISTS (SELECT 1 FROM Repuesto WHERE Stock < 0)
    BEGIN
        RAISERROR('No está permitido tener stock negativo.',16,1);
        ROLLBACK TRANSACTION;
        RETURN;
    END
END;
GO



