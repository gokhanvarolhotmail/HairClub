/* CreateDate: 05/03/2010 12:19:54.687 , ModifyDate: 02/12/2019 10:37:53.587 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimClientMembership_Transform_SetIsNewSCD]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimClientMembership_Transform_SetIsNewSCD] is used to determine which records
-- are NEW, which records are SCD Type 1 or Type 2
--
--
--   exec [bi_cms_stage].[spHC_DimClientMembership_Transform_SetIsNewSCD] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    03/16/2009  RLifke       Initial Creation
--			12/18/2018  KMurdoch	 Added National Monthly Fee & ClientMembershipIdentifier
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

 	SET @TableName = N'[bi_cms_dds].[DimClientMembership]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY

		-----------------------
		-- Check for new rows
		-----------------------
		UPDATE STG SET
		     [ClientMembershipKey] = DW.[ClientMembershipKey]
			,IsNew = CASE WHEN DW.[ClientMembershipKey] IS NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimClientMembership] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimClientMembership] DW ON
				DW.[ClientMembershipSSID] = STG.[ClientMembershipSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for Inferred Members
		-----------------------
		UPDATE STG SET
			IsInferredMember = CASE WHEN DW.[ClientMembershipKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimClientMembership] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimClientMembership] DW ON
				 STG.[ClientMembershipSSID] = DW.[ClientMembershipSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey



		-----------------------
		-- Check for SCD Type 1
		-----------------------
		UPDATE STG SET
			IsType1 = CASE WHEN DW.[ClientMembershipKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimClientMembership] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimClientMembership] DW ON
				 STG.[ClientMembershipSSID] = DW.[ClientMembershipSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE   1=1   -- 1=0 No Fields Change to 1=1 when there are SCD Type 1 fields
			AND ( COALESCE(STG.[Member1_ID_Temp],0) <> COALESCE(DW.[Member1_ID_Temp],0)
				OR COALESCE(STG.[ClientKey],0) <> COALESCE(DW.[ClientKey],0)
				OR COALESCE(STG.[ClientSSID],'') <> COALESCE(DW.[ClientSSID],'')
				OR COALESCE(STG.[CenterKey],0) <> COALESCE(DW.[CenterKey],0)
				OR COALESCE(STG.[CenterSSID],0) <> COALESCE(DW.[CenterSSID],0)
				OR COALESCE(STG.[MembershipKey],0) <> COALESCE(DW.[MembershipKey],0)
				OR COALESCE(STG.[MembershipSSID],0) <> COALESCE(DW.[MembershipSSID],0)
				OR COALESCE(STG.[ClientMembershipStatusSSID],0) <> COALESCE(DW.[ClientMembershipStatusSSID],0)
				OR COALESCE(STG.[ClientMembershipStatusDescription],'') <> COALESCE(DW.[ClientMembershipStatusDescription],'')
				OR COALESCE(STG.[ClientMembershipStatusDescriptionShort],'') <> COALESCE(DW.[ClientMembershipStatusDescriptionShort],'')
				OR COALESCE(STG.[ClientMembershipContractPaidAmount],0) <> COALESCE(DW.[ClientMembershipContractPaidAmount],0)
				OR COALESCE(STG.[ClientMembershipContractPrice],0) <> COALESCE(DW.[ClientMembershipContractPrice],0)
				OR COALESCE(STG.[ClientMembershipMonthlyFee],0) <> COALESCE(DW.[ClientMembershipMonthlyFee],0)
				OR COALESCE(STG.[ClientMembershipBeginDate],0) <> COALESCE(DW.[ClientMembershipBeginDate],0)
				OR COALESCE(STG.[ClientMembershipEndDate],0) <> COALESCE(DW.[ClientMembershipEndDate],0)
				OR COALESCE(STG.[ClientMembershipCancelDate],0) <> COALESCE(DW.[ClientMembershipCancelDate],0)
				--OR COALESCE(STG.[ClientMembershipIdentifier],0) <> COALESCE(DW.[ClientMembershipIdentifier],0)
				OR COALESCE(STG.[NationalMonthlyFee],0) <> COALESCE(DW.[NationalMonthlyFee],0)
				)
		AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for SCD Type 2
		-----------------------
		UPDATE STG SET
			IsType2 = CASE WHEN DW.[ClientMembershipKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimClientMembership] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimClientMembership] DW ON
				 STG.[ClientMembershipSSID] = DW.[ClientMembershipSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE  1=0   -- 1=0 No Fields Change to 1=1 when there are SCD Type 2 fields
			--AND ( COALESCE(STG.[Member1_ID_Temp],0) <> COALESCE(DW.[Member1_ID_Temp],0)
				--OR COALESCE(STG.[ClientKey],0) <> COALESCE(DW.[ClientKey],0)
				--OR COALESCE(STG.[ClientSSID],'') <> COALESCE(DW.[ClientSSID],'')
				--OR COALESCE(STG.[CenterKey],0) <> COALESCE(DW.[CenterKey],0)
				--OR COALESCE(STG.[CenterSSID],0) <> COALESCE(DW.[CenterSSID],0)
				--OR COALESCE(STG.[MembershipKey],0) <> COALESCE(DW.[MembershipKey],0)
				--OR COALESCE(STG.[MembershipSSID],0) <> COALESCE(DW.[MembershipSSID],0)
				--OR COALESCE(STG.[ClientMembershipStatusSSID],0) <> COALESCE(DW.[ClientMembershipStatusSSID],0)
				--OR COALESCE(STG.[ClientMembershipStatusDescription],'') <> COALESCE(DW.[ClientMembershipStatusDescription],'')
				--OR COALESCE(STG.[ClientMembershipStatusDescriptionShort],'') <> COALESCE(DW.[ClientMembershipStatusDescriptionShort],'')
				--OR COALESCE(STG.[ClientMembershipContractPaidAmount],0) <> COALESCE(DW.[ClientMembershipContractPaidAmount],0)
				--OR COALESCE(STG.[ClientMembershipMonthlyFee],0) <> COALESCE(DW.[ClientMembershipMonthlyFee],0)
				--OR COALESCE(STG.[ClientMembershipBeginDate],0) <> COALESCE(DW.[ClientMembershipBeginDate],0)
				--OR COALESCE(STG.[ClientMembershipEndDate],0) <> COALESCE(DW.[ClientMembershipEndDate],0)
				--OR COALESCE(STG.[ClientMembershipCancelDate],0) <> COALESCE(DW.[ClientMembershipCancelDate],0)
			--	)
		AND STG.[DataPkgKey] = @DataPkgKey;


		-----------------------
		-- Check for duplicate records
		-----------------------
		WITH Duplicates  AS
			(SELECT  ClientMembershipSSID
						, IsDuplicate
					  , row_number() OVER ( PARTITION BY ClientMembershipSSID ORDER BY ClientMembershipSSID ) AS RowNum
			   FROM  [bi_cms_stage].[DimClientMembership] STG
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
		FROM [bi_cms_stage].[DimClientMembership] STG
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
