/*****************************************
Фрагментированные индексы
*******************************************/
SELECT  '[' + DB_NAME() + '].[' + OBJECT_SCHEMA_NAME(ddips.[object_id],
                                                     DB_ID()) + '].['
        + OBJECT_NAME(ddips.[object_id], DB_ID()) + ']' AS [Object] ,
        i.[name] AS [Index] ,
        ddips.[index_type_desc] AS [Index Type],
        ddips.[partition_number] AS [Partition Number],
        ddips.[alloc_unit_type_desc] AS [Allocation Unit Type],
        ddips.[index_depth] AS [Index Depth],
        ddips.[index_level] AS [Index Level],
        CAST(ddips.[avg_fragmentation_in_percent] AS SMALLINT)
            AS [Average Fragmentation (%)] ,
        CAST(ddips.[avg_fragment_size_in_pages] AS SMALLINT)
            AS [Average Fragment Size (pages)] ,
        ddips.[fragment_count] AS [Fragments],
        ddips.[page_count] AS [Pages]
FROM    sys.dm_db_index_physical_stats(DB_ID(), NULL,
                                         NULL, NULL, 'limited') ddips
        INNER JOIN sys.[indexes] i ON ddips.[object_id] = i.[object_id]
                                       AND ddips.[index_id] = i.[index_id]
WHERE   ddips.[avg_fragmentation_in_percent] > 5
ORDER BY ddips.[avg_fragmentation_in_percent] DESC
GO