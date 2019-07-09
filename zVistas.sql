-- Listar todos los cruceros

GO
create view LOS_QUE_VAN_A_APROBAR.ListarCruceros
as
select C.IdCrucero, M.Descripcion as Marca, Mo.Descripcion as Modelo, C.CantidadCabinas
from LOS_QUE_VAN_A_APROBAR.Crucero as c
join LOS_QUE_VAN_A_APROBAR.Marca as M on c.IdMarca = M.IdMarca
join LOS_QUE_VAN_A_APROBAR.Modelo as Mo on c.IdModelo = Mo.IdModelo
GO

create view LOS_QUE_VAN_A_APROBAR.ListarCrucerosHabilitados
as
select DISTINCT C.IdCrucero, M.Descripcion as Marca, Mo.Descripcion as Modelo, C.CantidadCabinas
from LOS_QUE_VAN_A_APROBAR.Crucero as c
join LOS_QUE_VAN_A_APROBAR.Marca as M on c.IdMarca = M.IdMarca
join LOS_QUE_VAN_A_APROBAR.Modelo as Mo on c.IdModelo = Mo.IdModelo
where c.FechaAlta < (select TOP(1) Fecha from LOS_QUE_VAN_A_APROBAR.TablaFecha)

GO

create view LOS_QUE_VAN_A_APROBAR.ListarCrucerosInhabilitados
as
select DISTINCT C.IdCrucero, M.Descripcion as Marca, Mo.Descripcion as Modelo, C.CantidadCabinas
from LOS_QUE_VAN_A_APROBAR.Crucero as c
join LOS_QUE_VAN_A_APROBAR.Marca as M on c.IdMarca = M.IdMarca
join LOS_QUE_VAN_A_APROBAR.Modelo as Mo on c.IdModelo = Mo.IdModelo
where c.FechaAlta > (select TOP(1) Fecha from LOS_QUE_VAN_A_APROBAR.TablaFecha) or c.FechaAlta is null
GO

create view LOS_QUE_VAN_A_APROBAR.ListarCrucerosSinViaje
as
select DISTINCT C.IdCrucero, M.Descripcion as Marca, Mo.Descripcion as Modelo, C.CantidadCabinas
from LOS_QUE_VAN_A_APROBAR.Crucero as c
join LOS_QUE_VAN_A_APROBAR.Marca as M on c.IdMarca = M.IdMarca
join LOS_QUE_VAN_A_APROBAR.Modelo as Mo on c.IdModelo = Mo.IdModelo
join LOS_QUE_VAN_A_APROBAR.Viaje as v on v.IdCrucero = c.IdCrucero
where (select TOP(1) Fecha from LOS_QUE_VAN_A_APROBAR.TablaFecha) NOT between v.Fecha_Salida and v.Fecha_Llegada
GO


create view LOS_QUE_VAN_A_APROBAR.ListarCrucerosEnViaje
as
select DISTINCT C.IdCrucero, M.Descripcion as Marca, Mo.Descripcion as Modelo, C.CantidadCabinas
from LOS_QUE_VAN_A_APROBAR.Crucero as c
join LOS_QUE_VAN_A_APROBAR.Marca as M on c.IdMarca = M.IdMarca
join LOS_QUE_VAN_A_APROBAR.Modelo as Mo on c.IdModelo = Mo.IdModelo
join LOS_QUE_VAN_A_APROBAR.Viaje as v on v.IdCrucero = c.IdCrucero
where (select TOP(1) Fecha from LOS_QUE_VAN_A_APROBAR.TablaFecha) between v.Fecha_Salida and v.Fecha_Llegada 
GO

select * from LOS_QUE_VAN_A_APROBAR.Viaje order by Fecha_Llegada DESC
-- Recorridos

create view LOS_QUE_VAN_A_APROBAR.ListarRecorridos
as
select RPT.CodigoRecorrido, t1.Puerto_Salida as PuertoSalida, t2.Puerto_Llegada as PuertoLlegada, COUNT(CodigoTramo) as CantidadDeTramos, (select SUM(PrecioTramo) from LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo where CodigoRecorrido = RPT.CodigoRecorrido) as PrecioDeRecorrido from LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo as RPT
join LOS_QUE_VAN_A_APROBAR.Tramo t1 on (select MIN(CodigoTramo) from LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo where CodigoRecorrido = RPT.CodigoRecorrido) = t1.IdTramo
join LOS_QUE_VAN_A_APROBAR.Tramo t2 on (select MAX(CodigoTramo) from LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo where CodigoRecorrido = RPT.CodigoRecorrido) = t2.IdTramo
group by RPT.CodigoRecorrido, t1.Puerto_Salida, t2.Puerto_Llegada
GO





-- Roles

create view LOS_QUE_VAN_A_APROBAR.ListaRoles
as
select r.Nombre as Nombre, f.Descripcion as Descripcion, FPR.Estado as Estado from LOS_QUE_VAN_A_APROBAR.FuncionalidadPorRol FPR
join LOS_QUE_VAN_A_APROBAR.Rol r on FPR.IdRol = r.IdRol
join LOS_QUE_VAN_A_APROBAR.Funcionalidad f on FPR.IdFuncionalidad = f.IdFuncionalidad
GO





