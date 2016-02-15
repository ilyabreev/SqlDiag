/*****************************************
Ввод-вывод в файлы баз
*******************************************/
SELECT  DB_NAME(database_id) AS [Database Name] ,
        file_id AS [File ID],
        io_stall_read_ms AS [Total Read Waits (ms)],
        num_of_reads AS [Number of Reads],
        CAST(io_stall_read_ms / ( 1.0 + num_of_reads ) AS NUMERIC(10, 1))
            AS [Average Read Wait (ms)] ,
        io_stall_write_ms AS [Total Write Waits (ms)],
        num_of_writes AS [Number of Writes],
        CAST(io_stall_write_ms / ( 1.0 + num_of_writes ) AS NUMERIC(10, 1))
            AS [Average Write Wait (ms)] ,
        io_stall_read_ms + io_stall_write_ms AS [Total I/O Waits (ms)] ,
        num_of_reads + num_of_writes AS [Number of I/O Operations] ,
        CAST(( io_stall_read_ms + io_stall_write_ms ) / ( 1.0 + num_of_reads
                                                          + num_of_writes)
           AS NUMERIC(10,1)) AS [Average I/O Wait (ms)]
FROM    sys.dm_io_virtual_file_stats(NULL, NULL)
ORDER BY [Average I/O Wait (ms)] DESC ;
