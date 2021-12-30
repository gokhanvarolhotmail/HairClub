/* CreateDate: 12/09/2008 00:11:46.953 , ModifyDate: 10/27/2014 10:02:38.283 */
GO
CREATE PROCEDURE [dbo].[pso_PopluateNobleData] (
	@filter nchar(1000)
)
AS

BEGIN
	SET NOCOUNT ON
	DECLARE @sql varchar(MAX)
	DECLARE @Text NVARCHAR(500)
	DECLARE @EndOfToday varchar(30)

	SET @EndOfToday = CONVERT(nchar(10), GETDATE(), 121) + ' 23:59:59'

	SET @Text = 'Rebuild Queue Index: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Noble Daily Export', @Text)

	ALTER index oncd_activity_i19 ON oncd_activity REBUILD

	SET @Text = 'Refresh Contact Flat: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Noble Daily Export', @Text)

	EXEC [dbo].[pso_RefreshCstdContactFlatData]

	--SET @Text = 'Clear Queue Assignments: ' + CAST(GETDATE() AS CHAR)
	--RAISERROR(@Text,0,1) WITH NOWAIT
	--INSERT INTO cstd_sql_job_log (name, message) VALUES ('Noble Daily Export', @Text)

	--UPDATE oncd_activity SET cst_queue_id = NULL, cst_in_noble_queue = 'N'
	--WHERE result_code IS NULL AND cst_queue_id IS NOT NULL

	SET @Text = 'Clear Noble Export Data: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Noble Daily Export', @Text)

	TRUNCATE TABLE cstd_noble_export_data

	SET @sql = '
	insert into cstd_noble_export_data (
	ContactID,
	FirstName,
	LastName,
	LeadCreationDate,
	LeadCreatedBy,
	City,
	StateName,
	ZipCode,
	TimeZone,
	HairLossAltDesc,
	AgeRangeDesc,
	LanguageDesc,
	PromoCodeDesc,
	GenderDesc,
	TotalNumOfAppts,
	NumOfNoShowAppts,
	NumOfShowSaleAppts,
	NumOfCancelAppts,
	NumOfReschedAppts,
	PrimaryCenterNum,
	PrimaryCenterName,
	CntryCodePrePri,
	AreaCodePri,
	PhoneNumberPri,
	PhoneTypeCodePri,
	CntryCodePreBus,
	AreaCodeBus,
	PhoneNumberBus,
	PhoneTypeCodeBus,
	CntryCodePreHM,
	AreaCodeHM,
	PhoneNumberHM,
	PhoneTypeCodeHM,
	CntryCodePreCL,
	AreaCodeCL,
	PhoneNumberCL,
	PhoneTypeCodeCL,
	CntryCodePreHM2,
	AreaCodeHM2,
	PhoneNumberHM2,
	PhoneTypeCodeHM2,
	PriSourceCodeDesc,
	OpenCallActivityId,
	ActionCodeDesc,
	DueDate,
	StartTime,
	CurrentSourceCode,
	LastActvityDate,
	LastResultDesc,
	CurrOpenApptDate,
	CurrOpenApptTime,
	CurrOpenApptType,
	DateOfLastAppt,
	LastApptResultDesc
	)
	select distinct
	cstd_contact_flat.contact_id,
	cstd_contact_flat.first_name,
	cstd_contact_flat.last_name,
	CONVERT(varchar(10),cstd_contact_flat.lead_creation_date,101),
	cstd_contact_flat.lead_created_by_display_name,
	REPLACE(cstd_contact_flat.city,'','',''''),
	cstd_contact_flat.state_description,
	cstd_contact_flat.zip_code,
	cstd_contact_flat.time_zone_code,
	cstd_contact_flat.hair_loss_alternative_description,
	cstd_contact_flat.age_range_description,
	cstd_contact_flat.language_description,
	cstd_contact_flat.promotion_description,
	cstd_contact_flat.gender_description,
	cstd_contact_flat.total_appointments,
	cstd_contact_flat.no_show_appointments,
	cstd_contact_flat.show_sale_appointments,
	cstd_contact_flat.canceled_appointments,
	cstd_contact_flat.rescheduled_appointments,
	primary_center_number,
	primary_center_name,
	call_country_code_prefix,
	call_area_code,
	call_phone_number,
	call_phone_type_description,
	business_country_code_prefix,
	business_area_code,
	business_phone_number,
	business_phone_type_description,
	home_country_code_prefix,
	home_area_code,
	home_phone_number,
	home_phone_type_description,
	CASE WHEN has_open_confirmation_call = ''Y'' THEN cell_country_code_prefix ELSE NULL END,
	CASE WHEN has_open_confirmation_call = ''Y'' THEN cell_area_code ELSE NULL END,
	CASE WHEN has_open_confirmation_call = ''Y'' THEN cell_phone_number ELSE NULL END,
	CASE WHEN has_open_confirmation_call = ''Y'' THEN cell_phone_type_description ELSE NULL END,
	home_2_country_code_prefix,
	home_2_area_code,
	home_2_phone_number,
	home_2_phone_type_description,
	primary_source_description,
	open_call_activity_id,
	open_call_action_description,
	open_call_due_date,
	open_call_start_time,
	current_source_description,
	last_activity_date,
	last_activity_result_description,
	current_appointment_date,
	current_appointment_time,
	current_appointment_type,
	last_appointment_date,
	last_appointment_result_description
	from cstd_contact_flat (NOLOCK)
	INNER JOIN oncd_activity_contact (NOLOCK) on cstd_contact_flat.contact_id = oncd_activity_contact.contact_id
	INNER JOIN oncd_activity (NOLOCK) on oncd_activity_contact.activity_id = oncd_activity.activity_id
	LEFT OUTER JOIN onca_phone_type ppt ON ppt.phone_type_code = primary_phone_type_code '

	-- Hit maximum size we can set at once so split it into two statements.
	SET @Sql = @Sql + '
	where cstd_contact_flat.time_zone_code IS NOT NULL
	and (call_phone_number IS NOT NULL OR business_phone_number IS NOT NULL OR home_phone_number IS NOT NULL OR (cell_phone_number IS NOT NULL AND has_open_confirmation_call = ''Y'') OR home_2_phone_number IS NOT NULL)
	and open_call_activity_id IS NOT NULL
	and do_not_call = ''N'' AND do_not_solicit = ''N''
	and((contact_status_code = ''LEAD''
	and (exists ( select 1 from oncd_activity (NOLOCK) a
	inner join oncd_activity_contact (NOLOCK) ac on ac.activity_id = a.activity_id
	and ac.contact_id = cstd_contact_flat.contact_id where a.due_date <= ''' + @EndOfToday + '''
	and (a.result_code = '''' or a.result_code is null)
	and a.action_code <> ''APPOINT'')))
	OR
	(exists( select 1 from oncd_activity (NOLOCK) a2
		inner join oncd_activity_contact (NOLOCK) ac2 on ac2.activity_id = a2.activity_id
		and ac2.contact_id = cstd_contact_flat.contact_id where a2.action_code = ''CONFIRM''
		and (a2.result_code = '''' or a2.result_code is null) ))
	OR
	(contact_status_code = ''LEAD''
	and cstd_contact_flat.created_by_user_code = ''TM 600''
	and (exists ( select 1 from oncd_activity (NOLOCK) a
	inner join oncd_activity_contact (NOLOCK) ac on ac.activity_id = a.activity_id
	and ac.contact_id = cstd_contact_flat.contact_id where a.due_date >= ''' + LEFT(@EndOfToday,10) + '''
	and (a.result_code = '''' or a.result_code is null)
	and a.action_code = ''BROCHCALL''))))
	and (' + dbo.psoQueueDialerFilter(GETDATE()) + ') AND ' + @filter

	SET @Text = 'Populate Noble Export Data: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	RAISERROR(@filter,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Noble Daily Export', @Text)

	EXEC (@sql)

	SET @Text = 'Assign Noble Queue: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Noble Daily Export', @Text)

	DECLARE @QueueId NCHAR(10)
	SET @QueueId = dbo.psoQueueDialerId(GETDATE())

	--INSERT INTO csta_queue_history (queue_date, queue_id, activity_id)
	--SELECT GETDATE(), @QueueId, activity_id
	--FROM oncd_activity
	--INNER JOIN cstd_noble_export_data ON oncd_activity.activity_id = cstd_noble_export_data.OpenCallActivityId
	--WHERE oncd_activity.cst_queue_id = @QueueId

	--SET @Text = 'Noble Queue non-Sets Queue History: ' + CAST(@@ROWCOUNT AS CHAR)
	--RAISERROR(@Text,0,1) WITH NOWAIT
	--INSERT INTO cstd_sql_job_log (name, message) VALUES ('Noble Daily Export', @Text)

	--Only Update rows where Queue is changing
	UPDATE oncd_activity
	SET cst_queue_id = @QueueId, cst_in_noble_queue = 'Y'
	FROM oncd_activity
	INNER JOIN cstd_noble_export_data ON oncd_activity.activity_id = cstd_noble_export_data.OpenCallActivityId
	WHERE oncd_activity.cst_queue_id <> @QueueId OR oncd_activity.cst_queue_id IS NULL

	SET @Text = 'Noble Queue Sets: ' + CAST(@@ROWCOUNT AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Noble Daily Export', @Text)

	--Reset any that were previously Noble but now arent, so they're available to other queues
	UPDATE oncd_activity
	SET cst_queue_id = NULL, cst_in_noble_queue = 'N'
	FROM oncd_activity
	LEFT OUTER JOIN cstd_noble_export_data ON cstd_noble_export_data.OpenCallActivityId = oncd_activity.activity_id
	WHERE result_code IS NULL AND cst_in_noble_queue = 'Y' AND cstd_noble_export_data.OpenCallActivityId IS NULL

	SET @Text = 'Noble Queue Clears: ' + CAST(@@ROWCOUNT AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Noble Daily Export', @Text)

	SET @Text = 'Remove Unicode: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Noble Daily Export', @Text)

	EXEC pso_RemoveNobleExportDataUnicode

	SET @Text = 'Assign Queues: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Noble Daily Export', @Text)

	EXEC psoQueueAssignActivities

	SET @Text = 'Backup Export Data: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Noble Daily Export', @Text)

	TRUNCATE TABLE backup_cstd_noble_export_data
	INSERT INTO backup_cstd_noble_export_data SELECT * FROM cstd_noble_export_data

	SET @Text = 'Process Completed: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Noble Daily Export', @Text)
END
GO
