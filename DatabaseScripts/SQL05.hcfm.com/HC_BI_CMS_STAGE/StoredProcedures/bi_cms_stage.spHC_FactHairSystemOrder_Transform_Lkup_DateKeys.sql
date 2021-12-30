/* CreateDate: 06/27/2011 17:22:53.580 , ModifyDate: 10/26/2011 11:16:03.757 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_FactHairSystemOrder_Transform_Lkup_DateKeys]
			   @DataPkgKey					int

AS
-------------------------------------------------------------------------
-- [spHC_FactHairSystemOrder_Transform_Lkup_eadCreationDateKey] is used to determine
-- which records have late arriving dimensions and adds them
--
--
--   exec [bi_cms_stage].[spHC_FactHairSystemOrder_Transform_Lkup_DateKeys] -1
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    09/21/2009  RLifke       Initial Creation
--			10/26/2011  KMurdoch     Added Exception Message
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
		-- Update Date Keys in STG
		------------------------
		UPDATE STG SET
		     HairSystemOrderDateKey = COALESCE(DW.[DateKey], 0)
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimDate] DW  WITH (NOLOCK)
			ON DW.[ISODate] = CONVERT(char(8),STG.HairSystemOrderDate,112)
		WHERE COALESCE(STG.HairSystemOrderDateKey, 0) = 0
			AND STG.[DataPkgKey] = @DataPkgKey

		UPDATE STG SET
		     HairSystemDueDateKey = COALESCE(DW.[DateKey], -1)
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimDate] DW  WITH (NOLOCK)
			ON DW.[ISODate] = CONVERT(char(8),STG.HairSystemDueDate,112)
		WHERE COALESCE(STG.HairSystemDueDateKey, 0) = 0
			AND STG.[DataPkgKey] = @DataPkgKey

		UPDATE STG SET
		     HairSystemAllocationDateKey = COALESCE(DW.[DateKey], -1)
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimDate] DW  WITH (NOLOCK)
			ON DW.[ISODate] = CONVERT(char(8),STG.HairSystemAllocationDate,112)
		WHERE COALESCE(STG.HairSystemAllocationDateKey, 0) = 0
			AND STG.[DataPkgKey] = @DataPkgKey

		UPDATE STG SET
		     HairSystemReceivedDateKey = COALESCE(DW.[DateKey], -1)
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimDate] DW  WITH (NOLOCK)
			ON DW.[ISODate] = CONVERT(char(8),STG.HairSystemReceivedDate,112)
		WHERE COALESCE(STG.HairSystemReceivedDateKey, 0) = 0
			AND STG.[DataPkgKey] = @DataPkgKey

		UPDATE STG SET
		     HairSystemShippedDateKey = COALESCE(DW.[DateKey], -1)
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimDate] DW  WITH (NOLOCK)
			ON DW.[ISODate] = CONVERT(char(8),STG.HairSystemShippedDate,112)
		WHERE COALESCE(STG.HairSystemShippedDateKey, 0) = 0
			AND STG.[DataPkgKey] = @DataPkgKey

		UPDATE STG SET
		     HairSystemAppliedDateKey = COALESCE(DW.[DateKey], -1)
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimDate] DW  WITH (NOLOCK)
			ON DW.[ISODate] = CONVERT(char(8),STG.HairSystemAppliedDate,112)
		WHERE COALESCE(STG.HairSystemAppliedDateKey, 0) = 0
			AND STG.[DataPkgKey] = @DataPkgKey

		----------------------------------------------------------------------
		-- DO NOT ADD Inferred Members  use the DimDate_Populate SP
		-- to add dates to the DimDate table
		----------------------------------------------------------------------






		-----------------------
		-- Exception if [OrderDate] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'OrderDate is null - FHSO_Trans_Lkup'
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND STG.HairSystemOrderDate IS NULL


		-----------------------
		-- Exception if [DateKeys] IS NULL
		-----------------------
		UPDATE STG SET
		     IsException = 1, ExceptionMessage = 'DateKeys are null - FHSO_Trans_Lkup'
		FROM [bi_cms_stage].[FactHairSystemOrder] STG
		WHERE STG.[DataPkgKey] = @DataPkgKey
			AND (ISNULL(STG.HairSystemAllocationDateKey,0) = 0
				OR ISNULL(STG.HairSystemAppliedDateKey,0) = 0
				OR ISNULL(STG.HairSystemDueDateKey,0) = 0
				OR ISNULL(STG.HairSystemOrderDateKey,0) = 0
				OR ISNULL(STG.HairSystemReceivedDateKey,0) = 0
				OR ISNULL(STG.HairSystemShippedDateKey,0) = 0 )



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
