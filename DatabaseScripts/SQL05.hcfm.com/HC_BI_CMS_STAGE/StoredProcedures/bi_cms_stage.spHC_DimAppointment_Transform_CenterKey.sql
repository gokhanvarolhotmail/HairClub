/* CreateDate: 06/27/2011 17:23:48.140 , ModifyDate: 10/26/2011 14:04:49.900 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimAppointment_Transform_CenterKey]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimAppointment_Transform_CenterKey] is used to
--  transform CenterKey
--
--
--   exec [bi_cms_stage].[spHC_DimAppointment_Transform_CenterKey] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/03/2009  RLifke       Initial Creation
--			10/26/2011  KMurdoch	 Added Exception message
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
		-- Update [CenterKey]
		-----------------------
		UPDATE STG SET
		     [CenterKey] = DW.[CenterKey]
		FROM [bi_cms_stage].[DimAppointment] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimCenter] DW ON
				DW.[CenterSSID] = STG.[CenterSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Fix [CenterKey]
		-----------------------
		UPDATE STG SET
		     [CenterKey] = -1
		FROM [bi_cms_stage].[DimAppointment] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND coalesce(STG.[CenterKey],0) = 0

		-----------------------
		-- Fix [CenterSSID]
		-----------------------
		UPDATE STG SET
		     [CenterSSID] = -2  -- Not Assigned
		FROM [bi_cms_stage].[DimAppointment] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[CenterSSID] IS NULL
			OR	STG.[CenterSSID] = '' )

		-----------------------
		-- Exception if [CenterSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'CenterSSID is null - DAppt_Trans_Lkup'
		FROM [bi_cms_stage].[DimAppointment] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[CenterSSID] IS NULL
			OR	STG.[CenterSSID] = '' )

		-----------------------
		-- Exception if [CenterKey]IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'CenterKey is null - DAppt_Trans_Lkup'
		FROM [bi_cms_stage].[DimAppointment] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[CenterKey] IS NULL






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
