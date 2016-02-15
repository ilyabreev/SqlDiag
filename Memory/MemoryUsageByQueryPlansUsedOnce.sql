/*****************************************
Сколько памяти уходит на планы запросов, которые были использованы ровно 1 раз
*******************************************/

select LEFT(text, CHARINDEX('''', text)) AS QueryPattern, SUM(CAST(size_in_bytes AS BIGINT)) / 1024 AS TotalKbInPlanCache from sys.dm_Exec_cached_plans
cross apply sys.dm_exec_sql_text(plan_handle)
where cacheobjtype = 'Compiled Plan'
and objtype = 'Adhoc' and usecounts = 1
GROUP BY LEFT(text, CHARINDEX('''', text))
ORDER BY TotalKbInPlanCache DESC
GO