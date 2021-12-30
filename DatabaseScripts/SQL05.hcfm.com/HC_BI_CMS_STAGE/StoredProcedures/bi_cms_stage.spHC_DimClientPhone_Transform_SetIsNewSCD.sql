/* CreateDate: 07/07/2017 11:47:27.607 , ModifyDate: 07/07/2017 11:47:27.607 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimClientPhone_Transform_SetIsNewSCD]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimClientPhone_Transform_SetIsNewSCD] is used to determine which records
-- are NEW, which records are SCD Type 1 or Type 2
--
--
--   exec [bi_cms_stage].[spHC_DimClientPhone_Transform_SetIsNewSCD] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    03/16/2009  RLifke       Initial Creation
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

 	SET @TableName = N'[bi_cms_dds].[DimClientPhone]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY

		-----------------------
		-- Check for new rows
		-----------------------
		UPDATE STG SET
		     [ClientPhoneKey] = DW.[ClientPhoneKey]
			,IsNew = CASE WHEN DW.[ClientPhoneKey] IS NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimClientPhone] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimClientPhone] DW ON
				DW.[ClientPhoneSSID] = STG.[ClientPhoneSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for Inferred Members
		-----------------------
		UPDATE STG SET
			IsInferredMember = CASE WHEN DW.[ClientPhoneKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimClientPhone] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimClientPhone] DW ON
				 STG.[ClientPhoneSSID] = DW.[ClientPhoneSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey



		-----------------------
		-- Check for SCD Type 1
		-----------------------
		UPDATE STG SET
			IsType1 = CASE WHEN DW.[ClientPhoneKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimClientPhone] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimClientPhone] DW ON
				 STG.[ClientPhoneSSID] = DW.[ClientPhoneSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE   1=1   -- 1=0 No Fields Change to 1=1 when there are SCD Type 1 fields
			AND ( 	COALESCE(STG.[ClientKey],0) <> COALESCE(DW.[ClientKey],0)
						OR COALESCE(STG.[PhoneTypeDescription],'') <> COALESCE(DW.[PhoneTypeDescription],'')
						OR COALESCE(STG.[PhoneNumber],'') <> COALESCE(DW.[PhoneNumber],'')
						OR COALESCE(STG.[CanConfirmAppointmentByCall],-1) <> COALESCE(DW.[CanConfirmAppointmentByCall],-1)
						OR COALESCE(STG.[CanConfirmAppointmentByText],-1) <> COALESCE(DW.[CanConfirmAppointmentByText],-1)
						OR COALESCE(STG.[CanContactForPromotionsByCall],-1) <> COALESCE(DW.[CanContactForPromotionsByCall],-1)
						OR COALESCE(STG.[CanContactForPromotionsByText],-1) <> COALESCE(DW.[CanContactForPromotionsByText],-1)
						OR COALESCE(STG.[ClientPhoneSortOrder],0) <> COALESCE(DW.[ClientPhoneSortOrder],0)
						OR COALESCE(STG.[LastUpdate],convert(datetime,0)) <> COALESCE(DW.[LastUpdate],convert(datetime,0))
						OR COALESCE(STG.[LastUpdateUser],'') <> COALESCE(DW.[LastUpdateUser],'')
				)
		AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for SCD Type 2
		-----------------------
		UPDATE STG SET
			IsType2 = CASE WHEN DW.[ClientPhoneKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimClientPhone] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimClientPhone] DW ON
				 STG.[ClientPhoneSSID] = DW.[ClientPhoneSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		AND STG.[DataPkgKey] = @DataPkgKey;


		-----------------------
		-- Check for duplicate records
		-----------------------
		WITH Duplicates  AS
			(SELECT  ClientPhoneSSID
						, IsDuplicate
					  , row_number() OVER ( PARTITION BY ClientPhoneSSID ORDER BY ClientPhoneSSID ) AS RowNum
			   FROM  [bi_cms_stage].[DimClientPhone] STG
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
		FROM [bi_cms_stage].[DimClientPhone] STG
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
