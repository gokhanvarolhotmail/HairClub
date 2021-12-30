/* CreateDate: 05/03/2010 12:20:12.080 , ModifyDate: 05/03/2010 12:20:12.080 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimSalesOrderTender_Transform_SetIsNewSCD]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimSalesOrderTender_Transform_SetIsNewSCD] is used to determine which records
-- are NEW, which records are SCD Type 1 or Type 2
--
--
--   exec [bi_cms_stage].[spHC_DimSalesOrderTender_Transform_SetIsNewSCD] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/01/2009  RLifke       Initial Creation
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

 	SET @TableName = N'[bi_cms_dds].[DimSalesOrderTender]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY

		-----------------------
		-- Check for new rows
		-----------------------
		UPDATE STG SET
		     [SalesOrderTenderKey] = DW.[SalesOrderTenderKey]
			,IsNew = CASE WHEN DW.[SalesOrderTenderKey] IS NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimSalesOrderTender] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimSalesOrderTender] DW ON
				DW.[SalesOrderTenderSSID] = STG.[SalesOrderTenderSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for Inferred Members
		-----------------------
		UPDATE STG SET
			IsInferredMember = CASE WHEN DW.[SalesOrderTenderKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimSalesOrderTender] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimSalesOrderTender] DW ON
				 STG.[SalesOrderTenderSSID] = DW.[SalesOrderTenderSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey



		-----------------------
		-- Check for SCD Type 1
		-----------------------
		UPDATE STG SET
			IsType1 = CASE WHEN DW.[SalesOrderTenderKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimSalesOrderTender] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimSalesOrderTender] DW ON
				 STG.[SalesOrderTenderSSID] = DW.[SalesOrderTenderSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE   1=1   -- 1=0 No Fields Change to 1=1 when there are SCD Type 1 fields
			AND (  COALESCE(STG.SalesOrderKey,'') <> COALESCE(DW.SalesOrderKey,'')
				OR COALESCE(STG.SalesOrderSSID,'') <> COALESCE(DW.SalesOrderSSID,'')
				OR COALESCE(STG.OrderDate,'') <> COALESCE(DW.OrderDate,'')
				OR COALESCE(STG.TenderTypeSSID,'') <> COALESCE(DW.TenderTypeSSID,'')
				OR COALESCE(STG.TenderTypeDescription,'') <> COALESCE(DW.TenderTypeDescription,'')
				OR COALESCE(STG.TenderTypeDescriptionShort,'') <> COALESCE(DW.TenderTypeDescriptionShort,'')
				OR COALESCE(STG.Amount,'') <> COALESCE(DW.Amount,'')
				OR COALESCE(STG.CheckNumber,'') <> COALESCE(DW.CheckNumber,'')
				OR COALESCE(STG.CreditCardLast4Digits,'') <> COALESCE(DW.CreditCardLast4Digits,'')
				OR COALESCE(STG.ApprovalCode,'') <> COALESCE(DW.ApprovalCode,'')
				OR COALESCE(STG.CreditCardTypeSSID,'') <> COALESCE(DW.CreditCardTypeSSID,'')
				OR COALESCE(STG.CreditCardTypeDescription,'') <> COALESCE(DW.CreditCardTypeDescription,'')
				OR COALESCE(STG.CreditCardTypeDescriptionShort,'') <> COALESCE(DW.CreditCardTypeDescriptionShort,'')
				OR COALESCE(STG.FinanceCompanySSID,'') <> COALESCE(DW.FinanceCompanySSID,'')
				OR COALESCE(STG.FinanceCompanyDescription,'') <> COALESCE(DW.FinanceCompanyDescription,'')
				OR COALESCE(STG.FinanceCompanyDescriptionShort,'') <> COALESCE(DW.FinanceCompanyDescriptionShort,'')
				OR COALESCE(STG.InterCompanyReasonSSID,'') <> COALESCE(DW.InterCompanyReasonSSID,'')
				OR COALESCE(STG.InterCompanyReasonDescription,'') <> COALESCE(DW.InterCompanyReasonDescription,'')
				OR COALESCE(STG.InterCompanyReasonDescriptionShort,'') <> COALESCE(DW.InterCompanyReasonDescriptionShort,'')
				)
		AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for SCD Type 2
		-----------------------
		UPDATE STG SET
			IsType2 = CASE WHEN DW.[SalesOrderTenderKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimSalesOrderTender] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimSalesOrderTender] DW ON
				 STG.[SalesOrderTenderSSID] = DW.[SalesOrderTenderSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE  1=0   -- 1=0 No Fields Change to 1=1 when there are SCD Type 2 fields
			--AND ( COALESCE(STG.SalesOrderKey,'') <> COALESCE(DW.SalesOrderKey,'')
			--  OR COALESCE(STG.SalesOrderSSID,'') <> COALESCE(DW.SalesOrderSSID,'')
			--  OR COALESCE(STG.OrderDate,'') <> COALESCE(DW.OrderDate,'')
			--	OR COALESCE(STG.TenderTypeSSID,'') <> COALESCE(DW.TenderTypeSSID,'')
			--	OR COALESCE(STG.TenderTypeDescription,'') <> COALESCE(DW.TenderTypeDescription,'')
			--	OR COALESCE(STG.TenderTypeDescriptionShort,'') <> COALESCE(DW.TenderTypeDescriptionShort,'')
			--	OR COALESCE(STG.Amount,'') <> COALESCE(DW.Amount,'')
			--	OR COALESCE(STG.CheckNumber,'') <> COALESCE(DW.CheckNumber,'')
			--	OR COALESCE(STG.CreditCardLast4Digits,'') <> COALESCE(DW.CreditCardLast4Digits,'')
			--	OR COALESCE(STG.ApprovalCode,'') <> COALESCE(DW.ApprovalCode,'')
			--	OR COALESCE(STG.CreditCardTypeSSID,'') <> COALESCE(DW.CreditCardTypeSSID,'')
			--	OR COALESCE(STG.CreditCardTypeDescription,'') <> COALESCE(DW.CreditCardTypeDescription,'')
			--	OR COALESCE(STG.CreditCardTypeDescriptionShort,'') <> COALESCE(DW.CreditCardTypeDescriptionShort,'')
			--	OR COALESCE(STG.FinanceCompanySSID,'') <> COALESCE(DW.FinanceCompanySSID,'')
			--	OR COALESCE(STG.FinanceCompanyDescription,'') <> COALESCE(DW.FinanceCompanyDescription,'')
			--	OR COALESCE(STG.FinanceCompanyDescriptionShort,'') <> COALESCE(DW.FinanceCompanyDescriptionShort,'')
			--	OR COALESCE(STG.InterCompanyReasonSSID,'') <> COALESCE(DW.InterCompanyReasonSSID,'')
			--	OR COALESCE(STG.InterCompanyReasonDescription,'') <> COALESCE(DW.InterCompanyReasonDescription,'')
			--	OR COALESCE(STG.InterCompanyReasonDescriptionShort,'') <> COALESCE(DW.InterCompanyReasonDescriptionShort,'')
			--	)
		AND STG.[DataPkgKey] = @DataPkgKey;


		-----------------------
		-- Check for duplicate records
		-----------------------
		WITH Duplicates  AS
			(SELECT  SalesOrderTenderSSID
						, IsDuplicate
					  , row_number() OVER ( PARTITION BY SalesOrderTenderSSID ORDER BY SalesOrderTenderSSID ) AS RowNum
			   FROM  [bi_cms_stage].[DimSalesOrderTender] STG
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
		FROM [bi_cms_stage].[DimSalesOrderTender] STG
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
