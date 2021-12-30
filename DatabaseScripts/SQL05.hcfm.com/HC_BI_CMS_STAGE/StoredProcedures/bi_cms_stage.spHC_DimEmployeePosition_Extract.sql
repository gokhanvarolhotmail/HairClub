/* CreateDate: 08/02/2012 13:58:33.010 , ModifyDate: 03/13/2019 11:25:18.237 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimEmployeePosition_Extract]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimEmployeePosition_Extract] is used to retrieve a
-- list of Employee Positions
--
--   exec [bi_cms_stage].[spHC_DimEmployeePosition_Extract]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    08/02/2012  KMurdoch       Initial Creation
--
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

 	SET @TableName = N'[bi_cms_dds].[DimEmployeePosition]'


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


				INSERT INTO [bi_cms_stage].[DimEmployeePosition]
						   ( [DataPkgKey]
							, [EmployeePositionKey]
							, [EmployeePositionSSID]
							, [EmployeePositionDescription]
							, [EmployeePositionDescriptionShort]
							, [EmployeePositionSortOrder]
							, [ActiveDirectoryGroup]
							, [IsAdministratorFlag]
							, [IsEmployeeOneFlag]
							, [IsEmployeeTwoFlag]
							, [IsEmployeeThreeFlag]
							, [IsEmployeeFourFlag]
							, [CanScheduleFlag]
							, [ApplicationTimeoutMinutes]
							, [UseDefaultCenterFlag]
							, [IsSurgeryCenterEmployeeFlag]
							, [IsNonSurgeryCenterEmployeeFlag]
							, [Active]
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
				SELECT  @DataPkgKey
						, NULL AS [EmployeePositionKey]
						, [EmployeePositionID] AS [EmployeePositionSSID]
						, CAST(ISNULL(LTRIM(RTRIM([EmployeePositionDescription])),'') AS nvarchar(100)) AS [EmployeePositionDescription]
						, CAST(ISNULL(LTRIM(RTRIM([EmployeePositionDescriptionShort])),'') AS nvarchar(10)) AS [EmployeePositionDescriptionShort]
						, [EmployeePositionSortOrder]
						, CAST(ISNULL(LTRIM(RTRIM([ActiveDirectoryGroup])),'') AS nvarchar(50)) AS [ActiveDirectoryGroup]
						, [IsAdministratorFlag]
						, [IsEmployeeOneFlag]
						, [IsEmployeeTwoFlag]
						, [IsEmployeeThreeFlag]
						, [IsEmployeeFourFlag]
						, [CanScheduleFlag]
						, [ApplicationTimeoutMinutes]
						, [UseDefaultCenterFlag]
						, [IsSurgeryCenterEmployeeFlag]
						, [IsNonSurgeryCenterEmployeeFlag]
						, CASE WHEN ISNULL([IsActiveFlag],0) = 1 then 'Y' else 'N' end as Active
						, ep.[LastUpdate] AS [ModifiedDate]
						, 0 AS [IsNew]
						, 0 AS [IsType1]
						, 0 AS [IsType2]
						, 0 AS [IsException]
						, 0 AS [IsInferredMember]
						, 0 AS [IsDelete]
						, 0 AS [IsDuplicate]
						, CAST(ISNULL(LTRIM(RTRIM([EmployeePositionID])),'') AS nvarchar(50)) AS [SourceSystemKey]
				FROM [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpEmployeePosition] ep


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
GO
