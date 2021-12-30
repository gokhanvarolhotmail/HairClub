/* CreateDate: 05/03/2010 12:27:06.287 , ModifyDate: 09/16/2020 18:32:14.560 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactLead_Transform_Lkup_SourceKey]
			   @DataPkgKey					int


AS
-------------------------------------------------------------------------
-- [sspHC_FactLead_Transform_Lkup_SourceKey] is used to determine
-- the SourceKey foreign key values in the FactLead table using DimSource.
--
--
--   exec [bi_mktg_stage].[spHC_FactLead_Transform_Lkup_SourceKey] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    09/21/2009  RLifke       Initial Creation
--			10/26/2011	MBurrell	 Added exception message
--			08/24/2020  KMurdoch     Added Recent Source SSID lookup
--			09/16/2020  KMurdoch     Changed the coalesce on the recentsourcekey to be a -1 instead of 0
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

 	SET @TableName = N'[bi_mktg_dds].[DimSource]'

 	   -- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY

		UPDATE STG SET
		       [SourceKey]  = -1
		     , [SourceSSID] = '-2'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[SourceSSID] = '0'
				OR STG.[SourceSSID] = '')

		UPDATE STG SET
		       [STG].[RecentSourceKey]  = -1
		     , [STG].[RecentSourceSSID] = '-2'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[RecentSourceSSID] = '0'
				OR STG.[RecentSourceSSID] = '')


		---------------------------
		------ Get the Source for the Contact
		---------------------------
		----UPDATE STG SET
		----     [SourceSSID] = COALESCE(DW.[SourceSSID], '-2')
		----FROM [bi_mktg_stage].[FactLead] STG
		----LEFT OUTER JOIN
		----	(SELECT SourceCode  AS SourceSSID
		----				, ContactSSID AS ContactSSID
		----				, [RowIsCurrent] AS [RowIsCurrent]
		----				, [PrimaryFlag] AS [PrimaryFlag]
		----		FROM [bi_mktg_stage].[synHC_DDS_DimContactSource] WITH(NOLOCK)
		----	) AS DW
		----	ON 	DW.[ContactSSID] = STG.[ContactSSID]
		----		AND DW.[RowIsCurrent] = 1
		----WHERE STG.[DataPkgKey] = @DataPkgKey




		------------------------
		-- There might be some other load that just added them
		-- Update [SourceKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [SourceKey] = COALESCE(DW.[SourceKey], 0)
		FROM [bi_mktg_stage].[FactLead] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimSource] DW ON
				DW.[SourceSSID] = STG.[SourceSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[SourceSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey
			--AND COALESCE(STG.[SourceKey], 0) = 0

		UPDATE STG SET
		     [RecentSourceKey] = COALESCE(DW.[SourceKey], -1)
		FROM [bi_mktg_stage].[FactLead] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimSource] DW ON
				DW.[SourceSSID] = STG.[RecentSourceSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[RecentSourceSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey
			--AND COALESCE(STG.[SourceKey], 0) = 0
		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_mktg_stage].[spHC_FactLead_LoadInferred_DimSource] @DataPkgKey


		---- Update Center Keys in STG
		--UPDATE STG SET
		--     [SourceKey] = COALESCE(DW.[SourceKey], 0)
		--FROM [bi_mktg_stage].[FactLead] STG
		--LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimSource] DW ON
		--		DW.[SourceSSID] = STG.[SourceSSID]
		--	AND DW.[RowIsCurrent] = 1
		--WHERE COALESCE(STG.[SourceKey], 0) = 0
		--	AND STG.[SourceSSID] IS NOT NULL
		--	AND STG.[DataPkgKey] = @DataPkgKey


		---------------------------
		------ Fix [SourceKey]
		---------------------------
		----UPDATE STG SET
		----     [SourceKey] = -1
		----FROM [bi_mktg_stage].[FactLead] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND STG.[SourceKey] IS NULL

		---------------------------
		------ Fix [SourceSSID]
		---------------------------
		----UPDATE STG SET
		----       [SourceKey]  = -1
		----     , [SourceSSID] = '-2'
		----FROM [bi_mktg_stage].[FactLead] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND (STG.[SourceSSID] IS NULL )

		-----------------------
		-- Exception if [SourceSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'SourceSSID IS NULL - FL_Trans_LKup'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[SourceSSID] IS NULL


		-----------------------
		-- Exception if [SourceKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'SourceKey IS NULL - FL_Trans_LKup'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[SourceKey] IS NULL
				OR STG.[SourceKey] = 0)

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
