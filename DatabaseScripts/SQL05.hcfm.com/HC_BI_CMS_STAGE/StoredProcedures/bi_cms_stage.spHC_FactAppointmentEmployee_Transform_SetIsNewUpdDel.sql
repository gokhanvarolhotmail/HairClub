/* CreateDate: 06/27/2011 17:22:53.833 , ModifyDate: 07/14/2011 12:34:33.890 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactAppointmentEmployee_Transform_SetIsNewUpdDel]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_FactAppointmentEmployee_Transform_SetIsNewUpdDel] is used to determine
-- the SetIsNewUpdDel
--
--
--   exec [bi_cms_stage].[spHC_FactAppointmentEmployee_Transform_SetIsNewUpdDel] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/22/2011  KMurdoch       Initial Creation
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

 	SET @TableName = N'[bi_cms_dds].[FactAppointmentEmployee]'

 	   -- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY


		-----------------------
		-- Check for new and existing rows
		-----------------------
		UPDATE STG SET
			IsNew = CASE WHEN DW.[AppointmentEmployeeKey] IS NULL
					THEN 1 ELSE 0 END
			,IsUpdate = CASE WHEN DW.[AppointmentEmployeeKey] IS NOT NULL
					THEN 1 ELSE 0 END

		FROM [bi_cms_stage].[FactAppointmentEmployee] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_FactAppointmentEmployee] DW ON
				DW.AppointmentEmployeeSSID = STG.AppointmentEmployeeSSID
		WHERE STG.[DataPkgKey] = @DataPkgKey;


		-----------------------
		-- Check for duplicate records
		-----------------------
		WITH Duplicates  AS
			(SELECT  AppointmentEmployeeSSID
						, IsDuplicate
					  , row_number() OVER ( PARTITION BY AppointmentEmployeeSSID ORDER BY AppointmentEmployeeSSID ) AS RowNum
			   FROM  [bi_cms_stage].[FactAppointmentEmployee] STG
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
		FROM [bi_cms_stage].[FactAppointmentEmployee] STG
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
