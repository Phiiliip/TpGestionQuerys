create procedure NuevoRol (@NuevoNombre NVARCHAR(20))
as
begin
insert into dbo.Rol(Nombre)
values (@Nuevonombre)
end

--

create procedure NuevaFuncionalidad(@NuevoNombre NVARCHAR(255))
as 
begin
insert into dbo.Funcionalidad(Descripcion)
values(@NuevoNombre)
end

--

create procedure FuncionalidadParaRol(@IdRol int, @IdFuncionalidad int)
as
begin
insert into dbo.FuncionalidadPorRol(IdFuncionalidad, IdRol) 
values (@IdFuncionalidad, @IdRol)
end

/* Consulta sobre rol y funcionalidad
select f.Descripcion as Funcionalidad, r.nombre as Rol, fpr.Estado 
from FuncionalidadPorRol as fpr
join Funcionalidad as f on fpr.IdFuncionalidad = f.IdFuncionalidad
join Rol as r on r.IdRol = fpr.IdRol */

--

create procedure ModificarRol(@IdRol int, @Nombre NVARCHAR(20))
as
begin
update dbo.Rol
set Nombre = @Nombre
where IdRol = @IdRol
end

--

create procedure BajaRol(@IdRol int)
as
begin
update dbo.Rol
set Estado = 'Inhabilitado'
where IdRol = @Idrol
end

--

Create procedure AltaRol(@IdRol int)
as
begin
update dbo.Rol
set Estado = 'Habilitado'
where IdRol = @Idrol
end

--

create procedure BajaFuncionalidadDelRol(@IdRol int, @IdFuncionalidad int)
as
begin
update dbo.FuncionalidadPorRol
set Estado = 'Inhabilitado'
where IdRol = @IdRol and IdFuncionalidad = @IdFuncionalidad
end

--

create procedure AltaFuncionalidadDelRol(@IdRol int, @IdFuncionalidad int)
as
begin
update dbo.FuncionalidadPorRol
set Estado = 'Habilitado'
where IdRol = @IdRol and IdFuncionalidad = @IdFuncionalidad
end


--

