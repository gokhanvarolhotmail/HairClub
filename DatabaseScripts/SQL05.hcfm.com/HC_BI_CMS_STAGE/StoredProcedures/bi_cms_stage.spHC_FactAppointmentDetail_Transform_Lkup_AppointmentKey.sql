/* CreateDate: 06/27/2011 17:23:47.803 , ModifyDate: 10/26/2011 11:10:01.610 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactAppointmentDetail_Transform_Lkup_AppointmentKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [sspHC_FactAppointmentDetail_Transform_Lkup_AppointmentKey] is used to determine
-- the AppointmentKey foreign key values in the FactAppointmentDetail table using DimAppointment.
--
--
--   exec [bi_cms_stage].[spHC_FactAppointmentDetail_Transform_Lkup_AppointmentKey] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    09/21/2009  RLifke       Initial Creation
--			10/26/2011  KMurdoch     Added Exception message
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
		-- Update [AppointmentKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [AppointmentKey] = COALESCE(DW.[AppointmentKey], 0)
		FROM [bi_cms_stage].[FactAppointmentDetail] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimAppointment] DW  WITH (NOLOCK)
			ON DW.[AppointmentSSID] = STG.[AppointmentSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[AppointmentKey], 0) = 0
			AND STG.[AppointmentSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_cms_stage].[spHC_FactAppointmentDetail_LoadInferred_DimAppointment] @DataPkgKey


		-----------------------
		-- Update Appointment Keys in STG
		-----------------------
		UPDATE STG SET
		     [AppointmentKey] = COALESCE(DW.[AppointmentKey], 0)
		FROM [bi_cms_stage].[FactAppointmentDetail] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimAppointment] DW  WITH (NOLOCK)
			ON DW.[AppointmentSSID] = STG.[AppointmentSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[AppointmentKey], 0) = 0
			AND STG.[AppointmentSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		---------------------------
		------ Fix [AppointmentKey]
		---------------------------
		----UPDATE STG SET
		----     [AppointmentKey] = -1
		----FROM [bi_cms_stage].[FactAppointmentDetail] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND STG.[AppointmentKey] IS NULL

		---------------------------
		------ Fix [AppointmentSSID]
		---------------------------
		----UPDATE STG SET
		----     [AppointmentKey] = -1
		----     , [AppointmentSSID] = -2
		----FROM [bi_cms_stage].[FactAppointmentDetail] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND (STG.[AppointmentSSID] IS NULL )

		-----------------------
		-- Exception if [AppointmentSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'AppointmentSSID is null - FApptDet_Trans_Lkup'
		FROM [bi_cms_stage].[FactAppointmentDetail] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[AppointmentSSID] IS NULL


		-----------------------
		-- Exception if [AppointmentKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'AppointmentSSID is null - FApptDet_Trans_Lkup'
		FROM [bi_cms_stage].[FactAppointmentDetail] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[AppointmentKey] IS NULL
				OR STG.[AppointmentKey] = 0)


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
