/* CreateDate: 06/27/2011 17:23:38.170 , ModifyDate: 11/28/2017 16:16:25.920 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimAppointment_Extract_CDC]
		@DataPkgKey				int
	  , @LSET		datetime = NULL		-- Last Successful Extraction Time
	  , @CET		datetime = NULL		-- Current Extraction Time


AS
-------------------------------------------------------------------------
-- [spHC_DimAppointment_Extract_CDC] is used to retrieve a
-- list Appointment
--
--   exec [bi_cms_stage].[spHC_DimAppointment_Extract_CDC]  '2009-01-01 01:00:00'
--                                       , '2009-01-02 01:00:00'
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    07/01/2009  RLifke       Initial Creation
--			05/24/2013  KMurdoch	 Modified extract to not INNER join to datClient
--			07/02/2015	DLeiba		 Modified extract to populate the CDC_Operation column to process Deletions/Updates
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
				, @CDCTableName			varchar(150)	-- Name of CDC table
				, @ExtractRowCnt		int

 	SET @TableName = N'[bi_cms_dds].[DimAppointment]'
 	SET @CDCTableName = N'dbo_datAppointment'


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

							INSERT INTO [bi_cms_stage].[DimAppointment]
									   ( [DataPkgKey]
										, [AppointmentKey]
										, [AppointmentSSID]
										, [CenterKey]
										, [CenterSSID]
										, [ClientHomeCenterKey]
										, [ClientHomeCenterSSID]
										, [ClientKey]
										, [ClientSSID]
										, [ClientMembershipKey]
										, [ClientMembershipSSID]
										, [AppointmentDate]
										, [ResourceSSID]
										, [ResourceDescription]
										, [ConfirmationTypeSSID]
										, [ConfirmationTypeDescription]
										, [AppointmentTypeSSID]
										, [AppointmentTypeDescription]
										, [AppointmentStartTime]
										, [AppointmentEndTime]
										, [CheckInTime]
										, [CheckOutTime]
										, [AppointmentSubject]
										, [AppointmentStatusSSID]
										, [AppointmentStatusDescription]
										, [OnContactActivitySSID]
										, [OnContactContactSSID]
										, [CanPrinTCommentFlag]
										, [IsNonAppointmentFlag]
										, [IsDeletedFlag]
										, [SFDC_LeadID]
										, [SFDC_TaskID]
										, [IsException]
										, [IsDelete]
										, [IsDuplicate]
										, [SourceSystemKey]
										, [CDC_Operation]
										)
							SELECT @DataPkgKey
										, 0 AS [AppointmentKey]
										, COALESCE(chg.[AppointmentGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [AppointmentSSID]
										, 0 AS [CenterKey]
										, COALESCE(chg.[CenterID],-2) AS [CenterSSID]
										, 0 AS [ClientHomeCenterKey]
										, ISNULL(cl.[CenterID],chg.centerid) AS [CenterSSID]
										, 0 AS [ClientKey]
										, COALESCE(chg.[ClientGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [ClientSSID]
										, 0 AS [ClientMembershipKey]
										, COALESCE(chg.[ClientMembershipGUID], CONVERT(UNIQUEIDENTIFIER,'00000000-0000-0000-0000-000000000002')) AS [OrigClientMembershipSSID]
										, chg.AppointmentDate  AS [AppointmentDate]-- [bief_stage].[fn_GetUTCDateTime](hso.HairSystemOrderDate, hso.[CenterID]) as 'HairSystemOrderDate'
										, res.ResourceID AS [ResourceSSID]
										, res.ResourceDescription AS [ResourceDescription]
										, chg.ConfirmationTypeID AS [ConfirmationTypeSSID]
										, cnftype.ConfirmationTypeDescription AS [ConfirmationTypeDescrption]
										, chg.AppointmentTypeID AS [AppointmentTypeSSID]
										, appttype.AppointmentTypeDescription AS [AppointmentTypeDescription]
										, chg.StartTime AS [AppointmentStartTime]
										, chg.EndTime AS [AppointmentEndTime]
										, chg.CheckinTime AS [CheckInTime]
										, chg.CheckoutTime AS [CheckOutTime]
										, chg.AppointmentSubject AS [AppointmentSubject]
										, chg.AppointmentStatusID AS [AppointmentStatusID]
										, apptstatus.AppointmentStatusDescription as [AppointmentStatusDescription]
										, chg.OnContactActivityID AS [OnContactActivityID]
										, chg.OnContactContactID AS [OnContactContactID]
										, chg.CanPrintCommentFlag AS [CanPrintCommentFlag]
										, chg.IsNonAppointmentFlag AS [IsNonAppointmentFlag]
										, chg.IsDeletedFlag AS [IsDeletedFlag]
										, chg.[SalesforceContactID]
										, chg.[SalesforceTaskID]
	    								, 0 AS [IsException]
										, 0 AS [IsDelete]
										, 0 AS [IsDuplicate]
										, CAST(ISNULL(LTRIM(RTRIM(chg.AppointmentGUID)),'') AS nvarchar(50)) AS [SourceSystemKey]
										, CASE [__$operation]
											WHEN 1 THEN 'D'
											WHEN 2 THEN 'I'
											WHEN 3 THEN 'UO'
											WHEN 4 THEN 'UN'
											WHEN 5 THEN 'M'
											ELSE NULL
										END AS [CDC_Operation]
							FROM [HairClubCMS].[cdc].[fn_cdc_get_net_changes_dbo_datAppointment](@From_LSN, @To_LSN, @row_filter_option) chg
								LEFT OUTER JOIN HairClubCMS.dbo.datClient  cl on
									chg.ClientGUID = cl.ClientGUID
								LEFT OUTER JOIN bi_cms_stage.synHC_SRC_TBL_CMS_cfgResource res on
									chg.ResourceID = res.ResourceID
								LEFT OUTER JOIN bi_cms_stage.synHC_SRC_TBL_CMS_lkpConfirmationType cnftype on
									chg.ConfirmationTypeID = cnftype.ConfirmationTypeID
								LEFT OUTER JOIN bi_cms_stage.synHC_SRC_TBL_CMS_lkpAppointmentType appttype on
									chg.AppointmentTypeID = appttype.AppointmentTypeID
								LEFT OUTER JOIN bi_cms_stage.synHC_SRC_TBL_CMS_lkpAppointmentStatus apptstatus on
									chg.AppointmentStatusID = apptstatus.AppointmentStatusID

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
