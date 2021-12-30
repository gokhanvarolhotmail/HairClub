/* CreateDate: 05/03/2010 12:26:23.170 , ModifyDate: 05/03/2010 12:26:23.170 */
GO
CREATE PROCEDURE [bief_stage].[_DataFlow_GetExtractionTime]
		@TimeIncrement		int = 1
	  , @TimeIncrementUnit	varchar(10) = 'DAY'	-- now,year,month,quarter,day,hour,minute
	  , @TableName			varchar(250)
	  , @LSET				datetime output		-- Last Successful Extraction Time
	  , @CET				datetime output		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [_DataFlow_GetExtractionTime] is used to determine the
-- next extraction time based upon last successful extraction time
-- and the time increment
-- NOTE: Extraction time cannot be greater than GETDATE()
--
--   exec [bief_stage].[_DataFlow_GetExtractionTime]  1, 'DAY'
--              , '[bief_stage].[DimDate]'
--
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    02/25/2009  RLifke       Initial Creation
-------------------------------------------------------------------------
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;



	DECLARE		  @intError			int				-- error code
				, @intDBErrorLogID	int				-- ID of error record logged
				, @intRowCount		int				-- count of rows modified
				, @vchTagValueList	nvarchar(1000)	-- Named Valued Pairs of Parameters


	BEGIN TRY

	   -- Put parameters in name value list to aid in reporting
		EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@TimeIncrement'
				, @TimeIncrement
				, N'@TimeIncrementUnit'
				, @TimeIncrementUnit
				, N'@TableName'
				, @TableName
				, N'@LSET'
				, @LSET
				, N'@CET'
				, @CET

		-- Get the last successful extraction Time
		SELECT @LSET = LSET
		FROM [bief_stage].[_DataFlow]
		WHERE [TableName] = @TableName

		IF (@LSET IS NOT NULL)
			BEGIN
				IF (UPPER(@TimeIncrementUnit) = 'NOW')
					BEGIN
						SET @CET = GETDATE()
					END
				IF (UPPER(@TimeIncrementUnit) = 'MINUTE')
					BEGIN
						SET @CET = DATEADD(minute, @TimeIncrement, @LSET)
					END
				IF (UPPER(@TimeIncrementUnit) = 'HOUR')
					BEGIN
						SET @CET = DATEADD(hour, @TimeIncrement, @LSET)
					END
				IF (UPPER(@TimeIncrementUnit) = 'DAY')
					BEGIN
						SET @CET = DATEADD(day, @TimeIncrement, @LSET)
					END
				IF (UPPER(@TimeIncrementUnit) = 'MONTH')
					BEGIN
						SET @CET = DATEADD(month, @TimeIncrement, @LSET)
					END
				IF (UPPER(@TimeIncrementUnit) = 'QUARTER')
					BEGIN
						SET @CET = DATEADD(quarter, @TimeIncrement, @LSET)
					END
				IF (UPPER(@TimeIncrementUnit) = 'YEAR')
					BEGIN
						SET @CET = DATEADD(year, @TimeIncrement, @LSET)
					END

				-- Can't set CET to the future
				IF (@CET > GETDATE())
					BEGIN
						SET @CET = GETDATE()
					END
				IF (@CET IS NULL)
					BEGIN
						SET @LSET = NULL
					END
			END
		ELSE
			BEGIN
				SET @CET = NULL
			END

		-- Cleanup
		-- Reset SET NOCOUNT to OFF.
		SET NOCOUNT OFF

		-- Cleanup temp tables

		-- Return success
		RETURN 0
	END TRY
    BEGIN CATCH
		-- Save original error number
		SET @intError = ERROR_NUMBER();

		-- Log the error
		EXECUTE [bief_stage].[_DBErrorLog_LogError]
					  @DBErrorLogID = @intDBErrorLogID OUTPUT
					, @tagValueList = @vchTagValueList;

		-- Re Raise the error
		EXECUTE [bief_stage].[_DBErrorLog_RethrowError] @vchTagValueList;

		-- Cleanup
		-- Reset SET NOCOUNT to OFF.
		SET NOCOUNT OFF
		-- Cleanup temp tables

		-- Return the error number
		RETURN @intError;
    END CATCH


END
GO
