/* CreateDate: 01/03/2014 07:07:48.633 , ModifyDate: 01/03/2014 07:07:48.633 */
GO
CREATE FUNCTION [snapshots].[fn_get_query_text](
    @source_id int,
    @sql_handle varbinary(64),
    @statement_start_offset int,
    @statement_end_offset int
)
RETURNS @query_text TABLE (database_id smallint NULL, object_id int NULL, object_name sysname NULL, query_text nvarchar(max) NULL)

BEGIN
    IF @sql_handle IS NOT NULL AND
       EXISTS (SELECT sql_handle FROM snapshots.notable_query_text WHERE sql_handle = @sql_handle AND source_id = @source_id)
    BEGIN
        INSERT INTO @query_text
        (
            database_id,
            object_id,
            object_name,
            query_text
        )
        SELECT
            t.database_id,
            t.object_id,
            t.object_name,
            [snapshots].[fn_get_query_fragment](t.sql_text, @statement_start_offset, @statement_end_offset)
        FROM
            snapshots.notable_query_text t
        WHERE
            t.sql_handle = @sql_handle
            AND t.source_id = @source_id
    END

    RETURN
END
GO
