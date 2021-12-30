/* CreateDate: 05/03/2010 12:27:06.187 , ModifyDate: 09/10/2020 08:27:49.753 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactLead_Transform_Lkup_GenderKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_FactLead_Transform_Lkup_GenderKey] is used to determine
-- the GenderKey foreign key values in the FactLead table using DimGender.
--
--
--   exec [bi_mktg_stage].[spHC_FactLead_Transform_Lkup_GenderKey] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    09/21/2009  RLifke       Initial Creation
--			10/26/2011	MBurrell	 Added exception message

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

 	SET @TableName = N'[bi_mktg_dds].[DimGender]'

 	   -- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY


		UPDATE STG SET
		       [GenderKey]  = -1
		     , [GenderSSID] = 'U'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[GenderSSID] = '?' )



		-----------------------
		-- Get the Gender for the Contact
		-----------------------
		--UPDATE STG SET
		--		 [GenderSSID] = COALESCE(DW.[GenderSSID], 'U')
		--FROM [bi_mktg_stage].[FactLead] STG
		--LEFT OUTER JOIN
		--	(SELECT GenderSSID  AS GenderSSID
		--				, ContactSSID AS ContactSSID
		--				,[RowIsCurrent] AS [RowIsCurrent]
		--		FROM [bi_mktg_stage].[synHC_DDS_DimActivityDemographic] WITH(NOLOCK)
		--	) AS DW
		--	ON 	DW.[ContactSSID] = STG.[ContactSSID]
		--		AND DW.[RowIsCurrent] = 1
		--WHERE STG.[DataPkgKey] = @DataPkgKey

	  --CCF:  This code is reducing ActivityDemographics down to just the most recent record for a given ContactSSID
	  --The information from the most current record is applied to the fact.
	 ---- ;WITH cte_ActivityDemographics AS
		----(SELECT ActivityDemographicKey AS [ActivityDemographicKey],
		----		ContactSSID AS [ContactSSID],
		----		GenderSSID AS [GenderSSID],
		----		RowIsCurrent AS [RowIsCurrent],
		----		DateSaved as [DateSaved],
		----		RowTimeStamp AS [RowTimeStamp],
	 ----    RowNum=row_number() OVER (PARTITION BY ContactSSID ORDER BY DateSaved DESC, RowTimeStamp DESC)
	 ----  FROM [bi_mktg_stage].[synHC_DDS_DimActivityDemographic] )


	 ----  UPDATE STG SET
		----	  [GenderSSID] = COALESCE(DW.[GenderSSID], 'U')
		----FROM [bi_mktg_stage].[FactLead] STG
		----LEFT OUTER JOIN
		----	(SELECT [GenderSSID]  AS [GenderSSID]
		----			, [ContactSSID] AS [ContactSSID]
		----			, [RowIsCurrent] AS [RowIsCurrent]
		----			, [RowNum] as [RowNum]
		----		FROM cte_ActivityDemographics
		----	) AS DW
		----	ON 	DW.[ContactSSID] = STG.[ContactSSID]
		----		AND DW.[RowIsCurrent] = 1 AND DW.[RowNum] = 1
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		------CCF: Change Complete

        --CCF:  Obtain Gender from dimContact
        UPDATE STG SET
				  [GenderSSID] = COALESCE(DW.[GenderSSID], 'U')
		FROM [bi_mktg_stage].[FactLead] STG
		LEFT OUTER JOIN
			(SELECT Left(LTrim(case when ISNULL(ContactGender,'')='' then 'U' else ContactGender end),1) AS GenderSSID
						, SFDC_LeadID AS SFDC_LeadID
						,[RowIsCurrent] AS [RowIsCurrent]
				FROM [bi_mktg_stage].[synHC_DDS_DimContact] WITH(NOLOCK)
			) AS DW
			ON 	DW.SFDC_LeadID = STG.SFDC_LeadID
				AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey
        --CCF:  End Obtain Gender from dimContact



		--UPDATE STG SET
		--		 [GenderSSID] = COALESCE(DW.[GenderSSID], 'U')
		--FROM [bi_mktg_stage].[FactLead] STG
		--LEFT OUTER JOIN
		--	(SELECT TOP 1 GenderSSID  AS GenderSSID
		--				, ContactSSID AS ContactSSID
		--				,[RowIsCurrent] AS [RowIsCurrent]
		--		FROM [bi_mktg_stage].[synHC_DDS_DimActivityDemographic] WITH(NOLOCK) order by RowTimeStamp DESC
		--	) AS DW
		--	ON 	DW.[ContactSSID] = STG.[ContactSSID]
		--		AND DW.[RowIsCurrent] = 1
		--WHERE STG.[DataPkgKey] = @DataPkgKey




		------------------------
		-- There might be some other load that just added them
		-- Update [GenderKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [GenderKey] = COALESCE(DW.[GenderKey], 0)
		FROM [bi_mktg_stage].[FactLead] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimGender] DW ON
				DW.[GenderSSID] = STG.[GenderSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[GenderKey], 0) = 0
			AND STG.[GenderSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_mktg_stage].[spHC_FactLead_LoadInferred_DimGender] @DataPkgKey


		-- Update Center Keys in STG
		UPDATE STG SET
		     [GenderKey] = COALESCE(DW.[GenderKey], 0)
		FROM [bi_mktg_stage].[FactLead] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimGender] DW ON
				DW.[GenderSSID] = STG.[GenderSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[GenderKey], 0) = 0
			AND STG.[GenderSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Fix [GenderKey]
		-----------------------
		UPDATE STG SET
		     [GenderKey] = -1
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[GenderKey] IS NULL

		-----------------------
		-- Fix [GenderSSID]
		-----------------------
		UPDATE STG SET
		       [GenderKey]  = -1
		     , [GenderSSID] = 'U'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[GenderSSID] IS NULL )

		-----------------------
		-- Exception if [GenderSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'GenderSSID IS NULL - FL_Trans_LKup'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[GenderSSID] IS NULL


		-----------------------
		-- Exception if [GenderKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'GenderKey IS NULL - FL_Trans_LKup'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[GenderKey] IS NULL
				OR STG.[GenderKey] = 0)


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
