/* CreateDate: 10/05/2010 14:04:36.693 , ModifyDate: 06/28/2011 23:40:05.183 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimClientMembershipAccum_Transform_SetIsNewSCD]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimClientMembershipAccum_Transform_SetIsNewSCD] is used to determine which records
-- are NEW, which records are SCD Type 1 or Type 2
--
--
--   exec [bi_cms_stage].[spHC_DimClientMembershipAccum_Transform_SetIsNewSCD] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    10/03/2010  RLifke       Initial Creation
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

	DECLARE		  @TableName			varchar(150)	-- Name of table

 	SET @TableName = N'[bi_cms_dds].[DimClientMembershipAccum]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY

		-----------------------
		-- Check for new rows
		-----------------------
		UPDATE STG SET
		     [ClientMembershipAccumKey] = DW.[ClientMembershipAccumKey]
			,IsNew = CASE WHEN DW.[ClientMembershipAccumKey] IS NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimClientMembershipAccum] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimClientMembershipAccum] DW with (nolock) ON
				DW.[ClientMembershipAccumSSID] = STG.[ClientMembershipAccumSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for Inferred Members
		-----------------------
		UPDATE STG SET
			IsInferredMember = CASE WHEN DW.[ClientMembershipAccumKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimClientMembershipAccum] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimClientMembershipAccum] DW  with (nolock) ON
				 STG.[ClientMembershipAccumSSID] = DW.[ClientMembershipAccumSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey



		-----------------------
		-- Check for SCD Type 1
		-----------------------
		UPDATE STG SET
			IsType1 = CASE WHEN DW.[ClientMembershipAccumKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimClientMembershipAccum] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimClientMembershipAccum] DW  with (nolock) ON
				 STG.[ClientMembershipAccumSSID] = DW.[ClientMembershipAccumSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE   1=1   -- 1=0 No Fields Change to 1=1 when there are SCD Type 1 fields
			AND (  COALESCE(STG.[ClientMembershipKey],0) <> COALESCE(DW.[ClientMembershipKey],0)
				OR COALESCE(STG.[ClientMembershipSSID],'') <> COALESCE(DW.[ClientMembershipSSID],'')
				OR COALESCE(STG.[AccumulatorKey],0) <> COALESCE(DW.[AccumulatorKey],0)
				OR COALESCE(STG.[AccumulatorSSID],0) <> COALESCE(DW.[AccumulatorSSID],0)
				OR COALESCE(STG.[AccumulatorDescription],'') <> COALESCE(DW.[AccumulatorDescription],'')
				OR COALESCE(STG.[AccumulatorDescriptionShort],'') <> COALESCE(DW.[AccumulatorDescriptionShort],'')
				OR COALESCE(STG.[UsedAccumQuantity],0) <> COALESCE(DW.[UsedAccumQuantity],0)
				OR COALESCE(STG.[AccumMoney],0) <> COALESCE(DW.[AccumMoney],0)
				OR COALESCE(STG.[AccumDate],0) <> COALESCE(DW.[AccumDate],0)
				OR COALESCE(STG.[TotalAccumQuantity],0) <> COALESCE(DW.[TotalAccumQuantity],0)
				OR COALESCE(STG.[AccumQuantityRemaining],0) <> COALESCE(DW.[AccumQuantityRemaining],0)
				)
		AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for SCD Type 2
		-----------------------
		UPDATE STG SET
			IsType2 = CASE WHEN DW.[ClientMembershipAccumKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimClientMembershipAccum] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimClientMembershipAccum] DW  with (nolock) ON
				 STG.[ClientMembershipAccumSSID] = DW.[ClientMembershipAccumSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE  1=0   -- 1=0 No Fields Change to 1=1 when there are SCD Type 2 fields
			--AND ( COALESCE(STG.[ClientMembershipKey],0) <> COALESCE(DW.[ClientMembershipKey],0)
				--OR COALESCE(STG.[ClientMembershipSSID],'') <> COALESCE(DW.[ClientMembershipSSID],'')
				--OR COALESCE(STG.[AccumulatorKey],0) <> COALESCE(DW.[AccumulatorKey],0)
				--OR COALESCE(STG.[AccumulatorSSID],0) <> COALESCE(DW.[AccumulatorSSID],0)
				--OR COALESCE(STG.[AccumulatorDescription],'') <> COALESCE(DW.[AccumulatorDescription],'')
				--OR COALESCE(STG.[AccumulatorDescriptionShort],'') <> COALESCE(DW.[AccumulatorDescriptionShort],'')
				--OR COALESCE(STG.[UsedAccumQuantity],0) <> COALESCE(DW.[UsedAccumQuantity],0)
				--OR COALESCE(STG.[AccumMoney],0) <> COALESCE(DW.[AccumMoney],0)
				--OR COALESCE(STG.[AccumDate],0) <> COALESCE(DW.[AccumDate],0)
				--OR COALESCE(STG.[TotalAccumQuantity],0) <> COALESCE(DW.[TotalAccumQuantity],0)
				--OR COALESCE(STG.[AccumQuantityRemaining],0) <> COALESCE(DW.[AccumQuantityRemaining],0)			--	)
		AND STG.[DataPkgKey] = @DataPkgKey;


		-----------------------
		-- Check for duplicate records
		-----------------------
		WITH Duplicates  AS
			(SELECT  ClientMembershipAccumSSID
						, IsDuplicate
					  , row_number() OVER ( PARTITION BY ClientMembershipAccumSSID ORDER BY ClientMembershipAccumSSID ) AS RowNum
			   FROM  [bi_cms_stage].[DimClientMembershipAccum] STG
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
		FROM [bi_cms_stage].[DimClientMembershipAccum] STG
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
