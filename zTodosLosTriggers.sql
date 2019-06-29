-- ROL

-- Cuando se inhabilita un rol, todos los usuarios con ese rol pierden su rol
GO
create trigger LOS_QUE_VAN_A_APROBAR.SacarRolesDeUsuario on LOS_QUE_VAN_A_APROBAR.Rol after update
as
begin
update c  
set IdRol = NULL
from LOS_QUE_VAN_A_APROBAR.Cliente as c
join Rol as r on r.IdRol = c.IdRol
where r.Estado = 'Inhabilitado'
end
GO




---------------------------------- CRUCEROS------------------------------------------






-- Trigger de baja definitivo

/*create trigger BajaDefinitiva on LOS_QUE_VAN_A_APROBAR.FueraDeServicio after insert
as
begin
declare @IdCruceroViejo int
declare @IdCruceroNuevo int
declare @FechaBaja Datetime2(3)

set @IdCruceroViejo = (select top(1) IdCrucero from inserted)
set @FechaBaja = (select top(1) FechaBaja from inserted)
set @IdCruceroNuevo = (select top(1) IdCrucero from LOS_QUE_VAN_A_APROBAR.Crucero 
where FechaAlta */





------ ----------------- Viaje ------------------------


create trigger CrearCabinasPorCrucero on LOS_QUE_VAN_A_APROBAR.Viaje after insert
as
begin
declare @IdCrucero NVARCHAR(50)
declare @FechaSalida DATETIME2(3)

set @IdCrucero = (select TOP(1) IdCrucero from inserted)
set @FechaSalida = (select TOP(1) Fecha_Salida from inserted)

exec LOS_QUE_VAN_A_APROBAR.GenerarCabinasPorCrucero @IdCrucero, @FechaSalida

end

GO