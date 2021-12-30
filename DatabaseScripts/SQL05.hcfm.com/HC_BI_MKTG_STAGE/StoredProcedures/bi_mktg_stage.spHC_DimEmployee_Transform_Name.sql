/* CreateDate: 02/17/2011 04:08:32.373 , ModifyDate: 02/23/2011 09:42:05.607 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_DimEmployee_Transform_Name]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_DimEmployee_Transform_Name] is used to set the First and Last
-- Name in the event that these are loaded as blank or null values.
-- We expect that these employees would eventually be updated to actual
-- names at some point.
--
--
--   exec [bi_mktg_stage].[spHC_DimEmployee_Transform_Name] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    02/17/2009  CFleming       Initial Creation
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

 	SET @TableName = N'[bi_mktg_dds].[DimEmployee]'

 	   -- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY

		-----------------------
		-- Update EmployeeLastName based on value
		-----------------------
		UPDATE STG SET
				STG.[EmployeeLastName]	 = CASE
										WHEN EmployeeLastName IS NULL THEN '(' + EmployeeSSID + ')' + 'Not set'
										WHEN Ltrim(Rtrim(EmployeeLastName)) = '' THEN '(' + EmployeeSSID + ')' + 'Not set'
										ELSE Ltrim(Rtrim(EmployeeLastName))
									END
		FROM [bi_mktg_stage].[DimEmployee]  STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
		AND  Ltrim(Rtrim(EmployeeLastName)) = ''


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
