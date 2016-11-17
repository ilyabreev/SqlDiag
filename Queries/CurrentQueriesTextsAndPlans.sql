/*****************************************
Тексты и планы запросов, которые выполняются прямо сейчас.
*******************************************/

SELECT sqltext.TEXT,
req.session_id,
req.status,
req.command,
req.cpu_time,
req.total_elapsed_time,
queryplan.query_plan
FROM sys.dm_exec_requests req
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS sqltext
CROSS APPLY sys.dm_exec_query_plan(plan_handle) AS queryplan