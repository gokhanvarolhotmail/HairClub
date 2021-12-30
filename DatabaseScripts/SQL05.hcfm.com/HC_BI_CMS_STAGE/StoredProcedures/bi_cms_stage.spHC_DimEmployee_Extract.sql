/* CreateDate: 05/03/2010 12:19:56.870 , ModifyDate: 11/30/2012 11:07:15.770 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimEmployee_Extract]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimEmployee_Extract] is used to retrieve a
-- list Business Unit Brands
--
--   exec [bi_cms_stage].[spHC_DimEmployee_Extract]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    03/12/2009  RLifke       Initial Creation
--			07/13/2011  KMurdoch	 Added CenterSSID
--			11/06/2012  KMurdoch	 Added EmployeePayrollID
--			11/30/2012  KMurdoch     Added IsActiveFlag
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

 	SET @TableName = N'[bi_cms_dds].[DimEmployee]'


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


				INSERT INTO [bi_cms_stage].[DimEmployee]
						   ( [DataPkgKey]
							, [EmployeeKey]
							, [EmployeeSSID]
							, [CenterSSID]
							, [EmployeeFirstName]
							, [EmployeeLastName]
							, [EmployeeInitials]
							, [SalutationSSID]
							, [EmployeeSalutationDescription]
							, [EmployeeSalutationDescriptionShort]
							, [EmployeeAddress1]
							, [EmployeeAddress2]
							, [EmployeeAddress3]
						    , [CountryRegionDescription]
						    , [CountryRegionDescriptionShort]
						    , [StateProvinceDescription]
						    , [StateProvinceDescriptionShort]
						    , [City]
							, [PostalCode]
							, [UserLogin]
							, [EmployeePhoneMain]
							, [EmployeePhoneAlternate]
							, [EmployeeEmergencyContact]
							, [EmployeePayrollNumber]
							, [EmployeeTimeClockNumber]
							, [EmployeePayrollID]
							, [IsActiveFlag]
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
				SELECT @DataPkgKey
						, NULL AS [EmployeeKey]
						, [EmployeeGUID] AS [EmployeeSSID]
						, [CenterID] as [CenterSSID]
						, CAST(ISNULL(LTRIM(RTRIM([FirstName])),'') AS nvarchar(50)) AS [EmployeeFirstName]
						, CAST(ISNULL(LTRIM(RTRIM([LastName])),'') AS nvarchar(50)) AS [EmployeeLastName]
						, CAST(ISNULL(LTRIM(RTRIM([EmployeeInitials])),'') AS nvarchar(5)) AS [EmployeeInitials]
						, cl.[SalutationID] AS [SalutationSSID]
						, CAST(ISNULL(LTRIM(RTRIM(sal.[SalutationDescription])),'') AS nvarchar(50)) AS [EmployeeSalutationDescription]
						, CAST(ISNULL(LTRIM(RTRIM(sal.[SalutationDescriptionShort])),'') AS nvarchar(10)) AS [EmployeeSalutationDescriptionShort]
						, CAST(ISNULL(LTRIM(RTRIM([Address1])),'') AS nvarchar(50)) AS [EmployeeAddress1]
						, CAST(ISNULL(LTRIM(RTRIM([Address2])),'') AS nvarchar(50)) AS [EmployeeAddress2]
						, CAST(ISNULL(LTRIM(RTRIM([Address3])),'') AS nvarchar(50)) AS [EmployeeAddress3]
						, CAST(ISNULL(LTRIM(RTRIM(cn.[CountryDescription])),'') AS nvarchar(50)) AS [CountryRegionDescription]
						, CAST(ISNULL(LTRIM(RTRIM(cn.[CountryDescriptionShort])),'') AS nvarchar(10)) AS [CountryRegionDescriptionShort]
						, CAST(ISNULL(LTRIM(RTRIM(st.[StateDescription])),'') AS nvarchar(50)) AS [StateProvinceDescription]
						, CAST(ISNULL(LTRIM(RTRIM(st.[StateDescriptionShort])),'') AS nvarchar(10)) AS [StateProvinceDescriptionShort]
						, CAST(ISNULL(LTRIM(RTRIM([City])),'') AS nvarchar(50)) AS [City]
						, CAST(ISNULL(LTRIM(RTRIM([PostalCode])),'') AS nvarchar(15)) AS [PostalCode]
						, CAST(ISNULL(LTRIM(RTRIM([UserLogin])),'') AS nvarchar(50)) AS [UserLogin]
						, CAST(ISNULL(LTRIM(RTRIM([PhoneMain])),'') AS nvarchar(25)) AS [EmployeePhoneMain]
						, CAST(ISNULL(LTRIM(RTRIM([PhoneAlternate])),'') AS nvarchar(25)) AS [EmployeePhoneAlternate]
						, CAST(ISNULL(LTRIM(RTRIM([EmergencyContact])),'') AS nvarchar(100)) AS [EmployeeEmergencyContact]
						, CAST(ISNULL(LTRIM(RTRIM([PayrollNumber])),'') AS nvarchar(20)) AS [EmployeePayrollNumber]
						, CAST(ISNULL(LTRIM(RTRIM([TimeClockNumber])),'') AS nvarchar(20)) AS [EmployeeTimeClockNumber]
						, CAST(ISNULL(LTRIM(RTRIM([EmployeePayrollID])),'') AS nvarchar(20)) AS [EmployeePayrollID]
						, ISNULL(cl.IsActiveFlag,0) as [IsActiveFlag]


						, cl.[LastUpdate] AS [ModifiedDate]
						, 0 AS [IsNew]
						, 0 AS [IsType1]
						, 0 AS [IsType2]
						, 0 AS [IsException]
						, 0 AS [IsInferredMember]
						, 0 AS [IsDelete]
						, 0 AS [IsDuplicate]
						, CAST(ISNULL(LTRIM(RTRIM([EmployeeGUID])),'') AS nvarchar(50)) AS [SourceSystemKey]
				FROM [bi_cms_stage].[synHC_SRC_TBL_CMS_datEmployee] cl
					Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpSalutation] sal
							ON cl.[SalutationID] = sal.[SalutationID]
					Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpState] st
							ON cl.[StateID] = st.[StateID]
					Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpCountry] cn
							ON st.[CountryID] = cn.[CountryID]
				WHERE (cl.[CreateDate] >= @LSET AND cl.[CreateDate] < @CET)
				   OR (cl.[LastUpdate] >= @LSET AND cl.[LastUpdate] < @CET)

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
