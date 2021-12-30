/* CreateDate: 05/03/2010 12:26:44.730 , ModifyDate: 05/03/2010 12:26:44.730 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_DimEmployee_Transform_SetIsNewSCD]
       (
			  @DataPkgKey				int
       )

AS
-------------------------------------------------------------------------
-- [spHC_DimEmployee_Transform_SetIsNewSCD] is used to determine which records
--  are NEW, which records are SCD Type 1 or Type 2.
--
--
-- EXEC [spHC_DimEmployee_Transform_SetIsNewSCD] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    08/11/2009               Initial Creation
-------------------------------------------------------------------------
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
	SET NOCOUNT ON;



  	DECLARE		      @intError			int				-- error code
  					, @intDBErrorLogID	int				-- ID of error record logged
  					, @intRowCount		int				-- count of rows modified
  					, @vchTagValueList	nvarchar(1000)	-- Named Valued Pairs of Parameters
  	 				, @return_value		int

    DECLARE		      @TableName		varchar(150)	-- Name of table
				    , @CleanupRowCnt	int

  	SET @TableName = N'[bi_mktg_dds].[DimEmployee]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

   BEGIN TRY


		-----------------------
		-- Check for new rows
		-----------------------
		UPDATE STG SET
		     [EmployeeKey] = DW.[EmployeeKey]
			,IsNew = CASE WHEN DW.[EmployeeKey] IS NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimEmployee] STG
		LEFT OUTER JOIN [bi_mktg_stage].[synHC_DDS_DimEmployee] DW ON
				DW.[EmployeeSSID] = STG.[EmployeeSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for Inferred Members
		-----------------------
		UPDATE STG SET
			IsInferredMember = CASE WHEN DW.[EmployeeKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimEmployee] STG
		INNER JOIN [bi_mktg_stage].[synHC_DDS_DimEmployee] DW ON
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
		FROM [bi_mktg_stage].[DimEmployee] STG
		INNER JOIN [bi_mktg_stage].[synHC_DDS_DimEmployee] DW ON
				 STG.[EmployeeSSID] = DW.[EmployeeSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE   1=1   -- 1=0 No Fields Change to 1=1 when there are SCD Type 1 fields
			AND ( COALESCE(STG.[EmployeeFirstName],'') <> COALESCE(DW.[EmployeeFirstName],'')
				OR COALESCE(STG.[EmployeeLastName],'') <> COALESCE(DW.[EmployeeLastName],'')
				OR COALESCE(STG.[EmployeeDescription],'') <> COALESCE(DW.[EmployeeDescription],'')
				OR COALESCE(STG.[EmployeeTitle],'') <> COALESCE(DW.[EmployeeTitle],'')
				OR COALESCE(STG.[ActionSetCode],'') <> COALESCE(DW.[ActionSetCode],'')
				OR COALESCE(STG.[EmployeeDepartmentSSID],'') <> COALESCE(DW.[EmployeeDepartmentSSID],'')
				OR COALESCE(STG.[EmployeeDepartmentDescription],'') <> COALESCE(DW.[EmployeeDepartmentDescription],'')
				OR COALESCE(STG.[EmployeeJobFunctionSSID],'') <> COALESCE(DW.[EmployeeJobFunctionSSID],'')
				OR COALESCE(STG.[EmployeeJobFunctionDescription],'') <> COALESCE(DW.[EmployeeJobFunctionDescription],'')
				)
		AND STG.[DataPkgKey] = @DataPkgKey


		-----------------------
		-- Check for SCD Type 2
		-----------------------
		UPDATE STG SET
			IsType2 = CASE WHEN DW.[EmployeeKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_mktg_stage].[DimEmployee] STG
		INNER JOIN [bi_mktg_stage].[synHC_DDS_DimEmployee] DW ON
				 STG.[EmployeeSSID] = DW.[EmployeeSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE  1=0   -- 1=0 No Fields Change to 1=1 when there are SCD Type 2 fields
			--AND ( COALESCE(STG.[EmployeeFirstName],'') <> COALESCE(DW.[EmployeeFirstName],'')
			-- OR COALESCE(STG.[EmployeeLastName],'') <> COALESCE(DW.[EmployeeLastName],'')
			-- OR COALESCE(STG.[EmployeeDescription],'') <> COALESCE(DW.[EmployeeDescription],'')
			-- OR COALESCE(STG.[EmployeeTitle],'') <> COALESCE(DW.[EmployeeTitle],'')
			-- OR COALESCE(STG.[ActionSetCode],'') <> COALESCE(DW.[ActionSetCode],'')
			-- OR COALESCE(STG.[EmployeeDepartmentSSID],'') <> COALESCE(DW.[EmployeeDepartmentSSID],'')
			-- OR COALESCE(STG.[EmployeeDepartmentDescription],'') <> COALESCE(DW.[EmployeeDepartmentDescription],'')
			-- OR COALESCE(STG.[EmployeeJobFunctionSSID],'') <> COALESCE(DW.[EmployeeJobFunctionSSID],'')
			-- OR COALESCE(STG.[EmployeeJobFunctionDescription],'') <> COALESCE(DW.[EmployeeJobFunctionDescription],'')
			--	)
		AND STG.[DataPkgKey] = @DataPkgKey;


		-----------------------
		-- Check for duplicate records
		-----------------------
		WITH Duplicates  AS
			(SELECT  [EmployeeSSID]
						, IsDuplicate
					  , row_number() OVER ( PARTITION BY [EmployeeSSID] ORDER BY [EmployeeSSID] ) AS RowNum
			   FROM  [bi_mktg_stage].[DimEmployee] STG
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
		FROM [bi_mktg_stage].[DimEmployee] STG
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
