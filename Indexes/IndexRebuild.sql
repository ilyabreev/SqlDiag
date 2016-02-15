/*****************************************
Генерация запросов на ребилд некластеризованных индексов
*******************************************/

SELECT  '[' + DB_NAME() + '].[' + OBJECT_SCHEMA_NAME(ddips.[object_id],
                                                     DB_ID()) + '].['
        + OBJECT_NAME(ddips.[object_id], DB_ID()) + ']' AS [Object] ,
        i.[name] AS [Index] ,
        CAST(ddips.[avg_fragmentation_in_percent] AS SMALLINT)
            AS [Average Fragmentation (%)],
        'ALTER INDEX ' + i.[name] + ' ON ' + '[' + DB_NAME() + '].[' + OBJECT_SCHEMA_NAME(ddips.[object_id],
                                                     DB_ID()) + '].['
        + OBJECT_NAME(ddips.[object_id], DB_ID()) + '] REBUILD;' AS [Rebuild Query]
FROM    sys.dm_db_index_physical_stats(DB_ID(), NULL,
                                         NULL, NULL, 'limited') ddips
        INNER JOIN sys.[indexes] i ON ddips.[object_id] = i.[object_id]
                                       AND ddips.[index_id] = i.[index_id]
WHERE   ddips.[avg_fragmentation_in_percent] > 30 AND ddips.[index_type_desc] = 'NONCLUSTERED INDEX'
ORDER BY ddips.[avg_fragmentation_in_percent] DESC
GO