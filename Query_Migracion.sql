select * from dbo.Reserva

-- Lo que anda piola:

-- Stored Procedure para ejecutar toda la migracion:
-- Para ejecutar usar EXEC dbo.migracion
drop procedure migracion
exec migracion

create procedure migracion
as
BEGIN

-- Rol
insert dbo.Rol(Nombre)
values('Cliente')

insert dbo.Rol(Nombre)
values('Administrador')

--Cliente
Insert dbo.Cliente(Nombre, Apellido,DNI,Direccion,Telefono,Mail,FechaNacimiento)select DISTINCT CLI_NOMBRE, CLI_APELLIDO, CLI_DNI, CLI_DIRECCION, CLI_TELEFONO, CLI_MAIL, CLI_FECHA_NAC
from gd_esquema.Maestra

--Modelo
Insert dbo.Modelo(Descripcion) select DISTINCT CRUCERO_MODELO
from gd_esquema.Maestra 
order by CRUCERO_MODELO

--Marca
insert dbo.Marca(Descripcion) select DISTINCT CRU_FABRICANTE
from gd_esquema.Maestra
order by CRU_FABRICANTE

-- Puerto
insert dbo.Puerto(Nombre) select DISTINCT PUERTO_DESDE
from gd_esquema.Maestra
order by PUERTO_DESDE

-- Tramo
insert dbo.Tramo(Puerto_Salida,Puerto_Llegada,Precio) select DISTINCT PUERTO_DESDE, PUERTO_HASTA, RECORRIDO_PRECIO_BASE
from gd_esquema.Maestra 

-- Recorrido
insert dbo.Recorrido(Codigo_Recorrido, PrecioTotal) select DISTINCT RECORRIDO_CODIGO, RECORRIDO_PRECIO_BASE
from gd_esquema.Maestra

-- Tipo Servicio
insert dbo.Servicio(TipoServicio,Porcentaje) select DISTINCT CABINA_TIPO, CABINA_TIPO_PORC_RECARGO
from gd_esquema.Maestra

-- Crucero

insert dbo.Crucero(IdCrucero,IdMarca,IdModelo,CantidadCabinas) select DISTINCT CRUCERO_IDENTIFICADOR, m.IdMarca, mo.IdModelo, (MAX(CABINA_NRO) * (MAX(CABINA_PISO)+1)) as TotalCabinas
from gd_esquema.Maestra
join dbo.Modelo as mo on (CRUCERO_MODELO = mo.Descripcion)
join dbo.Marca as m on (CRU_FABRICANTE = m.Descripcion)
group by CRUCERO_IDENTIFICADOR, m.IdMarca, mo.IdModelo

-- Cabina Por Crucero

insert dbo.CabinaPorCrucero(IdCrucero,TipoServicio, NroPiso, NroCabina, Estado, Fecha_Salida) select DISTINCT CRUCERO_IDENTIFICADOR, CABINA_TIPO, CABINA_PISO, CABINA_NRO, 'Ocupado',  FECHA_SALIDA 
from gd_esquema.Maestra
where RESERVA_CODIGO IS NULL
order by CRUCERO_IDENTIFICADOR, FECHA_SALIDA 

-- Viaje

insert dbo.Viaje(IdCrucero, IdRecorrido, Fecha_Salida, Fecha_Llegada, CodigoRecorrido) select DISTINCT CRUCERO_IDENTIFICADOR, MAX(r.IdRecorrido), FECHA_SALIDA,FECHA_LLEGADA, MAX(RECORRIDO_CODIGO)
from gd_esquema.Maestra
join dbo.Recorrido as r on RECORRIDO_CODIGO = r.Codigo_Recorrido and RECORRIDO_PRECIO_BASE = r.PrecioTotal
where RESERVA_FECHA IS NULL
group by CRUCERO_IDENTIFICADOR, FECHA_SALIDA, FECHA_LLEGADA

-- Pasaje

insert dbo.Pasaje(IdCliente, IdViaje, NroPiso,NroCabina,Fecha_Salida, Fecha_Pago) select DISTINCT c.IdCliente,v.IdViaje, g.CABINA_PISO, g.CABINA_NRO, g.FECHA_SALIDA, g.PASAJE_FECHA_COMPRA
from gd_esquema.Maestra as g
join dbo.Cliente as c on c.Nombre = g.CLI_NOMBRE and c.Apellido = g.CLI_APELLIDO and c.DNI = g.CLI_DNI
join dbo.Viaje as v on v.IdCrucero = g.CRUCERO_IDENTIFICADOR and v.Fecha_Salida = g.FECHA_SALIDA and v.CodigoRecorrido = g.RECORRIDO_CODIGO
where g.RESERVA_FECHA IS NULL 

insert dbo.Reserva(IdCliente, IdViaje, NroPiso,NroCabina,Fecha_Salida, Fecha_Reserva) select DISTINCT c.IdCliente,v.IdViaje, g.CABINA_PISO, g.CABINA_NRO, g.FECHA_SALIDA, g.RESERVA_FECHA
from gd_esquema.Maestra as g
join dbo.Cliente as c on c.Nombre = g.CLI_NOMBRE and c.Apellido = g.CLI_APELLIDO and c.DNI = g.CLI_DNI
join dbo.Viaje as v on v.IdCrucero = g.CRUCERO_IDENTIFICADOR and v.Fecha_Salida = g.FECHA_SALIDA and v.CodigoRecorrido = g.RECORRIDO_CODIGO
where g.PASAJE_FECHA_COMPRA IS NULL

END


-- Para realizar los borrados de las tablas (Esta en orden):

drop procedure dbo.BorrarTodo
exec dbo.migracion

create procedure dbo.BorrarTodo
AS
BEGIN
delete from dbo.CabinaPorCrucero
delete from dbo.RecorridoPorTramo
delete from dbo.Pasaje
delete from dbo.Reserva
delete from dbo.Cliente
delete from dbo.Viaje
delete from dbo.Servicio
delete from dbo.Tramo
delete from dbo.Puerto
delete from dbo.Recorrido
delete from dbo.Crucero
delete from dbo.Modelo
delete from dbo.Marca
delete from dbo.FueraDeServicio
delete from dbo.Reserva
delete from dbo.FuncionalidadPorRol
delete from dbo.Rol
delete from dbo.Funcionalidad
delete from dbo.Administrador

end

create procedure BorrarTablas
as
begin
drop table FuncionalidadPorRol
drop table Funcionalidad
drop table Administrador
drop table Reserva
drop table Pasaje
drop table FueraDeServicio
drop table CabinaPorCrucero
drop table Cliente
drop table RecorridoPorTramo
drop table Servicio
drop table Tramo
drop table Viaje
drop table Recorrido
drop table Puerto
drop table Crucero
drop table Modelo
drop table Marca
drop table Rol
end




