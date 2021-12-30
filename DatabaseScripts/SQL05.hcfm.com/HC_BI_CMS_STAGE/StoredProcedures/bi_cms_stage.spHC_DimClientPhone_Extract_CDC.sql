/* CreateDate: 07/07/2017 11:06:08.470 , ModifyDate: 07/07/2017 12:17:24.663 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimClientPhone_Extract_CDC]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimClientPhone_Extract_CDC] is used to retrieve a
-- list ClientPhone
--
--   exec [bi_cms_stage].[spHC_DimClientPhone_Extract_CDC]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    07/06/2017  SHietpas       Initial Creation
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

 	SET @TableName = N'[bi_cms_dds].[DimClientPhone]'
 	SET @CDCTableName = N'dbo_datClientPhone'


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

				DECLARE	@Start_Time datetime = null,
						@End_Time datetime = null,
						@row_filter_option nvarchar(30) = N'all'

				DECLARE @From_LSN binary(10), @To_LSN binary(10)

				SET @Start_Time = @LSET
				SET @End_Time = @CET

				IF (@Start_Time is null)
					SELECT @From_LSN = [HairClubCMS].[sys].[fn_cdc_get_min_lsn](@CDCTableName)
				ELSE
				BEGIN
					IF ([HairClubCMS].[sys].[fn_cdc_map_lsn_to_time]([HairClubCMS].[sys].[fn_cdc_get_min_lsn](@CDCTableName)) > @Start_Time) or
					   ([HairClubCMS].[sys].[fn_cdc_map_lsn_to_time]([HairClubCMS].[sys].[fn_cdc_get_max_lsn]()) < @Start_Time)
						SELECT @From_LSN = null
					ELSE
						SELECT @From_LSN = [HairClubCMS].[sys].[fn_cdc_increment_lsn]([HairClubCMS].[sys].[fn_cdc_map_time_to_lsn]('largest less than or equal',@Start_Time))
				END

				IF (@End_Time is null)
					SELECT @To_LSN = [HairClubCMS].[sys].[fn_cdc_get_max_lsn]()
				ELSE
				BEGIN
					IF [HairClubCMS].[sys].[fn_cdc_map_lsn_to_time]([HairClubCMS].[sys].[fn_cdc_get_max_lsn]()) < @End_Time
						--SELECT @To_LSN = null
						SELECT @To_LSN = [HairClubCMS].[sys].[fn_cdc_get_max_lsn]()
					ELSE
						SELECT @To_LSN = [HairClubCMS].[sys].[fn_cdc_map_time_to_lsn]('largest less than or equal',@End_Time)
				END


				-- Get the Actual Current Extraction Time
				SELECT @CET = [HairClubCMS].[sys].[fn_cdc_map_lsn_to_time](@To_LSN)

				IF (@From_LSN IS NOT NULL) AND (@To_LSN IS NOT NULL) AND (@From_LSN <> [HairClubCMS].[sys].[fn_cdc_increment_lsn](@To_LSN))
					BEGIN

						-- Set the Current Extraction Time & Status
						UPDATE [bief_stage].[_DataFlow]
							SET CET = @CET
								, [Status] = 'Extracting'
							WHERE [TableName] = @TableName


				INSERT INTO [bi_cms_stage].[DimClientPhone]
						   ( [DataPkgKey]
						   ,[ClientPhoneKey]
						   ,[ClientPhoneSSID]
						   ,[ClientKey]
						   ,[PhoneTypeDescription]
						   ,[PhoneNumber]
						   ,[CanConfirmAppointmentByCall]
						   ,[CanConfirmAppointmentByText]
						   ,[CanContactForPromotionsByCall]
						   ,[CanContactForPromotionsByText]
						   ,[ClientPhoneSortOrder]
						   ,[LastUpdate]
						   ,[LastUpdateUser]
						   ,[lkpClientKey_ClientSSID]
						   ,[SourceSystemKey]
						   ,[ModifiedDate]
						   ,[IsNew]
						   ,[IsType1]
						   ,[IsType2]
						   ,[IsDelete]
						   ,[IsDuplicate]
						   ,[IsInferredMember]
						   ,[IsException]
						   ,[IsHealthy]
						   ,[IsRejected]
						   ,[IsAllowed]
						   ,[IsFixed]
						   ,[RuleKey]
						   ,[DataQualityAuditKey]
						   ,[IsNewDQA]
						   ,[IsValidated]
						   ,[IsLoaded]
						   ,[CDC_Operation]
						   ,[ExceptionMessage])

				SELECT @DataPkgKey
						   ,[ClientPhoneKey]=NULL
						   ,[ClientPhoneSSID]=chg.[ClientPhoneID]
						   ,[ClientKey]=NULL
							,[PhoneTypeDescription]=COALESCE(PT.[PhoneTypeDescription],'Unknown')
							,[PhoneNumber]=chg.[PhoneNumber]
							,[CanConfirmAppointmentByCall]=COALESCE(chg.[CanConfirmAppointmentByCall],CAST(0 as bit))
							,[CanConfirmAppointmentByText]=COALESCE(chg.[CanConfirmAppointmentByText],CAST(0 as bit))
							,[CanContactForPromotionsByCall]=COALESCE(chg.[CanContactForPromotionsByCall],CAST(0 as bit))
							,[CanContactForPromotionsByText]=COALESCE(chg.[CanContactForPromotionsByText],CAST(0 as bit))
							,[ClientPhoneSortOrder]=chg.[ClientPhoneSortOrder]
						   ,[LastUpdate]=chg.[LastUpdate]
						   ,[LastUpdateUser]=chg.[LastUpdateUser]
						   ,[lkpClientKey_ClientSSID]=chg.[ClientGUID]
						   ,[SourceSystemKey]=chg.[ClientPhoneID]

						, [HairClubCMS].[sys].[fn_cdc_map_lsn_to_time](__$start_lsn) AS [ModifiedDate]
						, 0 AS [IsNew]
						, 0 AS [IsType1]
						, 0 AS [IsType2]
						, 0 AS [IsDelete]
						, 0 AS [IsDuplicate]
						, 0 AS [IsInferredMember]
						, 0 AS [IsException]
						, 0 AS [IsHealthy]
						, 0 AS [IsRejected]
						, 0 AS [IsAllowed]
						, 0 AS [IsFixed]
						, 0 AS [RuleKey]
						, 0 AS [DataQualityAuditKey]
						, 0 AS [IsNewDQA]
						, 0 AS [IsValidated]
						, 0 AS [IsLoaded]
						, CASE [__$operation]
								WHEN 1 THEN 'D'
								WHEN 2 THEN 'I'
								WHEN 3 THEN 'UO'
								WHEN 4 THEN 'UN'
								WHEN 5 THEN 'M'
								ELSE NULL
							END AS [CDC_Operation]
						, NULL AS [ExceptionMessage]
				FROM [HairClubCMS].[cdc].[fn_cdc_get_net_changes_dbo_datClientPhone](@From_LSN, @To_LSN, @row_filter_option) chg
					LEFT JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpPhoneType] PT
						ON chg.[PhoneTypeID] = PT.[PhoneTypeID]


						SET @ExtractRowCnt = @@ROWCOUNT

						-- Set the Last Successful Extraction Time & Status
						UPDATE [bief_stage].[_DataFlow]
							SET LSET = @CET
								, [Status] = 'Extraction Completed'
							WHERE [TableName] = @TableName

					END
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
