/* CreateDate: 05/03/2010 12:26:40.577 , ModifyDate: 11/30/2018 12:44:38.273 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_DimContactSource_Extract_CDC]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimContactSource_Extract_CDC] is used to retrieve a
-- list Contact Emails
--
--   exec [bi_mktg_stage].[spHC_DimContactSource_Extract_CDC]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    08/11/2009  RLifke       Initial Creation
-------------------------------------------------------------------------
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;



	DECLARE		  @intError			int				-- error code
				, @intDBErrorLogID	int				-- ID of error record logged
				, @intRowCount		int				-- count of rows modified
				, @vchTagValueList	nvarchar(1000)	-- Named Valued Pairs of Parameters
 				, @return_value		int

	DECLARE		  @TableName			varchar(150)	-- Name of table
				, @CDCTableName			varchar(150)	-- Name of CDC table
				, @ExtractRowCnt		int

 	SET @TableName = N'[bi_mktg_dds].[DimContactSource]'
 	SET @CDCTableName = N'dbo_oncd_contact_source'


	BEGIN TRY

	   -- Put parameters in name value list to aid in reporting
		EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@LSET'
				, @LSET
				, N'@CET'
				, @CET

		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_ExtractStart] @DataPkgKey, @TableName, @LSET, @CET

		IF (@CET IS NOT NULL) AND (@LSET IS NOT NULL)
			BEGIN

				--DECLARE	@Start_Time datetime = null,
				--		@End_Time datetime = null,
				--		@row_filter_option nvarchar(30) = N'all'

				--DECLARE @From_LSN binary(10), @To_LSN binary(10)

				--SET @Start_Time = @LSET
				--SET @End_Time = @CET

				--IF (@Start_Time is null)
				--	SELECT @From_LSN = [HCM].[sys].[fn_cdc_get_min_lsn](@CDCTableName)
				--ELSE
				--BEGIN
				--	IF ([HCM].[sys].[fn_cdc_map_lsn_to_time]([HCM].[sys].[fn_cdc_get_min_lsn](@CDCTableName)) > @Start_Time) or
				--	   ([HCM].[sys].[fn_cdc_map_lsn_to_time]([HCM].[sys].[fn_cdc_get_max_lsn]()) < @Start_Time)
				--		SELECT @From_LSN = null
				--	ELSE
				--		SELECT @From_LSN = [HCM].[sys].[fn_cdc_increment_lsn]([HCM].[sys].[fn_cdc_map_time_to_lsn]('largest less than or equal',@Start_Time))
				--END

				--IF (@End_Time is null)
				--	SELECT @To_LSN = [HCM].[sys].[fn_cdc_get_max_lsn]()
				--ELSE
				--BEGIN
				--	IF [HCM].[sys].[fn_cdc_map_lsn_to_time]([HCM].[sys].[fn_cdc_get_max_lsn]()) < @End_Time
				--		--SELECT @To_LSN = null
				--		SELECT @To_LSN = [HCM].[sys].[fn_cdc_get_max_lsn]()
				--	ELSE
				--		SELECT @To_LSN = [HCM].[sys].[fn_cdc_map_time_to_lsn]('largest less than or equal',@End_Time)
				--END


				---- Get the Actual Current Extraction Time
				--SELECT @CET = [HCM].[sys].[fn_cdc_map_lsn_to_time](@To_LSN)

				--IF (@From_LSN IS NOT NULL) AND (@To_LSN IS NOT NULL) AND (@From_LSN <> [HCM].[sys].[fn_cdc_increment_lsn](@To_LSN))
				--	BEGIN

						-- Set the Current Extraction Time & Status
						UPDATE [bief_stage].[_DataFlow]
							SET CET = @CET
								, [Status] = 'Extracting'
							WHERE [TableName] = @TableName


						--INSERT INTO [bi_mktg_stage].[DimContactSource]
						--		   ( [DataPkgKey]
						--		   , [ContactSourceKey]
						--		   , [ContactSourceSSID]
						--		   , [ContactSSID]
						--		   , [SourceCode]
						--		   , [MediaCode]
						--		   , [AssignmentDate]
						--		   , [AssignmentTime]
						--		   , [PrimaryFlag]
						--		   , [DNIS_Number]
						--		   , [SubSourceCode]
						--		   , [ModifiedDate]
						--		   , [IsNew]
						--		   , [IsType1]
						--		   , [IsType2]
						--		   , [IsException]
						--		   , [IsInferredMember]
						--			, [IsDelete]
						--			, [IsDuplicate]
						--		   , [SourceSystemKey]
						--		   , [CDC_Operation]
						--			)
						--SELECT @DataPkgKey
						--		, NULL AS [ContactSourceKey]
						--		, CAST(ISNULL(LTRIM(RTRIM(chg.[contact_source_id])),'') AS nvarchar(10)) AS [ContactSourceSSID]
						--		, CAST(ISNULL(LTRIM(RTRIM(chg.[contact_id])),'') AS nvarchar(10)) AS [ContactSSID]
						--		, CAST(ISNULL(LTRIM(RTRIM(chg.[source_code])),'') AS nvarchar(20)) AS [SourceCode]
						--		, CAST(ISNULL(LTRIM(RTRIM(chg.[media_code])),'') AS nvarchar(10)) AS [MediaCode]
						--		, CAST(ISNULL(LTRIM(RTRIM(chg.[assignment_date])),'') AS date) AS [AssignmentDate]
						--		, CAST(ISNULL(LTRIM(RTRIM(chg.[assignment_date])),'') AS time(0)) AS [AssignmentTime]
						--		, CAST(ISNULL(LTRIM(RTRIM(chg.[primary_flag])),'') AS nchar(1)) AS [PrimaryFlag]
						--		, CAST(ISNULL(LTRIM(RTRIM(chg.[cst_dnis_Number])),0) AS int) AS [DNIS_Number]
						--		, CAST(ISNULL(LTRIM(RTRIM(chg.[cst_sub_source_code])),'') AS nvarchar(10)) AS [SubSourceCode]
						--		, [HCM].[sys].[fn_cdc_map_lsn_to_time](__$start_lsn) AS [ModifiedDate]
						--		, 0 AS [IsNew]
						--		, 0 AS [IsType1]
						--		, 0 AS [IsType2]
						--		, 0 AS [IsException]
						--		, 0 AS [IsInferredMember]
						--		, 0 AS [IsDelete]
						--		, 0 AS [IsDuplicate]
						--		, CAST(ISNULL(LTRIM(RTRIM(chg.[contact_source_id])),'') AS nvarchar(50)) AS [SourceSystemKey]
						--		, CASE [__$operation]
						--				WHEN 1 THEN 'D'
						--				WHEN 2 THEN 'I'
						--				WHEN 3 THEN 'UO'
						--				WHEN 4 THEN 'UN'
						--				WHEN 5 THEN 'M'
						--				ELSE NULL
						--			END AS [CDC_Operation]
						--FROM [HCM].[cdc].[fn_cdc_get_net_changes_dbo_oncd_contact_source](@From_LSN, @To_LSN, @row_filter_option) chg
						--LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_contact] con WITH (NOLOCK)
						--			 ON con.[contact_id] = chg.[contact_id]

						--SET @ExtractRowCnt = @@ROWCOUNT

						SET @ExtractRowCnt = 0

						-- Set the Last Successful Extraction Time & Status
						UPDATE [bief_stage].[_DataFlow]
							SET LSET = @CET
								, [Status] = 'Extraction Completed'
							WHERE [TableName] = @TableName

					--END
		END

		IF (@ExtractRowCnt IS NULL) SET @ExtractRowCnt = 0

		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_ExtractStop] @DataPkgKey, @TableName, @ExtractRowCnt

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


/****** Object:  StoredProcedure [bi_mktg_stage].[spHC_DimEmployee_Extract]    Script Date: 11/30/2018 12:37:12 PM ******/
SET ANSI_NULLS ON
GO
