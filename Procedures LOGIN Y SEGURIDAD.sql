-- Validacion de Login

create procedure ValidarAdministrador(@Username NVARCHAR(100), @Password NVARCHAR(100))
as
begin
if exists(select * 
from LOS_QUE_VAN_A_APROBAR.Administrador
where NombreUsuario = @Username and Contraseņa = HASHBYTES('SHA2_256', @Password))
return 1
else return 0
end


-- Creacion de administrador
create procedure CrearAdministrador(@Username NVARCHAR(100), @Password NVARCHAR(100))
as
begin
insert LOS_QUE_VAN_A_APROBAR.Administrador(NombreUsuario,Contraseņa)
values (@Username, HASHBYTES('SHA2_256', @Password))
end

--


