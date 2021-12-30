/* CreateDate: 05/03/2010 12:27:06.253 , ModifyDate: 09/10/2020 08:23:14.983 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactLead_Transform_Lkup_MaritalStatusKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_FactLead_Transform_Lkup_MaritalStatusKey] is used to determine
-- the MaritalStatusKey foreign key values in the FactLead table using DimMaritalStatus.
--
--
--   exec [bi_mktg_stage].[spHC_FactLead_Transform_Lkup_MaritalStatusKey] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    09/21/2009  RLifke       Initial Creation
--			10/26/2011	MBurrell	 Added exception message
--			09/10/2020  KMurdoch     Removed references to ContactSSID
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

 	SET @TableName = N'[bi_mktg_dds].[DimMaritalStatus]'

 	   -- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY

		UPDATE STG SET
		       [MaritalStatusKey]  = -1
		     , [MaritalStatusSSID] = '-2'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE COALESCE(STG.[MaritalStatusSSID], '0') = '0'
			AND STG.[DataPkgKey] = @DataPkgKey


		-------------------------
		---- Get the MaritalStatus for the Contact
		-------------------------
		--UPDATE STG SET
		--       [MaritalStatusSSID] = COALESCE(DW.[MaritalStatusSSID], '-2')
		--FROM [bi_mktg_stage].[FactLead] STG
		--LEFT OUTER JOIN
		--	(SELECT MaritalStatusSSID  AS MaritalStatusSSID
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
				MaritalStatusSSID AS [MaritalStatusSSID],
				RowIsCurrent AS [RowIsCurrent],
				DateSaved as [DateSaved],
				RowTimeStamp AS [RowTimeStamp],
	     RowNum=row_number() OVER (PARTITION BY SFDC_LeadID ORDER BY DateSaved DESC, RowTimeStamp DESC)
	   FROM [bi_mktg_stage].[synHC_DDS_DimActivityDemographic] )


	   UPDATE STG SET
			 [MaritalStatusSSID] = COALESCE(DW.[MaritalStatusSSID], '-2')
		FROM [bi_mktg_stage].[FactLead] STG
		LEFT OUTER JOIN
			(SELECT [MaritalStatusSSID]  AS [MaritalStatusSSID]
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
		-- Update [MaritalStatusKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [MaritalStatusKey] = COALESCE(DW.[MaritalStatusKey], 0)
		FROM [bi_mktg_stage].[FactLead] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimMaritalStatus] DW ON
				DW.[MaritalStatusSSID] = STG.[MaritalStatusSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[MaritalStatusKey], 0) = 0
			AND STG.[MaritalStatusSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_mktg_stage].[spHC_FactLead_LoadInferred_DimMaritalStatus] @DataPkgKey


		-- Update Center Keys in STG
		UPDATE STG SET
		     [MaritalStatusKey] = COALESCE(DW.[MaritalStatusKey], 0)
		FROM [bi_mktg_stage].[FactLead] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimMaritalStatus] DW ON
				DW.[MaritalStatusSSID] = STG.[MaritalStatusSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[MaritalStatusKey], 0) = 0
			AND STG.[MaritalStatusSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Fix [MaritalStatusKey]
		-----------------------
		UPDATE STG SET
		     [MaritalStatusKey] = -1
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[MaritalStatusKey] IS NULL

		-----------------------
		-- Fix [MaritalStatusSSID]
		-----------------------
		UPDATE STG SET
		       [MaritalStatusKey]  = -1
		     , [MaritalStatusSSID] = '-2'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[MaritalStatusSSID] IS NULL )

		-----------------------
		-- Exception if [MaritalStatusSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'MaritalStatusSSID IS NULL - FL_Trans_LKup'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[MaritalStatusSSID] IS NULL


		-----------------------
		-- Exception if [MaritalStatusKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'MaritalStatusKey IS NULL - FL_Trans_LKup'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[MaritalStatusKey] IS NULL
				OR STG.[MaritalStatusKey] = 0)



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
