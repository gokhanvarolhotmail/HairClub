/* CreateDate: 05/03/2010 12:27:05.947 , ModifyDate: 01/06/2021 12:08:46.907 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactLead_LoadInferred_DimCenter]
			   @DataPkgKey					int


AS
-------------------------------------------------------------------------
-- [spHC_FactLead_LoadInferred_DimCenter] is used to load inferred
-- members to the DimCenter table.
--
--
--   exec [bi_mktg_stage].[spHC_FactLead_LoadInferred_DimCenter] -1
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

 	SET @TableName = N'[bi_mktg_dds].[DimCenter]'

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
		SELECT @InitialRowCnt = COUNT(1) FROM [bi_mktg_stage].[synHC_DDS_DimCenter]

		------------------------
		-- Add inferred members
		------------------------
		--???I did not have the DimCenter table attributes at the time I created this proc, so need to update when I get it from Randy
		INSERT INTO [bi_mktg_stage].[synHC_DDS_DimCenter] (
				  [CenterSSID]
				, [RegionKey]
				, [RegionSSID]
				, [TimeZoneKey]
				, [TimeZoneSSID]
				, [CenterTypeKey]
				, [CenterTypeSSID]
				, [DoctorRegionKey]
				, [DoctorRegionSSID]
				, [CenterOwnershipKey]
				, [CenterOwnershipSSID]
				, [CenterDescription]
				, [CenterAddress1]
				, [CenterAddress2]
				, [CenterAddress3]
			    , [CountryRegionDescription]
			    , [CountryRegionDescriptionShort]
			    , [StateProvinceDescription]
			    , [StateProvinceDescriptionShort]
			    , [City]
				, [PostalCode]
				, [CenterPhone1]
				, [CenterPhone1TypeDescription]
				, [CenterPhone1TypeDescriptionShort]
				, [CenterPhone2]
				, [CenterPhone2TypeDescription]
				, [CenterPhone2TypeDescriptionShort]
				, [CenterPhone3]
				, [CenterPhone3TypeDescription]
				, [CenterPhone3TypeDescriptionShort]
				,[RowIsCurrent]
				,[RowStartDate]
				,[RowEndDate]
				,[RowChangeReason]
				,[RowIsInferred]
				,[InsertAuditKey]
				,[UpdateAuditKey]
				)
			SELECT
				  DISTINCT(STG.[CenterSSID])
				, -1
				, -2
				, -1
				, -2
				, -1
				, -2
				, -1
				, -2
				, -1
				, -2
				, 'FactLead'
				, ''
				, ''
				, ''
				, ''
				, ''
				, ''
				, ''
				, ''
				, ''
				, ''
				, ''
				, ''
				, ''
				, ''
				, ''
				, ''
				, ''
				, ''
				, 1 -- [RowIsCurrent]
				, CAST('1753-01-01 00:00:00' AS DateTime) -- [RowStartDate]
				, CAST('9999-12-31 00:00:00' AS DateTime) -- [RowEndDate]
				, 'Inferred Member' -- [RowChangeReason]
				, 1
				, @DataPkgKey
				, -2 -- 'Not Updated Yet'
			FROM [bi_mktg_stage].[FactLead] STG
			WHERE COALESCE(STG.CenterKey, 0) = 0
			AND STG.[DataPkgKey] = @DataPkgKey
			AND STG.[CenterSSID] IS NOT NULL

		SET @InsertInferredRowCnt = @@ROWCOUNT

		---- Determine the number of inserted and updated rows
		SET @InsertRowCnt = @InsertNewRowCnt + @InsertInferredRowCnt + @InsertSCD2RowCnt
		SET @UpdateRowCnt = @UpdateInferredRowCnt + @UpdateSCD1RowCnt + @UpdateSCD2RowCnt


		---- Determine Final Row Cnt
		SELECT @FinalRowCnt = COUNT(1) FROM [bi_mktg_stage].[synHC_DDS_DimCenter]

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