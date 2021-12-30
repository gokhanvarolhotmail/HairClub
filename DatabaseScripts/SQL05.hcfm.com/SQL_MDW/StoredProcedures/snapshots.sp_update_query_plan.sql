/* CreateDate: 01/03/2014 07:07:48.773 , ModifyDate: 01/03/2014 07:07:48.773 */
GO
CREATE PROCEDURE [snapshots].[sp_update_query_plan]
    @source_id                 int,
    @sql_handle                varbinary(64),
    @plan_handle               varbinary(64),
    @statement_start_offset    int          ,
    @statement_end_offset      int          ,
    @plan_generation_num       bigint       ,
    @database_id               smallint     ,
    @object_id                 int          ,
    @object_name               nvarchar(128),
    @query_plan                nvarchar(max)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE [snapshots].[notable_query_plan]
    SET
        database_id     = @database_id,
        object_id       = @object_id,
        object_name     = @object_name,
        query_plan      = @query_plan
    WHERE
        source_id = @source_id
        AND sql_handle = @sql_handle
        AND plan_handle = @plan_handle
        AND statement_start_offset = @statement_start_offset
        AND statement_end_offset = @statement_end_offset
        AND plan_generation_num = @plan_generation_num

END;
GO
