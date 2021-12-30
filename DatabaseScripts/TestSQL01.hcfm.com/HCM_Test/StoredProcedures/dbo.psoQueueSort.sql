/* CreateDate: 10/15/2013 00:31:04.597 , ModifyDate: 10/15/2013 00:31:04.597 */
GO
CREATE PROCEDURE [dbo].[psoQueueSort]
	@QueueId NCHAR(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @SortFilter NVARCHAR(MAX)
	SET @SortFilter = ''

	DECLARE @TableName		NVARCHAR(128)
	DECLARE @ColumnName		NVARCHAR(128)
	DECLARE @SortDirection	NVARCHAR(4)

	DECLARE FilterCursor CURSOR FOR
		SELECT
		LTRIM(RTRIM(ISNULL(table_name,''))),
		LTRIM(RTRIM(ISNULL(column_name,''))),
		LTRIM(RTRIM(ISNULL(sort_direction,'')))
		FROM csta_queue_sort
		WHERE queue_id = @QueueId
		ORDER BY sort_order

	OPEN FilterCursor

	FETCH NEXT FROM FilterCursor
	INTO @TableName, @ColumnName, @SortDirection

	WHILE @@FETCH_STATUS = 0
	BEGIN
		IF (LEN(@TableName) > 0 AND LEN(@ColumnName) > 0)
		BEGIN
			SET @SortFilter = @SortFilter + ' ' + @TableName + '.' + @ColumnName + ' '
		END
		ELSE
		BEGIN
			SET @SortFilter = @SortFilter + @TableName + @ColumnName
		END

		SET @SortFilter = @SortFilter + ' ' + @SortDirection + ', '

		FETCH NEXT FROM FilterCursor
		INTO @TableName, @ColumnName, @SortDirection
	END

	CLOSE FilterCursor
	DEALLOCATE FilterCursor

	SET @SortFilter = LTRIM(RTRIM(@SortFilter))

	IF (@SortFilter LIKE ',')
	BEGIN
		SET @SortFilter = SUBSTRING(@SortFilter, 1, LEN(@SortFilter) - 1)
	END

	SELECT @SortFilter
END
GO
