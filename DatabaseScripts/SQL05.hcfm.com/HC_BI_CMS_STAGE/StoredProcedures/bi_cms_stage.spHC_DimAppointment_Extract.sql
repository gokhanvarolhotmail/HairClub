/* CreateDate: 06/27/2011 17:23:48.233 , ModifyDate: 11/28/2017 15:56:20.637 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimAppointment_Extract]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimAppointment_Extract] is used to retrieve a
-- list Sales Transactions
--
--   exec [bi_cms_stage].[spHC_DimAppointment_Extract]  '2011-01-01 01:00:00'
--                                       , '2011-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/09/2011  KMurdoch       Initial Creation
--			01/03/2013  EKnapp       Use UTC Current Extraction Time.
--			05/24/2013  KMurdoch	 Modified extract to not INNER join to datClient
--			11/28/2017  KMurdoch     Added SFDC_Lead/Task_ID
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
				, @CET_UTC              datetime

 	SET @TableName = N'[bi_cms_dds].[DimAppointment]'


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

				-- Convert our Current Extraction Time to UTC time for compare in the Where clause to ensure we pick up latest data.
				SELECT @CET_UTC = [bief_stage].[fn_CorporateToUTCDateTime](@CET)

				INSERT INTO [HC_BI_CMS_STAGE].[bi_cms_stage].[DimAppointment]
						   ([DataPkgKey]
						   ,[AppointmentKey]
						   ,[AppointmentSSID]
						   ,[CenterKey]
						   ,[CenterSSID]
						   ,[ClientHomeCenterKey]
						   ,[ClientHomeCenterSSID]
						   ,[ClientKey]
						   ,[ClientSSID]
						   ,[ClientMembershipKey]
						   ,[ClientMembershipSSID]
						   ,[AppointmentDate]
						   ,[ResourceSSID]
						   ,[ResourceDescription]
						   ,[ConfirmationTypeSSID]
						   ,[ConfirmationTypeDescription]
						   ,[AppointmentTypeSSID]
						   ,[AppointmentTypeDescription]
						   ,[AppointmentStartTime]
						   ,[AppointmentEndTime]
						   ,[CheckInTime]
						   ,[CheckOutTime]
						   ,[AppointmentSubject]
						   ,[AppointmentStatusSSID]
						   ,[AppointmentStatusDescription]
						   ,[OnContactActivitySSID]
						   ,[OnContactContactSSID]
						   ,[CanPrinTCommentFlag]
						   ,[IsNonAppointmentFlag]
						   ,[IsDeletedFlag]
						   ,[SFDC_LeadID]
						   ,[SFDC_TaskID]
						   ,[IsException]
						   ,[IsDelete]
						   ,[IsDuplicate]
						   ,[SourceSystemKey]
							)

				SELECT
							@DataPkgKey
							, NULL AS [AppointmentKey]
							, COALESCE(appt.[AppointmentGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [AppointmentSSID]
							, 0 AS [CenterKey]
							, COALESCE(appt.[CenterID],-2) AS [CenterSSID]
							, 0 AS [ClientHomeCenterKey]
							, ISNULL(cl.[CenterID],appt.centerid) AS [CenterSSID]
							, 0 AS [ClientKey]
							, COALESCE(appt.[ClientGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [ClientSSID]
							, 0 AS [ClientMembershipKey]
							, COALESCE(appt.[ClientMembershipGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [OrigClientMembershipSSID]
							, appt.AppointmentDate  AS [AppointmentDate]-- [bief_stage].[fn_GetUTCDateTime](hso.HairSystemOrderDate, hso.[CenterID]) as 'HairSystemOrderDate'
							, res.ResourceID AS [ResourceSSID]
							, res.ResourceDescription AS [ResourceDescription]
							, appt.ConfirmationTypeID AS [ConfirmationTypeSSID]
							, cnftype.ConfirmationTypeDescription AS [ConfirmationTypeDescrption]
							, appt.AppointmentTypeID AS [AppointmentTypeSSID]
							, appttype.AppointmentTypeDescription AS [AppointmentTypeDescription]
							, appt.StartTime AS [AppointmentStartTime]
							, appt.EndTime AS [AppointmentEndTime]
							, [bief_stage].[fn_GetUTCDateTime](appt.CheckinTime, appt.[CenterID])
							, [bief_stage].[fn_GetUTCDateTime](appt.CheckoutTime, appt.[CenterID])
							, appt.AppointmentSubject AS [AppointmentSubject]
							, appt.AppointmentStatusID AS [AppointmentStatusID]
							, apptstatus.AppointmentStatusDescription as [AppointmentStatusDescription]
							, appt.OnContactActivityID AS [OnContactActivityID]
							, appt.OnContactContactID AS [OnContactContactID]
							, appt.CanPrintCommentFlag AS [CanPrintCommentFlag]
							, appt.IsNonAppointmentFlag AS [IsNonAppointmentFlag]
							, appt.IsDeletedFlag AS [IsDeletedFlag]
							, appt.SalesforceContactID
							, appt.SalesforceTaskID
	    					, 0 AS [IsException]
							, 0 AS [IsDelete]
							, 0 AS [IsDuplicate]
							, CAST(ISNULL(LTRIM(RTRIM(appt.AppointmentGUID)),'') AS nvarchar(50)) AS [SourceSystemKey]
						FROM  bi_cms_stage.synHC_SRC_TBL_CMS_datAppointment appt
							LEFT OUTER JOIN HairClubCMS.dbo.datClient  cl on
								appt.ClientGUID = cl.ClientGUID
							LEFT OUTER JOIN bi_cms_stage.synHC_SRC_TBL_CMS_cfgResource res on
								appt.ResourceID = res.ResourceID
							LEFT OUTER JOIN bi_cms_stage.synHC_SRC_TBL_CMS_lkpConfirmationType cnftype on
								appt.ConfirmationTypeID = cnftype.ConfirmationTypeID
							LEFT OUTER JOIN bi_cms_stage.synHC_SRC_TBL_CMS_lkpAppointmentType appttype on
								appt.AppointmentTypeID = appttype.AppointmentTypeID
							LEFT OUTER JOIN bi_cms_stage.synHC_SRC_TBL_CMS_lkpAppointmentStatus apptstatus on
								appt.AppointmentStatusID = apptstatus.AppointmentStatusID
				WHERE (appt.[CreateDate] >= @LSET AND appt.[CreateDate] < @CET_UTC)
				   OR (appt.[LastUpdate] >= @LSET AND appt.[LastUpdate] < @CET_UTC)

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
