-- Validacion de Login

create procedure LOS_QUE_VAN_A_APROBAR.ValidarAdministrador(@Username NVARCHAR(100), @Password NVARCHAR(100))
as
begin
if exists(select * 
from LOS_QUE_VAN_A_APROBAR.Administrador
where NombreUsuario = @Username and Contrase�a = HASHBYTES('SHA2_256', @Password))
return 1
else return 0
end


-- Creacion de administrador
create procedure LOS_QUE_VAN_A_APROBAR.CrearAdministrador(@Username NVARCHAR(100), @Password NVARCHAR(100))
as
begin
insert LOS_QUE_VAN_A_APROBAR.Administrador(NombreUsuario,Contrase�a)
values (@Username, HASHBYTES('SHA2_256', @Password))
end

--


