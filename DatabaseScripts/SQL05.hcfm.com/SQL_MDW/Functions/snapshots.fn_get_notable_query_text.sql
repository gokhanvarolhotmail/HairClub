/* CreateDate: 01/03/2014 07:07:51.450 , ModifyDate: 01/03/2014 07:07:51.450 */
GO
CREATE FUNCTION [snapshots].[fn_get_notable_query_text](
    @source_id int
)
RETURNS @notable_text TABLE (sql_handle varbinary(64))
BEGIN
    INSERT INTO @notable_text
    SELECT  [sql_handle]
    FROM    [snapshots].[notable_query_text]
    WHERE   [source_id] = @source_id
    ORDER BY [sql_handle] ASC

    RETURN
END
GO
