/* CreateDate: 10/15/2013 00:30:16.503 , ModifyDate: 10/15/2013 00:30:16.503 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[psoQueueFilter]
	@QueueId NCHAR(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @SortFilter NVARCHAR(MAX)
	SET @SortFilter = ''

	DECLARE @ExpressionPrefix	NVARCHAR(20)
	DECLARE @TableName			NVARCHAR(128)
	DECLARE @ColumnName			NVARCHAR(128)
	DECLARE @RelationalOperator	NVARCHAR(20)
	DECLARE @FilterValue		NVARCHAR(MAX)
	DECLARE @ExpressionSuffix	NVARCHAR(20)
	DECLARE @LogicalOperator	NVARCHAR(10)
	DECLARE @DataType			NVARCHAR(10)

	DECLARE FilterCursor CURSOR FOR
		SELECT
		LTRIM(RTRIM(ISNULL(expression_prefix,''))),
		LTRIM(RTRIM(ISNULL(table_name,''))),
		LTRIM(RTRIM(ISNULL(column_name,''))),
		LTRIM(RTRIM(ISNULL(relational_operator,''))),
		LTRIM(RTRIM(ISNULL(filter_value,''))),
		LTRIM(RTRIM(ISNULL(expression_suffix,''))),
		LTRIM(RTRIM(ISNULL(logical_operator,''))),
		LTRIM(RTRIM(ISNULL(datatype,'')))
		FROM csta_queue_filter
		WHERE queue_id = @QueueId
		ORDER BY sort_order

	OPEN FilterCursor

	FETCH NEXT FROM FilterCursor
	INTO @ExpressionPrefix, @TableName, @ColumnName, @RelationalOperator, @FilterValue, @ExpressionSuffix, @LogicalOperator, @DataType

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @SortFilter = @SortFilter + ' ' + @ExpressionPrefix + ' '

		IF (LEN(@TableName) > 0 AND LEN(@ColumnName) > 0)
		BEGIN
			SET @SortFilter = @SortFilter + ' ' + @TableName + '.' + @ColumnName + ' '
		END
		ELSE
		BEGIN
			SET @SortFilter = @SortFilter + @TableName + @ColumnName
		END

		SET @SortFilter = @SortFilter + ' ' + @RelationalOperator + ' '

		IF (@RelationalOperator NOT IN ('IS NULL','IS NOT NULL'))
		BEGIN
			IF (@DataType IN ('INT','LITERAL'))
			BEGIN
				SET @SortFilter = @SortFilter + ' ' + @FilterValue + ' '
			END
			ELSE
			BEGIN
				SET @SortFilter = @SortFilter + ' ''' + @FilterValue + ''' '
			END
		END

		SET @SortFilter = @SortFilter + ' ' + @ExpressionSuffix + ' '
		SET @SortFilter = @SortFilter + ' ' + @LogicalOperator + ' '

		FETCH NEXT FROM FilterCursor
		INTO @ExpressionPrefix, @TableName, @ColumnName, @RelationalOperator, @FilterValue, @ExpressionSuffix, @LogicalOperator, @DataType
	END

	CLOSE FilterCursor
	DEALLOCATE FilterCursor

	SET @SortFilter = LTRIM(RTRIM(@SortFilter))

	IF (@SortFilter LIKE '%AND')
	BEGIN
		SET @SortFilter = SUBSTRING(@SortFilter, 1, LEN(@SortFilter) - 3)
	END
	ELSE IF (@SortFilter LIKE '%OR')
	BEGIN
		SET @SortFilter = SUBSTRING(@SortFilter, 1, LEN(@SortFilter) - 2)
	END

	SELECT @SortFilter
END
GO
