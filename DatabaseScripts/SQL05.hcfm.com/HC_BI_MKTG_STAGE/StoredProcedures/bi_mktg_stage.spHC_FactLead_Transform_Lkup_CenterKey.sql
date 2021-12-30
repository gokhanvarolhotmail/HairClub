/* CreateDate: 05/03/2010 12:27:06.127 , ModifyDate: 01/06/2021 12:58:13.610 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactLead_Transform_Lkup_CenterKey]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_FactLead_Transform_Lkup_CenterKey] is used to determine
-- the CenterKey foreign key values in the FactLead table using DimCenter.
--
--
--   exec [bi_mktg_stage].[spHC_FactLead_Transform_Lkup_CenterKey] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    09/21/2009  RLifke       Initial Creation
--			10/26/2011	MBurrell	 Added exception message
--			01/20/2018	KMurdoch	 Added derivation of center number.
--			06/24/2020  KMurdoch     Added exclusion of surgery centers
--			09/16/2020  KMurdoch     Added logic to use reporting centers and excluded Surgery Centers.
--			09/22/2020  KMurdoch     Removed logic to exclude surgery center
--			09/24/2020  KMurdoch     Added second Update query for centers where number is reused
--			09/24/2020  KMurdoch     Removed previous logic - it created multiple inferred centers.
--			09/24/2020  KMurdoch     Added logic back to exclude surgery centers
--			01/06/2021  KMurdoch     Added logic to check for Center Active and changed Coalesce to look at both joins
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

 	SET @TableName = N'[bi_mktg_dds].[DimCenter]'

 	   -- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY


		---------------------------
		------ Get the Center for the Contact
		---------------------------
		----UPDATE STG SET
		----     [CenterSSID] = COALESCE(DW.[CenterSSID], '-2')
		----FROM [bi_mktg_stage].[FactLead] STG
		----LEFT OUTER JOIN
		----	(SELECT CenterSSID  AS CenterSSID
		----				, ContactSSID AS ContactSSID
		----				,[RowIsCurrent] AS [RowIsCurrent]
		----		FROM [bi_mktg_stage].[synHC_DDS_DimActivityResult] WITH(NOLOCK)
		----	) AS DW
		----	ON 	DW.[ContactSSID] = STG.[ContactSSID]
		----		AND DW.[RowIsCurrent] = 1
		----WHERE STG.[DataPkgKey] = @DataPkgKey



		-----------------------
		-- Found an instance where the center number was not numeric
		-- so fix this first
		-----------------------
		UPDATE STG SET
		       [CenterKey]  = -1
		     , [CenterSSID] = '-2'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (ISNUMERIC(STG.[CenterSSID]) <> 1)



		------------------------
		-- There might be some other load that just added them
		-- Update [CenterKey] Keys in STG -
		------------------------
		UPDATE STG SET
		     [CenterKey] = COALESCE(DW_rc.[CenterKey], DW_c.[CenterKey])	--01/06/21
		FROM [bi_mktg_stage].[FactLead] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimCenter] DW_c
			ON DW_c.[CenterNumber] = STG.[CenterSSID]
				AND DW_c.[RowIsCurrent] = 1
				AND DW_c.CenterSSID NOT BETWEEN 300 AND 399
				AND dw_c.Active = 'Y'										--01/06/21
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimCenter] DW_rc
			ON DW_rc.[CenterSSID] = DW_c.[ReportingCenterSSID]
				AND DW_rc.Active = 'Y'
				AND DW_rc.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[CenterKey], 0) = 0
			AND STG.[CenterSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey



		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_mktg_stage].[spHC_FactLead_LoadInferred_DimCenter] @DataPkgKey


		-- Update Center Keys in STG
		UPDATE STG SET
		     [CenterKey] = COALESCE(DW_rc.[CenterKey], 0)
		FROM [bi_mktg_stage].[FactLead] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimCenter] DW_c
			ON DW_c.[CenterNumber] = STG.[CenterSSID]
				AND DW_c.[RowIsCurrent] = 1
				--AND DW_c.CenterSSID NOT BETWEEN 300 AND 399
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimCenter] DW_rc
			ON DW_rc.[CenterSSID] = DW_c.[ReportingCenterSSID]
				AND DW_rc.Active = 'Y'
				AND DW_rc.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[CenterKey], 0) = 0
			AND STG.[CenterSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		---------------------------
		------ Fix [CenterKey]
		---------------------------
		----UPDATE STG SET
		----     [CenterKey] = -1
		----FROM [bi_mktg_stage].[FactLead] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND STG.[CenterKey] IS NULL

		---------------------------
		------ Fix [CenterSSID]
		---------------------------
		----UPDATE STG SET
		----       [CenterKey]  = -1
		----     , [CenterSSID] = '-2'
		----FROM [bi_mktg_stage].[FactLead] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND (STG.[CenterSSID] IS NULL )

		-----------------------
		-- Exception if [CenterSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'CenterSSID IS NULL - FL_Trans_LKup'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[CenterSSID] IS NULL


		-----------------------
		-- Exception if [CenterKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'CenterKey IS NULL - FL_Trans_LKup'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[CenterKey] IS NULL
				OR STG.[CenterKey] = 0)

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
