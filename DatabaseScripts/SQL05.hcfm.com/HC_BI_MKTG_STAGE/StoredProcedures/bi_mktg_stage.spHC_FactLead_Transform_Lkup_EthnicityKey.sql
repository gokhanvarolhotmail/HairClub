/* CreateDate: 05/03/2010 12:27:06.170 , ModifyDate: 09/10/2020 08:44:29.037 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactLead_Transform_Lkup_EthnicityKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_FactLead_Transform_Lkup_EthnicityKey] is used to determine
-- the EthnicityKey foreign key values in the FactLead table using DimEthnicity.
--
--
--   exec [bi_mktg_stage].[spHC_FactLead_Transform_Lkup_EthnicityKey] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    09/21/2009  RLifke       Initial Creation
--			10/26/2011	MBurrell	 Added exception message
--			09/10/2020	KMurdoch	 Removed references to ContactSSID
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

 	SET @TableName = N'[bi_mktg_dds].[DimEthnicity]'

 	   -- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY



		UPDATE STG SET
		       [EthnicityKey]  = -1
		     , [EthnicitySSID] = '-2'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE COALESCE(STG.[EthnicitySSID], '0') = '0'
			AND STG.[DataPkgKey] = @DataPkgKey


		-------------------------
		---- Get the Ethnicity for the Contact
		-------------------------
		--UPDATE STG SET
		--		 [EthnicitySSID] = COALESCE(DW.[EthnicitySSID], '-2')
		--FROM [bi_mktg_stage].[FactLead] STG
		--LEFT OUTER JOIN
		--	(SELECT EthnicitySSID  AS EthnicitySSID
		--				, ContactSSID AS ContactSSID
		--				,[RowIsCurrent] AS [RowIsCurrent]
		--		FROM [bi_mktg_stage].[synHC_DDS_DimActivityDemographic] WITH(NOLOCK)
		--	) AS DW
		--	ON 	DW.[ContactSSID] = STG.[ContactSSID]
		--		AND DW.[RowIsCurrent] = 1
		--WHERE STG.[DataPkgKey] = @DataPkgKey

	  --CCF:  This code is reducing ActivityDemographics down to just the most recent record for a given ContactSSID
	  --The information from the most current record is applied to the fact.
	  ;WITH cte_ActivityDemographics AS
		(SELECT ActivityDemographicKey AS [ActivityDemographicKey],
				SFDC_LeadID AS [SFDC_LeadID],
				EthnicitySSID AS [EthnicitySSID],
				RowIsCurrent AS [RowIsCurrent],
				DateSaved as [DateSaved],
				RowTimeStamp AS [RowTimeStamp],
	     RowNum=row_number() OVER (PARTITION BY SFDC_LeadID ORDER BY DateSaved DESC, RowTimeStamp DESC)
	   FROM [bi_mktg_stage].[synHC_DDS_DimActivityDemographic] )


	   UPDATE STG SET
			  [EthnicitySSID] = COALESCE(DW.[EthnicitySSID], '-2')
		FROM [bi_mktg_stage].[FactLead] STG
		LEFT OUTER JOIN
			(SELECT [EthnicitySSID]  AS [EthnicitySSID]
					, [SFDC_LeadID] AS [SFDC_LeadID]
					, [RowIsCurrent] AS [RowIsCurrent]
					, [RowNum] as [RowNum]
				FROM cte_ActivityDemographics
			) AS DW
			ON 	DW.[SFDC_LeadID] = STG.[SFDC_LeadID]
				AND DW.[RowIsCurrent] = 1 AND DW.[RowNum] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey
		--CCF: Change Complete





		------------------------
		-- There might be some other load that just added them
		-- Update [EthnicityKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [EthnicityKey] = COALESCE(DW.[EthnicityKey], 0)
		FROM [bi_mktg_stage].[FactLead] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimEthnicity] DW ON
				DW.[EthnicitySSID] = STG.[EthnicitySSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[EthnicityKey], 0) = 0
			AND STG.[EthnicitySSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_mktg_stage].[spHC_FactLead_LoadInferred_DimEthnicity] @DataPkgKey


		-- Update Center Keys in STG
		UPDATE STG SET
		     [EthnicityKey] = COALESCE(DW.[EthnicityKey], 0)
		FROM [bi_mktg_stage].[FactLead] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimEthnicity] DW ON
				DW.[EthnicitySSID] = STG.[EthnicitySSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[EthnicityKey], 0) = 0
			AND STG.[EthnicitySSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Fix [EthnicityKey]
		-----------------------
		UPDATE STG SET
		     [EthnicityKey] = -1
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[EthnicityKey] IS NULL

		-----------------------
		-- Fix [EthnicitySSID]
		-----------------------
		UPDATE STG SET
		       [EthnicityKey]  = -1
		     , [EthnicitySSID] = '-2'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[EthnicitySSID] IS NULL )

		-----------------------
		-- Exception if [EthnicitySSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'EthnicitySSID IS NULL - FL_Trans_LKup'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[EthnicitySSID] IS NULL


		-----------------------
		-- Exception if [EthnicityKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'EthnicityKey IS NULL - FL_Trans_LKup'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[EthnicityKey] IS NULL
				OR STG.[EthnicityKey] = 0)


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
