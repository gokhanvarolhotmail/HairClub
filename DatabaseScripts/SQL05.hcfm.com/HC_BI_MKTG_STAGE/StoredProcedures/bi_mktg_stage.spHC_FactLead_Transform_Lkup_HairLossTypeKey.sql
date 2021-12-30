/* CreateDate: 05/03/2010 12:27:06.207 , ModifyDate: 09/10/2020 08:26:54.743 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactLead_Transform_Lkup_HairLossTypeKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_FactLead_Transform_Lkup_HairLossTypeKey] is used to determine
-- the HairLossTypeKey foreign key values in the FactLead table using DimHairLossType.
--
--
--   exec [bi_mktg_stage].[spHC_FactLead_Transform_Lkup_HairLossTypeKey] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    09/21/2009  RLifke       Initial Creation
--			10/26/2011	MBurrell	 Added exception message
--          07/07/2014  EKnapp       Fix lookup to use ssid not description.
--			09/10/2020  KMurdoch     Removed reference to ContactSSID
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

 	SET @TableName = N'[bi_mktg_dds].[DimHairLossType]'

 	   -- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY



		-----------------------
		-- Get the HairLossType for the Contact
		-----------------------
		--CCF Made changes to pick up most recent record

		--UPDATE STG SET
		--        [HairLossTypeSSID] = COALESCE(DW.[HairLossTypeSSID], '-2')
		--        , [NorwoodSSID] = COALESCE(DW.[NorwoodSSID], '')
		--        , [LudwigSSID] = COALESCE(DW.[LudwigSSID], '')
		--FROM [bi_mktg_stage].[FactLead] STG
		--LEFT OUTER JOIN
		--	(SELECT [HairLossTypeSSID]  AS [HairLossTypeSSID]
		--				, [ContactSSID] AS [ContactSSID]
		--				, [NorwoodSSID] AS [NorwoodSSID]
		--				, [LudwigSSID] AS [LudwigSSID]
		--				,[RowIsCurrent] AS [RowIsCurrent]
		--		FROM [bi_mktg_stage].[synHC_DDS_DimActivityDemographic] WITH(NOLOCK)
		--	) AS DW
		--	ON 	DW.[ContactSSID] = STG.[ContactSSID]
		--		AND DW.[RowIsCurrent] = 1
		--WHERE STG.[DataPkgKey] = @DataPkgKey

	  --CCF:  This code is reducing ActivityDemographics down to just the most recent record for a given ContactSSIS
	  --The information from the most current record is applied to the fact.
	  ;WITH cte_ActivityDemographics AS
		(SELECT ActivityDemographicKey AS [ActivityDemographicKey],
				SFDC_LeadID AS [SFDC_LeadID],
				HairLossTypeSSID AS [HairLossTypeSSID],
				NorwoodSSID AS [NorwoodSSID],
				LudwigSSID AS [LudwigSSID],
				RowIsCurrent AS [RowIsCurrent],
				DateSaved as [DateSaved],
				RowTimeStamp AS [RowTimeStamp],
	     RowNum=row_number() OVER (PARTITION BY SFDC_LeadID ORDER BY DateSaved DESC, RowTimeStamp DESC)
	   FROM [bi_mktg_stage].[synHC_DDS_DimActivityDemographic] )


	   UPDATE STG SET
			   [HairLossTypeSSID] = COALESCE(DW.[HairLossTypeSSID], '-2')
		       , [NorwoodSSID] = COALESCE(DW.[NorwoodSSID], '')
		       , [LudwigSSID] = COALESCE(DW.[LudwigSSID], '')
		FROM [bi_mktg_stage].[FactLead] STG
		LEFT OUTER JOIN
			(SELECT [HairLossTypeSSID]  AS [HairLossTypeSSID]
					, [SFDC_LeadID] AS [SFDC_LeadID]
					, [NorwoodSSID] AS [NorwoodSSID]
					, [LudwigSSID] AS [LudwigSSID]
					, [RowIsCurrent] AS [RowIsCurrent]
					, [RowNum] as [RowNum]
				FROM cte_ActivityDemographics
			) AS DW
			ON 	DW.[SFDC_LeadID] = STG.SFDC_LeadID
				AND DW.[RowIsCurrent] = 1 AND DW.[RowNum] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey
		--CCF: Change Complete


			-----------------------
		-- Update HairLossTypeSSID based upon Norwood
		-----------------------
		UPDATE STG SET
				STG.[HairLossTypeSSID]	 = STG.[NorwoodSSID]
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[NorwoodSSID] <> 'Unknown'
		AND LEN(STG.[NorwoodSSID]) > 0
		--AND STG.[LudwigSSID] = '0'


		-----------------------
		-- Update HairLossTypeSSID based upon Ludwig
		-----------------------
		UPDATE STG SET
				STG.[HairLossTypeSSID]	 = STG.[LudwigSSID]
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[LudwigSSID] <> 'Unknown'
		AND LEN(STG.[LudwigSSID]) > 0


		-- convert numbers to codes
		UPDATE STG SET
				STG.[HairLossTypeSSID]	 = CASE
												WHEN STG.[NorwoodSSID] = '2' THEN 'I'
												WHEN STG.[NorwoodSSID] = '3' THEN 'II'
												WHEN STG.[NorwoodSSID] = '4' THEN 'IIA'
												WHEN STG.[NorwoodSSID] = '5' THEN 'III'
												WHEN STG.[NorwoodSSID] = '6' THEN 'IIIA'
												WHEN STG.[NorwoodSSID] = '7' THEN 'IV'
												WHEN STG.[NorwoodSSID] = '8' THEN 'IVA'
												WHEN STG.[NorwoodSSID] = '10' THEN 'V'
												WHEN STG.[NorwoodSSID] = '12' THEN 'VA'
												WHEN STG.[NorwoodSSID] = '13' THEN 'VI'
												WHEN STG.[NorwoodSSID] = '14' THEN 'VII'
												END
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[NorwoodSSID] IN ('2','3','4','5','6','7','8','10','12','13'',14')

		UPDATE STG SET
				STG.[HairLossTypeSSID]	 = CASE
												WHEN STG.[LudwigSSID] = '2' THEN 'Androgenic Alopecia Grade I'
												WHEN STG.[LudwigSSID] = '3' THEN 'Androgenic Alopecia Grade II'
												WHEN STG.[LudwigSSID] = '4' THEN 'Androgenic Alopecia Grade III'
												WHEN STG.[LudwigSSID] = '5' THEN 'Traction Alopecia'
												WHEN STG.[LudwigSSID] = '6' THEN 'Alopecia Totalis'
												WHEN STG.[LudwigSSID] = '7' THEN 'Alopecia Areata'
												WHEN STG.[LudwigSSID] = '8' THEN 'Trichotillomania'
												WHEN STG.[LudwigSSID] = '9' THEN 'Chemical Damage'
												WHEN STG.[LudwigSSID] = '10' THEN 'No Visible Hair Loss'
												END
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
        AND STG.[LudwigSSID] IN ('2','3','4','5','6','7','8','9','10')



		-----------------------
		-- Update HairLossTypeSSID
		-----------------------
		UPDATE STG SET
				STG.[HairLossTypeKey] = -1
				, STG.[HairLossTypeSSID] = '-2'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[NorwoodSSID] = 'Unknown'
		AND STG.[LudwigSSID] = 'Unknown'

		-----------------------
		-- Update HairLossTypeSSID
		-----------------------
		UPDATE STG SET
				STG.[HairLossTypeKey] = -1
				, STG.[HairLossTypeSSID] = '-2'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[NorwoodSSID] = ''
		AND STG.[LudwigSSID] = ''

		-----------------------
		-- Update HairLossTypeSSID
		-----------------------
		UPDATE STG SET
				STG.[HairLossTypeKey] = -1
				, STG.[HairLossTypeSSID] = '-2'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[NorwoodSSID] = '0'
		AND STG.[LudwigSSID] = '0'


		UPDATE STG SET
				STG.[HairLossTypeKey] = -1
			, STG.[HairLossTypeSSID] = '-2'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND STG.[HairLossTypeSSID] = ''



		----------------------------------
		------------ There might be some other load that just added them
		------------ Update [HairLossTypeKey] Keys in STG
		----------------------------------
		--------UPDATE STG SET
		--------     [HairLossTypeSSID] = COALESCE(DW.[HairLossTypeSSID], -2)
		--------FROM [bi_mktg_stage].[FactLead] STG
		--------LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimHairLossType] DW ON
		--------		DW.[HairLossTypeDescription] = STG.[HairLossTypeSSID]
		--------	AND DW.[RowIsCurrent] = 1
		--------WHERE STG.[DataPkgKey] = @DataPkgKey

		------------------------
		-- There might be some other load that just added them
		-- Update [HairLossTypeKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [HairLossTypeKey] = COALESCE(DW.[HairLossTypeKey], 0)
		FROM [bi_mktg_stage].[FactLead] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimHairLossType] DW ON
				DW.[HairLossTypeSSID] = STG.[HairLossTypeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[HairLossTypeKey], 0) = 0
			AND STG.[HairLossTypeSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

	---Added this code to prevent addition of zero records krm ek 12/7/2011

		UPDATE STG SET
		       STG.[HairLossTypeKey]  = -1
		     , STG.[HairLossTypeSSID] = '-2'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[HairLossTypeSSID] = '0' )

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_mktg_stage].[spHC_FactLead_LoadInferred_DimHairLossType] @DataPkgKey


		-- Update Center Keys in STG
		UPDATE STG SET
		     [HairLossTypeKey] = COALESCE(DW.[HairLossTypeKey], 0)
		FROM [bi_mktg_stage].[FactLead] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimHairLossType] DW ON
				DW.[HairLossTypeSSID] = STG.[HairLossTypeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[HairLossTypeKey], 0) = 0
			AND STG.[HairLossTypeSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Fix [HairLossTypeKey]
		-----------------------
		UPDATE STG SET
		     [HairLossTypeKey] = -1
		     , [HairLossTypeSSID] = '-2'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[HairLossTypeKey] IS NULL

		-----------------------
		-- Fix [HairLossTypeSSID] and HairLossTypeKey
		-----------------------
		UPDATE STG SET
		       [HairLossTypeKey]  = -1
		     , [HairLossTypeSSID] = '-2'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[HairLossTypeSSID] IS NULL
			     OR STG.HairLossTypeKey=0)

		-----------------------
		-- Exception if [HairLossTypeSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'HairLossTypeSSID IS NULL - FL_Trans_LKup'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[HairLossTypeSSID] IS NULL



		-----------------------
		-- Exception if [HairLossTypeKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'HairLossTypeKey IS NULL - FL_Trans_LKup'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[HairLossTypeKey] IS NULL
				OR STG.[HairLossTypeKey] = 0)


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
