/* CreateDate: 02/03/2011 17:38:01.353 , ModifyDate: 09/10/2020 07:43:38.830 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactLead_Transform_Lkup_SalesTypeKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_FactLead_Transform_Lkup_SalesTypeKey] is used to determine
-- the SalesTypeKey foreign key values in the FactLead table using DimSalesType.
--
--
--   exec [bi_mktg_stage].[spHC_FactLead_Transform_Lkup_SalesTypeKey] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    02/02/2011               Initial Creation
--			10/26/2011	MBurrell	 Added exception message
--			09/21/2012  KMurdoch	 Added to sort on derivation of SalesTypeID
--			11/27/2012  KMurdoch     Modified to change sort on derivation to be by CompletionDate
--			09/10/2020  KMurdoch	 Removed references to ActivitySSID

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

 	SET @TableName = N'[bi_mktg_dds].[DimSalesType]'

 	   -- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY

		UPDATE STG SET
			   [SalesTypeKey] = -1
		     , [SalesTypeSSID] = '-2'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE coalesce(STG.[SalesTypeSSID],'0') = '0'
			AND STG.[DataPkgKey] = @DataPkgKey

		------------------------
		-- There might be some other load that just added them
		-- Update [SalesTypeKey] Keys in STG
		------------------------
		--CCF: Get Most Current Record
		--UPDATE STG SET
		--     [SalesTypeKey] = COALESCE(DW.[SalesTypeKey], 0)
		--FROM [bi_mktg_stage].[FactLead] STG
		--LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimSalesType] DW ON
		--		DW.[SalesTypeSSID] = STG.[SalesTypeSSID]
		--	AND DW.[RowIsCurrent] = 1
		--WHERE COALESCE(STG.[SalesTypeKey], 0) = 0
		--	AND STG.[SalesTypeSSID] IS NOT NULL
		--	AND STG.[DataPkgKey] = @DataPkgKey


	 ------------ --CCF:  This code is reducing ActivityDemographics down to just the most recent record for a given ContactSSID
	 ------------ --The information from the most current record is applied to the fact.
	 ------------ ;WITH cte_ActivityResult AS
		------------(SELECT	R.ActivityResultKey AS [ActivityResultKey],
		------------		R.ContactSSID AS [ContactSSID],
		------------		R.SalesTypeSSID AS [SalesTypeSSID],
		------------		R.RowIsCurrent AS [RowIsCurrent],
		------------		R.DateSaved as [DateSaved],
		------------		SA.completion_date as [CompletionDate],
		------------		SA.completion_time as [CompletionTime],
	 ------------    RowNum=row_number() OVER (PARTITION BY R.ContactSSID ORDER BY SA.[Completion_Date] DESC,SA.[Completion_Time] DESC,R.DateSaved DESC)
		------------ FROM [bi_mktg_stage].[synHC_DDS_DimActivityResult] R
		------------	inner join [bi_mktg_stage].[synHC_DDS_DimActivity] A
		------------		on R.ActivitySSID = A.ActivitySSID
		------------	left outer join [bi_mktg_stage].[synHC_SRC_TBL_MKTG_oncd_activity] SA
		------------		on R.ActivitySSID = SA.Activity_ID )


			  --CCF:  This code is reducing ActivityDemographics down to just the most recent record for a given ContactSSID
	  --The information from the most current record is applied to the fact.



	  ;WITH cte_ActivityResult AS
		(SELECT	R.ActivityResultKey AS [ActivityResultKey],
				R.SFDC_LeadID AS [SFDC_LeadID],
				R.SalesTypeSSID AS [SalesTypeSSID],
				R.RowIsCurrent AS [RowIsCurrent],
				R.DateSaved as [DateSaved],
				t.CompletionDate__c as [CompletionDate],
	     RowNum=row_number() OVER (PARTITION BY R.SFDC_LeadID ORDER BY t.[CompletionDate__c] DESC,R.DateSaved DESC)
		 FROM [bi_mktg_stage].[synHC_DDS_DimActivityResult] R
			inner join [bi_mktg_stage].[synHC_DDS_DimActivity] A
				on R.SFDC_TaskID = A.SFDC_TaskID
			LEFT OUTER JOIN HC_BI_SFDC.dbo.Task t
				ON a.SFDC_TaskID = t.Id)



	   UPDATE STG SET
			  [SalesTypeSSID] = COALESCE(DW.[SalesTypeSSID], '-2')
		FROM [bi_mktg_stage].[FactLead] STG
		LEFT OUTER JOIN
			(SELECT [SalesTypeSSID]  AS [SalesTypeSSID]
					, [SFDC_LeadID] AS [SFDC_LeadID]
					, [RowIsCurrent] AS [RowIsCurrent]
					, [RowNum] as [RowNum]
				FROM cte_ActivityResult
			) AS DW
			ON 	DW.SFDC_LeadID = STG.SFDC_LeadID
				AND DW.[RowIsCurrent] = 1 AND DW.[RowNum] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey
		--CCF: Change Complete

		-- Update Sales Type Keys in STG
		UPDATE STG SET
		     [SalesTypeKey] = COALESCE(DW.[SalesTypeKey], 0)
		FROM [bi_mktg_stage].[FactLead] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimSalesType] DW ON
				DW.[SalesTypeSSID] = STG.[SalesTypeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[SalesTypeKey], 0) = 0
			AND STG.[SalesTypeSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_mktg_stage].[spHC_FactLead_LoadInferred_DimSalesType] @DataPkgKey


		-- Update Sales Type Keys in STG
		UPDATE STG SET
		     [SalesTypeKey] = COALESCE(DW.[SalesTypeKey], 0)
		FROM [bi_mktg_stage].[FactLead] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimSalesType] DW ON
				DW.[SalesTypeSSID] = STG.[SalesTypeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[SalesTypeKey], 0) = 0
			AND STG.[SalesTypeSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Fix [SalesTypeKey]
		-----------------------
		UPDATE STG SET
		     [SalesTypeKey] = -1
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[SalesTypeKey] IS NULL

		-----------------------
		-- Fix [SalesTypeSSID]
		-----------------------
		UPDATE STG SET
		       [SalesTypeKey]  = -1
		     , [SalesTypeSSID] = -2
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[SalesTypeSSID] IS NULL )

		-----------------------
		-- Exception if [SalesTypeSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'SalesTypeSSID IS NULL - FL_Trans_LKup'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[SalesTypeSSID] IS NULL


		-----------------------
		-- Exception if [SalesTypeKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'SalesTypeKey IS NULL - FL_Trans_LKup'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[SalesTypeKey] IS NULL
				OR STG.[SalesTypeKey] = 0)


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
