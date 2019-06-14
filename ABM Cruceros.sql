-- Creacion de un crucero

create procedure AltaCrucero(@IdCrucero NVARCHAR(50), @IdMarca int, @IdModelo int, @CantidadCabinas int)
as
begin
insert LOS_QUE_VAN_A_APROBAR.Crucero(IdCrucero,IdMarca,IdModelo,FechaAlta,CantidadCabinas)
values(@IdCrucero,@IdMarca,@IdModelo,SYSDATETIME(), @CantidadCabinas)
end

-- Modificar Marca de crucero

create procedure ModificarMarca(@IdCrucero NVARCHAR(50), @IdMarca int)
as 
begin
update LOS_QUE_VAN_A_APROBAR.Crucero
set IdCrucero = @IdCrucero, IdMarca = @IdMarca
end


-- Modificar Modelo de crucero

create procedure ModificarModelo(@IdCrucero NVARCHAR(50), @IdModelo int)
as
begin
update LOS_QUE_VAN_A_APROBAR.Crucero
set IdCrucero = @IdCrucero, IdModelo = @IdModelo
end

-- Baja definitiva de crucero

create procedure BajaDefinitiva(@IdCrucero NVARCHAR(50))
as 
begin
update LOS_QUE_VAN_A_APROBAR.Crucero
set IdCrucero = @IdCrucero, FechaAlta = NULL

insert dbo.FueraDeServicio(IdCrucero,FechaBaja,MotivoBaja)
values(@IdCrucero, SYSDATETIME(), 'Vida util finalizada')

end

-- Baja fuera de servicio

create procedure BajaFueraDeServicio(@IdCrucero NVARCHAR(50), @FechaDeAlta datetime2(3))
as
begin
update LOS_QUE_VAN_A_APROBAR.Crucero
set IdCrucero = @IdCrucero, FechaAlta = null

insert dbo.FueraDeServicio(IdCrucero, FechaBaja, MotivoBaja, FechaReinicio)
values(@IdCrucero,SYSDATETIME(), 'Fuera de servicio', @FechaDeAlta)

end




