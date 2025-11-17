-- Procedimientos Almacenados
USE TallerMecanicoUTNFRGP;
GO

--Procedimiento almacenado para finalizar una orden de trabajo solo si la misma se encuentra con ordenes activas.

CREATE PROCEDURE sp_FinalizarOrdenTrabajo
    @IDOrden INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        IF NOT EXISTS (
            SELECT 1 
            FROM OrdenTrabajo 
            WHERE IDOrden = @IDOrden
            )
        BEGIN
            RAISERROR('La orden de trabajo no existe.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;
        IF EXISTS (
            SELECT 1 
            FROM OrdenTrabajo o
            INNER JOIN EstadoDeOrdenTrabajo e ON o.IDEstadoOrden = e.IDEstadoOrden
            WHERE IDOrden = @IDOrden
              AND e.NombreDeEstado = 'Finalizada'
        )
        BEGIN
            RAISERROR('La orden ya está finalizada.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;
        IF NOT EXISTS (
            SELECT 1 
            FROM DetalleOrden 
            WHERE IDOrden = @IDOrden
            )
        BEGIN
            RAISERROR('No se puede finalizar la orden porque no tiene servicios cargados.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;

        DECLARE @Total DECIMAL(10,2);

        SELECT @Total = SUM(Subtotal)
        FROM DetalleOrden
        WHERE IDOrden = @IDOrden;

        UPDATE OrdenTrabajo
        SET 
            FechaEgreso = GETDATE(),
            IDEstadoOrden = (SELECT IDEstadoOrden FROM EstadoDeOrdenTrabajo WHERE NombreDeEstado  = 'Finalizada'),
            Total = @Total
        WHERE IDOrden = @IDOrden;

        COMMIT TRANSACTION;
        PRINT 'La orden fue finalizada correctamente.';
    END TRY

    BEGIN CATCH
        ROLLBACK TRANSACTION;
        RAISERROR('Error al finalizar la orden', 16, 1);
    END CATCH
END;
GO

--Procedimiento almacenado que crea una orden nueva de trabajo, solo si no hay otra orden en proceso para ese auto

CREATE PROCEDURE sp_RegistrarOrdenTrabajo
    @IDVehiculo INT,
    @IDMecanico INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        IF EXISTS (
            SELECT 1
            FROM OrdenTrabajo o
            INNER JOIN EstadoDeOrdenTrabajo e ON o.IDEstadoOrden = e.IDEstadoOrden
            WHERE o.IDVehiculo = @IDVehiculo
              AND e.NombreDeEstado IN ('Pendiente', 'En Proceso')
        )
        BEGIN
            RAISERROR('El vehículo ya tiene una orden activa en el taller.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;
        INSERT INTO OrdenTrabajo (IDVehiculo, IDMecanico, FechaIngreso, IDEstadoOrden, Total)
        VALUES (
            @IDVehiculo, @IDMecanico, GETDATE(), (SELECT IDEstadoOrden FROM EstadoDeOrdenTrabajo WHERE NombreDeEstado = 'Pendiente'), 0
            );
        COMMIT TRANSACTION;
        PRINT 'Orden registrada correctamente.';
    END TRY

    BEGIN CATCH
        ROLLBACK TRANSACTION;
        RAISERROR('Error al registrar la orden', 16, 1);
    END CATCH
END;
GO
