/* CreateDate: 05/03/2010 12:19:59.043 , ModifyDate: 04/25/2013 09:35:35.110 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimEmployee_Transform_SetIsNewSCD]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimEmployee_Transform_SetIsNewSCD] is used to determine which records
-- are NEW, which records are SCD Type 1 or Type 2
--
--
--   exec [bi_cms_stage].[spHC_DimEmployee_Transform_SetIsNewSCD] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    03/16/2009  RLifke       Initial Creation
--			07/13/2011  KMurdoch	 Added CenterSSID
--			11/07/2012  KMurdoch     Added EmployeePayrollID
--			04/25/2013	KMurdoch     Added IsActiveFlag to Where clause in Type 1
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

 	SET @TableName = N'[bi_cms_dds].[DimEmployee]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY

		-----------------------
		-- Check for new rows
		-----------------------
		UPDATE STG SET
		     [EmployeeKey] = DW.[EmployeeKey]
			,IsNew = CASE WHEN DW.[EmployeeKey] IS NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimEmployee] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimEmployee] DW ON
				DW.[EmployeeSSID] = STG.[EmployeeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for Inferred Members
		-----------------------
		UPDATE STG SET
			IsInferredMember = CASE WHEN DW.[EmployeeKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimEmployee] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimEmployee] DW ON
				 STG.[EmployeeSSID] = DW.[EmployeeSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey



		-----------------------
		-- Check for SCD Type 1
		-----------------------
		UPDATE STG SET
			IsType1 = CASE WHEN DW.[EmployeeKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimEmployee] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimEmployee] DW ON
				 STG.[EmployeeSSID] = DW.[EmployeeSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE   1=1   -- 1=0 No Fields Change to 1=1 when there are SCD Type 1 fields
			AND ( COALESCE(STG.[EmployeeFirstName],'') <> COALESCE(DW.[EmployeeFirstName],'')
				OR COALESCE(STG.[EmployeeLastName],'') <> COALESCE(DW.[EmployeeLastName],'')
				OR COALESCE(STG.[EmployeeInitials],'') <> COALESCE(DW.[EmployeeInitials],'')
				OR COALESCE(STG.[SalutationSSID],'') <> COALESCE(DW.[SalutationSSID],'')
				OR COALESCE(STG.[EmployeeSalutationDescription],'') <> COALESCE(DW.[EmployeeSalutationDescription],'')
				OR COALESCE(STG.[EmployeeSalutationDescriptionShort],'') <> COALESCE(DW.[EmployeeSalutationDescriptionShort],'')
				OR COALESCE(STG.[EmployeeAddress1],'') <> COALESCE(DW.[EmployeeAddress1],'')
				OR COALESCE(STG.[EmployeeAddress2],'') <> COALESCE(DW.[EmployeeAddress2],'')
				OR COALESCE(STG.[EmployeeAddress3],'') <> COALESCE(DW.[EmployeeAddress3],'')
				OR COALESCE(STG.[CountryRegionDescription],'') <> COALESCE(DW.[CountryRegionDescription],'')
				OR COALESCE(STG.[CountryRegionDescriptionShort],'') <> COALESCE(DW.[CountryRegionDescriptionShort],'')
				OR COALESCE(STG.[StateProvinceDescription],'') <> COALESCE(DW.[StateProvinceDescription],'')
				OR COALESCE(STG.[StateProvinceDescriptionShort],'') <> COALESCE(DW.[StateProvinceDescriptionShort],'')
				OR COALESCE(STG.[City],'') <> COALESCE(DW.[City],'')
				OR COALESCE(STG.[PostalCode],'') <> COALESCE(DW.[PostalCode],'')
				OR COALESCE(STG.[UserLogin],'') <> COALESCE(DW.[UserLogin],'')
				OR COALESCE(STG.[EmployeePhoneMain],'') <> COALESCE(DW.[EmployeePhoneMain],'')
				OR COALESCE(STG.[EmployeePhoneAlternate],'') <> COALESCE(DW.[EmployeePhoneAlternate],'')
				OR COALESCE(STG.[EmployeeEmergencyContact],'') <> COALESCE(DW.[EmployeeEmergencyContact],'')
				OR COALESCE(STG.[EmployeePayrollNumber],'') <> COALESCE(DW.[EmployeePayrollNumber],'')
				OR COALESCE(STG.[EmployeeTimeClockNumber],'') <> COALESCE(DW.[EmployeeTimeClockNumber],'')
				OR COALESCE(STG.[EmployeePayrollID],'') <> COALESCE(DW.[EmployeePayrollID],'')
				OR COALESCE(STG.[CenterSSID],0) <> COALESCE(DW.[CenterSSID],0)
				OR COALESCE(STG.[IsActiveFlag],0) <> COALESCE(DW.[IsActiveFlag],0)
				)
		AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for SCD Type 2
		-----------------------
		UPDATE STG SET
			IsType2 = CASE WHEN DW.[EmployeeKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimEmployee] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimEmployee] DW ON
				 STG.[EmployeeSSID] = DW.[EmployeeSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE  1=0   -- 1=0 No Fields Change to 1=1 when there are SCD Type 2 fields
			--AND ( COALESCE(STG.[EmployeeFirstName],'') <> COALESCE(DW.[EmployeeFirstName],'')
				--OR COALESCE(STG.[EmployeeLastName],'') <> COALESCE(DW.[EmployeeLastName],'')
				--OR COALESCE(STG.[EmployeeInitials],'') <> COALESCE(DW.[EmployeeInitials],'')
				--OR COALESCE(STG.[SalutationSSID],'') <> COALESCE(DW.[SalutationSSID],'')
				--OR COALESCE(STG.[EmployeeSalutationDescription],'') <> COALESCE(DW.[EmployeeSalutationDescription],'')
				--OR COALESCE(STG.[EmployeeSalutationDescriptionShort],'') <> COALESCE(DW.[EmployeeSalutationDescriptionShort],'')
				--OR COALESCE(STG.[EmployeeAddress1],'') <> COALESCE(DW.[EmployeeAddress1],'')
				--OR COALESCE(STG.[EmployeeAddress2],'') <> COALESCE(DW.[EmployeeAddress2],'')
				--OR COALESCE(STG.[EmployeeAddress3],'') <> COALESCE(DW.[EmployeeAddress3],'')
				--OR COALESCE(STG.[CountryRegionDescription],'') <> COALESCE(DW.[CountryRegionDescription],'')
				--OR COALESCE(STG.[CountryRegionDescriptionShort],'') <> COALESCE(DW.[CountryRegionDescriptionShort],'')
				--OR COALESCE(STG.[StateProvinceDescription],'') <> COALESCE(DW.[StateProvinceDescription],'')
				--OR COALESCE(STG.[StateProvinceDescriptionShort],'') <> COALESCE(DW.[StateProvinceDescriptionShort],'')
				--OR COALESCE(STG.[City],'') <> COALESCE(DW.[City],'')
				--OR COALESCE(STG.[PostalCode],'') <> COALESCE(DW.[PostalCode],'')
				--OR COALESCE(STG.[UserLogin],'') <> COALESCE(DW.[UserLogin],'')
				--OR COALESCE(STG.[EmployeePhoneMain],'') <> COALESCE(DW.[EmployeePhoneMain],'')
				--OR COALESCE(STG.[EmployeePhoneAlternate],'') <> COALESCE(DW.[EmployeePhoneAlternate],'')
				--OR COALESCE(STG.[EmployeeEmergencyContact],'') <> COALESCE(DW.[EmployeeEmergencyContact],'')
				--OR COALESCE(STG.[EmployeePayrollNumber],'') <> COALESCE(DW.[EmployeePayrollNumber],'')
				--OR COALESCE(STG.[EmployeeTimeClockNumber],'') <> COALESCE(DW.[EmployeeTimeClockNumber],'')
			--	)
		AND STG.[DataPkgKey] = @DataPkgKey;


		-----------------------
		-- Check for duplicate records
		-----------------------
		WITH Duplicates  AS
			(SELECT  EmployeeSSID
						, IsDuplicate
					  , row_number() OVER ( PARTITION BY EmployeeSSID ORDER BY EmployeeSSID ) AS RowNum
			   FROM  [bi_cms_stage].[DimEmployee] STG
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
		FROM [bi_cms_stage].[DimEmployee] STG
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
