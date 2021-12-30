/* CreateDate: 05/03/2010 12:26:55.240 , ModifyDate: 10/26/2011 10:40:58.540 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_OriginalAppointmentDateKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_FactActivityResults_Transform_Lkup_OriginalAppointmentDateKey] is used to populate
-- the OriginalAppointmentDateKey in the FactActivityResults rows
--
--
--   exec [bi_mktg_stage].[spHC_FactActivityResults_Transform_Lkup_OriginalAppointmentDateKey] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    09/21/2009  RLifke       Initial Creation
--			10/26/2011	MBurrell	 Added exception message

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

	DECLARE		@TableName			varchar(150)	-- Name of table
	DECLARE		@DataPkgDetailKey	int

 	SET @TableName = N'[bi_mktg_dds].[DimDate]'

 	   -- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY

		------------------------
		-- Update [OriginalAppointmentDateKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [OriginalAppointmentDateKey] = COALESCE(DW.[DateKey], 0)
		FROM [bi_mktg_stage].[FactActivityResults] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimDate] DW ON
				DW.[ISODate] = CONVERT(char(8),STG.[OriginalAppointmentDateSSID],112)
		WHERE COALESCE(STG.[OriginalAppointmentDateKey], 0) = 0
			AND STG.[DataPkgKey] = @DataPkgKey

		----------------------------------------------------------------------
		-- DO NOT ADD Inferred Members  use the DimDate_Populate SP
		-- to add dates to the DimDate table.  No audit logging is needed.
		----------------------------------------------------------------------

		-----------------------
		-- Set [OriginalAppointmentDate] to UnKnown date if IS NULL
		-----------------------
		UPDATE STG SET
		       [OriginalAppointmentDateKey] = -1
		     , [OriginalAppointmentDateSSID] = '1753-01-01 00:00:00.000'
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[OriginalAppointmentDateSSID] IS NULL

		-----------------------
		-- Exception if [OriginalAppointmentDate] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'OriginalAppointmentDateSSID IS NULL - FAR_Trans_LKup'
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[OriginalAppointmentDateSSID] IS NULL

		-----------------------
		-- Exception if [OriginalAppointmentDateKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'OriginalAppointmentDateKey IS NULL - FAR_Trans_LKup'
		FROM [bi_mktg_stage].[FactActivityResults] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[OriginalAppointmentDateKey] IS NULL
				OR STG.[OriginalAppointmentDateKey] = 0)

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
