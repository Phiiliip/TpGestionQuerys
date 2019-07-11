use GD1C2019

---LISTADO RECORRIDO CON MAS PASAJES COMPRADOS

SELECT TOP 5 r1.Codigo_Recorrido as CodigoRecorrido, r1.IdRecorrido, COUNT(IdPasaje) as CantidadDePasajesComprados, pto.Nombre as PuertoOrigen
from LOS_QUE_VAN_A_APROBAR.Pasaje p1 join LOS_QUE_VAN_A_APROBAR.Viaje v1 on (p1.IdViaje = v1.IdViaje) 
		join LOS_QUE_VAN_A_APROBAR.Recorrido r1 on (v1.IdRecorrido = r1.IdRecorrido)
		join LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo rt1 on (r1.IdRecorrido = rt1.CodigoRecorrido) 
		join LOS_QUE_VAN_A_APROBAR.Tramo t1 on (rt1.CodigoTramo = t1.IdTramo)
		join LOS_QUE_VAN_A_APROBAR.Puerto pto on (t1.Puerto_Salida = pto.Nombre)

where rt1.CodigoTramo in (select MIN(CodigoTramo) from LOS_QUE_VAN_A_APROBAR.RecorridoPorTramo rpt2 
							where rpt2.CodigoRecorrido = r1.IdRecorrido ) AND MONTH(p1.Fecha_Pago) <= 6 AND YEAR(p1.Fecha_Pago)= 2019
							
group by r1.Codigo_Recorrido, r1.IdRecorrido, pto.Nombre

order by CantidadDePasajesComprados ASC



---LISTADO RECORRIDOS CON MAS CABINAS LIBRES EN CADA VIAJE

SELECT TOP 5 r1.Codigo_Recorrido as CodigoRecorrido, v1.IdViaje, (c1.CantidadCabinas - (select count(p1.IdPasaje)  from LOS_QUE_VAN_A_APROBAR.Pasaje p1 where (p1.IdViaje = v1.IdViaje))) as CantidadCabinasLibres

from LOS_QUE_VAN_A_APROBAR.Recorrido r1 join LOS_QUE_VAN_A_APROBAR.Viaje v1 on (r1.IdRecorrido = v1.IdRecorrido)
		join LOS_QUE_VAN_A_APROBAR.Crucero c1 on (v1.IdCrucero = c1.IdCrucero)

order by CantidadCabinasLibres DESC


----LISTADO CANTIDAD DIAS FUERA DE SERVICIO-----

select TOP 5 c1.IdCrucero, m1.Descripcion as Marca, m2.Descripcion as Modelo, sum(LOS_QUE_VAN_A_APROBAR.diasFuera(2019,2,f1.FechaBaja, f1.FechaReinicio)) as CantidadDiasFueraDeServicio

from LOS_QUE_VAN_A_APROBAR.FueraDeServicio f1 join LOS_QUE_VAN_A_APROBAR.Crucero c1 on (f1.IdCrucero = c1.IdCrucero) 
join LOS_QUE_VAN_A_APROBAR.Marca m1 on (c1.IdMarca = m1.IdMarca) join LOS_QUE_VAN_A_APROBAR.Modelo m2 on (c1.IdModelo = m2.IdModelo)

group by c1.IdCrucero, m1.Descripcion, m2.Descripcion

order by CantidadDiasFueraDeServicio DESC




use GD1C2019

create function LOS_QUE_VAN_A_APROBAR.diasFuera (@anio numeric(5), @semestre numeric(2), @fechabaja dateTime, @fechaalta dateTime)
returns numeric(5)
as
begin
	declare @resultado numeric(5)
	
	declare @fechalimite1 dateTime
	declare @fechalimite2 dateTime
	declare @fechalimite3 dateTime
	set @fechalimite1 = DATEFROMPARTS(@anio, 1, 1)
	set @fechalimite2 = DATEFROMPARTS(@anio, 6, 30)
	set @fechalimite3 = DATEFROMPARTS(@anio, 12, 31)

	if(@semestre = 1)
	begin
		if(@fechabaja < @fechalimite1)
			set @fechabaja = @fechalimite1
		if(@fechaalta > @fechalimite2)
			set @fechaalta = @fechalimite2
		if(@fechabaja > @fechalimite2 or @fechaalta < @fechalimite1)
			set @fechabaja = @fechaalta
	end
	else
	begin
		if(@fechabaja < @fechalimite2)
			set @fechabaja = @fechalimite2
		if(@fechaalta > @fechalimite3)
			set @fechaalta = @fechalimite3
		if(@fechabaja > @fechalimite3 or @fechaalta < @fechalimite2)
			set @fechabaja = @fechaalta
	end

	set @resultado = DATEDIFF(day, @fechabaja, @fechaalta)
	return @resultado
end
