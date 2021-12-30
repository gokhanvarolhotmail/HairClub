/* CreateDate: 06/27/2011 17:23:08.577 , ModifyDate: 12/10/2012 14:07:11.613 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactAppointmentDetail_LoadInferred_DimAppointment]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_FactAppointmentDetail_LoadInferred_DimAppointment] is used to load inferred
-- members to the DimAppointment table.
--
--
--   exec [bi_cms_stage].[spHC_FactAppointmentDetail_LoadInferred_DimAppointment] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    09/21/2009  RLifke       Initial Creation
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
			   ,@IgnoreRowCnt		int
			   ,@InsertRowCnt		int
			   ,@UpdateRowCnt		int
			   ,@ExceptionRowCnt	int
			   ,@ExtractRowCnt		int
			   ,@InsertNewRowCnt	int
			   ,@InsertInferredRowCnt int
			   ,@InsertSCD2RowCnt	int
			   ,@UpdateInferredRowCnt int
			   ,@UpdateSCD1RowCnt	int
			   ,@UpdateSCD2RowCnt	int
			   ,@InitialRowCnt		int
			   ,@FinalRowCnt		int

 	SET @TableName = N'[bi_cms_dds].[DimAppointment]'

 	-- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY

		SET @IgnoreRowCnt = 0
		SET @InsertRowCnt = 0
		SET @UpdateRowCnt = 0
		SET @ExceptionRowCnt = 0
		SET @ExtractRowCnt = 0
		SET @InsertNewRowCnt = 0
		SET @InsertInferredRowCnt = 0
		SET @InsertSCD2RowCnt = 0
		SET @UpdateInferredRowCnt = 0
		SET @UpdateSCD1RowCnt = 0
		SET @UpdateSCD2RowCnt = 0
		SET @InitialRowCnt = 0
		SET @FinalRowCnt = 0

		---- Determine Initial Row Cnt
		SELECT @InitialRowCnt = COUNT(1) FROM [bi_cms_stage].[synHC_DDS_DimAppointment]

		------------------------
		-- Add inferred members
		------------------------
		INSERT INTO [bi_cms_stage].[synHC_DDS_DimAppointment] (
					  [AppointmentSSID]
					   ,[CenterKey]
					   ,[CenterSSID]
					   ,[ClientHomeCenterKey]
					   ,[ClientHomeCenterSSID]
					   ,[ClientKey]
					   ,[ClientSSID]
					   ,[ClientMembershipKey]
					   ,[ClientMembershipSSID]
					   ,[AppointmentDate]
					   ,[ResourceSSID]
					   ,[ResourceDescription]
					   ,[ConfirmationTypeSSID]
					   ,[ConfirmationTypeDescription]
					   ,[AppointmentTypeSSID]
					   ,[AppointmentTypeDescription]
					   ,[AppointmentStartTime]
					   ,[AppointmentEndTime]
					   ,[CheckInTime]
					   ,[CheckOutTime]
					   ,[AppointmentSubject]
					   ,[AppointmentStatusSSID]
					   ,[AppointmentStatusDescription]
					   ,[OnContactActivitySSID]
					   ,[OnContactContactSSID]
					   ,[CanPrinTCommentFlag]
					   ,[IsNonAppointmentFlag]
					   ,[IsDeletedFlag]
					   ,[RowIsCurrent]
					   ,[RowStartDate]
					   ,[RowEndDate]
					   ,[RowChangeReason]
					   ,[RowIsInferred]
					   ,[InsertAuditKey]
					   ,[UpdateAuditKey]
					)
			SELECT DISTINCT
				  STG.[AppointmentSSID]
				, -1 --[CenterKey]
				, -1 --[CenterSSID]
				, -1 --[ClientHomeCenterKey]
				, -1 --[ClientHomeCenterSSID]
				, -1 --[ClientKey]
				, CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002') --[ClientSSID]
				, -1 --[ClientMembershipKey]
				, CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002') --[ClientMembershipSSID]
				, '12/31/9999' --[AppointmentDate]
				, -1 --[ResourceSSID]
				, '' --[ResourceDescription]
				, -1 --[ConfirmationTypeSSID]
				, '' --[ConfirmationTypeDescription]
				, -1 --[AppointmentTypeSSID]
				, '' --[AppointmentTypeDescription]
				, CAST('1753-01-01 00:00:00' AS Time) --[AppointmentStartTime]
				, CAST('1753-01-01 00:00:00' AS Time) --[AppointmentEndTime]
				, CAST('1753-01-01 00:00:00' AS DateTime) --[CheckInTime]
				, CAST('1753-01-01 00:00:00' AS DateTime) --[CheckOutTime]
				, '' --[AppointmentSubject]
				, -1 --[AppointmentStatusSSID]
				, '' --[AppointmentStatusDescription]
				, '' --[OnContactActivitySSID]
				, '' --[OnContactContactSSID]
				, 0 --[CanPrinTCommentFlag]
				, 1 --[IsNonAppointmentFlag]
				, 1 --[IsDeletedFlag]
				, 1 -- [RowIsCurrent]
				, CAST('1753-01-01 00:00:00' AS DateTime) -- [RowStartDate]
				, CAST('9999-12-31 00:00:00' AS DateTime) -- [RowEndDate]
				, 'Inferred Member' -- [RowChangeReason]
				, 1
				, @DataPkgKey
				, -2 -- 'Not Updated Yet'
			FROM [bi_cms_stage].[FactAppointmentDetail] STG
			WHERE COALESCE(STG.AppointmentKey, 0) = 0
			AND STG.[DataPkgKey] = @DataPkgKey
			AND STG.[AppointmentSSID] IS NOT NULL


		SET @InsertInferredRowCnt = @@ROWCOUNT

		---- Determine the number of inserted and updated rows
		SET @InsertRowCnt = @InsertNewRowCnt + @InsertInferredRowCnt + @InsertSCD2RowCnt
		SET @UpdateRowCnt = @UpdateInferredRowCnt + @UpdateSCD1RowCnt + @UpdateSCD2RowCnt


		---- Determine Final Row Cnt
		SELECT @FinalRowCnt = COUNT(1) FROM [bi_cms_stage].[synHC_DDS_DimAppointment]

		IF @InsertInferredRowCnt > 0
		BEGIN
			-- Data pkg auditing.  Once we know inferred members were created, create an audit trail for this fact
			EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_LoadInferredMembersStart] @DataPkgKey, @TableName, @DataPkgDetailKey OUTPUT

			EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_LoadInferredMembersStop] @DataPkgKey, @TableName
						, @DataPkgDetailKey, @IgnoreRowCnt, @InsertRowCnt, @UpdateRowCnt, @ExceptionRowCnt, @ExtractRowCnt
						, @InsertNewRowCnt, @InsertInferredRowCnt, @InsertSCD2RowCnt
						, @UpdateInferredRowCnt, @UpdateSCD1RowCnt, @UpdateSCD2RowCnt
						, @InitialRowCnt, @FinalRowCnt
		END

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
