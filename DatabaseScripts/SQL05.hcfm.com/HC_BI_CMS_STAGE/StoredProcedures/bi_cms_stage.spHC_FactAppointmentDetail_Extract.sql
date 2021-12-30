/* CreateDate: 06/27/2011 17:22:53.887 , ModifyDate: 01/03/2013 14:54:02.457 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactAppointmentDetail_Extract]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_FactAppointmentDetail_Extract] is used to retrieve a
-- list Sales Transactions
--
--   exec [bi_cms_stage].[spHC_FactAppointmentDetail_Extract]  '2011-01-01 01:00:00'
--                                       , '2011-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/22/2011  KMurdoch       Initial Creation
--			01/03/2013  EKnapp       Use UTC Current Extraction Time.
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
				, @CET_UTC              datetime

 	SET @TableName = N'[bi_cms_dds].[FactAppointmentDetail]'


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

				-- Convert our Current Extraction Time to UTC time for compare in the Where clause to ensure we pick up latest data.
				SELECT @CET_UTC = [bief_stage].[fn_CorporateToUTCDateTime](@CET)

				INSERT INTO [HC_BI_CMS_STAGE].[bi_cms_stage].[FactAppointmentDetail]
						   ([DataPkgKey]
   						   ,[AppointmentDetailKey]
						   ,[AppointmentDetailSSID]
						   ,[AppointmentKey]
						   ,[AppointmentSSID]
						   ,[SalesCodeKey]
						   ,[SalesCodeSSID]
						   ,[AppointmentDetailDuration]
						   ,[IsException]
						   ,[IsDelete]
						   ,[IsDuplicate]
						   ,[SourceSystemKey]
							)

				SELECT
							@DataPkgKey
							, NULL AS [AppointmentDetailKey]
							, COALESCE(apptdet.[AppointmentDetailGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [AppointmentDetailSSID]
							, NULL AS [AppointmentKey]
							, COALESCE(apptdet.[AppointmentGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [AppointmentSSID]
							, 0 AS [SalesCodeKey]
							, COALESCE(apptdet.[SalesCodeID],-2) AS [CenterSSID]
							, apptdet.AppointmentDetailDuration
	    					, 0 AS [IsException]
							, 0 AS [IsDelete]
							, 0 AS [IsDuplicate]
							, CAST(ISNULL(LTRIM(RTRIM(apptdet.AppointmentDetailGUID)),'') AS nvarchar(50)) AS [SourceSystemKey]
						FROM  bi_cms_stage.synHC_SRC_TBL_CMS_datAppointmentDetail apptdet
				WHERE (apptdet.[CreateDate] >= @LSET AND apptdet.[CreateDate] < @CET_UTC)
				   OR (apptdet.[LastUpdate] >= @LSET AND apptdet.[LastUpdate] < @CET_UTC)

				SET @ExtractRowCnt = @@ROWCOUNT

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
GO
