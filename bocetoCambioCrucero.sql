
drop procedure LOS_QUE_VAN_A_APROBAR.asd
create function LOS_QUE_VAN_A_APROBAR.asd(@FechaSalida datetime, @FechaLlegada datetime)
returns nvarchar(50)
as
begin

declare @IdCrucero nvarchar(50)

set @IdCrucero = (select top 1 IdCrucero from LOS_QUE_VAN_A_APROBAR.crucerosParaViaje(@FechaSalida, @FechaLlegada))


return @IdCrucero
end
go

select LOS_QUE_VAN_A_APROBAR.asd('2020-01-01', '2020-01-05')

drop procedure LOS_QUE_VAN_A_APROBAR.cambioCrucero
create procedure LOS_QUE_VAN_A_APROBAR.cambioCrucero(@tiempo int,@IdCruceroViejo nvarchar(50))
as
begin

begin try

declare @Fecha_actual datetime2(3)

set @Fecha_actual = (select top 1 * from LOS_QUE_VAN_A_APROBAR.TablaFecha)

declare @IdViaje int


declare cur_viajes cursor for
select IdViaje from LOS_QUE_VAN_A_APROBAR.Viaje
where Fecha_Salida > @Fecha_actual

open cur_viajes


fetch next from cur_viajes into @IdViaje


while @@FETCH_STATUS = 0

begin

	declare @CruceroNuevo nvarchar(50)
	declare @FechaSalidaNueva datetime2(3)
	declare @FechaLlegadaNueva datetime2(3)
	declare @FechaSalidaVieja datetime2(3)
	declare @FechaLlegadaVieja datetime2(3)
		
	
	
	select @FechaSalidaVieja = Fecha_Salida, @FechaLlegadaVieja = Fecha_Llegada from LOS_QUE_VAN_A_APROBAR.Viaje where IdViaje = @IdViaje
	
	set @FechaSalidaNueva = dateadd(DAY,@tiempo,@FechaSalidaVieja)
	set @FechaLlegadaNueva = dateadd(day, @tiempo, @FechaLlegadaVieja)

	set @CruceroNuevo = (select top 1 IdCrucero from LOS_QUE_VAN_A_APROBAR.crucerosParaViaje(@FechaSalidaNueva, @FechaLlegadaNueva))



	if (@CruceroNuevo IS NULL)
		throw 50000, ' no hay cruceros',1;
	else
	begin

	
	update LOS_QUE_VAN_A_APROBAR.Viaje
	set IdCrucero = @CruceroNuevo, Fecha_Salida = @FechaSalidaNueva, Fecha_Llegada = @FechaLlegadaNueva
	where IdViaje = @IdViaje

	update LOS_QUE_VAN_A_APROBAR.CabinaPorCrucero
	set IdCrucero = @CruceroNuevo, Fecha_Salida = @FechaSalidaNueva
	where IdCrucero = @IdCruceroViejo AND CAST(Fecha_Salida AS DATE) = CAST(@FechaSalidaVieja as date)
	
	update LOS_QUE_VAN_A_APROBAR.Pasaje
	set Fecha_Salida = @FechaSalidaNueva
	where IdViaje = @IdViaje

	update LOS_QUE_VAN_A_APROBAR.Reserva
	set Fecha_Salida = @FechaSalidaNueva
	where IdViaje = @IdViaje

	end
	fetch next from cur_viajes into @IdViaje
end
end try

begin catch
	throw 50000, 'no hay crucero disponible',1;
end catch 

close cur_viajes
deallocate cur_viajes

end
go


