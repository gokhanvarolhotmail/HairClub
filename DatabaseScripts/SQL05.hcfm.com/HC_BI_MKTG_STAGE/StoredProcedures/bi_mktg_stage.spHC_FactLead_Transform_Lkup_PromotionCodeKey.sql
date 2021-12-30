/* CreateDate: 02/03/2011 17:18:17.587 , ModifyDate: 10/26/2011 10:49:12.537 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_FactLead_Transform_Lkup_PromotionCodeKey]
			   @DataPkgKey					int


AS
-------------------------------------------------------------------------
-- [sspHC_FactLead_Transform_Lkup_PromotionCodeKey] is used to determine
-- the PromotionCodeKey foreign key values in the FactLead table using DimPromotionCode.
--
--
--   exec [bi_mktg_stage].[spHC_FactLead_Transform_Lkup_PromotionCodeKey] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    02/03/2011          Initial Creation
--			10/26/2011	MBurrell	 Added exception message

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

 	SET @TableName = N'[bi_mktg_dds].[DimPromotionCode]'

 	   -- Put parameters in name value list to aid in reporting
	EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@DataPkgKey'
				, @DataPkgKey


	BEGIN TRY

		UPDATE STG SET
		       [PromotionCodeKey]  = -1
		     , [PromotionCodeSSID] = '-2'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (ISNULL(STG.[PromotionCodeSSID],'0') = '0'
				OR STG.[PromotionCodeSSID] = '')


		---------------------------
		------ Get the PromotionCode for the Contact
		---------------------------
		----UPDATE STG SET
		----     [PromotionCodeSSID] = COALESCE(DW.[PromotionCodeSSID], '-2')
		----FROM [bi_mktg_stage].[FactLead] STG
		----LEFT OUTER JOIN
		----	(SELECT PromotionCodeCode  AS PromotionCodeSSID
		----				, ContactSSID AS ContactSSID
		----				, [RowIsCurrent] AS [RowIsCurrent]
		----				, [PrimaryFlag] AS [PrimaryFlag]
		----		FROM [bi_mktg_stage].[synHC_DDS_DimContactPromotionCode] WITH(NOLOCK)
		----	) AS DW
		----	ON 	DW.[ContactSSID] = STG.[ContactSSID]
		----		AND DW.[RowIsCurrent] = 1
		----WHERE STG.[DataPkgKey] = @DataPkgKey




		------------------------
		-- There might be some other load that just added them
		-- Update [PromotionCodeKey] Keys in STG
		------------------------
		UPDATE STG SET
		     [PromotionCodeKey] = COALESCE(DW.[PromotionCodeKey], 0)
		FROM [bi_mktg_stage].[FactLead] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimPromotionCode] DW ON
				DW.[PromotionCodeSSID] = STG.[PromotionCodeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[PromotionCodeKey], 0) = 0
			AND STG.[PromotionCodeSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Load Inferred Members
		-----------------------
		EXEC	@return_value = [bi_mktg_stage].[spHC_FactLead_LoadInferred_DimPromotionCode] @DataPkgKey


		-- Update Center Keys in STG
		UPDATE STG SET
		     [PromotionCodeKey] = COALESCE(DW.[PromotionCodeKey], 0)
		FROM [bi_mktg_stage].[FactLead] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimPromotionCode] DW ON
				DW.[PromotionCodeSSID] = STG.[PromotionCodeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE COALESCE(STG.[PromotionCodeKey], 0) = 0
			AND STG.[PromotionCodeSSID] IS NOT NULL
			AND STG.[DataPkgKey] = @DataPkgKey


		---------------------------
		------ Fix [PromotionCodeKey]
		---------------------------
		----UPDATE STG SET
		----     [PromotionCodeKey] = -1
		----FROM [bi_mktg_stage].[FactLead] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND STG.[PromotionCodeKey] IS NULL

		---------------------------
		------ Fix [PromotionCodeSSID]
		---------------------------
		----UPDATE STG SET
		----       [PromotionCodeKey]  = -1
		----     , [PromotionCodeSSID] = '-2'
		----FROM [bi_mktg_stage].[FactLead] STG
		----WHERE STG.[DataPkgKey] = @DataPkgKey
		----	AND (STG.[PromotionCodeSSID] IS NULL )

		-----------------------
		-- Exception if [PromotionCodeSSID] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'PromotionCodeSSID IS NULL - FL_Trans_LKup'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.[PromotionCodeSSID] IS NULL


		-----------------------
		-- Exception if [PromotionCodeKey] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1
		     ,	ExceptionMessage = 'PromotionCodeKey IS NULL - FL_Trans_LKup'
		FROM [bi_mktg_stage].[FactLead] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (STG.[PromotionCodeKey] IS NULL
				OR STG.[PromotionCodeKey] = 0)

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
