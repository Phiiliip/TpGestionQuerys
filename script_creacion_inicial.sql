use GD1C2019

go
create schema [LOS_QUE_VAN_A_APROBAR]
go

create table [LOS_QUE_VAN_A_APROBAR].Modelo(
IdModelo int IDENTITY(1,1) PRIMARY KEY,
Descripcion nvarchar (50) NOT NULL,
);

--- Marca

create table [LOS_QUE_VAN_A_APROBAR].Marca(
IdMarca int IDENTITY(1,1) PRIMARY KEY,
Descripcion nvarchar (255) NOT NULL,
);

-- Servicio

create table [LOS_QUE_VAN_A_APROBAR].Servicio(
TipoServicio nVARCHAR(255) PRIMARY KEY,
Porcentaje decimal(18,2),
);


-- Crucero

create table [LOS_QUE_VAN_A_APROBAR].Crucero(
IdCrucero nvarchar(50) PRIMARY KEY,
IdMarca int REFERENCES LOS_QUE_VAN_A_APROBAR.MARCA(IdMarca),
IdModelo int REFERENCES LOS_QUE_VAN_A_APROBAR.MODELO(IdModelo),
FechaAlta DATETIME2(3) DEFAULT(SYSDATETIME()),
CantidadCabinas int,
);

-- Fuera de servicio

create table [LOS_QUE_VAN_A_APROBAR].FueraDeServicio(
IdFDS int IDENTITY(1,1) PRIMARY KEY,
IdCrucero nvarchar(50) REFERENCES LOS_QUE_VAN_A_APROBAR.Crucero(IdCrucero),
FechaBaja DATETIME2(3),
MotivoBaja VARCHAR(50),
FechaReinicio DATETIME2(3),
);

-- Cabina por crucero

create table [LOS_QUE_VAN_A_APROBAR].CabinaPorCrucero(
IdCPC int IDENTITY(1,1) PRIMARY KEY,
IdCrucero nvarchar(50) REFERENCES LOS_QUE_VAN_A_APROBAR.Crucero(IdCrucero),
TipoServicio nvarchar(255) REFERENCES LOS_QUE_VAN_A_APROBAR.Servicio(TipoServicio),
NroPiso decimal(18,0),
NroCabina decimal(18,0),
Estado NVARCHAR(12) DEFAULT('Disponible'),
Fecha_Salida DATETIME2(3),
CHECK(Estado IN ('Disponible','Ocupado'))
);

-- Puerto

create table [LOS_QUE_VAN_A_APROBAR].Puerto(
Nombre nvarchar(255) PRIMARY KEY,
Descripcion VARCHAR(50) NULL,
);

-- Tramo

create table [LOS_QUE_VAN_A_APROBAR].Tramo(
IdTramo int IDENTITY(1,1) PRIMARY KEY,
Puerto_Salida nvarchar(255) REFERENCES LOS_QUE_VAN_A_APROBAR.PUERTO(NOMBRE),
Puerto_Llegada nvarchar(255) REFERENCES LOS_QUE_VAN_A_APROBAR.PUERTO(NOMBRE),
Precio decimal(18,2),
check(Puerto_Salida != Puerto_Llegada),
);


-- Recorrido

create table [LOS_QUE_VAN_A_APROBAR].Recorrido(
IdRecorrido int IDENTITY(1,1) PRIMARY KEY,
Codigo_Recorrido decimal(18,0) NOT NULL,
Descripcion VARCHAR(50),
PrecioTotal decimal(18,2),
Estado NVARCHAR(20) DEFAULT('Habilitado'),
check(Estado in('Habilitado','Inhabilitado'))
);

-- Recorrido por tramo

create table [LOS_QUE_VAN_A_APROBAR].RecorridoPorTramo(
CodigoRecorrido int REFERENCES LOS_QUE_VAN_A_APROBAR.Recorrido(IdRecorrido),
CodigoTramo int REFERENCES LOS_QUE_VAN_A_APROBAR.Tramo(IdTramo),
PrecioTramo decimal(18,2),
);

-- Viaje

create table [LOS_QUE_VAN_A_APROBAR].Viaje(
IdViaje int IDENTITY(1,1) PRIMARY KEY,
IdCrucero nvarchar(50) REFERENCES LOS_QUE_VAN_A_APROBAR.Crucero(IdCrucero),
IdRecorrido int REFERENCES LOS_QUE_VAN_A_APROBAR.Recorrido(IdRecorrido),
Fecha_Salida DATETIME2(3),
Fecha_Llegada DATETIME2(3),
CodigoRecorrido DECIMAL(18,0),
check(Fecha_Llegada > Fecha_Salida),
);

-- Rol

create table [LOS_QUE_VAN_A_APROBAR].Rol(
IdRol int IDENTITY(1,1) PRIMARY KEY,
Estado NVARCHAR(20) DEFAULT('Habilitado'),
Nombre NVARCHAR(20) UNIQUE,
check(Estado in('Habilitado','Inhabilitado'))
);


-- Cliente

create table [LOS_QUE_VAN_A_APROBAR].Cliente(
IdCliente int IDENTITY(1,1) PRIMARY KEY,
IdRol int REFERENCES LOS_QUE_VAN_A_APROBAR.Rol(IdRol) DEFAULT(1),
Nombre nVARCHAR(255),
Apellido nVARCHAR(255),
DNI decimal(18,0),
Direccion nVARCHAR(255),
Telefono int,
Mail nVARCHAR(255) NULL,
FechaNacimiento DATETIME2(3),
);

-- Reserva

create table [LOS_QUE_VAN_A_APROBAR].Reserva(
IdReserva int IDENTITY(1,1) PRIMARY KEY,
IdCliente int REFERENCES LOS_QUE_VAN_A_APROBAR.Cliente(IdCliente),
IdViaje int REFERENCES LOS_QUE_VAN_A_APROBAR.Viaje(IdViaje),
NroPiso int,
NroCabina int,
Fecha_Salida DATETIME2(3),
Fecha_Reserva DATETIME2(3),
);

-- Pasaje

create table [LOS_QUE_VAN_A_APROBAR].Pasaje(
IdPasaje int IDENTITY(1,1) PRIMARY KEY,
IdCliente int REFERENCES LOS_QUE_VAN_A_APROBAR.Cliente(IdCliente),
IdViaje int REFERENCES LOS_QUE_VAN_A_APROBAR.Viaje(IdViaje),
NroPiso int,
NroCabina int,
Fecha_Salida DATETIME2(3),
Fecha_Pago DATETIME2(3),
);

-- Funcionalidad

create table [LOS_QUE_VAN_A_APROBAR].Funcionalidad(
IdFuncionalidad int IDENTITY(1,1) PRIMARY KEY,
Descripcion NVARCHAR(255)
);

-- Funcionalidad Por Rol

create table [LOS_QUE_VAN_A_APROBAR].FuncionalidadPorRol(
IdFuncionalidad int REFERENCES LOS_QUE_VAN_A_APROBAR.Funcionalidad(IdFuncionalidad),
IdRol int REFERENCES LOS_QUE_VAN_A_APROBAR.Rol(IdRol),
Estado NVARCHAR(20) DEFAULT('Habilitado'),
check(Estado in('Habilitado','Inhabilitado'))
);

-- Administrador

create table [LOS_QUE_VAN_A_APROBAR].Administrador(
NombreUsuario NVARCHAR(100) UNIQUE,
Contraseña NVARCHAR(255),
IdRol int REFERENCES LOS_QUE_VAN_A_APROBAR.Rol(IdRol) Default(2),
PRIMARY KEY(NombreUsuario,Contraseña)
);

-- Rol
insert LOS_QUE_VAN_A_APROBAR.Rol(Nombre)
values('Cliente')

insert LOS_QUE_VAN_A_APROBAR.Rol(Nombre)
values('Administrador')

--Cliente
Insert LOS_QUE_VAN_A_APROBAR.Cliente(Nombre, Apellido,DNI,Direccion,Telefono,Mail,FechaNacimiento)select DISTINCT CLI_NOMBRE, CLI_APELLIDO, CLI_DNI, CLI_DIRECCION, CLI_TELEFONO, CLI_MAIL, CLI_FECHA_NAC
from gd_esquema.Maestra

--Modelo
Insert LOS_QUE_VAN_A_APROBAR.Modelo(Descripcion) select DISTINCT CRUCERO_MODELO
from gd_esquema.Maestra 
order by CRUCERO_MODELO

--Marca
insert LOS_QUE_VAN_A_APROBAR.Marca(Descripcion) select DISTINCT CRU_FABRICANTE
from gd_esquema.Maestra
order by CRU_FABRICANTE

-- Puerto
insert LOS_QUE_VAN_A_APROBAR.Puerto(Nombre) select DISTINCT PUERTO_DESDE
from gd_esquema.Maestra
order by PUERTO_DESDE

-- Tramo
insert LOS_QUE_VAN_A_APROBAR.Tramo(Puerto_Salida,Puerto_Llegada,Precio) select DISTINCT PUERTO_DESDE, PUERTO_HASTA, RECORRIDO_PRECIO_BASE
from gd_esquema.Maestra 

-- Recorrido
insert LOS_QUE_VAN_A_APROBAR.Recorrido(Codigo_Recorrido, PrecioTotal) select DISTINCT RECORRIDO_CODIGO, RECORRIDO_PRECIO_BASE
from gd_esquema.Maestra

-- Tipo Servicio
insert LOS_QUE_VAN_A_APROBAR.Servicio(TipoServicio,Porcentaje) select DISTINCT CABINA_TIPO, CABINA_TIPO_PORC_RECARGO
from gd_esquema.Maestra

-- Crucero

insert LOS_QUE_VAN_A_APROBAR.Crucero(IdCrucero,IdMarca,IdModelo,CantidadCabinas) select DISTINCT CRUCERO_IDENTIFICADOR, m.IdMarca, mo.IdModelo, (MAX(CABINA_NRO) * (MAX(CABINA_PISO)+1)) as TotalCabinas
from gd_esquema.Maestra
join LOS_QUE_VAN_A_APROBAR.Modelo as mo on (CRUCERO_MODELO = mo.Descripcion)
join LOS_QUE_VAN_A_APROBAR.Marca as m on (CRU_FABRICANTE = m.Descripcion)
group by CRUCERO_IDENTIFICADOR, m.IdMarca, mo.IdModelo

-- Cabina Por Crucero

insert LOS_QUE_VAN_A_APROBAR.CabinaPorCrucero(IdCrucero,TipoServicio, NroPiso, NroCabina, Estado, Fecha_Salida) select DISTINCT CRUCERO_IDENTIFICADOR, CABINA_TIPO, CABINA_PISO, CABINA_NRO, 'Ocupado',  FECHA_SALIDA 
from gd_esquema.Maestra
where RESERVA_CODIGO IS NULL
order by CRUCERO_IDENTIFICADOR, FECHA_SALIDA 

-- Viaje

insert LOS_QUE_VAN_A_APROBAR.Viaje(IdCrucero, IdRecorrido, Fecha_Salida, Fecha_Llegada, CodigoRecorrido) select DISTINCT CRUCERO_IDENTIFICADOR, MAX(r.IdRecorrido), FECHA_SALIDA,FECHA_LLEGADA, MAX(RECORRIDO_CODIGO)
from gd_esquema.Maestra
join LOS_QUE_VAN_A_APROBAR.Recorrido as r on RECORRIDO_CODIGO = r.Codigo_Recorrido and RECORRIDO_PRECIO_BASE = r.PrecioTotal
where RESERVA_FECHA IS NULL
group by CRUCERO_IDENTIFICADOR, FECHA_SALIDA, FECHA_LLEGADA

-- Pasaje

insert LOS_QUE_VAN_A_APROBAR.Pasaje(IdCliente, IdViaje, NroPiso,NroCabina,Fecha_Salida, Fecha_Pago) select DISTINCT c.IdCliente,v.IdViaje, g.CABINA_PISO, g.CABINA_NRO, g.FECHA_SALIDA, g.PASAJE_FECHA_COMPRA
from gd_esquema.Maestra as g
join LOS_QUE_VAN_A_APROBAR.Cliente as c on c.Nombre = g.CLI_NOMBRE and c.Apellido = g.CLI_APELLIDO and c.DNI = g.CLI_DNI
join LOS_QUE_VAN_A_APROBAR.Viaje as v on v.IdCrucero = g.CRUCERO_IDENTIFICADOR and v.Fecha_Salida = g.FECHA_SALIDA and v.CodigoRecorrido = g.RECORRIDO_CODIGO
where g.RESERVA_FECHA IS NULL 

insert LOS_QUE_VAN_A_APROBAR.Reserva(IdCliente, IdViaje, NroPiso,NroCabina,Fecha_Salida, Fecha_Reserva) select DISTINCT c.IdCliente,v.IdViaje, g.CABINA_PISO, g.CABINA_NRO, g.FECHA_SALIDA, g.RESERVA_FECHA
from gd_esquema.Maestra as g
join LOS_QUE_VAN_A_APROBAR.Cliente as c on c.Nombre = g.CLI_NOMBRE and c.Apellido = g.CLI_APELLIDO and c.DNI = g.CLI_DNI
join LOS_QUE_VAN_A_APROBAR.Viaje as v on v.IdCrucero = g.CRUCERO_IDENTIFICADOR and v.Fecha_Salida = g.FECHA_SALIDA and v.CodigoRecorrido = g.RECORRIDO_CODIGO
where g.PASAJE_FECHA_COMPRA IS NULL


-- Funcionalidades

insert LOS_QUE_VAN_A_APROBAR.Funcionalidad(Descripcion)
values('Menu CyR'),('Menu puerto'),('Menu viajes'),('Menu rol'),('Menu crucero'),('Menu recorrido'),('Menu estadistico')

-- Funcionalidad por rol

insert LOS_QUE_VAN_A_APROBAR.FuncionalidadPorRol(IdFuncionalidad,IdRol)
values (1,2),(2,2),(3,2),(4,2),(5,2),(6,2),(7,2)


--

--

-- Vistas

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
select C.IdCrucero, M.Descripcion as Marca, Mo.Descripcion as Modelo, C.CantidadCabinas
from LOS_QUE_VAN_A_APROBAR.Crucero as c
join LOS_QUE_VAN_A_APROBAR.Marca as M on c.IdMarca = M.IdMarca
join LOS_QUE_VAN_A_APROBAR.Modelo as Mo on c.IdModelo = Mo.IdModelo
where c.FechaAlta < SYSDATETIME()

GO
create view LOS_QUE_VAN_A_APROBAR.ListarCrucerosInhabilitados
as
select C.IdCrucero, M.Descripcion as Marca, Mo.Descripcion as Modelo, C.CantidadCabinas
from LOS_QUE_VAN_A_APROBAR.Crucero as c
join LOS_QUE_VAN_A_APROBAR.Marca as M on c.IdMarca = M.IdMarca
join LOS_QUE_VAN_A_APROBAR.Modelo as Mo on c.IdModelo = Mo.IdModelo
where c.FechaAlta IS NULL
GO



-- Procedures

-- LOGIN Y SEGURIDAD:

-- Validacion de Login
GO
create procedure LOS_QUE_VAN_A_APROBAR.ValidarAdministrador(@Username NVARCHAR(100), @Password NVARCHAR(100))
as
begin
if exists(select *  from LOS_QUE_VAN_A_APROBAR.Administrador
where NombreUsuario = @Username and Contraseña = HASHBYTES('SHA2_256', @Password))
	begin
	return 1
	end
else 
	begin
	return 0
	end
end
GO

-- Creacion de administrador
create procedure LOS_QUE_VAN_A_APROBAR.CrearAdministrador(@Username NVARCHAR(100), @Password NVARCHAR(100))
as
begin
insert LOS_QUE_VAN_A_APROBAR.Administrador(NombreUsuario,Contraseña)
values (@Username, HASHBYTES('SHA2_256', @Password))
end
GO
--


-- ROL

create procedure LOS_QUE_VAN_A_APROBAR.NuevoRol (@NuevoNombre NVARCHAR(20))
as
begin
insert into LOS_QUE_VAN_A_APROBAR.Rol(Nombre)
values (@Nuevonombre)
end
GO
--

create procedure LOS_QUE_VAN_A_APROBAR.NuevaFuncionalidad(@NuevoNombre NVARCHAR(255))
as 
begin
insert into LOS_QUE_VAN_A_APROBAR.Funcionalidad(Descripcion)
values(@NuevoNombre)
end
GO
--

create procedure LOS_QUE_VAN_A_APROBAR.FuncionalidadParaRol(@IdRol int, @IdFuncionalidad int)
as
begin
insert into LOS_QUE_VAN_A_APROBAR.FuncionalidadPorRol(IdFuncionalidad, IdRol) 
values (@IdFuncionalidad, @IdRol)
end
GO
/* Consulta sobre rol y funcionalidad
select f.Descripcion as Funcionalidad, r.nombre as Rol, fpr.Estado 
from LOS_QUE_VAN_A_APROBAR.FuncionalidadPorRol as fpr
join LOS_QUE_VAN_A_APROBAR.Funcionalidad as f on fpr.IdFuncionalidad = f.IdFuncionalidad
join LOS_QUE_VAN_A_APROBAR.Rol as r on r.IdRol = fpr.IdRol */

--
create procedure LOS_QUE_VAN_A_APROBAR.ModificarRol(@IdRol int, @Nombre NVARCHAR(20))
as
begin
update LOS_QUE_VAN_A_APROBAR.Rol
set Nombre = @Nombre
where IdRol = @IdRol
end
GO
--

create procedure LOS_QUE_VAN_A_APROBAR.BajaRol(@NombreRol NVARCHAR(20))
as
begin
update LOS_QUE_VAN_A_APROBAR.Rol
set Estado = 'Inhabilitado'
where Nombre = @NombreRol
end
GO
--

Create procedure LOS_QUE_VAN_A_APROBAR.AltaRol(@IdRol int)
as
begin
update LOS_QUE_VAN_A_APROBAR.Rol
set Estado = 'Habilitado'
where IdRol = @Idrol
end
GO
--

create procedure LOS_QUE_VAN_A_APROBAR.BajaFuncionalidadDelRol(@IdRol int, @IdFuncionalidad int)
as
begin
update LOS_QUE_VAN_A_APROBAR.FuncionalidadPorRol
set Estado = 'Inhabilitado'
where IdRol = @IdRol and IdFuncionalidad = @IdFuncionalidad
end
GO
--

create procedure LOS_QUE_VAN_A_APROBAR.AltaFuncionalidadDelRol(@IdRol int, @IdFuncionalidad int)
as
begin
update LOS_QUE_VAN_A_APROBAR.FuncionalidadPorRol
set Estado = 'Habilitado'
where IdRol = @IdRol and IdFuncionalidad = @IdFuncionalidad
end
GO

--








-- PUERTO

-- Crear puerto
create procedure LOS_QUE_VAN_A_APROBAR.CrearPuerto(@NombrePuerto NVARCHAR(255), @Descripcion VARCHAR(50))
as
begin
insert into LOS_QUE_VAN_A_APROBAR.Puerto(Nombre,Descripcion)
values(@NombrePuerto,@Descripcion)
end
GO
-- Modificar puerto
create procedure LOS_QUE_VAN_A_APROBAR.ModificarPuerto(@NombrePuerto NVARCHAR(255), @Descripcion VARCHAR(50))
as
begin
update LOS_QUE_VAN_A_APROBAR.Puerto
set Descripcion = @Descripcion
where Nombre = @NombrePuerto
end

GO

-- Dar De baja
GO
create Procedure LOS_QUE_VAN_A_APROBAR. EliminarPuerto(@NombrePuertoBorrado NVARCHAR(255)) 
as 
begin
declare @IdRecorrido int
declare @IdTramo int
declare MiCursor CURSOR for
select CodigoRecorrido, IdTramo from LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo r
join LOS_QUE_VAN_A_APROBAR.Tramo t on t.IdTramo = r.CodigoTramo
where Puerto_Llegada = @NombrePuertoBorrado or Puerto_Salida = @NombrePuertoBorrado

open MiCursor 
fetch next from MiCursor into @IdRecorrido, @IdTramo

while @@FETCH_STATUS = 0

BEGIN

delete from LOS_QUE_VAN_A_APROBAR.Reserva
where IdViaje in(select IdViaje from Viaje v
where IdRecorrido = @IdRecorrido)

delete from LOS_QUE_VAN_A_APROBAR.Pasaje
where IdViaje in(select IdViaje from Viaje v
where IdRecorrido = @IdRecorrido)

delete from LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo 
where CodigoRecorrido = @IdRecorrido

delete from LOS_QUE_VAN_A_APROBAR.Viaje
where IdViaje in (select IdViaje from Viaje v
where IdRecorrido = @IdRecorrido)

delete from LOS_QUE_VAN_A_APROBAR.Recorrido
where IdRecorrido = @IdRecorrido

fetch next from MiCursor into @IdRecorrido, @IdTramo

END

close MiCursor
deallocate MiCursor

delete from LOS_QUE_VAN_A_APROBAR.Tramo
where Puerto_Salida = @NombrePuertoBorrado OR Puerto_Llegada = @NombrePuertoBorrado

delete from LOS_QUE_VAN_A_APROBAR.Puerto 
where Nombre = @NombrePuertoBorrado

END
GO
--







-- Recorrido

Create procedure LOS_QUE_VAN_A_APROBAR.CrearRecorrido(@CodigoRecorrido decimal(18,2), @Descripcion varchar(50), @Precio decimal(18,2))
AS
BEGIN
INSERT INTO LOS_QUE_VAN_A_APROBAR.Recorrido(Codigo_Recorrido, Descripcion, PrecioTotal)
VALUES (@CodigoRecorrido, @Descripcion, @Precio)
END
GO
--Crear tramo de recorrido

CREATE PROCEDURE LOS_QUE_VAN_A_APROBAR.InsertarTramoDeRecorrido(@CodigoRecorrido int, @CodigoTramo int, @Precio decimal(18,2))
AS
BEGIN
INSERT INTO LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo(CodigoRecorrido, CodigoTramo, PrecioTramo)
values( @CodigoRecorrido, @CodigoTramo, @Precio)
END
GO
--modificar tramo de recorrido

Create PROCEDURE LOS_QUE_VAN_A_APROBAR.modificarTramoDeRecorrido(@IdRecorrido int,@TramoViejo int, @TramoNuevo int)
AS
BEGIN

update LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo
set CodigoTramo = @TramoNuevo
WHERE CodigoRecorrido = @IdRecorrido AND CodigoTramo = @TramoViejo

end
GO


--DAR DE BAJA RECORRIDO
CREATE PROCEDURE LOS_QUE_VAN_A_APROBAR.BajaRecorrido(@IdRecorrido int)
AS
BEGIN

IF NOT EXISTS (SELECT R.IdRecorrido
FROM LOS_QUE_VAN_A_APROBAR.Pasaje p
 JOIN LOS_QUE_VAN_A_APROBAR.Viaje v ON (v.IdViaje = p.IdViaje)
 JOIN LOS_QUE_VAN_A_APROBAR.Recorrido r ON (v.IdRecorrido = r.IdRecorrido)
WHERE p.Fecha_Salida > GETDATE() AND r.IdRecorrido = @IdRecorrido
)

BEGIN
UPDATE LOS_QUE_VAN_A_APROBAR.Recorrido
SET  Estado = 'Inhabilitado'
WHERE IdRecorrido = @IdRecorrido
END

ELSE
BEGIN
PRINT 'Hay pasajes vendidos para un viaje que todavía no se realizó'
END

END
GO






--



-- CRUCERO

-- Creacion de un crucero

create procedure LOS_QUE_VAN_A_APROBAR.AltaCrucero(@IdCrucero NVARCHAR(50), @IdMarca int, @IdModelo int, @CantidadCabinas int)
as
begin
insert LOS_QUE_VAN_A_APROBAR.Crucero(IdCrucero,IdMarca,IdModelo,FechaAlta,CantidadCabinas)
values(@IdCrucero,@IdMarca,@IdModelo,SYSDATETIME(), @CantidadCabinas)
end
GO
-- Modificar Marca de crucero

create procedure LOS_QUE_VAN_A_APROBAR.ModificarMarca(@IdCrucero NVARCHAR(50), @IdMarca int)
as 
begin
update LOS_QUE_VAN_A_APROBAR.Crucero
set IdCrucero = @IdCrucero, IdMarca = @IdMarca
end
GO

-- Modificar Modelo de crucero

create procedure LOS_QUE_VAN_A_APROBAR.ModificarModelo(@IdCrucero NVARCHAR(50), @IdModelo int)
as
begin
update LOS_QUE_VAN_A_APROBAR.Crucero
set IdCrucero = @IdCrucero, IdModelo = @IdModelo
end
GO
-- Baja definitiva de crucero

create procedure LOS_QUE_VAN_A_APROBAR.BajaDefinitiva(@IdCrucero NVARCHAR(50))
as 
begin
update LOS_QUE_VAN_A_APROBAR.Crucero
set FechaAlta = NULL
where IdCrucero = @IdCrucero

insert LOS_QUE_VAN_A_APROBAR.FueraDeServicio(IdCrucero,FechaBaja,MotivoBaja)
values(@IdCrucero, SYSDATETIME(), 'Vida util finalizada')

end
GO
-- Baja fuera de servicio

create procedure LOS_QUE_VAN_A_APROBAR.BajaFueraDeServicio(@IdCrucero NVARCHAR(50), @FechaDeAlta datetime2(3))
as
begin
update LOS_QUE_VAN_A_APROBAR.Crucero
set FechaAlta = @FechaDeAlta
where IdCrucero = @IdCrucero

insert LOS_QUE_VAN_A_APROBAR.FueraDeServicio(IdCrucero, FechaBaja, MotivoBaja, FechaReinicio)
values(@IdCrucero,SYSDATETIME(), 'Fuera de servicio', @FechaDeAlta)

end
GO


--









-- VIAJE

-- Creacion de un viaje

create procedure LOS_QUE_VAN_A_APROBAR.CrearViaje(@IdCrucero nvarchar(50), @IdRecorrido int, @Fecha_Salida datetime2(3), @Fecha_Llegada datetime2(3), @CodigoRecorrido decimal(18,0))
as
begin
insert LOS_QUE_VAN_A_APROBAR.Viaje(IdCrucero,IdRecorrido,Fecha_Salida,Fecha_Llegada,CodigoRecorrido)
values(@IdCrucero,@IdRecorrido,@Fecha_Salida, @Fecha_Llegada, @CodigoRecorrido)
end
GO




-- Funciones


create function LOS_QUE_VAN_A_APROBAR.ObtenerNuevoRolInsertado()
returns int as
begin
return (select TOP(1) IdRol from LOS_QUE_VAN_A_APROBAR.Rol order by IdRol DESC)
end
GO


-- Triggers

-- ROL

-- Cuando se inhabilita un rol, todos los usuarios con ese rol pierden su rol

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

