/* CreateDate: 06/27/2011 17:22:53.450 , ModifyDate: 11/28/2017 16:18:02.443 */
GO
CREATE PROCEDURE [bi_cms_stage].[spHC_DimAppointment_Transform_SetIsNewSCD]
			  @DataPkgKey				int


AS
-------------------------------------------------------------------------
-- [spHC_DimAppointment_Transform_SetIsNewSCD] is used to determine which records
-- are NEW, which records are SCD Type 1 or Type 2
--
--
--   exec [bi_cms_stage].[spHC_DimAppointment_Transform_SetIsNewSCD] 422
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    06/01/2009  RLifke       Initial Creation
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

 	SET @TableName = N'[bi_cms_dds].[DimAppointment]'

	IF (@DataPkgKey = -1) SET @DataPkgKey = Null

	BEGIN TRY

		-----------------------
		-- Check for new rows
		-----------------------
		UPDATE STG SET
		     [AppointmentKey] = DW.[AppointmentKey]
			,IsNew = CASE WHEN DW.[AppointmentKey] IS NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimAppointment] STG
		LEFT OUTER JOIN [bi_cms_stage].[synHC_DDS_DimAppointment] DW ON
				DW.[AppointmentSSID] = STG.[AppointmentSSID]
			AND DW.[RowIsCurrent] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for Inferred Members
		-----------------------
		UPDATE STG SET
			IsInferredMember = CASE WHEN DW.[AppointmentKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimAppointment] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimAppointment] DW ON
				 STG.[AppointmentSSID] = DW.[AppointmentSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 1
		WHERE STG.[DataPkgKey] = @DataPkgKey



		-----------------------
		-- Check for SCD Type 1
		-----------------------
		UPDATE STG SET
			IsType1 = CASE WHEN DW.[AppointmentKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimAppointment] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimAppointment] DW ON
				 STG.[AppointmentSSID] = DW.[AppointmentSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE   1=1   -- 1=0 No Fields Change to 1=1 when there are SCD Type 1 fields
			AND ( COALESCE(STG.ResourceSSID,'') <> COALESCE(DW.ResourceSSID,'')
				OR COALESCE(STG.ResourceDescription,'') <> COALESCE(DW.ResourceDescription,'')
				OR COALESCE(STG.ConfirmationTypeSSID,'') <> COALESCE(DW.ConfirmationTypeSSID,'')
				OR COALESCE(STG.ConfirmationTypeDescription,'') <> COALESCE(DW.ConfirmationTypeDescription,'')
				OR COALESCE(STG.CenterKey,'') <> COALESCE(DW.CenterKey,'')
				OR COALESCE(STG.CenterSSID,'') <> COALESCE(DW.CenterSSID,'')
				OR COALESCE(STG.ClientHomeCenterKey,'') <> COALESCE(DW.ClientHomeCenterKey,'')
				OR COALESCE(STG.ClientHomeCenterSSID,'') <> COALESCE(DW.ClientHomeCenterSSID,'')
				OR COALESCE(STG.AppointmentTypeSSID,'') <> COALESCE(DW.AppointmentTypeSSID,'')
				OR COALESCE(STG.AppointmentTypeDescription,'') <> COALESCE(DW.AppointmentTypeDescription,'')
				OR COALESCE(STG.ClientKey,'') <> COALESCE(DW.ClientKey,'')
				OR COALESCE(STG.ClientSSID,'') <> COALESCE(DW.ClientSSID,'')
				OR COALESCE(STG.ClientMembershipKey,'') <> COALESCE(DW.ClientMembershipKey,'')
				OR COALESCE(STG.ClientMembershipSSID,'') <> COALESCE(DW.ClientMembershipSSID,'')
				OR COALESCE(STG.AppointmentDate,'') <> COALESCE(DW.AppointmentDate,'')
				OR COALESCE(STG.AppointmentStartTime,'') <> COALESCE(DW.AppointmentStartTime,'')
				OR COALESCE(STG.AppointmentEndTime,'') <> COALESCE(DW.AppointmentEndTime,'')
				OR COALESCE(STG.CheckInTime,'') <> COALESCE(DW.CheckInTime,'')
				OR COALESCE(STG.CheckOutTime,'') <> COALESCE(DW.CheckOutTime,'')
				OR COALESCE(STG.AppointmentSubject,'') <> COALESCE(DW.AppointmentSubject,'')
				OR COALESCE(STG.AppointmentStatusSSID,'') <> COALESCE(DW.AppointmentStatusSSID,'')
				OR COALESCE(STG.AppointmentStatusDescription,'') <> COALESCE(DW.AppointmentStatusDescription,'')
				OR COALESCE(STG.OnContactActivitySSID,'') <> COALESCE(DW.OnContactActivitySSID,'')
				OR COALESCE(STG.OnContactContactSSID,'') <> COALESCE(DW.OnContactContactSSID,'')
				OR COALESCE(STG.CanPrintCommentFlag,'') <> COALESCE(DW.CanPrintCommentFlag,'')
				OR COALESCE(STG.IsNonAppointmentFlag,'') <> COALESCE(DW.IsNonAppointmentFlag,'')
				OR COALESCE(STG.IsDeletedFlag,'') <> COALESCE(DW.IsDeletedFlag,'')
				OR COALESCE(STG.SFDC_LeadID,'') <> COALESCE(DW.SFDC_LeadID,'')
				OR COALESCE(STG.SFDC_TaskID,'') <> COALESCE(DW.SFDC_TaskID,'')

				)
		AND STG.[DataPkgKey] = @DataPkgKey

		-----------------------
		-- Check for SCD Type 2
		-----------------------
		UPDATE STG SET
			IsType2 = CASE WHEN DW.[AppointmentKey] IS NOT NULL
					THEN 1 ELSE 0 END
		FROM [bi_cms_stage].[DimAppointment] STG
		INNER JOIN [bi_cms_stage].[synHC_DDS_DimAppointment] DW ON
				 STG.[AppointmentSSID] = DW.[AppointmentSSID]
			AND DW.[RowIsCurrent] = 1
			AND DW.[RowIsInferred] = 0
		WHERE  1=0   -- 1=0 No Fields Change to 1=1 when there are SCD Type 2 fields
			--AND ( COALESCE(STG.InvoiceNumber,'') <> COALESCE(DW.InvoiceNumber,'')
			--	OR COALESCE(STG.FulfillmentNumber,'') <> COALESCE(DW.FulfillmentNumber,'')
			--	OR COALESCE(STG.TenderTransactionNumber_Temp,'') <> COALESCE(DW.TenderTransactionNumber_Temp,'')
			--	OR COALESCE(STG.TicketNumber_Temp,'') <> COALESCE(DW.TicketNumber_Temp,'')
				--OR COALESCE(STG.TicketNumber_Temp,'') <> COALESCE(DW.TicketNumber_Temp,'')
				--OR COALESCE(STG.CenterKey,'') <> COALESCE(DW.CenterKey,'')
				--OR COALESCE(STG.CenterSSID,'') <> COALESCE(DW.CenterSSID,'')
				--OR COALESCE(STG.ClientHomeCenterKey,'') <> COALESCE(DW.ClientHomeCenterKey,'')
				--OR COALESCE(STG.ClientHomeCenterSSID,'') <> COALESCE(DW.ClientHomeCenterSSID,'')
				--OR COALESCE(STG.AppointmentTypeKey,'') <> COALESCE(DW.AppointmentTypeKey,'')
				--OR COALESCE(STG.AppointmentTypeSSID,'') <> COALESCE(DW.AppointmentTypeSSID,'')
				--OR COALESCE(STG.ClientKey,'') <> COALESCE(DW.ClientKey,'')
				--OR COALESCE(STG.ClientSSID,'') <> COALESCE(DW.ClientSSID,'')
				--OR COALESCE(STG.ClientMembershipKey,'') <> COALESCE(DW.ClientMembershipKey,'')
				--OR COALESCE(STG.ClientMembershipSSID,'') <> COALESCE(DW.ClientMembershipSSID,'')
			--	OR COALESCE(STG.OrderDate,'') <> COALESCE(DW.OrderDate,'')
			--	OR COALESCE(STG.IsTaxExemptFlag,'') <> COALESCE(DW.IsTaxExemptFlag,'')
			--	OR COALESCE(STG.IsVoidedFlag,'') <> COALESCE(DW.IsVoidedFlag,'')
			--	OR COALESCE(STG.IsClosedFlag,'') <> COALESCE(DW.IsClosedFlag,'')
			--	OR COALESCE(STG.IsWrittenOffFlag,'') <> COALESCE(DW.IsWrittenOffFlag,'')
			--	OR COALESCE(STG.IsRefundedFlag,'') <> COALESCE(DW.IsRefundedFlag,'')
				--OR COALESCE(STG.RefundedAppointmentKey,'') <> COALESCE(DW.RefundedAppointmentKey,'')
				--OR COALESCE(STG.RefundedAppointmentGUID,'') <> COALESCE(DW.RefundedAppointmentGUID,'')
				--OR COALESCE(STG.EmployeeKey,'') <> COALESCE(DW.EmployeeKey,'')
				--OR COALESCE(STG.EmployeeGUID,'') <> COALESCE(DW.EmployeeGUID,'')
			--	)
		AND STG.[DataPkgKey] = @DataPkgKey;


		-----------------------
		-- Check for duplicate records
		-----------------------
		WITH Duplicates  AS
			(SELECT  AppointmentSSID
						, IsDuplicate
					  , row_number() OVER ( PARTITION BY AppointmentSSID ORDER BY AppointmentSSID ) AS RowNum
			   FROM  [bi_cms_stage].[DimAppointment] STG
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
		FROM [bi_cms_stage].[DimAppointment] STG
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
