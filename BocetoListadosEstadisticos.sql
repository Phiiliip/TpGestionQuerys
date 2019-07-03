use GD1C2019

SELECT TOP 5 r1.Codigo_Recorrido as CodigoRecorrido, COUNT(*) as CantidadDePasajesComprados

from LOS_QUE_VAN_A_APROBAR.Pasaje p1 join LOS_QUE_VAN_A_APROBAR.Viaje v1 on (p1.IdViaje = v1.IdViaje) join LOS_QUE_VAN_A_APROBAR.Recorrido r1 on (v1.IdRecorrido = r1.IdRecorrido)

group by r1.Codigo_Recorrido

order by CantidadDePasajesComprados DESC


select TOP 5 c1.IdCrucero, sum(DATEDIFF(DAY,f1.FechaBaja, f1.FechaReinicio)) as CantidadDiasFueraDeServicio

from LOS_QUE_VAN_A_APROBAR.FueraDeServicio f1 join LOS_QUE_VAN_A_APROBAR.Crucero c1 on (f1.IdCrucero = c1.IdCrucero)

group by c1.IdCrucero

order by CantidadDiasFueraDeServicio DESC


--Hay que ver como filtrar el semestre y el año, tengo pensado hacer todas funciones por separadas, y en estos selects
--filtrar en el where el año y los 6 meses priemro en el caso del primer semestre, u los otros seis meses en el caso del segundo 
--semestre