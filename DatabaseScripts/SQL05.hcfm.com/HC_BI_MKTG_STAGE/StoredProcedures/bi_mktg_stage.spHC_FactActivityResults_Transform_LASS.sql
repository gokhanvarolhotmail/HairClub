/* CreateDate: 05/03/2010 12:26:54.817 , ModifyDate: 09/10/2020 21:12:09.040 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactActivityResults_Transform_LASS]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_FactActivityResults_Transform_LASS] is used to determine
-- the LASS
--
--
--   exec [bi_mktg_stage].[spHC_FactActivityResults_Transform_LASS] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    09/21/2009  RLifke       Initial Creation
--			10/14/2016  KMurdoch     Added ShowDiff and SaleDiff Calculation
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

	DECLARE		@TableName			varchar(150)	-- Name of table
	DECLARE		@DataPkgDetailKey	int

 	SET @TableName = N'[bi_mktg_dds].[FactActivityResults]'

 	   -- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY



		-----------------------
		-- Update Shows, No Shows, Sales, NoSale
		-----------------------
		UPDATE STG SET
			   [Appointments] = [bi_mktg_stage].fn_IsAppointment(STG.ActionCodeSSID, STG.ResultCodeSSID)
			 , [Show] = [bi_mktg_stage].fn_IsShow(STG.ResultCodeSSID)
			 , [NoShow] = [bi_mktg_stage].fn_IsNoShow(STG.ResultCodeSSID)
			 , [Sale] = [bi_mktg_stage].fn_IsSale(STG.ResultCodeSSID)
			 , [NoSale] = [bi_mktg_stage].fn_IsNoSale(STG.ResultCodeSSID)
			 , [Consultation] = [bi_mktg_stage].fn_IsConsultation(STG.ActionCodeSSID, STG.ResultCodeSSID)
			 , [BeBack] = [bi_mktg_stage].fn_IsBeBack(STG.ActionCodeSSID, STG.ResultCodeSSID)

			 , [SurgeryOffered] = CASE
						WHEN STG.[SurgeryOfferedFlag] = 'Y' THEN 1
						WHEN STG.[SurgeryOfferedFlag] = 'N' THEN 0
						ELSE 0
						END
			 , [ReferredToDoctor] = CASE
						WHEN STG.[ReferredToDoctorFlag] = 'Y' THEN 1
						WHEN STG.[ReferredToDoctorFlag] = 'N' THEN 0
						ELSE 0
						END
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey


		--
		-- Show Differential = First Show Date - Lead Create Date
		--
		UPDATE FL
		SET FL.SHOWDIFF = DATEDIFF(DAY,[LeadCreationDateSSID],[ActivityDueDateSSID])
		FROM [bi_mktg_stage].[FactActivityResults] STG
		INNER JOIN bi_mktg_stage.FactLead FL
		ON FL.ContactKey = STG.ContactKey
		WHERE FL.SHOWDIFF IS NULL
			AND STG.SHOW = 1


		--
		-- Sale Differential = First Sale Date - Lead Create Date
		--
		UPDATE FL
		SET FL.SALEDIFF = DATEDIFF(DAY,[LeadCreationDateSSID],[ActivityDueDateSSID])
		FROM [bi_mktg_stage].[FactActivityResults] STG
		INNER JOIN bi_mktg_stage.FactLead FL
		ON FL.ContactKey = STG.ContactKey
		WHERE FL.SALEDIFF IS NULL
			AND STG.SALE = 1


		-----------------------
		-- Exception if  IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[Show] IS NULL
				OR STG.[NoShow] IS NULL
				OR STG.[Sale] IS NULL
				OR STG.[NoSale] IS NULL
				OR STG.[SurgeryOffered] IS NULL
				OR STG.[ReferredToDoctor] IS NULL
				)


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
