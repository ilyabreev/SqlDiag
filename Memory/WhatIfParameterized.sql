/*****************************************
Проводит анализ на возможную параметризацию кеша планов

1) выбирает все Adhoc планы из кеша
2) пытается их параметризовать и сохраняет параметризованный вариант (если не получается, удаляет)
3) группирует, чтобы определить количество вхождений параметризованного запроса
*******************************************/

SELECT st.text INTO query_plan_cache
FROM sys.dm_exec_cached_plans AS cp
CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) AS st
WHERE cp.objtype = 'AdHoc'

DECLARE @txt NVARCHAR(MAX);
DECLARE @par NVARCHAR(MAX);
DECLARE @id INT;
DECLARE @q NVARCHAR(MAX);
DECLARE db_cursor CURSOR FOR
OPEN db_cursor
FETCH NEXT FROM db_cursor INTO @id, @q

WHILE @@FETCH_STATUS = 0
BEGIN
    BEGIN TRY
        EXEC sp_get_query_template @q, @txt OUTPUT, @par OUTPUT
        UPDATE query_plan_cache SET [text] = @txt WHERE id = @id
    END TRY
    BEGIN CATCH
        DELETE query_plan_cache WHERE id = @id
    END CATCH
    FETCH NEXT FROM db_cursor INTO @id, @q
END

CLOSE db_cursor
DEALLOCATE db_cursor

SELECT [text], COUNT(*)
  FROM query_plan_cache WITH(NOLOCK)
  GROUP BY text
  ORDER BY COUNT(*) DESC