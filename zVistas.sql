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






-- Recorridos

create view LOS_QUE_VAN_A_APROBAR.BajaRecorrido
as
select r.CodigoRecorrido as IdRecorrido, (p1.Nombre + ' - ' +  p2.Nombre) as Descripcion
from LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo as r
join LOS_QUE_VAN_A_APROBAR.Tramo t on r.CodigoTramo = t.IdTramo
join LOS_QUE_VAN_A_APROBAR.Puerto p1 on t.Puerto_Llegada = p1.Nombre
join LOS_QUE_VAN_A_APROBAR.Puerto p2 on t.Puerto_Salida = p2.Nombre



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