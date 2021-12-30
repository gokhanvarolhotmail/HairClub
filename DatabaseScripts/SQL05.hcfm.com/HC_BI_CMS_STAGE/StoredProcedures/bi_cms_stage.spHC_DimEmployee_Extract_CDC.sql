/* CreateDate: 05/03/2010 12:19:58.990 , ModifyDate: 11/30/2012 11:08:14.660 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimEmployee_Extract_CDC]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimEmployee_Extract_CDC] is used to retrieve a
-- list Employee
--
--   exec [bi_cms_stage].[spHC_DimEmployee_Extract_CDC]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    05/27/2009  RLifke       Initial Creation
--			07/13/2011  KMurdoch	 Added CenterSSID
--			11/07/2012  KMurdoch	 Added EmployeePayrollID
--			11/30/2012  KMurdoch	 Added IsActiveFlag
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
				, @CDCTableName			varchar(150)	-- Name of CDC table
				, @ExtractRowCnt		int

 	SET @TableName = N'[bi_cms_dds].[DimEmployee]'
 	SET @CDCTableName = N'dbo_datEmployee'


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

				DECLARE	@Start_Time datetime = null,
						@End_Time datetime = null,
						@row_filter_option nvarchar(30) = N'all'

				DECLARE @From_LSN binary(10), @To_LSN binary(10)

				SET @Start_Time = @LSET
				SET @End_Time = @CET

				IF (@Start_Time is null)
					SELECT @From_LSN = [HairClubCMS].[sys].[fn_cdc_get_min_lsn](@CDCTableName)
				ELSE
				BEGIN
					IF ([HairClubCMS].[sys].[fn_cdc_map_lsn_to_time]([HairClubCMS].[sys].[fn_cdc_get_min_lsn](@CDCTableName)) > @Start_Time) or
					   ([HairClubCMS].[sys].[fn_cdc_map_lsn_to_time]([HairClubCMS].[sys].[fn_cdc_get_max_lsn]()) < @Start_Time)
						SELECT @From_LSN = null
					ELSE
						SELECT @From_LSN = [HairClubCMS].[sys].[fn_cdc_increment_lsn]([HairClubCMS].[sys].[fn_cdc_map_time_to_lsn]('largest less than or equal',@Start_Time))
				END

				IF (@End_Time is null)
					SELECT @To_LSN = [HairClubCMS].[sys].[fn_cdc_get_max_lsn]()
				ELSE
				BEGIN
					IF [HairClubCMS].[sys].[fn_cdc_map_lsn_to_time]([HairClubCMS].[sys].[fn_cdc_get_max_lsn]()) < @End_Time
						--SELECT @To_LSN = null
						SELECT @To_LSN = [HairClubCMS].[sys].[fn_cdc_get_max_lsn]()
					ELSE
						SELECT @To_LSN = [HairClubCMS].[sys].[fn_cdc_map_time_to_lsn]('largest less than or equal',@End_Time)
				END


				-- Get the Actual Current Extraction Time
				SELECT @CET = [HairClubCMS].[sys].[fn_cdc_map_lsn_to_time](@To_LSN)

				IF (@From_LSN IS NOT NULL) AND (@To_LSN IS NOT NULL) AND (@From_LSN <> [HairClubCMS].[sys].[fn_cdc_increment_lsn](@To_LSN))
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
									, [CDC_Operation]
									)
						SELECT @DataPkgKey
								, NULL AS [EmployeeKey]
								, chg.[EmployeeGUID] AS [EmployeeSSID]
								, chg.[CenterID] AS [CenterSSID]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[FirstName])),'') AS nvarchar(50)) AS [EmployeeFirstName]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[LastName])),'') AS nvarchar(50)) AS [EmployeeLastName]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[EmployeeInitials])),'') AS nvarchar(5)) AS [EmployeeInitials]
								, chg.[SalutationID] AS [SalutationSSID]
								, CAST(ISNULL(LTRIM(RTRIM(sal.[SalutationDescription])),'') AS nvarchar(50)) AS [EmployeeSalutationDescription]
								, CAST(ISNULL(LTRIM(RTRIM(sal.[SalutationDescriptionShort])),'') AS nvarchar(10)) AS [EmployeeSalutationDescriptionShort]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[Address1])),'') AS nvarchar(50)) AS [EmployeeAddress1]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[Address2])),'') AS nvarchar(50)) AS [EmployeeAddress2]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[Address3])),'') AS nvarchar(50)) AS [EmployeeAddress3]
								, CAST(ISNULL(LTRIM(RTRIM(cn.[CountryDescription])),'') AS nvarchar(50)) AS [CountryRegionDescription]
								, CAST(ISNULL(LTRIM(RTRIM(cn.[CountryDescriptionShort])),'') AS nvarchar(10)) AS [CountryRegionDescriptionShort]
								, CAST(ISNULL(LTRIM(RTRIM(st.[StateDescription])),'') AS nvarchar(50)) AS [StateProvinceDescription]
								, CAST(ISNULL(LTRIM(RTRIM(st.[StateDescriptionShort])),'') AS nvarchar(10)) AS [StateProvinceDescriptionShort]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[PostalCode])),'') AS nvarchar(15)) AS [PostalCode]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[City])),'') AS nvarchar(50)) AS [EmployeeCity]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[UserLogin])),'') AS nvarchar(50)) AS [UserLogin]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[PhoneMain])),'') AS nvarchar(25)) AS [EmployeePhoneMain]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[PhoneAlternate])),'') AS nvarchar(25)) AS [EmployeePhoneAlternate]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[EmergencyContact])),'') AS nvarchar(100)) AS [EmployeeEmergencyContact]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[PayrollNumber])),'') AS nvarchar(20)) AS [EmployeePayrollNumber]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[TimeClockNumber])),'') AS nvarchar(20)) AS [EmployeeTimeClockNumber]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[EmployeePayrollID])),'') AS nvarchar(20)) AS [EmployeePayrollID]
								, ISNULL(chg.IsActiveFlag,0) as [IsActiveFlag]

								, [HairClubCMS].[sys].[fn_cdc_map_lsn_to_time](__$start_lsn) AS [ModifiedDate]
								, 0 AS [IsNew]
								, 0 AS [IsType1]
								, 0 AS [IsType2]
								, 0 AS [IsException]
								, 0 AS [IsInferredMember]
								, 0 AS [IsDelete]
								, 0 AS [IsDuplicate]
								, CAST(ISNULL(LTRIM(RTRIM(chg.[EmployeeGUID])),'') AS nvarchar(50)) AS [SourceSystemKey]
								, CASE [__$operation]
										WHEN 1 THEN 'D'
										WHEN 2 THEN 'I'
										WHEN 3 THEN 'UO'
										WHEN 4 THEN 'UN'
										WHEN 5 THEN 'M'
										ELSE NULL
									END AS [CDC_Operation]
						FROM [HairClubCMS].[cdc].[fn_cdc_get_net_changes_dbo_datEmployee](@From_LSN, @To_LSN, @row_filter_option) chg
							Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpSalutation] sal
									ON chg.[SalutationID] = sal.[SalutationID]
							Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpState] st
									ON chg.[StateID] = st.[StateID]
							Left Outer JOIN [bi_cms_stage].[synHC_SRC_TBL_CMS_lkpCountry] cn
									ON st.[CountryID] = cn.[CountryID]

						SET @ExtractRowCnt = @@ROWCOUNT

						-- Set the Last Successful Extraction Time & Status
						UPDATE [bief_stage].[_DataFlow]
							SET LSET = @CET
								, [Status] = 'Extraction Completed'
							WHERE [TableName] = @TableName

					END
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
