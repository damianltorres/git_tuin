
select DISTINCT UnidadNegocio,SubunidadNegocio,  IdGrupoArticulo, GrupoArticulo, IdArticulo,  Descripcion , max(fecha) Ult_Fecha, sum(Neto)
from [bi].[reporte_movimientos] WHERE --ANIO >= '2001' and   MES = '05' AND
Playero1 <> 'n/i' --and UnidadNegocio = 'PLAYA' AND SubUnidadNegocio = 'COMBUSTIBLES'
and UnidadNegocio = 'SIN CLASIFICAR' --and Anio > 2019
and GrupoArticulo not in ('BIEN DE USO', 'TRANSPORTE', 'VARIOS')
 group by UnidadNegocio, SubunidadNegocio,IdGrupoArticulo, GrupoArticulo, IdArticulo,  Descripcion
 order by max(fecha) desc


--truncate table bi.reporte_movimientos
 
 select max(fecha) as corrida_reporte_movimientos 
 from bi.logETL
 where Tabla = 'bi.reporte_movimientos' and Descripcion = 'Fin Carga'

 --truncate table bi.logETL