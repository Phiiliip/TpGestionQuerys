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
FechaAlta DATETIME2(3),
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

