/* CreateDate: 01/03/2014 07:07:51.420 , ModifyDate: 01/03/2014 07:07:51.420 */
GO
CREATE FUNCTION [snapshots].[fn_get_notable_query_plans](
    @source_id  int
)
RETURNS @notable_queries TABLE (sql_handle varbinary(64) ,
                                plan_handle varbinary(64),
                                statement_start_offset int,
                                statement_end_offset int,
                                creation_time datetime)
BEGIN
    INSERT INTO @notable_queries
    SELECT  [sql_handle],
        [plan_handle],
        [statement_start_offset],
        [statement_end_offset],
            -- Convert datetimeoffset to datetime so that SSIS can easily join the output back
            -- to the new sys.dm_exec_query_stats data
            CONVERT (datetime, [creation_time]) AS [creation_time]
    FROM    [snapshots].[notable_query_plan]
    WHERE   [source_id] = @source_id
    ORDER BY [sql_handle] ASC, [plan_handle], [statement_start_offset], [statement_end_offset], [creation_time] ASC

    RETURN
END
GO
