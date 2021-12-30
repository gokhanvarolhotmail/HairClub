/* CreateDate: 01/03/2014 07:07:48.603 , ModifyDate: 01/03/2014 07:07:48.603 */
GO
CREATE FUNCTION [snapshots].[fn_get_query_fragment](
    @sqltext nvarchar(max),
    @start_offset int,
    @end_offset int
)
RETURNS NVARCHAR(MAX)
BEGIN
    DECLARE @query_text NVARCHAR(MAX)

    DECLARE @query_text_length int
    SET @query_text_length = DATALENGTH(@sqltext)

    -- If start_offset was set as null, default to starting byte 0
    IF (@start_offset IS NULL)
    BEGIN
        SET @start_offset = 0
    END

    -- Validate start_offset, return this function if  offset is less than 0
    -- Validate sqltext, if input is NULL, we dont need to continue
    IF (@start_offset < 0 OR @sqltext IS NULL)
    BEGIN
        -- exceptions are not thrown here because caller calls this function on a report query where
        -- throwing exceptions would abort report rendering
        RETURN @query_text
    END

    -- ending position of the query that the row describes within the text of its batch or persisted object.
    -- value of -1 indicates the end of the batch.
    IF (@end_offset IS NULL OR @end_offset = -1 )
    BEGIN
        SET @end_offset = @query_text_length
    END

    -- Set the offset to closest even number. Ex: start_offset = 5, set as start_offset = 4th byte
    SET @start_offset = CEILING(@start_offset/2) *2
    SET @end_offset = CEILING(@end_offset/2) *2

    -- Validate start and end offsets
    IF (@start_offset <= @query_text_length    -- start offset should be  less than length of query string
        AND @end_offset <= @query_text_length      -- end offset should be  less than length of query string
        AND @start_offset <= @end_offset)          -- start offset should be less than end offset
    BEGIN
        -- start and end offsets are the byte's position as reported  in DMV sys.dm_exec_query_stats.
        -- sqltext has a NVARCHAR string where every character takes 2 bytes. SUBSTRING() deals with starting character's position
        -- and length of characters from starting position. so, we are dividing by 2 to convert byte position to character position
        SELECT @query_text = SUBSTRING(@sqltext, @start_offset/2, (@end_offset - @start_offset)/2 + 1)
    END

    RETURN @query_text
END
GO
