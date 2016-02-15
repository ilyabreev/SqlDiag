/*****************************************
Топ типов ожиданий в SQL Engine
*******************************************/

WITH    Waits
          AS ( SELECT   wait_type ,
                        wait_time_ms / 1000. AS wait_time_sec ,
                        100. * wait_time_ms / SUM(wait_time_ms) OVER ( ) AS pct ,
                        ROW_NUMBER() OVER ( ORDER BY wait_time_ms DESC ) AS rn
               FROM     sys.dm_os_wait_stats
               WHERE    wait_type NOT IN ( 'CLR_SEMAPHORE', 'LAZYWRITER_SLEEP',
                                           'RESOURCE_QUEUE', 'SLEEP_TASK',
                                           'SLEEP_SYSTEMTASK',
                                           'SQLTRACE_BUFFER_FLUSH', 'WAITFOR',
                                           'LOGMGR_QUEUE', 'CHECKPOINT_QUEUE',
                                           'XE_TIMER_EVENT', 'XE_DISPATCHER_WAIT',
                                           'REQUEST_FOR_DEADLOCK_SEARCH', 'SQLTRACE_INCREMENTAL_FLUSH_SLEEP' )
             )
    SELECT  wait_type AS [Wait Type],
            CAST(wait_time_sec AS DECIMAL(12, 2)) AS [Wait Time (s)] ,
            CAST(pct AS DECIMAL(12, 2)) AS [Wait Time (%)]
    FROM    Waits
    WHERE   pct > 0
    ORDER BY wait_time_sec DESC
GO    