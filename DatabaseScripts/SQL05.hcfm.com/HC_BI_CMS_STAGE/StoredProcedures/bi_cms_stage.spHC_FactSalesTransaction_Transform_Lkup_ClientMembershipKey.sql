/* CreateDate: 05/03/2010 12:20:25.593 , ModifyDate: 10/26/2011 14:17:02.040 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactSalesTransaction_Transform_Lkup_ClientMembershipKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [sspHC_FactSalesTransaction_Transform_Lkup_ClientMembershipKey] is used to determine
-- the ClientMembershipKey foreign key values in the FactSalesTransaction table using DimClientMembership.
--
--
--   exec [bi_cms_stage].[spHC_FactSalesTransaction_Transform_Lkup_ClientMembershipKey] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    09/21/2009  RLifke       Initial Creation
--			10/26/2011  KMurdoch     Added exception message
--          10/26/2011  EKnapp       Update MemberShipKey to -1 after LoadInferred
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


 	-- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY

		------------------------
		-- There might be some other load that just added them
		-- Update [ClientMembershipKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [ClientMembershipKey] = COALESCE(DW.[ClientMembershipKey], 0)
		     , [MembershipKey] = COALESCE(DW.[MembershipKey], 0)
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimClientMembership] DW  WITH (NOLOCK)
			ON DW.[ClientMembershipSSID] = STG.[ClientMembershipSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[ClientMembershipKey], 0) = 0
			AND STG.[ClientMembershipSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		------------------------
		-- There might be some other load that just added them
		-- Update [ClientMembershipKey] Keys in STG
		------------------------
		UPDATE STG SET
			 [MembershipKey] = COALESCE(DW.[MembershipKey], 0)
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimClientMembership] DW  WITH (NOLOCK)
			ON DW.[ClientMembershipSSID] = STG.[ClientMembershipSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[MembershipKey], 0) = 0
			AND STG.[ClientMembershipSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_FactSalesTransaction_LoadInferred_DimClientMembership] @DataPkgKey


		------------------------
		-- Update ClientMembership Keys in STG
		------------------------
		UPDATE STG SET
		     [ClientMembershipKey] = COALESCE(DW.[ClientMembershipKey], 0)
		     , 	 [MembershipKey]=-1
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimClientMembership] DW  WITH (NOLOCK)
			ON DW.[ClientMembershipSSID] = STG.[ClientMembershipSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[ClientMembershipKey], 0) = 0
			AND STG.[ClientMembershipSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		---------------------------
		------ Fix [ClientMembershipKey]
		---------------------------
		----UPDATE STG SET
		----     [ClientMembershipKey] = -1
		----     , [MembershipKey] = -1
		----FROM [bi_cms_stage].[FactSalesTransaction] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND STG.[ClientMembershipKey] IS NULL

		---------------------------
		------ Fix [ClientMembershipSSID]
		---------------------------
		----UPDATE STG SET
		----     [ClientMembershipKey] = -2
		----     , [ClientMembershipSSID] = CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')
		----     , [MembershipKey] = -2
		----FROM [bi_cms_stage].[FactSalesTransaction] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND (STG.[ClientMembershipSSID] IS NULL )

		-----------------------
		-- Exception if [ClientMembershipSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'ClientMembershipSSID is null - FSalesTrx_Trans_Lkup'
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[ClientMembershipSSID] IS NULL


		-----------------------
		-- Exception if [ClientMembershipKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'ClientMembershipKey is null - FSalesTrx_Trans_Lkup'
		FROM [bi_cms_stage].[FactSalesTransaction] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[ClientMembershipKey] IS NULL
				OR STG.[ClientMembershipKey] = 0)


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
