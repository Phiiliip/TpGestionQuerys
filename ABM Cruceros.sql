-- Creacion de un crucero

create procedure LOS_QUE_VAN_A_APROBAR.AltaCrucero(@IdCrucero NVARCHAR(50), @IdMarca int, @IdModelo int, @CantidadCabinas int)
as
begin
insert LOS_QUE_VAN_A_APROBAR.Crucero(IdCrucero,IdMarca,IdModelo,FechaAlta,CantidadCabinas)
values(@IdCrucero,@IdMarca,@IdModelo,SYSDATETIME(), @CantidadCabinas)
end

-- Modificar Marca de crucero

create procedure LOS_QUE_VAN_A_APROBAR.ModificarMarca(@IdCrucero NVARCHAR(50), @IdMarca int)
as 
begin
update LOS_QUE_VAN_A_APROBAR.Crucero
set IdMarca = @IdMarca
where IdCrucero = @IdCrucero
end


-- Modificar Modelo de crucero

create procedure LOS_QUE_VAN_A_APROBAR.ModificarModelo(@IdCrucero NVARCHAR(50), @IdModelo int)
as
begin
update LOS_QUE_VAN_A_APROBAR.Crucero
set IdCrucero = @IdCrucero, IdModelo = @IdModelo
end

-- Baja definitiva de crucero

create procedure LOS_QUE_VAN_A_APROBAR.BajaDefinitiva(@IdCrucero NVARCHAR(50))
as 
begin
update LOS_QUE_VAN_A_APROBAR.Crucero
set FechaAlta = NULL
where IdCrucero = @IdCrucero,

insert LOS_QUE_VAN_A_APROBAR.FueraDeServicio(IdCrucero,FechaBaja,MotivoBaja)
values(@IdCrucero, SYSDATETIME(), 'Vida util finalizada')

end

-- Baja fuera de servicio

create procedure LOS_QUE_VAN_A_APROBAR.BajaFueraDeServicio(@IdCrucero NVARCHAR(50), @FechaDeAlta datetime2(3))
as
begin
update LOS_QUE_VAN_A_APROBAR.Crucero
set FechaAlta = @FechaDeAlta
where IdCrucero = @IdCrucero

insert LOS_QUE_VAN_A_APROBAR.FueraDeServicio(IdCrucero, FechaBaja, MotivoBaja, FechaReinicio)
values(@IdCrucero,SYSDATETIME(), 'Fuera de servicio', @FechaDeAlta)

end




