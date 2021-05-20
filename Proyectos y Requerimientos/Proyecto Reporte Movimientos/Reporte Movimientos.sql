select --top 10000
 a.UserName
, a.IdPuesto
--, l.Nombre Puesto
, a.IdEmpleadoResponsable
, o.Empleado EmpleadoResponsable
, b.IdCierreTurno
--, n.IdCierreTurno
, n.IdEmpleado1
, o1.Empleado Empleado1
, n.IdEmpleado2
, o2.Empleado Empleado2
, n.IdEmpleado3
, o3.Empleado Empleado3
, n.IdEmpleado4
, o4.Empleado Empleado4
----
,a.IdMovimientoFac
, a.FechaEmision
, convert(varchar,a.FechaEmision, 11) Fecha
, convert(varchar,  a.Fecha, 11) FechaTurno
, CONVERT(varchar, a.Fecha, 8) as HoraTurno
, c.IdCaja
, e.Descripcion Caja
, m.Descripcion TipoMovimiento
, a.IdTipoMovimiento +'-'+ right ('0000'+ convert(varchar, a.PuntoVenta),4)+'-'+convert(varchar,a.Numero) as Comprobante
, a.IdCategoriaIVA
, g.Abreviatura +' - '+ g.Descripcion CategoriaIVA
, i.Descripcion CondicionVenta
, a.IdEstacion
, k.Nombre Estacion
, a.IdCliente
, f.Codigo CodigoCliente
, a.RazonSocial
, h.Descripcion TipoDocumento
, a.NumeroDocumento --, a.Total Total_a
, b.IdArticulo
, c.Codigo CodigoArticulo
, c.Descripcion
, c.IdGrupoArticulo 
, d.Descripcion GrupoArticulo
, d.IdFamiliaArticulo
, j.Descripcion FamiliaArticulo
---------------------------------------------------------------------------------------------
, case when d.IdFamiliaArticulo = 4 then 'COMBUSTIBLES' 
       when d.IdFamiliaArticulo = 2 OR d.IdGrupoArticulo IN (10) then 'OTROS' 
	   when d.IdGrupoArticulo IN (15,11,16) then 'LAVADO'
	   when d.IdGrupoArticulo IN (14,12) then 'AUTOMOTOR'
	   when d.IdGrupoArticulo IN (24) then 'CIGARRILLOS'
	   when d.IdGrupoArticulo IN (28,49,33,45,50,22,25,23,21,19,20,30,32,37,39,3,7,57,36) then 'ALMACEN'
	   when d.IdGrupoArticulo IN (48,26,62,56,42,29,18,35,31) then 'COMIDAS Y PREPARADOS'
	   else 'SIN CLASIFICAR'
	   end AS SubUnidadNegocio
---------------------------------------------------------------------------------------------
, case when d.IdFamiliaArticulo = 4 then 'PLAYA'
       when d.IdFamiliaArticulo = 2 OR d.IdGrupoArticulo IN (10) then 'PLAYA'
	   when d.IdGrupoArticulo IN (15,11,16) then 'LAVADERO Y ENGRASE'
	   when d.IdGrupoArticulo IN (14,12) then 'SHOP'
	   when d.IdGrupoArticulo IN (24) then 'SHOP'
       when d.IdGrupoArticulo IN (28,49,33,45,50,22,25,23,21,19,20,30,32,37,39,3,7,57,36) then 'SHOP'
	   when d.IdGrupoArticulo IN (48,26,62,56,42,29,18,35,31) then 'SHOP'
	   else 'SIN CLASIFICAR'
	   end as UnidadNegocio
---------------------------------------------------------------------------------------------
, b.Facturado
, b.Cantidad
, b.Precio
, b.Costo
,(b.Cantidad * b.Precio) - (b.IVA + b.ImpuestoInterno + b.Tasas)  Neto
, b.IVA
, b.ImpuestoInterno
, b.Tasas
, b.Cantidad * b.Precio Total
, convert(varchar, a.IdMovimientoFac) +' - '+convert(varchar, a.fecha) as Grupo
, (b.Cantidad * b.Precio) - (b.IVA) as Net_Int
, (b.Cantidad * b.Costo) + b.ImpuestoInterno + b.Tasas as Costo_T 
, DATEPART(dw,a.Fecha) Dia_Sem
, DATEPART(day,a.Fecha) Fecha_Dia
, datepart(hour, a.Fecha) Hora
from MovimientosFac a 
left join MovimientosDetalleFac b on b.IdMovimientoFac = a.IdMovimientoFac
left join Articulos c on c.IdArticulo = b.IdArticulo
left join GruposArticulos d on d.IdGrupoArticulo = c.IdGrupoArticulo
left join Cajas e on e.IdCaja =  c.IdCaja
left join Clientes f on f.IdCliente = a.IdCliente
left join CategoriasIVA g on g.IdCategoriaIVA = a.IdCategoriaIVA
left join TiposDocumento h on h.IdTipoDocumento = a.IdTipoDocumento
left join CondicionesVenta i on i.IdCondicionVenta = a.IdCondicionVenta
left join FamiliasArticulos j on j.IdFamiliaArticulo = d.IdFamiliaArticulo
left join Estaciones k on k.IdEstacion = a.IdEstacion
--left join Puestos l on l.IdPuesto = a.IdPuesto
left join TiposMovimiento m on m.IdTipoMovimiento = a.IdTipoMovimiento
left join Empleados o  on o.IdEmpleado = a.IdEmpleadoResponsable
left join CierresTurno n on n.IdCierreTurno = b.IdCierreTurno and n.IdEstacion = a.IdEstacion
left join Empleados o1  on o1.IdEmpleado = n.IdEmpleado1
left join Empleados o2  on o2.IdEmpleado = n.IdEmpleado2
left join Empleados o3  on o3.IdEmpleado = n.IdEmpleado3
left join Empleados o4  on o4.IdEmpleado = n.IdEmpleado4