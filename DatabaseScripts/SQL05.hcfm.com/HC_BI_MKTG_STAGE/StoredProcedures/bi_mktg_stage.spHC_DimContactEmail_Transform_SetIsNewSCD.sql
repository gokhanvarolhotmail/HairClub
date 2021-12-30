/* CreateDate: 05/03/2010 12:26:36.310 , ModifyDate: 09/17/2020 13:01:04.300 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_DimContactEmail_Transform_SetIsNewSCD]
       (
			  @DataPkgKey				int
       )

AS
-------------------------------------------------------------------------
-- [spHC_DimContactEmail_Transform_SetIsNewSCD] is used to determine which records
--  are NEW, which records are SCD Type 1 or Type 2.
--
--
-- EXEC [spHC_DimContactEmail_Transform_SetIsNewSCD] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    08/11/2009               Initial Creation
--			11/21/2017  KMurdoch     Added SFDC_Lead/LeadEmail_ID
--			05/18/2020  KMurdoch     Added ContactEmailHashed
--			09/14/2020  KMurdoch     Removed references to OnContact ContactEmailSSID - changed to [SFDC_LeadEmailID]
--			09/17/2020	KMurdoch     Removed reference to CDC Operation for delete
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

  	SET @TableName = N'[bi_mktg_dds].[DimContactEmail]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

   BEGIN TRY


		-----------------------
		-- Check for new rows
		-----------------------
		UPDATE STG SET
		     [ContactEmailKey] = DW.[ContactEmailKey]
			,IsNew = CASE WHEN DW.[ContactEmailKey] IS NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimContactEmail] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimContactEmail] DW ON
				DW.[SFDC_LeadEmailID] = STG.[SFDC_LeadEmailID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for Inferred Members
		-----------------------
		UPDATE STG SET
			IsInferredMember = CASE WHEN DW.[ContactEmailKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimContactEmail] STG
		INNER JOIN [bi_mktg_stage].[synHC_DDS_DimContactEmail] DW ON
				 STG.[SFDC_LeadEmailID] = DW.[SFDC_LeadEmailID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey




		-----------------------
		-- Check for SCD Type 1
		-----------------------
		UPDATE STG SET
			IsType1 = CASE WHEN DW.[ContactEmailKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimContactEmail] STG
		INNER JOIN [bi_mktg_stage].[synHC_DDS_DimContactEmail] DW ON
				 STG.[SFDC_LeadEmailID] = DW.[SFDC_LeadEmailID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE   1=1   -- 1=0 No Fields Change to 1=1 when there are SCD Type 1 fields
			AND (COALESCE(STG.[ContactSSID],'') <> COALESCE(DW.[ContactSSID],'')
			 OR  COALESCE(STG.[EmailTypeCode],'') <> COALESCE(DW.[EmailTypeCode],'')
			 OR  COALESCE(STG.[Email],'') <> COALESCE(DW.[Email],'')
			 OR  COALESCE(STG.[Description],'') <> COALESCE(DW.[Description],'')
			 OR  COALESCE(STG.[PrimaryFlag],'') <> COALESCE(DW.[PrimaryFlag],'')
			 OR  COALESCE(STG.[SFDC_LeadID],'') <> COALESCE(DW.[SFDC_LeadID],'')
			 OR  COALESCE(STG.[SFDC_LeadEmailID],'') <> COALESCE(DW.[SFDC_LeadEmailID],'')
			 OR  COALESCE(STG.[ContactEmailHashed],'') <> COALESCE(DW.[ContactEmailHashed],'')
				)
		AND STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Check for SCD Type 2
		-----------------------
		UPDATE STG SET
			IsType2 = CASE WHEN DW.[ContactEmailKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimContactEmail] STG
		INNER JOIN [bi_mktg_stage].[synHC_DDS_DimContactEmail] DW ON
				 STG.[SFDC_LeadEmailID] = DW.[SFDC_LeadEmailID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE  1=0   -- 1=0 No Fields Change to 1=1 when there are SCD Type 2 fields
			--AND (COALESCE(STG.[ContactSSID],'') <> COALESCE(DW.[ContactSSID],'')
			-- OR  COALESCE(STG.[EmailTypeCode],'') <> COALESCE(DW.[EmailTypeCode],'')
			-- OR  COALESCE(STG.[Email],'') <> COALESCE(DW.[Email],'')
			-- OR  COALESCE(STG.[Description],'') <> COALESCE(DW.[Description],'')
			-- OR  COALESCE(STG.[PrimaryFlag],'') <> COALESCE(DW.[PrimaryFlag],'')
			--	)
		AND STG.[DataPkgKey] = @DataPkgKey;


		-----------------------
		-- Check for duplicate records
		-----------------------
		WITH Duplicates  AS
			(SELECT  [SFDC_LeadEmailID]
						, IsDuplicate
					  , row_number() OVER ( PARTITION BY [SFDC_LeadEmailID] ORDER BY [SFDC_LeadEmailID] ) AS RowNum
			   FROM  [bi_mktg_stage].[DimContactEmail] STG
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
		--UPDATE STG SET
		--		IsDelete = CASE WHEN COALESCE(STG.[CDC_Operation],'') = 'D'
		--			THEN 1 ELSE 0 END
		--FROM [bi_mktg_stage].[DimContactEmail] STG
		--WHERE STG.[DataPkgKey] = @DataPkgKey

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
