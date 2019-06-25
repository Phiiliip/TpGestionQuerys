
--Crear Recorrido
Create procedure LOS_QUE_VAN_A_APROBAR.CrearRecorrido(@CodigoRecorrido decimal(18,2), @Descripcion varchar(50), @Precio decimal(18,2))
AS
BEGIN
INSERT INTO LOS_QUE_VAN_A_APROBAR.Recorrido(Codigo_Recorrido, Descripcion, PrecioTotal)
VALUES (@CodigoRecorrido, @Descripcion, @Precio)
END

select * from LOS_QUE_VAN_A_APROBAR.Recorrido

--Crear tramo de recorrido
DROP PROCEDURE LOS_QUE_VAN_A_APROBAR.InsertarTramoDeRecorrido
CREATE PROCEDURE LOS_QUE_VAN_A_APROBAR.InsertarTramoDeRecorrido(@CodigoRecorrido int, @Puerto_Salida nvarchar(255), @Puerto_Llegada nvarchar(255))
AS
BEGIN

DECLARE @CodigoTramo int

IF NOT EXISTS(SELECT * FROM LOS_QUE_VAN_A_APROBAR.Tramo WHERE Puerto_Salida = @Puerto_Salida AND Puerto_Llegada = @Puerto_Llegada)
BEGIN
INSERT INTO LOS_QUE_VAN_A_APROBAR.Tramo(Puerto_Salida, Puerto_Llegada)
VALUES(@Puerto_Salida, @Puerto_Llegada)
END

SET @CodigoTramo = (select top 1 IdTramo from LOS_QUE_VAN_A_APROBAR.Tramo where Puerto_Salida = @Puerto_Salida AND Puerto_Llegada = @Puerto_Llegada)

INSERT INTO LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo(CodigoRecorrido, CodigoTramo)
values( @CodigoRecorrido, @CodigoTramo)
END

--modificar tramo de recorrido
Drop procedure LOS_QUE_VAN_A_APROBAR.modificarTramoDeRecorrido
Create PROCEDURE LOS_QUE_VAN_A_APROBAR.modificarTramoDeRecorrido(@IdRecorrido int, @TramoViejo int, @Puerto_Salida nvarchar(255), @Puerto_Llegada nvarchar(255))
AS
BEGIN

DECLARE @TramoNuevo int

IF NOT EXISTS(SELECT * FROM LOS_QUE_VAN_A_APROBAR.Tramo WHERE Puerto_Salida = @Puerto_Salida AND Puerto_Llegada = @Puerto_Llegada)
BEGIN
INSERT INTO LOS_QUE_VAN_A_APROBAR.Tramo(Puerto_Salida, Puerto_Llegada)
VALUES(@Puerto_Salida, @Puerto_Llegada)
END


set @TramoNuevo = (select top 1 IdTramo from LOS_QUE_VAN_A_APROBAR.Tramo where Puerto_Salida = @Puerto_Salida AND Puerto_Llegada = @Puerto_Llegada)

update LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo
set CodigoTramo = @TramoNuevo
WHERE CodigoRecorrido = @IdRecorrido AND CodigoTramo = @TramoViejo

end


--DAR DE BAJA RECORRIDO
CREATE PROCEDURE LOS_QUE_VAN_A_APROBAR.BajaRecorrido(@IdRecorrido int)
AS
BEGIN

IF NOT EXISTS (SELECT R.IdRecorrido
FROM LOS_QUE_VAN_A_APROBAR.Pasaje p
 JOIN LOS_QUE_VAN_A_APROBAR.Viaje v ON (v.IdViaje = p.IdViaje)
 JOIN LOS_QUE_VAN_A_APROBAR.Recorrido r ON (v.IdRecorrido = r.IdRecorrido)
WHERE p.Fecha_Salida > GETDATE() AND r.IdRecorrido = @IdRecorrido
)

BEGIN
UPDATE LOS_QUE_VAN_A_APROBAR.Recorrido
SET  Estado = 'Inhabilitado'
WHERE IdRecorrido = @IdRecorrido
END

ELSE
BEGIN
PRINT 'Hay pasajes vendidos para un viaje que todavía no se realizó' --ver como pasar al visual
END

END


