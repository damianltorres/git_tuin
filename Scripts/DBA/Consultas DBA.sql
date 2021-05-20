SELECT SO.NAME, SC.NAME
FROM sysobjects SO INNER JOIN syscolumns SC
ON SO.ID = SC.ID
WHERE SO.XTYPE = 'U' --and SC.NAME like 'IdCierreTurno'
ORDER BY SO.NAME, SC.NAME


-----------------------------------------------------------------------

SELECT
    X.[name], 
    REPLACE(CONVERT(varchar, CONVERT(money, X.[rows]), 1), '.00', '') 
        AS [rows], 
    REPLACE(CONVERT(varchar, CONVERT(money, X.[reserved]), 1), '.00', '') 
        AS [reserved], 
    REPLACE(CONVERT(varchar, CONVERT(money, X.[data]), 1), '.00', '') 
        AS [data], 
    REPLACE(CONVERT(varchar, CONVERT(money, X.[index_size]), 1), '.00', '') 
        AS [index_size], 
    REPLACE(CONVERT(varchar, CONVERT(money, X.[unused]), 1), '.00', '') 
        AS [unused] 
FROM
(SELECT
    CAST(object_name(id) AS varchar(50)) 
        AS [name], 
    SUM(CASE WHEN indid < 2 THEN CONVERT(bigint, [rows]) END) 
        AS [rows],
    SUM(CONVERT(bigint, reserved)) * 8 
        AS reserved, 
    SUM(CONVERT(bigint, dpages)) * 8 
        AS data, 
    SUM(CONVERT(bigint, used) - CONVERT(bigint, dpages)) * 8 
        AS index_size, 
    SUM(CONVERT(bigint, reserved) - CONVERT(bigint, used)) * 8 
        AS unused 
    FROM sysindexes WITH (NOLOCK) 
    WHERE sysindexes.indid IN (0, 1, 255) 
        AND sysindexes.id > 100 
        AND object_name(sysindexes.id) <> 'dtproperties'
    GROUP BY sysindexes.id WITH ROLLUP
) AS X
WHERE X.[name] is not null and X.rows > 1
ORDER BY X.[rows] DESC
