/* CreateDate: 06/27/2011 17:23:32.363 , ModifyDate: 12/10/2012 14:16:18.500 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactSurgeryCloseoutEmployee_LoadInferred_DimEmployee]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_FactSurgeryCloseoutEmployee_LoadInferred_DimEmployee] is used to load inferred
-- members to the DimEmployee table.
--
--
--   exec [bi_cms_stage].[spHC_FactSurgeryCloseoutEmployee_LoadInferred_DimEmployee] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/22/2011  KMurdoch     Initial Creation
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

 	SET @TableName = N'[bi_cms_dds].[DimEmployee]'

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
		SELECT @InitialRowCnt = COUNT(1) FROM [bi_cms_stage].[synHC_DDS_DimEmployee]

		------------------------
		-- Add inferred members
		------------------------
		INSERT INTO [bi_cms_stage].[synHC_DDS_DimEmployee] (
					  [EmployeeSSID]
					, [EmployeeFirstName]
					, [EmployeeLastName]
					, [EmployeeInitials]
					, [SalutationSSID]
					, [EmployeeSalutationDescription]
					, [EmployeeSalutationDescriptionShort]
					, [EmployeeAddress1]
					, [EmployeeAddress2]
					, [EmployeeAddress3]
				    , [CountryRegionDescription]
				    , [CountryRegionDescriptionShort]
				    , [StateProvinceDescription]
				    , [StateProvinceDescriptionShort]
				    , [City]
					, [PostalCode]
					, [UserLogin]
					, [EmployeePhoneMain]
					, [EmployeePhoneAlternate]
					, [EmployeeEmergencyContact]
					, [EmployeePayrollNumber]
					, [EmployeeTimeClockNumber]
					, [RowIsCurrent]
					, [RowStartDate]
					, [RowEndDate]
					, [RowChangeReason]
					, [RowIsInferred]
					, [InsertAuditKey]
					, [UpdateAuditKey]
					)
			SELECT DISTINCT
				  STG.[EmployeeSSID]
				, 'Unknown'
				, 'Unknown'
				, ''
				, -1
				, 'Unknown'
				, 'Unknown'
				, 'Unknown'
				, 'Unknown'
				, 'Unknown'
				, ''
				, ''
				, ''
				, ''
				, ''

				, 'Unknown'
				, 'Unknown'
				, 'Unknown'
				, 'Unknown'
				, 'Unknown'
				, 'Unknown'
				, 'Unknown'

				, 1 -- [RowIsCurrent]
				, CAST('1753-01-01 00:00:00' AS DateTime) -- [RowStartDate]
				, CAST('9999-12-31 00:00:00' AS DateTime) -- [RowEndDate]
				, 'Inferred Member' -- [RowChangeReason]
				, 1
				, @DataPkgKey
				, -2 -- 'Not Updated Yet'
			FROM [bi_cms_stage].[FactSurgeryCloseoutEmployee] STG
			WHERE COALESCE(STG.EmployeeKey, 0) = 0
			AND STG.[DataPkgKey] = @DataPkgKey
			AND STG.[EmployeeSSID] IS NOT NULL


		SET @InsertInferredRowCnt = @@ROWCOUNT

		---- Determine the number of inserted and updated rows
		SET @InsertRowCnt = @InsertNewRowCnt + @InsertInferredRowCnt + @InsertSCD2RowCnt
		SET @UpdateRowCnt = @UpdateInferredRowCnt + @UpdateSCD1RowCnt + @UpdateSCD2RowCnt


		---- Determine Final Row Cnt
		SELECT @FinalRowCnt = COUNT(1) FROM [bi_cms_stage].[synHC_DDS_DimEmployee]

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
