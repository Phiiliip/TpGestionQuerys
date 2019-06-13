-- Validacion de Login

create procedure ValidarAdministrador(@Username NVARCHAR(100), @Password NVARCHAR(100))
as
begin
if exists(select * 
from Administrador
where NombreUsuario = @Username and Contrase�a = HASHBYTES('SHA2_256', @Password))
return 1
else return 0
end


-- Creacion de administrador
create procedure CrearAdministrador(@Username NVARCHAR(100), @Password NVARCHAR(100))
as
begin
insert Administrador(NombreUsuario,Contrase�a)
values (@Username, HASHBYTES('SHA2_256', @Password))
end

--


