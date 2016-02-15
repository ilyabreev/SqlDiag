/*****************************************
Суммарный расход памяти под разные виды планов запроса
*******************************************/
    
SELECT objtype AS 'Cached Object Type', 
  COUNT(*) AS 'Numberof Plans', 
  SUM(CAST(size_in_bytes AS BIGINT))/1048576 AS 'Plan Cache SIze (MB)', 
  AVG(usecounts) AS 'Avg Use Counts' 
FROM sys.dm_exec_cached_plans 
GROUP BY objtype  
ORDER BY objtype 
GO