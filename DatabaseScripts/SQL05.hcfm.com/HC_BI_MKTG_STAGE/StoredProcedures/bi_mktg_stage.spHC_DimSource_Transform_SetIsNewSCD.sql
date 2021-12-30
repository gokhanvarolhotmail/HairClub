/* CreateDate: 05/03/2010 12:26:49.193 , ModifyDate: 12/08/2020 13:13:24.820 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_DimSource_Transform_SetIsNewSCD]
       (
			  @DataPkgKey				int
       )

AS
-------------------------------------------------------------------------
-- [spHC_DimSource_Transform_SetIsNewSCD] is used to determine which records
--  are NEW, which records are SCD Type 1 or Type 2.
--
--
-- EXEC [spHC_DimSource_Transform_SetIsNewSCD] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    08/11/2009               Initial Creation
--			04/18/2018				 Added Channel, Campaign Name, Gender, promocode
--			10/01/2019  KMurdoch     Added check for changed OwnerType
--			07/27/2020  KMurdoch     Added check for Origin
--			12/08/2020  KMurdoch     Added check for Content
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

  	SET @TableName = N'[bi_mktg_dds].[DimSource]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

   BEGIN TRY


		-----------------------
		-- Check for new rows
		-----------------------
		UPDATE STG SET
		     [SourceKey] = DW.[SourceKey]
			,IsNew = CASE WHEN DW.[SourceKey] IS NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimSource] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimSource] DW ON
				DW.[SourceSSID] = STG.[SourceSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for Inferred Members
		-----------------------
		UPDATE STG SET
			IsInferredMember = CASE WHEN DW.[SourceKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimSource] STG
		INNER JOIN [bi_mktg_stage].[synHC_DDS_DimSource] DW ON
				 STG.[SourceSSID] = DW.[SourceSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey




		-----------------------
		-- Check for SCD Type 1
		-----------------------
		UPDATE STG SET
			IsType1 = CASE WHEN DW.[SourceKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimSource] STG
		INNER JOIN [bi_mktg_stage].[synHC_DDS_DimSource] DW ON
				 STG.[SourceSSID] = DW.[SourceSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE   1=1   -- 1=0 No Fields Change to 1=1 when there are SCD Type 1 fields
			AND ( COALESCE(STG.[SourceName],'') <> COALESCE(DW.[SourceName],'')
				OR COALESCE(STG.[Media],'') <> COALESCE(DW.[Media],'')
				OR COALESCE(STG.[Level02Location],'') <> COALESCE(DW.[Level02Location],'')
				OR COALESCE(STG.[Level03Language],'') <> COALESCE(DW.[Level03Language],'')
				OR COALESCE(STG.[Level04Format],'') <> COALESCE(DW.[Level04Format],'')
				OR COALESCE(STG.[Level05Creative],'') <> COALESCE(DW.[Level05Creative],'')
				OR COALESCE(STG.[Number],'') <> COALESCE(DW.[Number],'')
				OR COALESCE(STG.[Channel],'') <> COALESCE(DW.[Channel],'')
				OR COALESCE(STG.[CampaignName],'') <> COALESCE(DW.[CampaignName],'')
				OR COALESCE(STG.[Gender],'') <> COALESCE(DW.[Gender],'')
				OR COALESCE(STG.[PromoCode],'') <> COALESCE(DW.[PromoCode],'')
				OR COALESCE(STG.[OwnerType],'') <> COALESCE(DW.[OwnerType],'')
				OR COALESCE(STG.[Origin],'') <> COALESCE(DW.[Origin],'')
				OR COALESCE(STG.[Content],'') <> COALESCE(DW.[Content],'')
				)
		AND STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Check for SCD Type 2
		-----------------------
		UPDATE STG SET
			IsType2 = CASE WHEN DW.[SourceKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimSource] STG
		INNER JOIN [bi_mktg_stage].[synHC_DDS_DimSource] DW ON
				 STG.[SourceSSID] = DW.[SourceSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE  1=0   -- 1=0 No Fields Change to 1=1 when there are SCD Type 2 fields
			--AND ( COALESCE(STG.[SourceName],'') <> COALESCE(DW.[SourceName],'')
			--	OR COALESCE(STG.[Media],'') <> COALESCE(DW.[Media],'')
			--	OR COALESCE(STG.[Level02Location],'') <> COALESCE(DW.[Level02Location],'')
			--	OR COALESCE(STG.[Level03Language],'') <> COALESCE(DW.[Level03Language],'')
			--	OR COALESCE(STG.[Level04Format],'') <> COALESCE(DW.[Level04Format],'')
			--	OR COALESCE(STG.[Level05Creative],'') <> COALESCE(DW.[Level05Creative],'')
			--	OR COALESCE(STG.[Number],'') <> COALESCE(DW.[Number],'')
			--	)
		AND STG.[DataPkgKey] = @DataPkgKey;


		-----------------------
		-- Check for duplicate records
		-----------------------
		WITH Duplicates  AS
			(SELECT  [SourceSSID]
						, IsDuplicate
					  , row_number() OVER ( PARTITION BY [SourceSSID] ORDER BY [SourceSSID] ) AS RowNum
			   FROM  [bi_mktg_stage].[DimSource] STG
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
		FROM [bi_mktg_stage].[DimSource] STG
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
