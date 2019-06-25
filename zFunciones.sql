-- Rol

create function LOS_QUE_VAN_A_APROBAR.ObtenerNuevoRolInsertado()
returns int as
begin
return (select TOP(1) IdRol from LOS_QUE_VAN_A_APROBAR.Rol order by IdRol DESC)
end





-- Validacion de admin


create function LOS_QUE_VAN_A_APROBAR.ValidarAdministrador(@Username NVARCHAR(100), @Password NVARCHAR(100))
returns int as
begin
declare @Resultado tinyint
if  exists(select * 
from LOS_QUE_VAN_A_APROBAR.Administrador
where NombreUsuario = @Username and Contraseņa = HASHBYTES('SHA2_256', @Password))
set @Resultado = 1
else
begin
set @Resultado = 0
end
return @Resultado
end

select * from LOS_QUE_VAN_A_APROBAR.Administrador