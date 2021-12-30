/* CreateDate: 10/05/2010 14:04:33.820 , ModifyDate: 04/09/2015 12:02:45.343 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimAccumulatorAdjustment_Transform_ClientMembershipKey]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimAccumulatorAdjustment_Transform_ClientMembershipKey] is used to
--  transform ClientMembershipKey
--
--
--   exec [bi_cms_stage].[spHC_DimAccumulatorAdjustment_Transform_ClientMembershipKey] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    10/03/2010  RLifke       Initial Creation
--			10/26/2011  KMurdoch	 Added exception message
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

 	SET @TableName = N'[bi_cms_dds].[DimAccumulatorAdjustment]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY
					-- Set the Current Extraction Time & Status
				UPDATE [bief_stage].[_DataFlow]
					SET CET = GETDATE()
						, [Status] = 'Extracting-c'
					WHERE [TableName] = @TableName



		-----------------------
		-- Update [ClientMembershipKey]
		-----------------------
		UPDATE STG SET
		     [ClientMembershipKey] = DW.[ClientMembershipKey]
		FROM [bi_cms_stage].[DimAccumulatorAdjustment] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimClientMembership] DW ON
				DW.[ClientMembershipSSID] = STG.[ClientMembershipSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Fix [ClientMembershipKey]
		-----------------------
		UPDATE STG SET
		     [ClientMembershipKey] = -1
		     , [ClientMembershipSSID] = CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')  -- Not Assigned
		FROM [bi_cms_stage].[DimAccumulatorAdjustment] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[ClientMembershipKey] IS NULL

		-----------------------
		-- Fix [ClientMembershipSSID]
		-----------------------
		UPDATE STG SET
		     [ClientMembershipKey] = -1
		     , [ClientMembershipSSID] = CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')  -- Not Assigned
		FROM [bi_cms_stage].[DimAccumulatorAdjustment] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[ClientMembershipSSID] IS NULL
				 )

		-----------------------
		-- Exception if [ClientMembershipSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'ClientMembershipSSID is null - DAccAdj_Trans_Lkup'
		FROM [bi_cms_stage].[DimAccumulatorAdjustment] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[ClientMembershipSSID] IS NULL
				 )

		-----------------------
		-- Exception if [ClientMembershipKey]IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'ClientMembershipSSID is null - DAccAdj_Trans_Lkup'
		FROM [bi_cms_stage].[DimAccumulatorAdjustment] STG
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
