-- Rol

create function LOS_QUE_VAN_A_APROBAR.ObtenerNuevoRolInsertado()
returns int as
begin
return (select TOP(1) IdRol from LOS_QUE_VAN_A_APROBAR.Rol order by IdRol DESC)
end
GO








-------------------------------------- Validacion de admin------------------------------------------


create function LOS_QUE_VAN_A_APROBAR.ValidarAdministrador(@Username NVARCHAR(100), @Password NVARCHAR(100))
returns int as
begin
declare @Resultado tinyint
if  exists(select * 
from LOS_QUE_VAN_A_APROBAR.Administrador
where NombreUsuario = @Username and Contraseña = HASHBYTES('SHA2_256', @Password))
set @Resultado = 1
else
begin
set @Resultado = 0
end
return @Resultado
end
GO



--- Id de rol dado un usuario

create function LOS_QUE_VAN_A_APROBAR.IdDeRol(@Username NVARCHAR(100), @Password NVARCHAR(255))
returns int as
begin
declare @Resultado int
set @Resultado = (select top(1) IdRol from LOS_QUE_VAN_A_APROBAR.Administrador where NombreUsuario = @Username and Contraseña = HASHBYTES('SHA2_256',@Password))
return @Resultado
end
GO






---------------------------------- COMPRA Y RESERVA ----------------------------------------------




CREATE FUNCTION LOS_QUE_VAN_A_APROBAR.ListarViajes(@Fecha_Salida datetime2(3), @Puerto_Salida nvarchar(255), @Puerto_Llegada nvarchar(255))
RETURNS TABLE
AS
RETURN
	SELECT v.IdViaje, v.IdRecorrido from LOS_QUE_VAN_A_APROBAR.Viaje v
	WHERE Fecha_Salida = @Fecha_Salida 
	AND @Puerto_Salida IN (select Puerto_Salida from LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo r
							JOIN LOS_QUE_VAN_A_APROBAR.Tramo t ON (r.CodigoTramo = t.IdTramo)
							where r.CodigoRecorrido =  v.IdRecorrido)
	AND @Puerto_Llegada IN (SELECT Puerto_Llegada from LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo r
							JOIN LOS_QUE_VAN_A_APROBAR.Tramo t ON (r.CodigoTramo = t.IdTramo)
							where r.CodigoRecorrido = V.IdRecorrido)
GO









-------------------------------------------- VIAJE --------------------------------------------

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
GO


---- Recorrido

create function LOS_QUE_VAN_A_APROBAR.PuertosDeRecorrido(@IdReco int)
returns TABLE
as
return 
select DISTINCT p.Nombre as NombrePuerto from LOS_QUE_VAN_A_APROBAR.Puerto p
join LOS_QUE_VAN_A_APROBAR.Tramo T on (T.Puerto_Llegada = p.Nombre or T.Puerto_Salida = p.Nombre)
join LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo RPT on T.IdTramo = RPT.CodigoTramo
where RPT.CodigoRecorrido = @IdReco
GO


-- Puertos extremos de un recorrido
create function LOS_QUE_VAN_A_APROBAR.PuertosExtremos(@IdReco int)
returns NVARCHAR(255)
as
begin
declare @Retorno NVARCHAR(255)
set @Retorno = (select TOP(1) ('Puerto salida: ' + t1.Puerto_Salida + ' - Puerto llegada: ' + t2.Puerto_Llegada) from LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo RPT
join LOS_QUE_VAN_A_APROBAR.Tramo t1 on t1.IdTramo = (select TOP(1) MIN(CodigoTramo) from LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo rpt where rpt.CodigoRecorrido = @IdReco)
join LOS_QUE_VAN_A_APROBAR.Tramo t2 on t2.IdTramo = (select TOP(1) MAX(CodigoTramo) from LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo ptr where ptr.CodigoRecorrido = @IdReco))
return @Retorno
end
GO


