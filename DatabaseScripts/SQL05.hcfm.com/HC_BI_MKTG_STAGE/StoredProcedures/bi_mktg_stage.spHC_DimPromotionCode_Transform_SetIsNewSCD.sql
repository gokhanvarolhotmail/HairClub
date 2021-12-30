/* CreateDate: 02/02/2011 17:27:16.100 , ModifyDate: 02/02/2011 17:27:16.100 */
GO
create PROCEDURE [bi_mktg_stage].[spHC_DimPromotionCode_Transform_SetIsNewSCD]
       (
			  @DataPkgKey				int
       )

AS
-------------------------------------------------------------------------
-- [spHC_DimPromotionCode_Transform_SetIsNewSCD] is used to determine which records
--  are NEW, which records are SCD Type 1 or Type 2.
--
--
-- EXEC [spHC_DimPromotionCode_Transform_SetIsNewSCD] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    02/02/2011              Initial Creation
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

  	SET @TableName = N'[bi_mktg_dds].[DimPromotionCode]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

   BEGIN TRY


		-----------------------
		-- Check for new rows
		-----------------------
		UPDATE STG SET
		     [PromotionCodeKey] = DW.[PromotionCodeKey]
			,IsNew = CASE WHEN DW.[PromotionCodeKey] IS NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimPromotionCode] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimPromotionCode] DW ON
				DW.[PromotionCodeSSID] = STG.[PromotionCodeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for Inferred Members
		-----------------------
		UPDATE STG SET
			IsInferredMember = CASE WHEN DW.[PromotionCodeKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimPromotionCode] STG
		INNER JOIN [bi_mktg_stage].[synHC_DDS_DimPromotionCode] DW ON
				 STG.[PromotionCodeSSID] = DW.[PromotionCodeSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Check for SCD Type 1
		-----------------------
		UPDATE STG SET
			IsType1 = CASE WHEN DW.[PromotionCodeKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimPromotionCode] STG
		INNER JOIN [bi_mktg_stage].[synHC_DDS_DimPromotionCode] DW ON
				 STG.[PromotionCodeSSID] = DW.[PromotionCodeSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE   1=1   -- 1=0 No Fields Change to 1=1 when there are SCD Type 1 fields
			AND ( COALESCE(STG.[PromotionCodeDescription],'') <> COALESCE(DW.[PromotionCodeDescription],'')
				OR COALESCE(STG.[Active],'') <> COALESCE(DW.[Active],'')
				)
		AND STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Check for SCD Type 2
		-----------------------
		UPDATE STG SET
			IsType2 = CASE WHEN DW.[PromotionCodeKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimPromotionCode] STG
		INNER JOIN [bi_mktg_stage].[synHC_DDS_DimPromotionCode] DW ON
				 STG.[PromotionCodeSSID] = DW.[PromotionCodeSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE  1=0   -- 1=0 No Fields Change to 1=1 when there are SCD Type 2 fields
			--AND ( COALESCE(STG.[PromotionCodeDescription],'') <> COALESCE(DW.[PromotionCodeDescription],'')
			--	OR COALESCE(STG.[PromotionCodeDescriptionShort],'') <> COALESCE(DW.[PromotionCodeDescriptionShort],'')
			--	)
		AND STG.[DataPkgKey] = @DataPkgKey;


		-----------------------
		-- Check for duplicate records
		-----------------------
		WITH Duplicates  AS
			(SELECT  PromotionCodeSSID
						, IsDuplicate
					  , row_number() OVER ( PARTITION BY PromotionCodeSSID ORDER BY PromotionCodeSSID ) AS RowNum
			   FROM  [bi_mktg_stage].[DimPromotionCode] STG
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
		FROM [bi_mktg_stage].[DimPromotionCode] STG
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
