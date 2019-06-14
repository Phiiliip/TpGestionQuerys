-- Creacion de un viaje

create procedure CrearViaje(@IdCrucero nvarchar(50), @IdRecorrido int, @Fecha_Salida datetime2(3), @Fecha_Llegada datetime2(3), @CodigoRecorrido decimal(18,0))
as
begin
insert LOS_QUE_VAN_A_APROBAR.Viaje(IdCrucero,IdRecorrido,Fecha_Salida,Fecha_Llegada,CodigoRecorrido)
values(@IdCrucero,@IdRecorrido,@Fecha_Salida, @Fecha_Llegada, @CodigoRecorrido)
end

