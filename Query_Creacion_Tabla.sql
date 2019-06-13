use GD1C2019

drop procedure CrearTablas

create procedure CrearTablas
as
begin
--- Modelo 

create table Modelo(
IdModelo int IDENTITY(1,1) PRIMARY KEY,
Descripcion nvarchar (50) NOT NULL,
);

--- Marca

create table Marca(
IdMarca int IDENTITY(1,1) PRIMARY KEY,
Descripcion nvarchar (255) NOT NULL,
);

-- Servicio

create table Servicio(
TipoServicio nVARCHAR(255) PRIMARY KEY,
Porcentaje decimal(18,2),
);


-- Crucero

create table Crucero(
IdCrucero nvarchar(50) PRIMARY KEY,
IdMarca int REFERENCES MARCA(IdMarca),
IdModelo int REFERENCES MODELO(IdModelo),
FechaAlta DATETIME2(3),
CantidadCabinas int,
);

-- Fuera de servicio

create table FueraDeServicio(
IdFDS int IDENTITY(1,1) PRIMARY KEY,
IdCrucero nvarchar(50) REFERENCES Crucero(IdCrucero),
FechaBaja DATETIME2(3),
MotivoBaja VARCHAR(50),
FechaReinicio DATETIME2(3),
);

-- Cabina por crucero

create table CabinaPorCrucero(
IdCPC int IDENTITY(1,1) PRIMARY KEY,
IdCrucero nvarchar(50) REFERENCES Crucero(IdCrucero),
TipoServicio nvarchar(255) REFERENCES Servicio(TipoServicio),
NroPiso decimal(18,0),
NroCabina decimal(18,0),
Estado NVARCHAR(12) DEFAULT('Disponible'),
Fecha_Salida DATETIME2(3),
CHECK(Estado IN ('Disponible','Ocupado'))
);

-- Puerto

create table Puerto(
Nombre nvarchar(255) PRIMARY KEY,
Descripcion VARCHAR(50) NULL,
);

-- Tramo

create table Tramo(
IdTramo int IDENTITY(1,1) PRIMARY KEY,
Puerto_Salida nvarchar(255) REFERENCES PUERTO(NOMBRE),
Puerto_Llegada nvarchar(255) REFERENCES PUERTO(NOMBRE),
Precio decimal(18,2),
check(Puerto_Salida != Puerto_Llegada),
);


-- Recorrido

create table Recorrido(
IdRecorrido int IDENTITY(1,1) PRIMARY KEY,
Codigo_Recorrido decimal(18,0) NOT NULL,
Descripcion VARCHAR(50),
PrecioTotal decimal(18,2)
);

-- Recorrido por tramo

create table RecorridoPorTramo(
CodigoRecorrido int REFERENCES Recorrido(IdRecorrido),
CodigoTramo int REFERENCES Tramo(IdTramo),
PrecioTramo decimal(18,2),
);

-- Viaje

create table Viaje(
IdViaje int IDENTITY(1,1) PRIMARY KEY,
IdCrucero nvarchar(50) REFERENCES Crucero(IdCrucero),
IdRecorrido int REFERENCES Recorrido(IdRecorrido),
Fecha_Salida DATETIME2(3),
Fecha_Llegada DATETIME2(3),
CodigoRecorrido DECIMAL(18,0),
check(Fecha_Llegada > Fecha_Salida),
);

create table Rol(
IdRol int IDENTITY(1,1) PRIMARY KEY,
Estado NVARCHAR(20) DEFAULT('Habilitado'),
Nombre NVARCHAR(20),
check(Estado in('Habilitado','Inhabilitado'))
);


-- Cliente

create table Cliente(
IdCliente int IDENTITY(1,1) PRIMARY KEY,
IdRol int REFERENCES Rol(IdRol) DEFAULT(1),
Nombre nVARCHAR(255),
Apellido nVARCHAR(255),
DNI decimal(18,0),
Direccion nVARCHAR(255),
Telefono int,
Mail nVARCHAR(255) NULL,
FechaNacimiento DATETIME2(3),
);

-- Reserva

create table Reserva(
IdReserva int IDENTITY(1,1) PRIMARY KEY,
IdCliente int REFERENCES Cliente(IdCliente),
IdViaje int REFERENCES Viaje(IdViaje),
NroPiso int,
NroCabina int,
Fecha_Salida DATETIME2(3),
Fecha_Reserva DATETIME2(3),
);

-- Pasaje

create table Pasaje(
IdPasaje int IDENTITY(1,1) PRIMARY KEY,
IdCliente int REFERENCES Cliente(IdCliente),
IdViaje int REFERENCES Viaje(IdViaje),
NroPiso int,
NroCabina int,
Fecha_Salida DATETIME2(3),
Fecha_Pago DATETIME2(3),
);

-- Funcionalidad

create table Funcionalidad(
IdFuncionalidad int IDENTITY(1,1) PRIMARY KEY,
Descripcion NVARCHAR(255)
);

-- Funcionalidad Por Rol

create table FuncionalidadPorRol(
IdFuncionalidad int REFERENCES Funcionalidad(IdFuncionalidad),
IdRol int REFERENCES Rol(IdRol),
Estado NVARCHAR(20) DEFAULT('Habilitado'),
check(Estado in('Habilitado','Inhabilitado'))
);

-- Administrador

create table Administrador(
NombreUsuario NVARCHAR(100) UNIQUE,
Contraseña NVARCHAR(255),
IdRol int REFERENCES Rol(IdRol) Default(2),
PRIMARY KEY(NombreUsuario,Contraseña)
);

END
----
Exec dbo.CrearTablas
