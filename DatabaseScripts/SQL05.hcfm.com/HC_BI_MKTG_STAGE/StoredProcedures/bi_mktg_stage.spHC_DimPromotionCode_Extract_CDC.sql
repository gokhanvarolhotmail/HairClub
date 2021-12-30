/* CreateDate: 02/03/2011 15:18:27.373 , ModifyDate: 08/30/2021 21:15:49.217 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_DimPromotionCode_Extract_CDC]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimPromotionCode_Extract_CDC] is used to retrieve a
-- list PromotionCode
--
--   exec [bi_mktg_stage].[spHC_DimPromotionCode_Extract_CDC] 1, '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    02/03/2009               Initial Creation
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

 	SET @TableName = N'[bi_mktg_dds].[DimPromotionCode]'
 	SET @CDCTableName = N'dbo_csta_promotion_code'


	BEGIN TRY

	   -- Put parameters in name value list to aid in reporting
		EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@LSET'
				, @LSET
				, N'@CET'
				, @CET

		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_ExtractStart] @DataPkgKey, @TableName

		IF (@CET IS NOT NULL) AND (@LSET IS NOT NULL)
			BEGIN

					-- Set the Current Extraction Time & Status
					UPDATE [bief_stage].[_DataFlow]
						SET CET = @CET
							, [Status] = 'Extracting'
						WHERE [TableName] = @TableName


					INSERT INTO [bi_mktg_stage].[DimPromotionCode]
								( [DataPkgKey]
								, [PromotionCodeKey]
								, [PromotionCodeSSID]
								, [PromotionCodeDescription]
								, [Active]
								, [ModifiedDate]
								, [IsNew]
								, [IsType1]
								, [IsType2]
								, [IsException]
								, [IsInferredMember]
								, [IsDelete]
								, [IsDuplicate]
								, [SourceSystemKey]
								)

					SELECT
					@DataPkgKey
					,NULL	AS PromotionCodeKey
					,PromoCode__c
					,'' AS PromotionCodeDescription
					,CASE WHEN PromoCode__c.isactiveflag = 1 THEN 'Y'
							WHEN PromoCode__c.isactiveflag = 0 THEN 'N' ELSE '' END AS active
					,lastmodifieddate
					, 0 AS IsNew
					, 0 AS IsType1
					, 0 AS IsType2
					, 0 AS IsException
					, 0 AS IsInferredMember
					, 0 AS IsDelete
					, 0 AS IsDuplicate
					--,PromoCode__c AS SourceSystemKey
					--,id AS SourceSystemKey
				    ,CAST(ISNULL(LTRIM(RTRIM(id)), '') AS VARCHAR(18)) AS 'SourceSystemKey'
					FROM SQL06.HC_BI_SFDC.dbo.PromoCode__c WITH ( NOLOCK )


					SET @ExtractRowCnt = @@ROWCOUNT

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



/****** Object:  StoredProcedure [bi_mktg_stage].[spHC_FactLead_Extract]    Script Date: 11/30/2018 12:42:59 PM ******/
SET ANSI_NULLS ON
GO
