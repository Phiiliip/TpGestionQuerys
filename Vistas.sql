
-- Listar todos los cruceros

create view LOS_QUE_VAN_A_APROBAR.ListarCruceros
as
select C.IdCrucero, M.Descripcion as Marca, Mo.Descripcion as Modelo, C.CantidadCabinas
from LOS_QUE_VAN_A_APROBAR.Crucero as c
join LOS_QUE_VAN_A_APROBAR.Marca as M on c.IdMarca = M.IdMarca
join LOS_QUE_VAN_A_APROBAR.Modelo as Mo on c.IdModelo = Mo.IdModelo
