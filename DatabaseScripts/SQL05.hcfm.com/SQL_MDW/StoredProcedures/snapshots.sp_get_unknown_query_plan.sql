/* CreateDate: 01/03/2014 07:07:48.733 , ModifyDate: 01/03/2014 07:07:48.733 */
GO
CREATE PROCEDURE [snapshots].[sp_get_unknown_query_plan]
    @source_id       int
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        [source_id],
        [sql_handle],
        [plan_handle],
        [statement_start_offset],
        [statement_end_offset],
        [plan_generation_num]
    FROM
        [snapshots].[notable_query_plan]
    WHERE
        [source_id] = @source_id
        AND [query_plan] IS NULL
END;
GO
