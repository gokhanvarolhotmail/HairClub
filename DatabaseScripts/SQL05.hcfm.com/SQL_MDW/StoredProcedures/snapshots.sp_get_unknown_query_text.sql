/* CreateDate: 01/03/2014 07:07:48.697 , ModifyDate: 01/03/2014 07:07:48.697 */
GO
CREATE PROCEDURE [snapshots].[sp_get_unknown_query_text]
    @source_id  int
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        [source_id],
        [sql_handle]
    FROM
        [snapshots].[notable_query_text]
    WHERE
        [source_id] = @source_id
        AND [sql_text] IS NULL
END;
GO
