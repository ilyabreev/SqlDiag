/*****************************************
Таблицы без кластизованных индексов (кучи)
*******************************************/

SELECT o.name
FROM sys.objects o
WHERE o.type='U'
  AND NOT EXISTS(SELECT 1 FROM sys.indexes i
                 WHERE o.object_id = i.object_id
                   AND i.type_desc = 'CLUSTERED')
