/* CreateDate: 01/03/2014 07:07:46.600 , ModifyDate: 01/03/2014 07:07:46.600 */
GO
CREATE FUNCTION [core].[fn_query_text_from_handle](
    @handle varbinary(64),
    @statement_start_offset int,
    @statement_end_offset int)
RETURNS @query_text TABLE (database_id smallint, object_id int, encrypted bit, query_text nvarchar(max))
BEGIN
      IF @handle IS NOT NULL
      BEGIN
            DECLARE @start int, @end int
            DECLARE @dbid smallint, @objectid int, @encrypted bit
            DECLARE @batch nvarchar(max), @query nvarchar(max)

            -- statement_end_offset is zero prior to beginning query execution (e.g., compilation)
            SELECT
                  @start = ISNULL(@statement_start_offset, 0),
                  @end = CASE WHEN @statement_end_offset is null or @statement_end_offset = 0 THEN -1
                                    ELSE @statement_end_offset
                              END

            SELECT @dbid = t.dbid,
                  @objectid = t.objectid,
                  @encrypted = t.encrypted,
                  @batch = t.text
            FROM sys.dm_exec_sql_text(@handle) AS t

            SELECT @query = CASE
                        WHEN @encrypted = CAST(1 as bit) THEN N'encrypted text'
                        ELSE LTRIM(SUBSTRING(@batch, @start / 2 + 1, ((CASE WHEN @end = -1 THEN DATALENGTH(@batch)
                                          ELSE @end END) - @start) / 2))
                  end

            -- Found internal queries (e.g., CREATE INDEX) with end offset of original batch that is
            -- greater than the length of the internal query and thus returns nothing if we don''t do this
            IF DATALENGTH(@query) = 0
            BEGIN
                  SELECT @query = @batch
            END

            INSERT INTO @query_text (database_id, object_id, encrypted, query_text)
            VALUES (@dbid, @objectid, @encrypted, @query)
      END
      RETURN
END
GO
