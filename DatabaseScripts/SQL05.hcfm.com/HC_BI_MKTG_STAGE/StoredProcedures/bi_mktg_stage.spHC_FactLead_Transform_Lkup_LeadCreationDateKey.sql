/* CreateDate: 05/03/2010 12:27:06.223 , ModifyDate: 01/10/2013 14:58:02.593 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactLead_Transform_Lkup_LeadCreationDateKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_FactLead_Transform_Lkup_eadCreationDateKey] is used to determine
-- which records have late arriving dimensions and adds them
--
--
--   exec [bi_mktg_stage].[spHC_FactLead_Transform_Lkup_LeadCreationDateKey] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    09/21/2009  RLifke       Initial Creation
--			10/26/2011	MBurrell	 Added exception message
--          01/08/2013  EKnapp		 Default null creation dates to unknown.
--          01/10/2013  EKnapp       Don't overwrite an existing exception message.
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
		-- Update [DateKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [LeadCreationDateKey] = COALESCE(DW.[DateKey], 0)
		FROM [bi_mktg_stage].[FactLead] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimDate] DW ON
				DW.[ISODate] = CONVERT(char(8),STG.[LeadCreationDateSSID],112)
		WHERE COALESCE(STG.[LeadCreationDateKey], 0) = 0
			AND STG.[DataPkgKey] = @DataPkgKey

		----------------------------------------------------------------------
		-- DO NOT ADD Inferred Members  use the DimDate_Populate SP
		-- to add dates to the DimDate table
		----------------------------------------------------------------------


        -----------------------
		-- Set [LeadCreationDateKey] to UnKnown date if IS NULL
		-----------------------
		UPDATE STG SET
		       [LeadCreationDateKey] = -1
		     , LeadCreationDateSSID = '1753-01-01 00:00:00.000'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.LeadCreationDateSSID IS NULL

    	-----------------------
		-- Exception if [LeadCreationDateSSID] IS NULL
		-------------------------
		--UPDATE STG SET
		--     IsException = 1
		--     ,	ExceptionMessage = 'LeadCreationDateSSID IS NULL - FL_Trans_LKup'
		--FROM [bi_mktg_stage].[FactLead] STG
		--WHERE STG.[DataPkgKey] = @DataPkgKey
		--	AND STG.[LeadCreationDateSSID] IS NULL


		-----------------------
		-- Exception if [LeadCreationDateKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = case when isnull(ExceptionMessage,'') = '' then 'LeadCreationDateKey IS NULL - FL_Trans_LKup' else ExceptionMessage end
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[LeadCreationDateKey] IS NULL
				OR STG.[LeadCreationDateKey] = 0)



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
