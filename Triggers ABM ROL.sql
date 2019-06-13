-- Cuando se inhabilita un rol, todos los usuarios con ese rol pierden su rol

create trigger SacarRolesDeUsuario on dbo.Rol after update
as
begin
update c  
set IdRol = NULL
from Cliente as c
join Rol as r on r.IdRol = c.IdRol
where r.Estado = 'Inhabilitado'
end

-- Proba papa