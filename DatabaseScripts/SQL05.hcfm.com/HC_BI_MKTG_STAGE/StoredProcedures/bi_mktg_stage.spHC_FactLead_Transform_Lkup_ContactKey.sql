/* CreateDate: 05/03/2010 12:27:06.140 , ModifyDate: 09/10/2020 20:35:58.703 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactLead_Transform_Lkup_ContactKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_FactLead_Transform_Lkup_ContactKey] is used to determine
-- the ContactKey foreign key values in the FactLead table using DimContact.
--
--
--   exec [bi_mktg_stage].[spHC_FactLead_Transform_Lkup_ContactKey] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    09/21/2009  RLifke       Initial Creation
--			10/26/2011	MBurrell	 Added exception message
--			09/10/2020	DLeiba		 Added Update based on SFDC_PersonAccountID
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

 	SET @TableName = N'[bi_mktg_dds].[DimContact]'

 	   -- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY


		------------------------
		-- There might be some other load that just added them
		-- Update [ContactKey] Keys in STG -BASED ON SFDC_LeadID
		------------------------
		UPDATE STG SET
		     [ContactKey] = COALESCE(DW.[ContactKey], 0)
		FROM [bi_mktg_stage].[FactLead] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimContact] DW ON
				DW.[SFDC_LeadID] = STG.[SFDC_LeadID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[ContactKey], 0) = 0
			AND STG.SFDC_LeadID IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		------------------------
		-- There might be some other load that just added them
		-- Update [ContactKey] Keys in STG - BASED ON SFDC_PersonAccountID
		------------------------
		UPDATE STG SET
		     [ContactKey] = COALESCE(DW.[ContactKey], 0)
		FROM [bi_mktg_stage].[FactLead] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimContact] DW ON
				DW.[SFDC_PersonAccountID] = STG.[SFDC_PersonAccountID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[ContactKey], 0) = 0
			AND STG.SFDC_PersonAccountID IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_mktg_stage].[spHC_FactLead_LoadInferred_DimContact] @DataPkgKey


		-- Update Contact Keys in STG
		UPDATE STG SET
		     [ContactKey] = COALESCE(DW.[ContactKey], 0)
		FROM [bi_mktg_stage].[FactLead] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimContact] DW ON
				DW.[SFDC_LeadID] = STG.[SFDC_LeadID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[ContactKey], 0) = 0
			AND STG.SFDC_LeadID IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		-- Update Contact Keys in STG
		UPDATE STG SET
		     [ContactKey] = COALESCE(DW.[ContactKey], 0)
		FROM [bi_mktg_stage].[FactLead] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimContact] DW ON
				DW.SFDC_PersonAccountID = STG.SFDC_PersonAccountID
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[ContactKey], 0) = 0
			AND STG.SFDC_PersonAccountID IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		---------------------------
		------ Fix [ContactKey]
		---------------------------
		----UPDATE STG SET
		----     [ContactKey] = -1
		----FROM [bi_mktg_stage].[FactLead] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND STG.[ContactKey] IS NULL

		---------------------------
		------ Fix [ContactSSID]
		---------------------------
		----UPDATE STG SET
		----       [ContactKey]  = -1
		----     , [ContactSSID] = -2
		----FROM [bi_mktg_stage].[FactLead] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND (STG.[ContactSSID] IS NULL )

		-----------------------
		-- Exception if [ContactSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'SFDC_LeadID IS NULL - FL_Trans_LKup'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.SFDC_LeadID IS NULL


		-----------------------
		-- Exception if [ContactKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'ContactKey IS NULL - FL_Trans_LKup'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[ContactKey] IS NULL
				OR STG.[ContactKey] = 0)



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
