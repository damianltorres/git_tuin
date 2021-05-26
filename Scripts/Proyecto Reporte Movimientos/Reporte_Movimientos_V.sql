USE [SBDBITUIN]
GO

/****** Object:  View [dbo].[TUIN_Reporte_Movimientos]    Script Date: 21/05/2021 14:25:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



alter view [bi].[Reporte_Movimientos_V] with encryption as (
select
--a.UserName0
a.IdMovimientoFac
--, a.LastUpdated
--, a.FechaEmision
, convert(varchar,a.Fecha, 112) IdFecha
, a.Fecha FechaMovimiento
, convert(varchar,a.FechaEmision, 23) Fecha
, year(a.Fecha) Anio
, right ('00'+ convert(varchar,month(a.Fecha)),2) Mes
, convert(varchar,year(a.Fecha))+'-'+right ('00'+ convert(varchar,month(a.Fecha)),2) Periodo
, convert(varchar, n.Fecha , 23) FechaTurno --b.LastUpdated
, CONVERT(varchar,n.Fecha, 8) as HoraTurno
, c.IdCaja
, e.Descripcion Caja
, m.IdTipoMovimiento
, m.Descripcion TipoMovimiento
, a.IdTipoMovimiento +'-'+ right ('0000'+ convert(varchar, a.PuntoVenta),4)+'-'+convert(varchar,a.Numero) as Comprobante
, a.IdCategoriaIVA
, g.Abreviatura +' - '+ g.Descripcion CategoriaIVA
, i.Descripcion CondicionVenta
, a.IdEstacion
, k.Nombre Estacion
, isnull(a.IdCliente,0) IdCliente
, isnull(f.Codigo,0) CodigoCliente
, UPPER(a.RazonSocial) RazonSocial
, isnull(h.Descripcion,'N/I') TipoDocumento
, isnull(a.NumeroDocumento,'N/I') NumeroDocumento
---------------------------------------------------------------------------------------------
, isnull(a.IdPuesto,0) IdPuesto
, 'N/I' Puesto--, isnull(l.Nombre,'N/I') Puesto
--, a.IdEmpleadoResponsable
, isnull(o.Empleado,'N/I') EmpleadoResponsable
--, n.IdEmpleado1
--, o1.Empleado 
--, n.IdEmpleado2 IdPlayero1
, isnull(o2.Empleado,'N/I') Playero1
--, n.IdEmpleado3 IdPlayero2
, isnull(o3.Empleado,'N/I') Playero2
--, n.IdEmpleado4 IdPlayero3
, isnull(o4.Empleado,'N/I') Playero3
---------------------------------------------------------------------------------------------
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
	   when d.IdGrupoArticulo IN (28,49,33,45,50,22,25,23,21,19,20,30,32,37,39,3,7,57,36,38,51,58,63) then 'ALMACEN'
	   when d.IdGrupoArticulo IN (48,26,62,56,42,29,18,35,31) then 'COMIDAS Y PREPARADOS'
	   else 'SIN CLASIFICAR'
	   end AS SubUnidadNegocio
---------------------------------------------------------------------------------------------
, case when d.IdFamiliaArticulo = 4 then 'PLAYA'
       when d.IdFamiliaArticulo = 2 OR d.IdGrupoArticulo IN (10) then 'PLAYA'
	   when d.IdGrupoArticulo IN (15,11,16) then 'LAVADERO Y ENGRASE'
	   when d.IdGrupoArticulo IN (14,12) then 'SHOP'
	   when d.IdGrupoArticulo IN (24) then 'SHOP'
       when d.IdGrupoArticulo IN (28,49,33,45,50,22,25,23,21,19,20,30,32,37,39,3,7,57,36,38,51,58,63) then 'SHOP'
	   when d.IdGrupoArticulo IN (48,26,62,56,42,29,18,35,31) then 'SHOP'
	   else 'SIN CLASIFICAR'
	   end as UnidadNegocio
---------------------------------------------------------------------------------------------
, case when b.Facturado = '1' then 'S' else 'N' end Facturado
, b.Cantidad
, b.Precio
, b.Costo
, round((b.Cantidad * b.Precio) - (b.IVA*b.Cantidad) - (b.ImpuestoInterno*b.Cantidad) - (b.Tasas*b.Cantidad),4) Neto
, (b.IVA*b.Cantidad) IVA
, (b.ImpuestoInterno*b.Cantidad) ImpuestoInterno
, (b.Tasas*b.Cantidad) Tasas
, (b.Cantidad * b.Precio) Total
, convert(varchar, a.IdMovimientoFac) +' - '+ convert(varchar,a.Fecha, 112) as Grupo
, (b.Cantidad * b.Precio) - (b.IVA*b.Cantidad) as Net_Int
, (b.Cantidad * b.Costo) + (b.ImpuestoInterno*b.Cantidad) + (b.Tasas*b.Cantidad) as Costo_T 
, DATEPART(dw,a.Fecha) Dia_Sem
, DATEPART(day,a.Fecha) Fecha_Dia
, datepart(hour, a.Fecha) Hora
from [TUIN\SQLAONIKEN].[DS2000.Net].[dbo].MovimientosFac a 
left join [TUIN\SQLAONIKEN].[DS2000.Net].[dbo].MovimientosDetalleFac b on b.IdMovimientoFac = a.IdMovimientoFac
left join [TUIN\SQLAONIKEN].[DS2000.Net].[dbo].Articulos c on c.IdArticulo = b.IdArticulo
left join [TUIN\SQLAONIKEN].[DS2000.Net].[dbo].GruposArticulos d on d.IdGrupoArticulo = c.IdGrupoArticulo
left join [TUIN\SQLAONIKEN].[DS2000.Net].[dbo].Cajas e on e.IdCaja =  c.IdCaja
left join [TUIN\SQLAONIKEN].[DS2000.Net].[dbo].Clientes f on f.IdCliente = a.IdCliente
left join [TUIN\SQLAONIKEN].[DS2000.Net].[dbo].CategoriasIVA g on g.IdCategoriaIVA = a.IdCategoriaIVA
left join [TUIN\SQLAONIKEN].[DS2000.Net].[dbo].TiposDocumento h on h.IdTipoDocumento = a.IdTipoDocumento
left join [TUIN\SQLAONIKEN].[DS2000.Net].[dbo].CondicionesVenta i on i.IdCondicionVenta = a.IdCondicionVenta
left join [TUIN\SQLAONIKEN].[DS2000.Net].[dbo].FamiliasArticulos j on j.IdFamiliaArticulo = d.IdFamiliaArticulo
left join [TUIN\SQLAONIKEN].[DS2000.Net].[dbo].Estaciones k on k.IdEstacion = a.IdEstacion
--left join [TUIN\SQLAONIKEN].[DS2000.Net].[dbo].Puestos l on l.IdPuesto = a.IdPuesto
left join [TUIN\SQLAONIKEN].[DS2000.Net].[dbo].TiposMovimiento m on m.IdTipoMovimiento = a.IdTipoMovimiento
left join [TUIN\SQLAONIKEN].[DS2000.Net].[dbo].Empleados o  on o.IdEmpleado = a.IdEmpleadoResponsable
left join [TUIN\SQLAONIKEN].[DS2000.Net].[dbo].CierresTurno n on n.IdCierreTurno = b.IdCierreTurno and n.IdEstacion = a.IdEstacion
left join [TUIN\SQLAONIKEN].[DS2000.Net].[dbo].Empleados o4  on o4.IdEmpleado = n.IdEmpleado4
left join [TUIN\SQLAONIKEN].[DS2000.Net].[dbo].Empleados o1  on o1.IdEmpleado = n.IdEmpleado1
left join [TUIN\SQLAONIKEN].[DS2000.Net].[dbo].Empleados o2  on o2.IdEmpleado = n.IdEmpleado2
left join [TUIN\SQLAONIKEN].[DS2000.Net].[dbo].Empleados o3  on o3.IdEmpleado = n.IdEmpleado3
)
GO


