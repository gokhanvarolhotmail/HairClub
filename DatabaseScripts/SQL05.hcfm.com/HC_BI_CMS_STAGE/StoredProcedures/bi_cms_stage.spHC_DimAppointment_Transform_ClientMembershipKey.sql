/* CreateDate: 06/27/2011 17:22:53.493 , ModifyDate: 10/26/2011 14:06:05.857 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimAppointment_Transform_ClientMembershipKey]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimAppointment_Transform_ClientMembershipKey] is used to
--  transform ClientMembershipKey
--
--
--   exec [bi_cms_stage].[spHC_DimAppointment_Transform_ClientMembershipKey] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/22/2011  KMurdoch       Initial Creation
--			10/26/2011	KMurdoch	 Added exception message
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

 	SET @TableName = N'[bi_cms_dds].[DimAppointment]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY




		-----------------------
		-- Update [ClientMembershipKey]
		-----------------------
		UPDATE STG SET
		     [ClientMembershipKey] = DW.[ClientMembershipKey]
		FROM [bi_cms_stage].[DimAppointment] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimClientMembership] DW ON
				DW.[ClientMembershipSSID] = STG.[ClientMembershipSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Fix [ClientMembershipKey]
		-----------------------
		UPDATE STG SET
		     [ClientMembershipKey] = -1
		FROM [bi_cms_stage].[DimAppointment] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[ClientMembershipKey] IS NULL

		-----------------------
		-- Fix [ClientMembershipSSID]
		-----------------------
		UPDATE STG SET
		     [ClientMembershipSSID] = CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')  -- Not Assigned
		FROM [bi_cms_stage].[DimAppointment] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[ClientMembershipSSID] IS NULL

		-----------------------
		-- Exception if [ClientMembershipSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'ClientMembershipSSID is null - DAppt_Trans_Lkup'
		FROM [bi_cms_stage].[DimAppointment] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[ClientMembershipSSID] IS NULL

		-----------------------
		-- Exception if [ClientMembershipKey]IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'ClientMembershipKey is null - DAppt_Trans_Lkup'
		FROM [bi_cms_stage].[DimAppointment] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[ClientMembershipKey] IS NULL







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
