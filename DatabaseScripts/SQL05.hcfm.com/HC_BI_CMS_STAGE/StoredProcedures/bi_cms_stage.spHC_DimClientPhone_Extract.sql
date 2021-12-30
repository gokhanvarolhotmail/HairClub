/* CreateDate: 07/06/2017 16:21:52.573 , ModifyDate: 07/07/2017 12:17:01.103 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimClientPhone_Extract]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimClientPhone_Extract] is used to retrieve a
-- list Business Unit Brands
--
--   exec [bi_cms_stage].[spHC_DimClientPhone_Extract]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    07/6/2017  SHietpas       Initial Creation
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

 	SET @TableName = N'[bi_cms_dds].[DimClientPhone]'


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
						   ,[ClientPhoneSSID]=[SRC1].[ClientPhoneID]
						   ,[ClientKey]=NULL
							,[PhoneTypeDescription]=COALESCE(PT.[PhoneTypeDescription],'Unknown')
							,[PhoneNumber]=[SRC1].[PhoneNumber]
							,[CanConfirmAppointmentByCall]=COALESCE([SRC1].[CanConfirmAppointmentByCall],CAST(0 as bit))
							,[CanConfirmAppointmentByText]=COALESCE([SRC1].[CanConfirmAppointmentByText],CAST(0 as bit))
							,[CanContactForPromotionsByCall]=COALESCE([SRC1].[CanContactForPromotionsByCall],CAST(0 as bit))
							,[CanContactForPromotionsByText]=COALESCE([SRC1].[CanContactForPromotionsByText],CAST(0 as bit))
							,[ClientPhoneSortOrder]=[SRC1].[ClientPhoneSortOrder]
						   ,[LastUpdate]=SRC1.[LastUpdate]
						   ,[LastUpdateUser]=SRC1.[LastUpdateUser]
						   ,[lkpClientKey_ClientSSID]=SRC1.[ClientGUID]
						   ,[SourceSystemKey]=[SRC1].[ClientPhoneID]

						, SRC1.[LastUpdate] AS [ModifiedDate]
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
						, NULL AS [CDC_Operation] --if using Track Changes
						, NULL AS [ExceptionMessage]
				FROM [bi_cms_stage].[synHC_SRC_TBL_CMS_datClientPhone]  SRC1
					LEFT JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpPhoneType] PT
						ON SRC1.[PhoneTypeID] = PT.[PhoneTypeID]

				WHERE (SRC1.[CreateDate] >= @LSET AND SRC1.[CreateDate] < @CET_UTC)
				   OR (SRC1.[LastUpdate] >= @LSET AND SRC1.[LastUpdate] < @CET_UTC)

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
