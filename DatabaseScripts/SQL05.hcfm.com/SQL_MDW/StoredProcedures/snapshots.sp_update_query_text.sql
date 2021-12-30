/* CreateDate: 01/03/2014 07:07:48.747 , ModifyDate: 01/03/2014 07:07:48.747 */
GO
CREATE PROCEDURE [snapshots].[sp_update_query_text]
    @source_id       int,
    @sql_handle      varbinary(64),
    @database_id     smallint     ,
    @object_id       int          ,
    @object_name     nvarchar(128),
    @sql_text        nvarchar(max)
AS
BEGIN
    SET NOCOUNT ON;

    UPDATE [snapshots].[notable_query_text]
    SET
        database_id = @database_id,
        object_id   = @object_id,
        object_name = @object_name,
        sql_text    = @sql_text
    WHERE
        source_id = @source_id
        AND sql_handle = @sql_handle

END;
GO
