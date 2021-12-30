/* CreateDate: 05/03/2010 12:27:06.110 , ModifyDate: 09/10/2020 08:41:17.793 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactLead_Transform_Lkup_AgeRangeKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_FactLead_Transform_Lkup_AgeRangeKey] is used to determine
-- the AgeRangeKey foreign key values in the FactLead table using DimAgeRange.
--
--
--   exec [bi_mktg_stage].[spHC_FactLead_Transform_Lkup_AgeRangeKey] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    09/21/2009  RLifke       Initial Creation
--			10/26/2011	MBurrell	 Added exception message
--			07/24/2019	DLeiba		 Added code to determine AgeRange
--			06/16/2020  KMurdoch     Use Birthday if Age is null
--			09/10/2020  KMurdoch	 Removed references to contactSSID
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

 	SET @TableName = N'[bi_mktg_dds].[DimAgeRange]'

 	   -- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY

	  /*
		-----------------------
		-- Get the [Age] for the Contact
		-----------------------
	  --CCF:  This code is reducing ActivityDemographics down to just the most recent record for a given ContactSSID
	  --The information from the most current record is applied to the fact.

	  ;WITH cte_ActivityDemographics AS
		(SELECT ActivityDemographicKey AS [ActivityDemographicKey],
				ContactSSID AS [ContactSSID],
				Age AS [Age],
				RowIsCurrent AS [RowIsCurrent],
				DateSaved as [DateSaved],
				RowTimeStamp AS [RowTimeStamp],
	     RowNum=row_number() OVER (PARTITION BY ContactSSID ORDER BY DateSaved DESC, RowTimeStamp DESC)
	   FROM [bi_mktg_stage].[synHC_DDS_DimActivityDemographic] )


	   UPDATE STG SET
			  [Age] = COALESCE(DW.[Age], NULL)
		FROM [bi_mktg_stage].[FactLead] STG
		LEFT OUTER JOIN
			(SELECT [Age]  AS [Age]
					, [ContactSSID] AS [ContactSSID]
					, [RowIsCurrent] AS [RowIsCurrent]
					, [RowNum] as [RowNum]
				FROM cte_ActivityDemographics
			) AS DW
			ON 	DW.[ContactSSID] = STG.[ContactSSID]
				AND DW.[RowIsCurrent] = 1 AND DW.[RowNum] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Update AgeRangeSSID based upon age
		-----------------------
		UPDATE STG SET
				STG.[AgeRangeSSID]	 = CASE
										WHEN Age IS NULL THEN -2
										WHEN Age < 18 THEN 1
										WHEN Age >= 18 AND Age <= 24 THEN 2
										WHEN Age >= 25 AND Age <= 34 THEN 3
										WHEN Age >= 35 AND Age <= 44 THEN 4
										WHEN Age >= 45 AND Age <= 54 THEN 5
										WHEN Age >= 55 AND Age <= 64 THEN 6
										WHEN Age > 64 THEN 7
										ELSE -2
									END
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		*/


		UPDATE	STG
		SET		Age = COALESCE(ISNULL(l.Age__c,DATEDIFF(YEAR,l.birthday__c,ReportCreateDate__c)), 0)
		,		AgeRangeSSID = CASE WHEN COALESCE(ISNULL(l.Age__c,DATEDIFF(YEAR,l.birthday__c,ReportCreateDate__c)), 0) = 0
										AND ISNULL(l.AgeRange__c, 'Unknown') <> 'Unknown' THEN darAR.AgeRangeSSID
								WHEN COALESCE(ISNULL(l.Age__c,DATEDIFF(YEAR,l.birthday__c,ReportCreateDate__c)), 0) <> 0
										AND COALESCE(ISNULL(l.Age__c,DATEDIFF(YEAR,l.birthday__c,ReportCreateDate__c)), 0) <= 120
										AND ISNULL(l.AgeRange__c, 'Unknown') = 'Unknown' THEN darA.AgeRangeSSID
								WHEN COALESCE(ISNULL(l.Age__c,DATEDIFF(YEAR,l.birthday__c,ReportCreateDate__c)), 0) > 120 THEN -2
								ELSE -2
							END
		FROM	bi_mktg_stage.FactLead STG

				INNER JOIN HC_BI_SFDC.[dbo].[Lead] l
					ON l.Id = stg.SFDC_LeadID
				LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAgeRange darA
					ON COALESCE(ISNULL(l.Age__c,DATEDIFF(YEAR,l.birthday__c,ReportCreateDate__c)), 0) BETWEEN darA.BeginAge AND darA.EndAge
				LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAgeRange darAR
					ON ISNULL(l.AgeRange__c, 'Unknown') = darAR.AgeRangeDescription
		WHERE	STG.DataPkgKey = @DataPkgKey


		-----------------------
		-- Fix [AgeRangeSSID]
		-----------------------
		UPDATE STG SET
		       [AgeRangeKey]  = -1
		     , [AgeRangeSSID] = -2
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[AgeRangeSSID] IS NULL )

		------------------------
		-- There might be some other load that just added them
		-- Update [AgeRangeKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [AgeRangeKey] = COALESCE(DW.[AgeRangeKey], 0)
		FROM [bi_mktg_stage].[FactLead] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimAgeRange] DW ON
				DW.[AgeRangeSSID] = STG.[AgeRangeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[AgeRangeKey], 0) = 0
			AND STG.[AgeRangeSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_mktg_stage].[spHC_FactLead_LoadInferred_DimAgeRange] @DataPkgKey


		-- Update Center Keys in STG
		UPDATE STG SET
		     [AgeRangeKey] = COALESCE(DW.[AgeRangeKey], 0)
		FROM [bi_mktg_stage].[FactLead] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimAgeRange] DW ON
				DW.[AgeRangeSSID] = STG.[AgeRangeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[AgeRangeKey], 0) = 0
			AND STG.[AgeRangeSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Fix [AgeRangeKey]
		-----------------------
		UPDATE STG SET
		     [AgeRangeKey] = -1
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[AgeRangeKey] IS NULL

		-----------------------
		-- Fix [AgeRangeSSID]
		-----------------------
		UPDATE STG SET
		       [AgeRangeKey]  = -1
		     , [AgeRangeSSID] = -2
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[AgeRangeSSID] IS NULL )

		-----------------------
		-- Exception if [AgeRangeSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'AgeRangeSSID IS NULL - FL_Trans_LKup'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[AgeRangeSSID] IS NULL


		-----------------------
		-- Exception if [AgeRangeKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'AgeRangeKey IS NULL - FL_Trans_LKup'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[AgeRangeKey] IS NULL
				OR STG.[AgeRangeKey] = 0)


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
