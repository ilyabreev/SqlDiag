/*****************************************
Фрагментированные и часто используемые индексы
*******************************************/
SELECT  '[' + DB_NAME() + '].[' + OBJECT_SCHEMA_NAME(ddips.[object_id],
                                                     DB_ID()) + '].['
        + OBJECT_NAME(ddips.[object_id], DB_ID()) + ']' AS [Object] ,
        i.[name] AS [Index] ,
        ddips.[index_type_desc] AS [Index Type],
        CAST(ddips.[avg_fragmentation_in_percent] AS SMALLINT)
            AS [Average Fragmentation (%)] ,
        ddips.[fragment_count] AS [Fragments],
        ddips.[page_count] AS [Pages],
        dm_ius.user_seeks AS UserSeek
        , dm_ius.user_scans AS UserScans
        , dm_ius.user_lookups AS UserLookups
        , dm_ius.user_updates AS UserUpdates,
        'ALTER INDEX ' + i.[name] + ' ON ' +  '[' + DB_NAME() + '].[' + OBJECT_SCHEMA_NAME(ddips.[object_id],
                                                     DB_ID()) + '].['
        + OBJECT_NAME(ddips.[object_id], DB_ID()) + ']' + ' REBUILD;' AS [RebuildQuery]
FROM    sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'limited') ddips
        INNER JOIN sys.[indexes] i ON ddips.[object_id] = i.[object_id] AND ddips.[index_id] = i.[index_id]
        INNER JOIN sys.dm_db_index_usage_stats dm_ius ON dm_ius.index_id = i.index_id AND dm_ius.object_id = i.object_id                        
WHERE   ddips.[avg_fragmentation_in_percent] > 5
ORDER BY  (dm_ius.user_seeks + dm_ius.user_scans + dm_ius.user_lookups) DESC
GO