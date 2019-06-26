-- Creacion de un viaje
drop procedure LOS_QUE_VAN_A_APROBAR.GenerarViaje


--HABRIA QUE MOSTRAR SOLO LOS CRUCEROS QUE ESTEN DISPONIBLES Y SOLO RECORRIDOS HABILITADOS
CREATE PROCEDURE LOS_QUE_VAN_A_APROBAR.GenerarViaje(@IdCrucero nvarchar(50), @IdRecorrido int, @Fecha_Salida datetime2(3), @Fecha_Llegada datetime2(3), @CodigoRecorrido decimal(18,2), @Fecha_Actual nvarchar(255))
AS
BEGIN

if CONVERT(datetime2(3),@Fecha_Salida) > CONVERT(datetime2(3), @Fecha_Actual)
BEGIN
	insert into LOS_QUE_VAN_A_APROBAR.Viaje(IdCrucero, IdRecorrido, Fecha_Salida, Fecha_Llegada, CodigoRecorrido)
	values(@IdCrucero, @IdRecorrido, @Fecha_Salida, @Fecha_Llegada, @CodigoRecorrido)
END

ELSE
	Print 'la fecha de salida debe ser mayor a la actual' -- ver como pasar error a visual
END
go


DROP FUNCTION LOS_QUE_VAN_A_APROBAR.crucerosParaViaje

--FUNCION PARA SELECCIONAR CRUCEROS QUE PUEDEN VIAJAR
CREATE FUNCTION LOS_QUE_VAN_A_APROBAR.crucerosParaViaje(@Fecha_SalidaNueva datetime2(3), @Fecha_LlegadaNueva datetime2(3))
RETURNS TABLE
AS	
RETURN 
select * from LOS_QUE_VAN_A_APROBAR.Crucero
where IdCrucero not in
 (select IdCrucero from LOS_QUE_VAN_A_APROBAR.Viaje
  WHERE (convert(datetime2(3), Fecha_Salida) BETWEEN convert(datetime2(3), @Fecha_SalidaNueva) AND convert(datetime2(3), @Fecha_LlegadaNueva)) OR
   convert(datetime2(3), Fecha_Llegada) BETWEEN CONVERT(datetime2(3), @Fecha_SalidaNueva) AND convert(datetime2(3), @Fecha_LlegadaNueva)
   OR (convert(datetime2(3), @Fecha_SalidaNueva) > convert(datetime2(3),Fecha_Salida) AND convert(datetime2(3), @Fecha_LlegadaNueva) < convert(datetime2(3), Fecha_Llegada))
   )




--pruebas
/*SELECT* FROM LOS_QUE_VAN_A_APROBAR.Crucero

select * from LOS_QUE_VAN_A_APROBAR.Recorrido

SELECT * FROM LOS_QUE_VAN_A_APROBAR.Viaje
ORDER BY IdViaje desc

INSERT INTO LOS_QUE_VAN_A_APROBAR.Crucero(IdCrucero,IdMarca,IdModelo,FechaAlta,CantidadCabinas)
values('ASD123',1,1,getdate(),500)

--deberia funcionar
EXEC LOS_QUE_VAN_A_APROBAR.GenerarViaje 'ASHFLJ-66175', 1, '2020-01-01 01:01:01', '2020-01-02 01:01:01', 43820895, '2019-06-25 17:51:00'


--deberia fallar
EXEC LOS_QUE_VAN_A_APROBAR.GenerarViaje 'ASHFLJ-66175', 1, '2018-01-01 01:01:01', '2020-01-02 01:01:01', 43820895, '2019-06-25 17:51:00' --
*/