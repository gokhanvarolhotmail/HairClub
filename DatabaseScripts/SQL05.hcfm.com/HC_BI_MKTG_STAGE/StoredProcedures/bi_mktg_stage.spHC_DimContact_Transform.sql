/* CreateDate: 05/03/2010 12:26:42.687 , ModifyDate: 12/30/2020 13:19:56.803 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_DimContact_Transform]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimContact_Transform] is used to transform records
--
--
--   exec [bi_mktg_stage].[spHC_DimContact_Transform] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    08/11/2009  RLifke       Initial Creation
--			12/30/2020  KMurdoch     Added Accomodation to DimContact
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

 	SET @TableName = N'[bi_mktg_dds].[DimContact]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY

		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_TransformStart] @DataPkgKey, @TableName

		-----------------------
		--Update Accomodation based on 1st occurence of Accomodation in DimActivityResults
		-----------------------

		SELECT ROW_NUMBER() OVER (PARTITION BY dar.SFDC_LeadID ORDER BY dar.OrigApptDate ASC) AS 'RowID',
			dar.SFDC_LeadID,
			dar.Accomodation,
			dar.OrigApptDate
		INTO #Accom
		FROM HC_BI_MKTG_DDS.bi_mktg_dds.DimActivityResult dar
			INNER JOIN HC_BI_MKTG_STAGE.bi_mktg_stage.DimContact dc
				 ON dc.SFDC_LeadID = dar.SFDC_LeadID
			WHERE dar.Accomodation IS NOT NULL
				AND dc.DataPkgKey = @DataPkgKey


		UPDATE dc
		SET dc.Accomodation = #Accom.Accomodation
		FROM HC_BI_MKTG_STAGE.bi_mktg_stage.DimContact dc
			INNER JOIN #Accom
				ON #Accom.SFDC_LeadID = dc.SFDC_LeadID
					AND #accom.RowID = 1
		WHERE dc.DataPkgKey = @DataPkgKey


		-----------------------
		-- Set the ISNew and SCD fields
		-----------------------
		EXEC	@return_value = [bi_mktg_stage].[spHC_DimContact_Transform_SetIsNewSCD] @DataPkgKey


		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_TransformStop] @DataPkgKey, @TableName

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
