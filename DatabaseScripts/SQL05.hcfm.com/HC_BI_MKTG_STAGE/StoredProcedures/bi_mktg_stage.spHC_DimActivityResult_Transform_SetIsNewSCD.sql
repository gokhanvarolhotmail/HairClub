/* CreateDate: 08/05/2019 11:26:27.030 , ModifyDate: 09/10/2020 20:53:20.263 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_DimActivityResult_Transform_SetIsNewSCD]
       (
			  @DataPkgKey				int
       )

AS
-------------------------------------------------------------------------
-- [spHC_DimActivityResult_Transform_SetIsNewSCD] is used to determine which records
--  are NEW, which records are SCD Type 1 or Type 2.
--
--
-- EXEC [spHC_DimActivityResult_Transform_SetIsNewSCD] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    08/11/2009               Initial Creation
--			11/21/2017	KMurdoch	 Added SFDC_Lead/Task_ID
--			08/05/2017	KMurdoch	 Migrate ONC to SFDC
--			08/06/2019  KMurdoch	 Moved SFDC Lead/Task to be primary
--			07/10/2020  KMurdoch     Added Accomodation
--			09/10/2020  KMurdoch     Added SFDC_PersonAccountID
-------------------------------------------------------------------------
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
	SET NOCOUNT ON;



  	DECLARE		      @intError			int				-- error code
  					, @intDBErrorLogID	int				-- ID of error record logged
  					, @intRowCount		int				-- count of rows modified
  					, @vchTagValueList	nvarchar(1000)	-- Named Valued Pairs of Parameters
  	 				, @return_value		int

    DECLARE		      @TableName		varchar(150)	-- Name of table
				    , @CleanupRowCnt	int

  	SET @TableName = N'[bi_mktg_dds].[DimActivityResult]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

   BEGIN TRY


		-----------------------
		-- Check for new rows
		-----------------------
		UPDATE STG SET
		     [ActivityResultKey] = DW.[ActivityResultKey]
			,IsNew = CASE WHEN DW.[ActivityResultKey] IS NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimActivityResult] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimActivityResult] DW
			ON DW.SFDC_TaskID = STG.SFDC_TaskID
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for Inferred Members
		-----------------------
		UPDATE STG SET
			IsInferredMember = CASE WHEN DW.[ActivityResultKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimActivityResult] STG
		INNER JOIN [bi_mktg_stage].[synHC_DDS_DimActivityResult] DW
			ON DW.SFDC_TaskID = STG.SFDC_TaskID
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Check for SCD Type 1
		-----------------------
		UPDATE STG SET
			IsType1 = CASE WHEN DW.[ActivityResultKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimActivityResult] STG
		INNER JOIN [bi_mktg_stage].[synHC_DDS_DimActivityResult] DW
			ON DW.SFDC_TaskID = STG.SFDC_TaskID
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE   1=1   -- 1=0 No Fields Change to 1=1 when there are SCD Type 1 fields
			AND (  COALESCE(STG.[CenterSSID],'') <> COALESCE(DW.[CenterSSID],'')
				OR COALESCE(STG.[ActivitySSID],'') <> COALESCE(DW.[ActivitySSID],'')
				OR COALESCE(STG.[ContactSSID],'') <> COALESCE(DW.[ContactSSID],'')
				OR COALESCE(STG.[SalesTypeSSID],'') <> COALESCE(DW.[SalesTypeSSID],'')
				OR COALESCE(STG.[SalesTypeDescription],'') <> COALESCE(DW.[SalesTypeDescription],'')
				OR COALESCE(STG.[ActionCodeSSID],'') <> COALESCE(DW.[ActionCodeSSID],'')
				OR COALESCE(STG.[ActionCodeDescription],'') <> COALESCE(DW.[ActionCodeDescription],'')
				OR COALESCE(STG.[ResultCodeSSID],'') <> COALESCE(DW.[ResultCodeSSID],'')
				OR COALESCE(STG.[ResultCodeDescription],'') <> COALESCE(DW.[ResultCodeDescription],'')
				OR COALESCE(STG.[SourceSSID],'') <> COALESCE(DW.[SourceSSID],'')
				OR COALESCE(STG.[SourceDescription],'') <> COALESCE(DW.[SourceDescription],'')
				OR COALESCE(STG.[IsShow],'') <> COALESCE(DW.[IsShow],'')
				OR COALESCE(STG.[IsSale],'') <> COALESCE(DW.[IsSale],'')
				OR COALESCE(STG.[ContractNumber],'') <> COALESCE(DW.[ContractNumber],'')
				OR COALESCE(STG.[ContractAmount],'') <> COALESCE(DW.[ContractAmount],'')
				OR COALESCE(STG.[ClientNumber],'') <> COALESCE(DW.[ClientNumber],'')
				OR COALESCE(STG.[InitialPayment],'') <> COALESCE(DW.[InitialPayment],'')
				OR COALESCE(STG.[NumberOfGraphs],'') <> COALESCE(DW.[NumberOfGraphs],'')
				OR COALESCE(STG.[OrigApptDate],'') <> COALESCE(DW.[OrigApptDate],'')
				OR COALESCE(STG.[DateSaved],'') <> COALESCE(DW.[DateSaved],'')
				OR COALESCE(STG.[RescheduledFlag],'') <> COALESCE(DW.[RescheduledFlag],'')
				OR COALESCE(STG.[RescheduledDate],'') <> COALESCE(DW.[RescheduledDate],'')
				OR COALESCE(STG.[SurgeryOffered],'') <> COALESCE(DW.[SurgeryOffered],'')
				OR COALESCE(STG.[ReferredToDoctor],'') <> COALESCE(DW.[ReferredToDoctor],'')
				OR COALESCE(STG.[SFDC_LeadID],'') <> COALESCE(DW.[SFDC_LeadID],'')
				OR COALESCE(STG.[SFDC_PersonAccountID],'') <> COALESCE(DW.[SFDC_PersonAccountID],'')
				OR COALESCE(STG.[SFDC_TaskID],'') <> COALESCE(DW.[SFDC_TaskID],'')
				OR COALESCE(STG.[Accomodation],'') <> COALESCE(DW.[Accomodation],'')
				)
		AND STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Check for SCD Type 2
		-----------------------
		UPDATE STG SET
			IsType2 = CASE WHEN DW.[ActivityResultKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimActivityResult] STG
		INNER JOIN [bi_mktg_stage].[synHC_DDS_DimActivityResult] DW
			ON DW.SFDC_TaskID = STG.SFDC_TaskID
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE  1=0
		AND STG.[DataPkgKey] = @DataPkgKey;


		-----------------------
		-- Check for duplicate records
		-----------------------
		--WITH Duplicates  AS
		--	(SELECT  ISNULL(SFDC_TaskID,ActivitySSID) AS 'ActivitySSID'
		--	,		ISNULL(SFDC_LeadID,ContactSSID) AS 'ContactSSID'
		--				, IsDuplicate
		--			  , row_number() OVER ( PARTITION BY ISNULL(SFDC_TaskID,ActivitySSID), ISNULL(SFDC_LeadID,ContactSSID) ORDER BY ISNULL(SFDC_TaskID,ActivitySSID), ISNULL(SFDC_LeadID,ContactSSID) ) AS RowNum
		--	   FROM  [bi_mktg_stage].[DimActivityResult] STG
		--	   WHERE IsNew = 1
		--	   AND STG.[DataPkgKey] = @DataPkgKey

		--	)

		WITH Duplicates  AS
			(SELECT  STG.SFDC_TaskID
						, IsDuplicate
					  , row_number() OVER ( PARTITION BY STG.SFDC_TaskID ORDER BY STG.SFDC_TaskID ) AS RowNum
			   FROM  [bi_mktg_stage].[DimActivityResult] STG
			   WHERE IsNew = 1
			   AND STG.[DataPkgKey] = @DataPkgKey

			)
			UPDATE STG SET
				IsDuplicate = 1
			FROM Duplicates STG
			WHERE   RowNum > 1

		-----------------------
		-- Check for deleted rows
		-----------------------
		UPDATE STG SET
				IsDelete = CASE WHEN COALESCE(STG.[CDC_Operation],'') = 'D'
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimActivityResult] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey


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
