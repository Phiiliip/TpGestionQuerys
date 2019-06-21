
--Crear Recorrido
Create procedure LOS_QUE_VAN_A_APROBAR.CrearRecorrido(@CodigoRecorrido decimal(18,2), @Descripcion varchar(50), @Precio decimal(18,2))
AS
BEGIN
INSERT INTO LOS_QUE_VAN_A_APROBAR.Recorrido(Codigo_Recorrido, Descripcion, PrecioTotal)
VALUES (@CodigoRecorrido, @Descripcion, @Precio)
END

--Crear tramo de recorrido

CREATE PROCEDURE LOS_QUE_VAN_A_APROBAR.InsertarTramoDeRecorrido(@CodigoRecorrido int, @CodigoTramo int, @Precio decimal(18,2))
AS
BEGIN
INSERT INTO LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo(CodigoRecorrido, CodigoTramo, PrecioTramo)
values( @CodigoRecorrido, @CodigoTramo, @Precio)
END

--modificar tramo de recorrido

Create PROCEDURE LOS_QUE_VAN_A_APROBAR.modificarTramoDeRecorrido(@IdRecorrido int,@TramoViejo int, @TramoNuevo int)
AS
BEGIN

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
PRINT 'Hay pasajes vendidos para un viaje que todavía no se realizó'
END

END
