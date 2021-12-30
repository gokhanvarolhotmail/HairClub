/* CreateDate: 05/03/2010 12:26:32.043 , ModifyDate: 08/05/2019 11:17:55.627 */
GO
CREATE PROCEDURE [bi_mktg_stage].[zzzspHC_DimActivity_Transform_SetIsNewSCD]
       (
			  @DataPkgKey				int
       )

AS
-------------------------------------------------------------------------
-- [spHC_DimActivity_Transform_SetIsNewSCD] is used to determine which records
--  are NEW, which records are SCD Type 1 or Type 2.
--
--
-- EXEC [spHC_DimActivity_Transform_SetIsNewSCD] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    08/11/2009               Initial Creation
--			11/20/2017   KMurdoch    Added SFDC Lead/TaskID
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

  	SET @TableName = N'[bi_mktg_dds].[DimActivity]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

   BEGIN TRY


		-----------------------
		-- Check for new rows
		-----------------------
		UPDATE STG SET
		     [ActivityKey] = DW.[ActivityKey]
			,IsNew = CASE WHEN DW.[ActivityKey] IS NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimActivity] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimActivity] DW ON
			DW.[ActivitySSID] = STG.[ActivitySSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for Inferred Members
		-----------------------
		UPDATE STG SET
			IsInferredMember = CASE WHEN DW.[ActivityKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimActivity] STG
		INNER JOIN [bi_mktg_stage].[synHC_DDS_DimActivity] DW ON
			STG.[ActivitySSID] = DW.[ActivitySSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey




		-----------------------
		-- Check for SCD Type 1
		-----------------------
		UPDATE STG SET
			IsType1 = CASE WHEN DW.[ActivityKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimActivity] STG
		INNER JOIN [bi_mktg_stage].[synHC_DDS_DimActivity] DW ON
			STG.[ActivitySSID] = DW.[ActivitySSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE   1=1   -- 1=0 No Fields Change to 1=1 when there are SCD Type 1 fields
			AND (  COALESCE(STG.[ActivityDueDate],'') <> COALESCE(DW.[ActivityDueDate],'')
				OR COALESCE(STG.[ActivityStartTime],'') <> COALESCE(DW.[ActivityStartTime],'')
				OR COALESCE(STG.[ActivityCompletionDate],'') <> COALESCE(DW.[ActivityCompletionDate],'')
				OR COALESCE(STG.[ActivityCompletionTime],'') <> COALESCE(DW.[ActivityCompletionTime],'')
				OR COALESCE(STG.[ActionCodeSSID],'') <> COALESCE(DW.[ActionCodeSSID],'')
				OR COALESCE(STG.[ActionCodeDescription],'') <> COALESCE(DW.[ActionCodeDescription],'')
				OR COALESCE(STG.[ResultCodeSSID],'') <> COALESCE(DW.[ResultCodeSSID],'')
				OR COALESCE(STG.[ResultCodeDescription],'') <> COALESCE(DW.[ResultCodeDescription],'')
				OR COALESCE(STG.[SourceSSID],'') <> COALESCE(DW.[SourceSSID],'')
				OR COALESCE(STG.[SourceDescription],'') <> COALESCE(DW.[SourceDescription],'')

				OR COALESCE(STG.[CenterSSID],'') <> COALESCE(DW.[CenterSSID],'')
				OR COALESCE(STG.[ContactSSID],'') <> COALESCE(DW.[ContactSSID],'')
				OR COALESCE(STG.[SalesTypeSSID],'') <> COALESCE(DW.[SalesTypeSSID],'')
				OR COALESCE(STG.[SalesTypeDescription],'') <> COALESCE(DW.[SalesTypeDescription],'')

				OR COALESCE(STG.[ActivityTypeSSID],'') <> COALESCE(DW.[ActivityTypeSSID],'')
				OR COALESCE(STG.[ActivityTypeDescription],'') <> COALESCE(DW.[ActivityTypeDescription],'')
				OR COALESCE(STG.[TimeZoneSSID],'') <> COALESCE(DW.[TimeZoneSSID],'')
				OR COALESCE(STG.[TimeZoneDescription],'') <> COALESCE(DW.[TimeZoneDescription],'')
				OR COALESCE(STG.[GreenwichOffset],'') <> COALESCE(DW.[GreenwichOffset],'')
				OR COALESCE(STG.[PromotionCodeSSID],'') <> COALESCE(DW.[PromotionCodeSSID],'')
				OR COALESCE(STG.[PromotionCodeDescription],'') <> COALESCE(DW.[PromotionCodeDescription],'')
				OR COALESCE(STG.[IsAppointment],'') <> COALESCE(DW.[IsAppointment],'')
				OR COALESCE(STG.[IsShow],'') <> COALESCE(DW.[IsShow],'')
				OR COALESCE(STG.[IsNoShow],'') <> COALESCE(DW.[IsNoShow],'')
				OR COALESCE(STG.[IsSale],'') <> COALESCE(DW.[IsSale],'')
				OR COALESCE(STG.[IsNoSale],'') <> COALESCE(DW.[IsNoSale],'')
				OR COALESCE(STG.[IsConsultation],'') <> COALESCE(DW.[IsConsultation],'')
				OR COALESCE(STG.[IsBeBack],'') <> COALESCE(DW.[IsBeBack],'')
				OR COALESCE(STG.[SFDC_TaskID],'') <> COALESCE(DW.[SFDC_TaskID],'')
				OR COALESCE(STG.[SFDC_LeadID],'') <> COALESCE(DW.[SFDC_LeadID],'')

				)
		AND STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Check for SCD Type 2
		-----------------------
		UPDATE STG SET
			IsType2 = CASE WHEN DW.[ActivityKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimActivity] STG
		INNER JOIN [bi_mktg_stage].[synHC_DDS_DimActivity] DW ON
			STG.[ActivitySSID] = DW.[ActivitySSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE  1=0   -- 1=0 No Fields Change to 1=1 when there are SCD Type 2 fields
			--AND (  COALESCE(STG.[ActivityDueDate],'') <> COALESCE(DW.[ActivityDueDate],'')
			--	OR COALESCE(STG.[ActivityStartTime],'') <> COALESCE(DW.[ActivityStartTime],'')
			--	OR COALESCE(STG.[ActivityCompletionDate],'') <> COALESCE(DW.[ActivityCompletionDate],'')
			--	OR COALESCE(STG.[ActivityCompletionTime],'') <> COALESCE(DW.[ActivityCompletionTime],'')
			--	OR COALESCE(STG.[ActionCodeSSID],'') <> COALESCE(DW.[ActionCodeSSID],'')
			--	OR COALESCE(STG.[ActionCodeDescription],'') <> COALESCE(DW.[ActionCodeDescription],'')
			--	OR COALESCE(STG.[ResultCodeSSID],'') <> COALESCE(DW.[ResultCodeSSID],'')
			--	OR COALESCE(STG.[ResultCodeDescription],'') <> COALESCE(DW.[ResultCodeDescription],'')
			--	OR COALESCE(STG.[SourceSSID],'') <> COALESCE(DW.[SourceSSID],'')
			--	OR COALESCE(STG.[SourceDescription],'') <> COALESCE(DW.[SourceDescription],'')
				--OR COALESCE(STG.[CenterSSID],'') <> COALESCE(DW.[CenterSSID],'')
				--OR COALESCE(STG.[ContactSSID],'') <> COALESCE(DW.[ContactSSID],'')
				--OR COALESCE(STG.[SalesTypeSSID],'') <> COALESCE(DW.[SalesTypeSSID],'')
				--OR COALESCE(STG.[SalesTypeDescription],'') <> COALESCE(DW.[SalesTypeDescription],'')
			--	OR COALESCE(STG.[ActivityTypeSSID],'') <> COALESCE(DW.[ActivityTypeSSID],'')
			--	OR COALESCE(STG.[ActivityTypeDescription],'') <> COALESCE(DW.[ActivityTypeDescription],'')
			--	OR COALESCE(STG.[TimeZoneSSID],'') <> COALESCE(DW.[TimeZoneSSID],'')
			--	OR COALESCE(STG.[TimeZoneDescription],'') <> COALESCE(DW.[TimeZoneDescription],'')
			--	OR COALESCE(STG.[GreenwichOffset],'') <> COALESCE(DW.[GreenwichOffset],'')
			--	OR COALESCE(STG.[PromotionCodeSSID],'') <> COALESCE(DW.[PromotionCodeSSID],'')
			--	OR COALESCE(STG.[PromotionCodeDescription],'') <> COALESCE(DW.[PromotionCodeDescription],'')
			--OR COALESCE(STG.[IsAppointment],'') <> COALESCE(DW.[IsAppointment],'')
			--OR COALESCE(STG.[IsShow],'') <> COALESCE(DW.[IsShow],'')
			--OR COALESCE(STG.[IsNoShow],'') <> COALESCE(DW.[IsNoShow],'')
			--OR COALESCE(STG.[IsSale],'') <> COALESCE(DW.[IsSale],'')
			--OR COALESCE(STG.[IsNoSale],'') <> COALESCE(DW.[IsNoSale],'')
			--OR COALESCE(STG.[IsConsultation],'') <> COALESCE(DW.[IsConsultation],'')
			--OR COALESCE(STG.[IsBeBack],'') <> COALESCE(DW.[IsBeBack],'')
			--	)
		AND STG.[DataPkgKey] = @DataPkgKey;


		-----------------------
		-- Check for duplicate records
		-----------------------
		WITH Duplicates  AS
			(SELECT  ActivitySSID
						, IsDuplicate
					  , row_number() OVER ( PARTITION BY ActivitySSID ORDER BY ActivitySSID ) AS RowNum
			   FROM  [bi_mktg_stage].[DimActivity] STG
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
		FROM [bi_mktg_stage].[DimActivity] STG
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
