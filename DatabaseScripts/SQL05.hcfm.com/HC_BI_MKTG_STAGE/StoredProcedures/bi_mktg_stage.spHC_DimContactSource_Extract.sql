/* CreateDate: 05/03/2010 12:26:38.533 , ModifyDate: 11/30/2018 12:44:38.240 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_DimContactSource_Extract]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimContactSource_Extract] is used to retrieve a
-- list of Contact Emails
--
--   exec [bi_mktg_stage].[spHC_DimContactSource_Extract]  '2009-01-01 01:00:00'
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
				, @ExtractRowCnt		int

 	SET @TableName = N'[bi_mktg_dds].[DimContactSource]'


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
				--			)
				--SELECT @DataPkgKey
				--		, NULL AS [ContactSourceKey]
				--		, CAST(ISNULL(LTRIM(RTRIM(contact_source.[contact_source_id])),'') AS nvarchar(10)) AS [ContactSourceSSID]
				--		, CAST(ISNULL(LTRIM(RTRIM(contact_source.[contact_id])),'') AS nvarchar(10)) AS [ContactSSID]
				--		, CAST(ISNULL(LTRIM(RTRIM(contact_source.[source_code])),'') AS nvarchar(20)) AS [SourceCode]
				--		, CAST(ISNULL(LTRIM(RTRIM(contact_source.[media_code])),'') AS nvarchar(10)) AS [MediaCode]
				--		, CAST(ISNULL(LTRIM(RTRIM(contact_source.[assignment_date])),'') AS date) AS [AssignmentDate]
				--		, CAST(ISNULL(LTRIM(RTRIM(contact_source.[assignment_date])),'') AS time(0)) AS [AssignmentTime]
				--		, CAST(ISNULL(LTRIM(RTRIM(contact_source.[primary_flag])),'') AS nchar(1)) AS [PrimaryFlag]
				--		, CAST(ISNULL(LTRIM(RTRIM(contact_source.[cst_dnis_Number])),0) AS int) AS [DNIS_Number]
				--		, CAST(ISNULL(LTRIM(RTRIM(contact_source.[cst_sub_source_code])),'') AS nvarchar(10)) AS [SubSourceCode]
				--		, '' --[LastUpdate] AS [ModifiedDate]
				--		, 0 AS [IsNew]
				--		, 0 AS [IsType1]
				--		, 0 AS [IsType2]
				--		, 0 AS [IsException]
				--		, 0 AS [IsInferredMember]
				--		, 0 AS [IsDelete]
				--		, 0 AS [IsDuplicate]
				--		, CAST(ISNULL(LTRIM(RTRIM([contact_source_id])),'') AS nvarchar(50)) AS [SourceSystemKey]
				--FROM [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_contact_source] contact_source WITH (NOLOCK)
				--LEFT OUTER JOIN [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_contact] con WITH (NOLOCK)
				--			 ON con.[contact_id] = contact_source.[contact_id]

				--WHERE (contact_source.[creation_date] >= @LSET AND contact_source.[creation_date] < @CET)
				--  OR (contact_source.[updated_date] >= @LSET AND contact_source.[updated_date] < @CET)
				--  OR (con.[creation_date] >= @LSET AND con.[creation_date] < @CET)
				--  OR (con.[updated_date] >= @LSET AND con.[updated_date] < @CET)

				--   --OR (contact_source.[creation_date] < '1/1/1990')      ---Only on first load
				--   --OR (contact_source.[creation_date] IS NULL)      ---Only on first load

				--SET @ExtractRowCnt = @@ROWCOUNT

				SET @ExtractRowCnt = 0

				-- Set the Last Successful Extraction Time & Status
				UPDATE [bief_stage].[_DataFlow]
					SET LSET = @CET
						, [Status] = 'Extraction Completed'
					WHERE [TableName] = @TableName
		END

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


/****** Object:  StoredProcedure [bi_mktg_stage].[spHC_DimContactSource_Extract_CDC]    Script Date: 11/30/2018 12:36:41 PM ******/
SET ANSI_NULLS ON
GO
