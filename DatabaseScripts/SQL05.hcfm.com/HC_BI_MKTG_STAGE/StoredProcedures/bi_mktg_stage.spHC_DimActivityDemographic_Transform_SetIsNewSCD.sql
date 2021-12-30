/* CreateDate: 08/05/2019 11:23:03.697 , ModifyDate: 09/10/2020 20:50:58.663 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_DimActivityDemographic_Transform_SetIsNewSCD]
       (
			  @DataPkgKey				int
       )

AS
-------------------------------------------------------------------------
-- [spHC_DimActivityDemographic_Transform_SetIsNewSCD] is used to determine which records
--  are NEW, which records are SCD Type 1 or Type 2.
--
--
-- EXEC [spHC_DimActivityDemographic_Transform_SetIsNewSCD] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    08/11/2009               Initial Creation
--			11/18/2017	Kmurdoch	 Added SFDC_Lead/Task_ID
--			08/05/2019	KMurdoch	 Migrate ONC to SFDC
--			08/06/2019   KMurdoch    Changed to check SFDC TaskID first
--			09/10/2020   KMurdoch    Added SFDC_PersonAccountID
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

  	SET @TableName = N'[bi_mktg_dds].[DimActivityDemographic]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

   BEGIN TRY


		-----------------------
		-- Check for new rows
		-----------------------
		UPDATE STG SET
		     [ActivityDemographicKey] = DW.[ActivityDemographicKey]
			,IsNew = CASE WHEN DW.[ActivityDemographicKey] IS NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimActivityDemographic] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimActivityDemographic] DW
			ON DW.SFDC_TaskID = STG.SFDC_TaskID
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for Inferred Members
		-----------------------
		UPDATE STG SET
			IsInferredMember = CASE WHEN DW.[ActivityDemographicKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimActivityDemographic] STG
		INNER JOIN [bi_mktg_stage].[synHC_DDS_DimActivityDemographic] DW
			ON DW.SFDC_TaskID = STG.SFDC_TaskID
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey




		-----------------------
		-- Check for SCD Type 1
		-----------------------
		UPDATE STG SET
			IsType1 = CASE WHEN DW.[ActivityDemographicKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimActivityDemographic] STG
		INNER JOIN [bi_mktg_stage].[synHC_DDS_DimActivityDemographic] DW
			ON DW.SFDC_TaskID = STG.SFDC_TaskID
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE   1=1   -- 1=0 No Fields Change to 1=1 when there are SCD Type 1 fields
			AND ( COALESCE(STG.[ActivitySSID],'') <> COALESCE(DW.[ActivitySSID],'')
				OR COALESCE(STG.[ContactSSID],'') <> COALESCE(DW.[ContactSSID],'')
				OR COALESCE(STG.[GenderSSID],'') <> COALESCE(DW.[GenderSSID],'')
				OR COALESCE(STG.[GenderDescription],'') <> COALESCE(DW.[GenderDescription],'')
				OR COALESCE(STG.[EthnicitySSID],'') <> COALESCE(DW.[EthnicitySSID],'')
				OR COALESCE(STG.[EthnicityDescription],'') <> COALESCE(DW.[EthnicityDescription],'')
				OR COALESCE(STG.[OccupationSSID],'') <> COALESCE(DW.[OccupationSSID],'')
				OR COALESCE(STG.[OccupationDescription],'') <> COALESCE(DW.[OccupationDescription],'')
				OR COALESCE(STG.[MaritalStatusSSID],'') <> COALESCE(DW.[MaritalStatusSSID],'')
				OR COALESCE(STG.[MaritalStatusDescription],'') <> COALESCE(DW.[MaritalStatusDescription],'')
				OR COALESCE(STG.[Birthday],'') <> COALESCE(DW.[Birthday],'')
				OR COALESCE(STG.[Age],'') <> COALESCE(DW.[Age],'')
				OR COALESCE(STG.[AgeRangeSSID],'') <> COALESCE(DW.[AgeRangeSSID],'')
				OR COALESCE(STG.[AgeRangeDescription],'') <> COALESCE(DW.[AgeRangeDescription],'')
				OR COALESCE(STG.[HairLossTypeSSID],'') <> COALESCE(DW.[HairLossTypeSSID],'')
				OR COALESCE(STG.[HairLossTypeDescription],'') <> COALESCE(DW.[HairLossTypeDescription],'')
				OR COALESCE(STG.[NorwoodSSID],'') <> COALESCE(DW.[NorwoodSSID],'')
				OR COALESCE(STG.[LudwigSSID],'') <> COALESCE(DW.[LudwigSSID],'')
				OR COALESCE(STG.[Performer],'') <> COALESCE(DW.[Performer],'')
				OR COALESCE(STG.[PriceQuoted],'') <> COALESCE(DW.[PriceQuoted],'')
				OR COALESCE(STG.[SolutionOffered],'') <> COALESCE(DW.[SolutionOffered],'')
				OR COALESCE(STG.[NoSaleReason],'') <> COALESCE(DW.[NoSaleReason],'')
				OR COALESCE(STG.[DateSaved],'') <> COALESCE(DW.[DateSaved],'')
				OR COALESCE(STG.[DiscStyleSSID],'') <> COALESCE(DW.[DiscStyleSSID],'')
				OR COALESCE(STG.[SFDC_LeadID],'') <> COALESCE(DW.[SFDC_LeadID],'')
				OR COALESCE(STG.[SFDC_PersonAccountID],'') <> COALESCE(DW.[SFDC_PersonAccountID],'')
				OR COALESCE(STG.[SFDC_TaskID],'') <> COALESCE(DW.[SFDC_TaskID],'')
				)
		AND STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Check for SCD Type 2
		-----------------------
		UPDATE STG SET
			IsType2 = CASE WHEN DW.[ActivityDemographicKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimActivityDemographic] STG
		INNER JOIN [bi_mktg_stage].[synHC_DDS_DimActivityDemographic] DW
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
		--	   FROM  [bi_mktg_stage].[DimActivityDemographic] STG
		--	   WHERE IsNew = 1
		--	   AND STG.[DataPkgKey] = @DataPkgKey

		--	)

		WITH Duplicates  AS
			(SELECT  STG.SFDC_TaskID
						, IsDuplicate
					  , row_number() OVER ( PARTITION BY STG.SFDC_TaskID ORDER BY STG.SFDC_TaskID ) AS RowNum
			   FROM  [bi_mktg_stage].[DimActivityDemographic] STG
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
		FROM [bi_mktg_stage].[DimActivityDemographic] STG
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
