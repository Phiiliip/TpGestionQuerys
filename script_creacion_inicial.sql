use GD1C2019


create schema [LOS_QUE_VAN_A_APROBAR]


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
Estado NVARCHAR(20) DEFAULT('Disponible'),
check(Estado in('Disponible','Expirada'))
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

-- Tabla de fecha

create table [LOS_QUE_VAN_A_APROBAR].TablaFecha(
Fecha DATETIME2(3) PRIMARY KEY
);

insert LOS_QUE_VAN_A_APROBAR.TablaFecha(Fecha)
values(SYSDATETIME())

-- Rol
insert LOS_QUE_VAN_A_APROBAR.Rol(Nombre)
values('Cliente')

insert LOS_QUE_VAN_A_APROBAR.Rol(Nombre)
values('Administrador')

-- Administradores de prueba:

insert LOS_QUE_VAN_A_APROBAR.Administrador(NombreUsuario,Contraseña)
values('FelipeOtero','w23e')

insert LOS_QUE_VAN_A_APROBAR.Administrador(NombreUsuario,Contraseña)
values('EmanuelSedlar','w23e')

insert LOS_QUE_VAN_A_APROBAR.Administrador(NombreUsuario,Contraseña)
values('NicolasMarchesotti','w23e')

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

insert LOS_QUE_VAN_A_APROBAR.Reserva(IdCliente, IdViaje, NroPiso,NroCabina,Fecha_Salida, Fecha_Reserva, Estado) select DISTINCT c.IdCliente,v.IdViaje, g.CABINA_PISO, g.CABINA_NRO, g.FECHA_SALIDA, g.RESERVA_FECHA , 'Expirada'
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

--------------------------------------------- PROCEDURES ---------------------------------------------











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




-----------------------------------------------------------ROL----------------------------------------------------------------------------







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

create procedure LOS_QUE_VAN_A_APROBAR.BajaRol(@IdRol int)
as
begin
update LOS_QUE_VAN_A_APROBAR.Rol
set Estado = 'Inhabilitado'
where IdRol = @IdRol
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


--
create procedure LOS_QUE_VAN_A_APROBAR.BajaFuncionalidadDeRol(@IdRol int, @IdFuncionalidad int)
as
begin
update LOS_QUE_VAN_A_APROBAR.FuncionalidadPorRol
set Estado = 'Inhabilitado'
where IdRol = @IdRol and IdFuncionalidad = @IdFuncionalidad
end
GO


create procedure LOS_QUE_VAN_A_APROBAR.BajaFuncionalidadesDelRol(@IdRol int)
as
begin
update LOS_QUE_VAN_A_APROBAR.FuncionalidadPorRol
set Estado = 'Inhabilitado'
where IdRol = @IdRol
end
GO
--

create procedure LOS_QUE_VAN_A_APROBAR.AltaFuncionalidadDelRol(@IdRol int, @IdFuncionalidad int)
as
begin
if EXISTS (SELECT 1 from LOS_QUE_VAN_A_APROBAR.FuncionalidadPorRol where IdRol = @IdRol and IdFuncionalidad = @IdFuncionalidad)
begin
	update LOS_QUE_VAN_A_APROBAR.FuncionalidadPorRol
	set Estado = 'Habilitado'
	where IdRol = @IdRol and IdFuncionalidad = @IdFuncionalidad
end
else
begin
	insert into LOS_QUE_VAN_A_APROBAR.FuncionalidadPorRol(IdFuncionalidad, IdRol)
	values(@IdFuncionalidad, @IdRol)
end
end
GO


--





-------------------------------------------------------PUERTO--------------------------------------------------













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





---------------------------------------------------------------RECORRIDO------------------------------------------------------------------------






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





----------------------------------------------------------------------CRUCERO--------------------------------------






--




-- Creacion de un crucero

create procedure LOS_QUE_VAN_A_APROBAR.AltaCrucero(@IdCrucero NVARCHAR(50), @IdMarca int, @IdModelo int, @CantidadCabinas int)
as
begin
insert LOS_QUE_VAN_A_APROBAR.Crucero(IdCrucero,IdMarca,IdModelo,FechaAlta,CantidadCabinas)
values(@IdCrucero,@IdMarca,@IdModelo,SYSDATETIME(), @CantidadCabinas)
end
GO
-- Modificar Marca y modelo de crucero

create procedure LOS_QUE_VAN_A_APROBAR.ModificarMarcaYModelo(@IdCrucero NVARCHAR(50), @IdMarca int, @IdModelo int)
as 
begin
update LOS_QUE_VAN_A_APROBAR.Crucero
set IdMarca = @IdMarca, IdModelo = @IdModelo
where IdCrucero = @IdCrucero
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










--------------------------------------------------------VIAJE------------------------------------------



-- VIAJE

-- Creacion de un viaje

CREATE PROCEDURE LOS_QUE_VAN_A_APROBAR.GenerarViaje(@IdCrucero nvarchar(50), @IdRecorrido int, @Fecha_Salida datetime2(3), @Fecha_Llegada datetime2(3), @CodigoRecorrido decimal(18,2))
AS
BEGIN

DECLARE @Fecha_Actual datetime2(3)

set @Fecha_Actual = (select top 1 * from LOS_QUE_VAN_A_APROBAR.TablaFecha)

if CONVERT(datetime2(3),@Fecha_Salida) > CONVERT(datetime2(3), @Fecha_Actual)
BEGIN
	insert into LOS_QUE_VAN_A_APROBAR.Viaje(IdCrucero, IdRecorrido, Fecha_Salida, Fecha_Llegada, CodigoRecorrido)
	values(@IdCrucero, @IdRecorrido, @Fecha_Salida, @Fecha_Llegada, @CodigoRecorrido)
END

ELSE
	Print 'la fecha de salida debe ser mayor a la actual' -- ver como pasar error a visual
END
GO












------------------------------------------PAGO Y CHEQUEO DE RESERVAS------------------------------------------


CREATE PROCEDURE LOS_QUE_VAN_A_APROBAR.PagarReserva(@IdReserva int)
AS
BEGIN

DECLARE @Fecha_Actual datetime2(3)

DECLARE @IdCliente int
DECLARE @IdViaje int
DECLARE @NroPiso int
DECLARE @NroCabina int
DECLARE @Fecha_Salida datetime2(3)

set @Fecha_Actual = (select top 1 * from LOS_QUE_VAN_A_APROBAR.TablaFecha)

IF EXISTS (SELECT 1 FROM LOS_QUE_VAN_A_APROBAR.Reserva WHERE IdReserva = @IdReserva AND Estado = 'Disponible')
	BEGIN

		select @IdCliente = IdCliente, @IdViaje = IdViaje, @NroPiso = NroPiso, @NroCabina = NroCabina, @Fecha_Salida = Fecha_Salida
		from LOS_QUE_VAN_A_APROBAR.Reserva WHERE IdReserva = @IdReserva

		update LOS_QUE_VAN_A_APROBAR.Reserva
		set Estado = 'Expirada'
		WHERE IdReserva = @IdReserva

		insert into LOS_QUE_VAN_A_APROBAR.Pasaje(IdCliente, IdViaje, NroPiso, NroCabina, Fecha_Salida, Fecha_Pago)
		VALUES(@IdCliente, @IdViaje, @NroPiso, @NroCabina, @Fecha_Salida, @Fecha_Actual)

		
	END
END
GO


CREATE PROCEDURE LOS_QUE_VAN_A_APROBAR.ChequearReservas
AS
BEGIN

DECLARE @Fecha_Actual datetime2(3)

DECLARE @IdReserva int
DECLARE @IdCliente int
DECLARE @IdViaje int
DECLARE @NroPiso int
DECLARE @NroCabina int
DECLARE @Fecha_Salida datetime2(3)
DECLARE @Fecha_Reserva datetime2(3)
DECLARE @IdCrucero nvarchar(50)

SET @Fecha_Actual = (select top 1 * from LOS_QUE_VAN_A_APROBAR.TablaFecha)

DECLARE cur CURSOR FOR
 SELECT IdReserva, IdCliente, IdViaje, NroPiso, NroCabina, Fecha_Salida, Fecha_Reserva
 FROM LOS_QUE_VAN_A_APROBAR.Reserva
 WHERE convert(datetime2(3),Fecha_Salida) > convert(datetime2(3),@Fecha_Actual) AND Estado = 'Disponible'
 
OPEN cur

FETCH NEXT FROM cur into @IdReserva, @IdCliente, @IdViaje, @NroPiso, @NroCabina, @Fecha_Salida, @Fecha_Reserva

WHILE @@FETCH_STATUS = 0
BEGIN
IF (DATEDIFF(day, convert(datetime2(3),@Fecha_Reserva), convert(datetime2(3),@Fecha_Actual)) > 3)
	BEGIN
	SET @IdCrucero = (SELECT TOP 1 IdCrucero FROM LOS_QUE_VAN_A_APROBAR.Viaje where IdViaje = @IdViaje)

	update LOS_QUE_VAN_A_APROBAR.CabinaPorCrucero
	SET Estado = 'Disponible'
	WHERE IdCrucero = @IdCrucero AND NroPiso = @NroPiso AND NroCabina = @NroCabina AND Fecha_Salida = @Fecha_Salida
	
	update LOS_QUE_VAN_A_APROBAR.Reserva
		set Estado = 'Expirada'
		WHERE IdReserva = @IdReserva
	END
	FETCH NEXT FROM cur into @IdReserva, @IdCliente, @IdViaje, @NroPiso, @NroCabina, @Fecha_Salida, @Fecha_Reserva
END
	close cur
	DEALLOCATE cur
END
GO











----------------------------------------------------COMPRA Y RESERVA ----------------------------------------------------


create procedure LOS_QUE_VAN_A_APROBAR.GenerarPasaje(@IdCliente int, @IdViaje int, @TipoServicio nvarchar(255),@NroPiso int, @NroCabina int, @Fecha_Salida datetime2(3))
AS
BEGIN
	
	DECLARE @Fecha_Actual datetime2(3)
	DECLARE @IdCrucero nvarchar(50)

	set @IdCrucero = (select IdCrucero from LOS_QUE_VAN_A_APROBAR.Viaje WHERE IdViaje = @IdViaje)
	SET @Fecha_Actual = (SELECT top 1 * from LOS_QUE_VAN_A_APROBAR.TablaFecha)

	IF EXISTS (select 1 from LOS_QUE_VAN_A_APROBAR.CabinaPorCrucero 
				WHERE IdCrucero = @IdCrucero AND TipoServicio = @TipoServicio AND NroPiso = @NroPiso AND @NroCabina = @NroCabina)
		BEGIN
			INSERT INTO LOS_QUE_VAN_A_APROBAR.Pasaje(IdCliente, IdViaje, NroPiso, NroCabina, Fecha_Salida, Fecha_Pago)
			values(@IdCliente, @IdViaje, @NroPiso, @NroCabina, convert(datetime2(3),@Fecha_Salida),convert(datetime2(3),@Fecha_Actual))

			UPDATE LOS_QUE_VAN_A_APROBAR.CabinaPorCrucero
			SET Estado = 'Ocupado'
			WHERE IdCrucero = @IdCrucero AND TipoServicio = @TipoServicio AND NroPiso = @NroPiso AND NroCabina = @NroCabina AND Fecha_Salida = @Fecha_Salida
		END
END
GO



create procedure LOS_QUE_VAN_A_APROBAR.GenerarReserva(@IdCliente int, @IdViaje int, @TipoServicio nvarchar(255),@NroPiso int, @NroCabina int, @Fecha_Salida datetime2(3))
AS
BEGIN
	
	DECLARE @Fecha_Actual datetime2(3)
	DECLARE @IdCrucero nvarchar(50)

	set @Fecha_Actual = (select top 1 * from LOS_QUE_VAN_A_APROBAR.TablaFecha)
	set @IdCrucero = (select IdCrucero from LOS_QUE_VAN_A_APROBAR.Viaje WHERE IdViaje = @IdViaje)
	
	IF EXISTS (select 1 from LOS_QUE_VAN_A_APROBAR.CabinaPorCrucero 
				WHERE IdCrucero = @IdCrucero AND TipoServicio = @TipoServicio AND NroPiso = @NroPiso AND @NroCabina = @NroCabina)
		BEGIN
			INSERT INTO LOS_QUE_VAN_A_APROBAR.Reserva(IdCliente, IdViaje, NroPiso, NroCabina, Fecha_Salida, Fecha_Reserva)
			values(@IdCliente, @IdViaje, @NroPiso, @NroCabina, convert(datetime2(3),@Fecha_Salida),convert(datetime2(3),@Fecha_Actual))

			set @IdCrucero = (select top 1 IdCrucero from LOS_QUE_VAN_A_APROBAR.Viaje WHERE IdViaje = @IdViaje)

			UPDATE LOS_QUE_VAN_A_APROBAR.CabinaPorCrucero
			SET Estado = 'Ocupado'
			WHERE IdCrucero = @IdCrucero AND TipoServicio = @TipoServicio AND NroPiso = @NroPiso AND NroCabina = @NroCabina AND Fecha_Salida = @Fecha_Salida
		END
END
GO


CREATE PROCEDURE LOS_QUE_VAN_A_APROBAR.IngresarCliente(@Nombre nvarchar(255), @Apellido nvarchar(255), @DNI decimal(18,0), @Direccion nvarchar(255), @Telefono int, @Mail nvarchar(255), @FechaNacimiento datetime2(3))
AS
BEGIN

	insert into LOS_QUE_VAN_A_APROBAR.Cliente(Nombre, Apellido, DNI, Direccion, Telefono, Mail, FechaNacimiento)
	values(@Nombre, @Apellido, @DNI, @Direccion, @Telefono, @Mail, @FechaNacimiento)
END
GO


create procedure LOS_QUE_VAN_A_APROBAR.TramosARecorrido
as
begin
declare @IdRecorrido int
declare @CodigoTramo int
declare @Precio decimal(18,2)
declare @Incremental decimal(18,0)
declare Cursorsito CURSOR FOR
select IdTramo, Precio from LOS_QUE_VAN_A_APROBAR.Tramo

open Cursorsito

set @Incremental = 250000

fetch next from Cursorsito into @CodigoTramo, @Precio

while @@FETCH_STATUS = 0

begin

insert into LOS_QUE_VAN_A_APROBAR.Recorrido(Codigo_Recorrido,Descripcion,PrecioTotal)
values(@Incremental,'Prueba',@Precio)

set @IdRecorrido = (select TOP(1) IdRecorrido from LOS_QUE_VAN_A_APROBAR.Recorrido order by IdRecorrido DESC)

insert into LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo(CodigoRecorrido, CodigoTramo, PrecioTramo)
values(@IdRecorrido, @CodigoTramo, @Precio)

set @Incremental = @Incremental +1

fetch next from Cursorsito into @CodigoTramo, @Precio

end

close Cursorsito
deallocate Cursorsito

end
GO

exec LOS_QUE_VAN_A_APROBAR.TramosARecorrido
GO


--- Tabla fecha

CREATE PROCEDURE LOS_QUE_VAN_A_APROBAR.ActualizarFecha(@Fecha DATETIME2(3))
as
begin
update LOS_QUE_VAN_A_APROBAR.TablaFecha
set Fecha = @Fecha
where Fecha = (select TOP(1) * from LOS_QUE_VAN_A_APROBAR.TablaFecha)
end
GO


------------------------------ Funciones ------------------------------





-------------------------------------- Validacion de admin------------------------------------------


create function LOS_QUE_VAN_A_APROBAR.ValidarAdministrador(@Username NVARCHAR(100), @Password NVARCHAR(100))
returns int as
begin
declare @Resultado tinyint
if  exists(select * 
from LOS_QUE_VAN_A_APROBAR.Administrador
where NombreUsuario = @Username and Contraseña = HASHBYTES('SHA2_256', @Password))
set @Resultado = 1
else
begin
set @Resultado = 0
end
return @Resultado
end
GO



--- Id de rol dado un usuario

create function LOS_QUE_VAN_A_APROBAR.IdDeRol(@Username NVARCHAR(100), @Password NVARCHAR(255))
returns int as
begin
declare @Resultado int
set @Resultado = (select top(1) IdRol from LOS_QUE_VAN_A_APROBAR.Administrador where NombreUsuario = @Username and Contraseña = HASHBYTES('SHA2_256',@Password))
return @Resultado
end
GO



---------------------------------- COMPRA Y RESERVA ----------------------------------------------




CREATE FUNCTION LOS_QUE_VAN_A_APROBAR.ListarViajes(@Fecha_Salida datetime2(3), @Puerto_Salida nvarchar(255), @Puerto_Llegada nvarchar(255))
RETURNS TABLE
AS
RETURN
	SELECT v.IdViaje, v.IdRecorrido from LOS_QUE_VAN_A_APROBAR.Viaje v
	WHERE Fecha_Salida = @Fecha_Salida 
	AND @Puerto_Salida IN (select Puerto_Salida from LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo r
							JOIN LOS_QUE_VAN_A_APROBAR.Tramo t ON (r.CodigoTramo = t.IdTramo)
							where r.CodigoRecorrido =  v.IdRecorrido)
	AND @Puerto_Llegada IN (SELECT Puerto_Llegada from LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo r
							JOIN LOS_QUE_VAN_A_APROBAR.Tramo t ON (r.CodigoTramo = t.IdTramo)
							where r.CodigoRecorrido = V.IdRecorrido)
GO









-------------------------------------------- VIAJE --------------------------------------------

CREATE FUNCTION LOS_QUE_VAN_A_APROBAR.crucerosParaViaje(@Fecha_SalidaNueva datetime2(3), @Fecha_LlegadaNueva datetime2(3))
RETURNS TABLE
AS	
RETURN 
select * from LOS_QUE_VAN_A_APROBAR.Crucero
where IdCrucero not in
 (select IdCrucero from LOS_QUE_VAN_A_APROBAR.Viaje
  WHERE (convert(datetime2(3), Fecha_Salida) BETWEEN convert(datetime2(3), @Fecha_SalidaNueva) AND convert(datetime2(3), @Fecha_LlegadaNueva)) OR
   convert(datetime2(3), Fecha_Llegada) BETWEEN CONVERT(datetime2(3), @Fecha_SalidaNueva) AND convert(datetime2(3), @Fecha_LlegadaNueva)
   OR (convert(datetime2(3), @Fecha_SalidaNueva) > convert(datetime2(3),Fecha_Salida) AND convert(datetime2(3), @Fecha_LlegadaNueva) < convert(datetime2(3), Fecha_Llegada))
   )
GO









-------------------------------- Triggers------------------------------------------

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






-- ------------------------------------Vistas------------------------------------------

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

