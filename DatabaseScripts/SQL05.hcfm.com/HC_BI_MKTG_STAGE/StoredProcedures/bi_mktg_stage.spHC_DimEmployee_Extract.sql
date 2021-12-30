/* CreateDate: 05/03/2010 12:26:42.743 , ModifyDate: 08/30/2021 21:21:16.013 */
GO
CREATE PROCEDURE [bi_mktg_stage].[spHC_DimEmployee_Extract]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimEmployee_Extract] is used to retrieve a
-- list Employees
--
--   exec [bi_mktg_stage].[spHC_DimEmployee_Extract]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    08/11/2009  RLifke       Initial Creation
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
				, @ExtractRowCnt		int

 	SET @TableName = N'[bi_mktg_dds].[DimEmployee]'


	BEGIN TRY

	   -- Put parameters in name value list to aid in reporting
		EXEC [bief_stage]._DBErrorLog_TagValueList @vchTagValueList OUTPUT
				, N'@LSET'
				, @LSET
				, N'@CET'
				, @CET

		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_ExtractStart] @DataPkgKey, @TableName, @LSET, @CET

		IF (@CET IS NOT NULL) AND (@LSET IS NOT NULL)
			BEGIN

				-- Set the Current Extraction Time & Status
				UPDATE [bief_stage].[_DataFlow]
					SET CET = @CET
						, [Status] = 'Extracting'
					WHERE [TableName] = @TableName


				UPDATE	u
				SET		u.Team = ou.title
				FROM	HC_BI_SFDC.dbo.[User] u
						INNER JOIN HCM.dbo.onca_user ou
							ON ou.user_code = u.UserCode__c


				INSERT INTO [bi_mktg_stage].[DimEmployee]
						   ( [DataPkgKey]
						   , [EmployeeKey]
						   , [EmployeeSSID]
						   , [EmployeeFirstName]
						   , [EmployeeLastName]
						   , [EmployeeDescription]
						   , [EmployeeTitle]
						   , [ActionSetCode]
						   , [EmployeeDepartmentSSID]
						   , [EmployeeDepartmentDescription]
						   , [EmployeeJobFunctionSSID]
						   , [EmployeeJobFunctionDescription]
						   , [ModifiedDate]
						   , [IsNew]
						   , [IsType1]
						   , [IsType2]
						   , [IsException]
						   , [IsInferredMember]
							, [IsDelete]
							, [IsDuplicate]
						   , [SourceSystemKey]
							)

				SELECT
						@DataPkgKey
						,NULL AS [EmployeeKey]
						, UserCode__c AS EmployeeSSID --CAST(ISNULL(LTRIM(RTRIM(Id)),'') AS nvarchar(20)) AS [EmployeeSSID]
						, CAST(ISNULL(LTRIM(RTRIM(FirstName)),'') AS nvarchar(50)) AS [EmployeeFirstName]
						, CAST(ISNULL(LTRIM(RTRIM(LastName)),'') AS nvarchar(50)) AS [EmployeeLastName]
						, CAST(ISNULL(LTRIM(RTRIM(UserCode__c)),'') AS nvarchar(50)) AS [EmployeeDescription]
						, CAST(ISNULL(LTRIM(RTRIM(Team)),'') AS nvarchar(50)) AS [EmployeeTitle]
						, '' AS [ActionSetCode]
						, CAST(ISNULL(LEFT(Department,10),'') AS nvarchar(10)) AS [EmployeeDepartmentSSID]
						, CAST(ISNULL(LTRIM(RTRIM(Department)),'') AS nvarchar(50)) AS [EmployeeDepartmentDescription]
						,'' AS [EmployeeJobFunctionSSID]
						,'' AS [EmployeeJobFunctionDescription]
						--, CAST(ISNULL(LTRIM(RTRIM(ou.[job_function_code])),'') AS nvarchar(10)) AS [EmployeeJobFunctionSSID]--???SUPER; ACE
						--, CAST(ISNULL(LTRIM(RTRIM(jf.[description])),'') AS nvarchar(50)) AS [EmployeeJobFunctionDescription] --??SUPERVISORS
						, LastModifiedDate AS [ModifiedDate]
						, 0 AS [IsNew]
						, 0 AS [IsType1]
						, 0 AS [IsType2]
						, 0 AS [IsException]
						, 0 AS [IsInferredMember]
						, 0 AS [IsDelete]
						, 0 AS [IsDuplicate]
						--, CAST(ISNULL(LTRIM(RTRIM(UserCode__c)),'') AS nvarchar(50)) AS [SourceSystemKey]
						, CAST(ISNULL(LTRIM(RTRIM(id)),'') AS nvarchar(18)) AS [SourceSystemKey]

				FROM  SQL06.[HC_BI_SFDC].[dbo].[User] WITH ( NOLOCK )

				WHERE UserCode__c IS NOT NULL

				SET @ExtractRowCnt = @@ROWCOUNT

				-- Set the Last Successful Extraction Time & Status
				UPDATE [bief_stage].[_DataFlow]
					SET LSET = @CET
						, [Status] = 'Extraction Completed'
					WHERE [TableName] = @TableName
		END

		-- Data pkg auditing
		EXEC	@return_value = [bief_stage].[sp_META_AuditDataPkgDetail_ExtractStop] @DataPkgKey, @TableName, @ExtractRowCnt

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


/****** Object:  StoredProcedure [bi_mktg_stage].[spHC_DimEmployee_Extract_CDC]    Script Date: 11/30/2018 12:37:28 PM ******/
SET ANSI_NULLS ON
GO
