/* CreateDate: 05/03/2010 12:26:59.637 , ModifyDate: 01/04/2013 15:34:23.473 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactActivity_Transform_Lkup_ActivityDueDateKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_FactActivity_Transform_Lkup_ActivityDueDateKey] is used to populate
-- the ActivityDueDateKey in the FactActivity rows
--
--
--   exec [bi_mktg_stage].[spHC_FactActivity_Transform_Lkup_ActivityDueDateKey] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    09/21/2009  RLifke       Initial Creation
--			10/26/2011	KMurdoch	 Added Exception message
--			01/04/2013  EKnapp		 If non-null activity date does not match a DimDate default to -1 member.
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
				, @MaxDimDate       date

	DECLARE		@TableName			varchar(150)	-- Name of table
	DECLARE		@DataPkgDetailKey	int

 	SET @TableName = N'[bi_mktg_dds].[DimDate]'

 	   -- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY

		------------------------
		-- Update [ActivityDueDateKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [ActivityDueDateKey] = COALESCE(DW.[DateKey], -1)
		FROM [bi_mktg_stage].[FactActivity] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimDate] DW ON
				DW.[ISODate] = CONVERT(char(8),STG.[ActivityDueDateSSID],112)
		WHERE COALESCE(STG.[ActivityDueDateKey], 0) = 0
			AND STG.[DataPkgKey] = @DataPkgKey
			AND STG.ActivityDueDateSSID is not null


		----------------------------------------------------------------------
		-- DO NOT ADD Inferred Members  use the DimDate_Populate SP
		-- to add dates to the DimDate table.  No audit logging is needed.
		----------------------------------------------------------------------

		-----------------------
		-- Set [ActivityDueDate] to UnKnown date if IS NULL
		-----------------------
		UPDATE STG SET
		       [ActivityDueDateKey] = -1
		     , [ActivityDueDateSSID] = '1753-01-01 00:00:00.000'
		FROM [bi_mktg_stage].[FactActivity] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[ActivityDueDateSSID] IS NULL


		-----------------------
		-- Exception if [ActivityDueDate] IS NULL -- so with the prior statement this should never update anything
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage= 'ActivityDueDate is null - FA_Trans_Lkup'
		FROM [bi_mktg_stage].[FactActivity] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[ActivityDueDateSSID] IS NULL

		-----------------------
		-- Exception if [ActivityDueDateKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage= 'ActivityDueDateKey is null - FA_Trans_Lkup'
		FROM [bi_mktg_stage].[FactActivity] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[ActivityDueDateKey] IS NULL
				OR STG.[ActivityDueDateKey] = 0)

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
