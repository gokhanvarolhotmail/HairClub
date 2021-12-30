/* CreateDate: 05/03/2010 12:19:54.667 , ModifyDate: 10/26/2011 14:15:46.317 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimClientMembership_Transform_MembershipKey]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimClientMembership_Transform_MembershipKey] is used to
--  transform MembershipKey
--
--
--   exec [bi_cms_stage].[spHC_DimClientMembership_Transform_MembershipKey] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    02/25/2009  RLifke       Initial Creation
--			10/26/2011  KMurdoch     Added exception message
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
		-- Update [MembershipKey]
		-----------------------
		UPDATE STG SET
		     [MembershipKey] = DW.[MembershipKey]
		FROM [bi_cms_stage].[DimClientMembership] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimMembership] DW ON
				DW.[MembershipSSID] = STG.[MembershipSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Fix [MembershipKey]
		-----------------------
		UPDATE STG SET
		     [MembershipKey] = -1
		FROM [bi_cms_stage].[DimClientMembership] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[MembershipKey] IS NULL

		-----------------------
		-- Fix [MembershipSSID]
		-----------------------
		UPDATE STG SET
		     [MembershipSSID] = -2  -- Not Assigned
		FROM [bi_cms_stage].[DimClientMembership] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[MembershipSSID] IS NULL
			OR	STG.[MembershipSSID] = '' )

		-----------------------
		-- Exception if [MembershipSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'MembershipSSID is null - DCLM_Lkup'
		FROM [bi_cms_stage].[DimClientMembership] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[MembershipSSID] IS NULL
			OR	STG.[MembershipSSID] = '' )

		-----------------------
		-- Exception if [MembershipKey]IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'MembershipSSID is null - DCLM_Lkup'
		FROM [bi_cms_stage].[DimClientMembership] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[MembershipKey] IS NULL







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
