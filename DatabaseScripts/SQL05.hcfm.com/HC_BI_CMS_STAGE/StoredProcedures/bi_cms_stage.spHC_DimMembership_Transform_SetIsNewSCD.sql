/* CreateDate: 05/03/2010 12:20:01.167 , ModifyDate: 04/10/2012 16:41:21.180 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimMembership_Transform_SetIsNewSCD]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimMembership_Transform_SetIsNewSCD] is used to determine which records
-- are NEW, which records are SCD Type 1 or Type 2
--
--
--   exec [bi_cms_stage].[spHC_DimMembership_Transform_SetIsNewSCD] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    02/25/2009  RLifke       Initial Creation
--			04/10/2012  KMurdoch	 Added Membership Sort Order
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

 	SET @TableName = N'[bi_cms_dds].[DimMembership]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY



		-----------------------
		-- Check for new rows
		-----------------------
		UPDATE STG SET
		     [MembershipKey] = DW.[MembershipKey]
			,IsNew = CASE WHEN DW.[MembershipKey] IS NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimMembership] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimMembership] DW ON
				DW.[MembershipSSID] = STG.[MembershipSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for Inferred Members
		-----------------------
		UPDATE STG SET
			IsInferredMember = CASE WHEN DW.[MembershipKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimMembership] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimMembership] DW ON
				 STG.[MembershipSSID] = DW.[MembershipSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey



		-----------------------
		-- Check for SCD Type 1
		-----------------------
		UPDATE STG SET
			IsType1 = CASE WHEN DW.[MembershipKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimMembership] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimMembership] DW ON
				 STG.[MembershipSSID] = DW.[MembershipSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE   1=1   -- 1=0 No Fields Change to 1=1 when there are SCD Type 1 fields
			AND ( COALESCE(STG.[MembershipDescription],'') <> COALESCE(DW.[MembershipDescription],'')
				OR COALESCE(STG.[MembershipDescriptionShort],'') <> COALESCE(DW.[MembershipDescriptionShort],'')
				OR COALESCE(STG.[RevenueGroupDescription],'') <> COALESCE(DW.[RevenueGroupDescription],'')
				OR COALESCE(STG.[RevenueGroupDescriptionShort],'') <> COALESCE(DW.[RevenueGroupDescriptionShort],'')
				OR COALESCE(STG.[GenderDescription],'') <> COALESCE(DW.[GenderDescription],'')
				OR COALESCE(STG.[GenderDescriptionShort],'') <> COALESCE(DW.[GenderDescriptionShort],'')
				OR COALESCE(STG.[BusinessSegmentKey],0) <> COALESCE(DW.[BusinessSegmentKey],0)
				OR COALESCE(STG.[MembershipMonthlyFee],0) <> COALESCE(DW.[MembershipMonthlyFee],0)
				OR COALESCE(STG.[MembershipDurationMonths],0) <> COALESCE(DW.[MembershipDurationMonths],0)
				OR COALESCE(STG.[MembershipContractPrice],0) <> COALESCE(DW.[MembershipContractPrice],0)
				OR COALESCE(STG.[MembershipSortOrder],0) <> COALESCE(DW.[MembershipSortOrder],0)
				)
		AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for SCD Type 2
		-----------------------
		UPDATE STG SET
			IsType2 = CASE WHEN DW.[MembershipKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimMembership] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimMembership] DW ON
				 STG.[MembershipSSID] = DW.[MembershipSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE  1=0   -- 1=0 No Fields Change to 1=1 when there are SCD Type 2 fields
			--AND ( COALESCE(STG.[MembershipDescription],'') <> COALESCE(DW.[MembershipDescription],'')
			--	OR COALESCE(STG.[MembershipDescriptionShort],'') <> COALESCE(DW.[MembershipDescriptionShort],'')
				--OR COALESCE(STG.[RevenueGroupDescription],'') <> COALESCE(DW.[RevenueGroupDescription],'')
				--OR COALESCE(STG.[RevenueGroupDescriptionShort],'') <> COALESCE(DW.[RevenueGroupDescriptionShort],'')
				--OR COALESCE(STG.[GenderDescription],'') <> COALESCE(DW.[GenderDescription],'')
				--OR COALESCE(STG.[GenderDescriptionShort],'') <> COALESCE(DW.[GenderDescriptionShort],'')
			--	OR COALESCE(STG.[BusinessSegmentKey],0) <> COALESCE(DW.[BusinessSegmentKey],0)
				--OR COALESCE(STG.[MembershipMonthlyFee],0) <> COALESCE(DW.[MembershipMonthlyFee],0)
				--OR COALESCE(STG.[MembershipDurationMonths],0) <> COALESCE(DW.[MembershipDurationMonths],0)
				--OR COALESCE(STG.[MembershipContractPrice],0) <> COALESCE(DW.[MembershipContractPrice],0)
			--	)
		AND STG.[DataPkgKey] = @DataPkgKey;


		-----------------------
		-- Check for duplicate records
		-----------------------
		WITH Duplicates  AS
			(SELECT  MembershipSSID
						, IsDuplicate
					  , row_number() OVER ( PARTITION BY MembershipSSID ORDER BY MembershipSSID ) AS RowNum
			   FROM  [bi_cms_stage].[DimMembership] STG
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
		FROM [bi_cms_stage].[DimMembership] STG
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
