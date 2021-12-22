/* CreateDate: 03/22/2016 11:02:44.640 , ModifyDate: 03/22/2016 11:02:44.640 */
GO
-- =============================================
-- Author:		MJW - Workwise, LLC
-- Create date: 2016-01-22
-- Description:	Select phone numbers for DNC/Wireless scrub export
-- =============================================
CREATE PROCEDURE [dbo].[pso_DNCWirelessExport]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @Text nvarchar(500)

	SET @Text = 'Start: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('DNCWirelessExport', @Text)

	DECLARE @id uniqueidentifier
	SET @id = NEWID()

	INSERT INTO cstd_phone_dnc_wireless_job (phone_dnc_wireless_job_id, export_date, exported_by_user_code)
		VALUES (@id, GETDATE(), 'WIRELESS_SCRUB')

	SET @Text = 'InsertCstdContactFlat: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('DNCWirelessExport', @Text)

	EXEC [dbo].[pso_InsertCstdContactFlatContacts]

	SET @Text = 'Create EBR Temp: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('DNCWirelessExport', @Text)

	CREATE TABLE #contactebr (contact_id nchar(10), EBRDate datetime)

	INSERT INTO #contactebr
		SELECT c.contact_id, MAX(DATEADD(dd, DATEDIFF(dd, 0, a.creation_date), 0))
		FROM oncd_contact c WITH (NOLOCK)
		INNER JOIN oncd_activity_contact ac WITH (NOLOCK) ON ac.contact_id = c.contact_id
		INNER JOIN oncd_activity a WITH (NOLOCK) ON a.activity_id = ac.activity_id
				AND ((a.action_code IN ('INCALL','INHOUSE','BOSLEAD','BOSCLIENT')
					AND a.result_code IS NOT NULL
					AND a.result_code NOT IN ('WRNGNUM', 'PRANK', 'NOCALL', 'NOCONTACT', 'NOTEXT'))
				OR a.result_code = 'SHOWNOSALE')
		INNER JOIN cstd_contact_flat cf ON cf.contact_id = c.contact_id
		GROUP BY c.contact_id

	CREATE NONCLUSTERED INDEX ebr_1 ON #contactebr (contact_id ASC)


	TRUNCATE TABLE cstd_phone_dnc_wireless_export_staging

	SET @Text = 'Main Select: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('DNCWirelessExport', @Text)

	INSERT INTO cstd_phone_dnc_wireless_export_staging
	SELECT pn, MAX(EBR), @id FROM
	(
	SELECT pn, #contactebr.EBRDate AS EBR, t.contact_id
	FROM
	(
	SELECT DISTINCT cp.contact_id, cp.cst_full_phone_number AS pn
	FROM oncd_contact_phone cp WITH (NOLOCK)
	INNER JOIN cstd_contact_flat cf (NOLOCK) ON cf.contact_id = cp.contact_id
		INNER JOIN oncd_activity_contact (NOLOCK) on cf.contact_id = oncd_activity_contact.contact_id
		INNER JOIN oncd_activity (NOLOCK) on oncd_activity_contact.activity_id = oncd_activity.activity_id
		LEFT OUTER JOIN onca_phone_type ppt ON ppt.phone_type_code = primary_phone_type_code
		LEFT OUTER JOIN cstd_phone_dnc_wireless o ON o.phonenumber = cp.cst_full_phone_number
	WHERE EXISTS
		(SELECT 1 FROM oncd_activity_contact ac WITH (NOLOCK)
			INNER JOIN oncd_activity a WITH (NOLOCK) ON a.activity_id = ac.activity_id
			LEFT OUTER JOIN onca_action ax ON ax.action_code = a.action_code
			WHERE ac.contact_id = cp.contact_id
				AND a.result_code IS NULL
				AND ax.cst_is_outbound_call = 'Y'
				AND a.due_date < CONVERT(datetime, CONVERT(nchar(10), DATEADD(d, 4, GETDATE()), 121))
		)
	AND cp.cst_valid_flag = 'Y'
	AND (o.last_vendor_update < DATEADD(d, -11, CONVERT(nchar(10), GETDATE(), 121)) OR o.last_vendor_update IS NULL)
	AND cf.time_zone_code IS NOT NULL
--		and (call_phone_number IS NOT NULL OR business_phone_number IS NOT NULL OR home_phone_number IS NOT NULL OR (cell_phone_number IS NOT NULL ) OR home_2_phone_number IS NOT NULL)
		and open_call_activity_id IS NOT NULL
		and do_not_call = 'N' AND do_not_solicit = 'N'
		and((contact_status_code = 'LEAD'
		and (exists ( select 1 from oncd_activity (NOLOCK) a
		inner join oncd_activity_contact (NOLOCK) ac on ac.activity_id = a.activity_id
		and ac.contact_id = cf.contact_id where a.due_date < CONVERT(datetime, CONVERT(nchar(10), DATEADD(d, 2, GETDATE()), 121))
		and (a.result_code = '' or a.result_code is null)
		and a.action_code <> 'APPOINT')))
		OR
		(exists( select 1 from oncd_activity (NOLOCK) a2
			inner join oncd_activity_contact (NOLOCK) ac2 on ac2.activity_id = a2.activity_id
			and ac2.contact_id = cf.contact_id where a2.action_code = 'CONFIRM'
			and (a2.result_code = '' or a2.result_code is null) ))
		OR
		(contact_status_code = 'LEAD'
		and cf.created_by_user_code = 'TM 600'
		and (exists ( select 1 from oncd_activity (NOLOCK) a
		inner join oncd_activity_contact (NOLOCK) ac on ac.activity_id = a.activity_id
		and ac.contact_id = cf.contact_id where a.due_date >= CONVERT(datetime, CONVERT(nchar(10), DATEADD(d, 1, GETDATE()), 121))
		and (a.result_code = '' or a.result_code is null)
		and a.action_code = 'BROCHCALL'))))
	--	and (dbo.psoQueueDialerFilter(DATEADD(d, 1, GETDATE())))

	) t
	LEFT OUTER JOIN #contactebr ON #contactebr.contact_id = t.contact_id
	) u GROUP BY pn

	SET @Text = 'Populate Wireless Job Detail: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('DNCWirelessExport', @Text)

	DECLARE @phonenumber nvarchar(30)
	DECLARE @rownumber int
	DECLARE @phone_dnc_wireless_job_detail_id uniqueidentifier
	DECLARE phones CURSOR FAST_FORWARD FOR
		SELECT phonenumber FROM cstd_phone_dnc_wireless_export_staging

	SET @rownumber = 0

	OPEN phones
	FETCH phones INTO @phonenumber
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @rownumber = @rownumber + 1
		INSERT INTO cstd_phone_dnc_wireless_job_detail (phone_dnc_wireless_job_detail_id, phone_dnc_wireless_job_id, row_id, phonenumber, dnc_flag, wireless_flag, nxx_flag)
			VALUES (NEWID(), @id, @rownumber, @phonenumber, 'N', 'N', 'N')

		FETCH phones INTO @phonenumber
	END

	CLOSE phones
	DEALLOCATE phones

	SET @Text = 'Complete: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('DNCWirelessExport', @Text)

END
GO
