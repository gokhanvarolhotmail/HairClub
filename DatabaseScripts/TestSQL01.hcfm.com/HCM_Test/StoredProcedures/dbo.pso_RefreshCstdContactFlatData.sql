/* CreateDate: 09/17/2014 10:09:13.697 , ModifyDate: 03/22/2017 16:53:21.263 */
GO
CREATE PROCEDURE [dbo].[pso_RefreshCstdContactFlatData]
AS

BEGIN
	SET NOCOUNT ON
	DECLARE @sql varchar(MAX)
	DECLARE @Text NVARCHAR(500)

	SET @Text = 'Add Contacts to Flat as Needed: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Refresh Contact Flat Data', @Text)

	EXEC pso_InsertCstdContactFlatContacts

	SET @Text = 'Create Temp Table: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT

	CREATE TABLE #actemp (
	activity_contact_id nchar(10) PRIMARY KEY,
	activity_id			nchar(10) NOT NULL,
	contact_id			nchar(10) NOT NULL,
	source_code			nchar(20) NULL,
	action_code			nchar(10) NULL,
	result_code			nchar(10) NULL,
	cst_activity_type_code nchar(10) NULL,
	due_date			datetime NULL,
	start_time			datetime NULL,
	completion_date		datetime NULL,
	completion_time		datetime NULL)

	INSERT INTO #actemp
	SELECT ac.activity_contact_id, a.activity_id, ac.contact_id, a.source_code, a.action_code, a.result_code, a.cst_activity_type_code, a.due_date, a.start_time, a.completion_date, a.completion_time
	FROM oncd_activity a WITH (NOLOCK)
	INNER JOIN oncd_activity_contact ac WITH (NOLOCK) ON ac.activity_id = a.activity_id
	INNER JOIN cstd_contact_flat ON cstd_contact_flat.contact_id = ac.contact_id

	CREATE NONCLUSTERED INDEX act_1 ON #actemp (contact_id ASC, result_code ASC, action_code ASC) INCLUDE (due_date, start_time, completion_date, completion_time)

	SET @Text = 'Clear Call Data: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Refresh Contact Flat Data', @Text)

	UPDATE cstd_contact_flat SET
		has_open_confirmation_call = CASE WHEN ac.activity_id IS NOT NULL THEN 'Y' ELSE 'N' END,
		call_country_code_prefix = NULL,
		call_area_code = NULL,
		call_phone_number = NULL,
		call_phone_type_code = NULL,
		call_phone_type_description = NULL,
		call_phone_id  = NULL
	FROM cstd_contact_flat
	LEFT OUTER JOIN oncd_activity_contact ac WITH (NOLOCK) ON ac.contact_id = cstd_contact_flat.contact_id
	AND EXISTS (SELECT 1 FROM oncd_activity WITH (NOLOCK) WHERE activity_id = ac.activity_id AND action_code = 'CONFIRM' AND result_code IS NULL)

	SET @Text = 'Update Contact Data: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Refresh Contact Flat Data', @Text)
	--Make sure status, dnc, dns are up to date
	UPDATE cstd_contact_flat SET
		contact_status_code = c.contact_status_code,
		do_not_call = c.cst_do_not_call,
		do_not_solicit = c.do_not_solicit
	FROM cstd_contact_flat
	LEFT OUTER JOIN oncd_contact c ON c.contact_id = cstd_contact_flat.contact_id


	SET @Text = 'Set Open Call Data: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Refresh Contact Flat Data', @Text)

	-- Remove EXOUTCALL from list of calls per Erika Defalco on 18 April 2014.
	-- Add BOSREFDCALL to list of call action codes per Michael Libeson 2016-08-26
	-- ReAdd EXOUTCALL to list of call action codes per Michael Libeson 2017-03-09
	update cstd_contact_flat set
		open_call_activity_id = a1.activity_id,
		open_call_action_description = ac.description,
		open_call_due_date = CONVERT(varchar(10),a1.due_date,101),
		open_call_start_time = CONVERT(varchar(5),a1.start_time,8),
		current_source_description = s.description
	from #actemp (NOLOCK) a1
		LEFT OUTER JOIN onca_action ac ON ac.action_code = a1.action_code
		left join onca_source s (NOLOCK) ON a1.source_code = s.source_code
		inner join oncd_activity_contact (NOLOCK) ac1 on ac1.activity_id = a1.activity_id
		and a1.result_code is null
		and (a1.action_code IN ('CONFIRM','EXOUTCALL','OUTSELECT','BROCHCALL','CANCELCALL','NOSHOWCALL','SHNOBUYCAL','BOSREFCALL','OUTCALL'))
	where ac1.contact_id = cstd_contact_flat.contact_id

	SET @Text = 'Set Last Activity Data 1: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Refresh Contact Flat Data', @Text)

	UPDATE cstd_contact_flat SET
		last_activity_date = CONVERT(varchar(10),a.completion_date,101),
		last_activity_result_description = ar.description
	FROM #actemp a WITH (NOLOCK)
	INNER JOIN onca_result ar WITH (NOLOCK) ON a.result_code = ar.result_code
	WHERE
	a.result_code IS NOT NULL AND
	a.activity_contact_id = (
		SELECT TOP 1 act.activity_contact_id
		FROM #actemp (NOLOCK) act
		WHERE
		act.contact_id = cstd_contact_flat.contact_id AND
		act.result_code is not null AND act.completion_date is not null
		ORDER BY act.completion_date desc, act.completion_time desc)

	SET @Text = 'Set Last Activity Data 2: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Refresh Contact Flat Data', @Text)

	update cstd_contact_flat set
		last_activity_date = CONVERT(varchar(10),a.completion_time,101),
		last_activity_result_description = ar.description
	from #actemp (NOLOCK) a
		inner join onca_result (NOLOCK) ar on ar.result_code = a.result_code
	where a.activity_contact_id =
		(
		  select top 1 act.activity_contact_id
		  from #actemp (NOLOCK) act
		  where act.result_code is not null
			and act.completion_time is not null
			AND act.contact_id = cstd_contact_flat.contact_id
			order by act.completion_time desc
		)
		and cstd_contact_flat.last_activity_date is null

	SET @Text = 'Set Current Appointment Data: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Refresh Contact Flat Data', @Text)

	UPDATE cstd_contact_flat SET
		current_appointment_date = CONVERT(varchar(10),a.due_date,101),
		current_appointment_time = CONVERT(varchar(5),a.start_time,8),
		current_appointment_type = LEFT(at.description,20)
	FROM #actemp (NOLOCK) a
		INNER JOIN csta_activity_type (NOLOCK) at on at.activity_type_code = a.cst_activity_type_code
	WHERE
		a.activity_contact_id =
		(
		  SELECT TOP 1 act.activity_contact_id
		  FROM #actemp (NOLOCK) act
		  WHERE
			act.contact_id = cstd_contact_flat.contact_id AND
			act.action_code = 'APPOINT' AND
			act.result_code IS NULL
			ORDER BY act.due_date DESC, act.start_time DESC
		)

	SET @Text = 'Set Last Appointment Data: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Refresh Contact Flat Data', @Text)

	UPDATE cstd_contact_flat SET
		last_appointment_date = CONVERT(varchar(10),a.due_date,101),
		last_appointment_result_description = LEFT(r.description,50)
	FROM #actemp (NOLOCK) a
		INNER JOIN onca_result (NOLOCK) r on r.result_code = a.result_code
	WHERE
		a.activity_contact_id =
		(
		  SELECT TOP 1 act.activity_contact_id
		  FROM #actemp (NOLOCK) act
		  WHERE
			act.contact_id = cstd_contact_flat.contact_id AND
			act.action_code = 'APPOINT' AND
			act.result_code IS NOT NULL
			ORDER BY act.due_date DESC, act.start_time DESC
		)

	SET @Text = 'Set Current Source: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Refresh Contact Flat Data', @Text)

	update cstd_contact_flat set
		current_source_description = s.description
	from #actemp (NOLOCK) a
		left join onca_source s (NOLOCK) ON a.source_code = s.source_code
	WHERE
		current_source_description IS NULL AND
		a.activity_contact_id =
		(
		  SELECT TOP 1 act.activity_contact_id
		  FROM #actemp (NOLOCK) act
		  WHERE
			act.contact_id = cstd_contact_flat.contact_id
			ORDER BY act.due_date DESC, act.start_time DESC
		)

	update cstd_contact_flat set
		total_appointments =
			(select count(*) from #actemp (NOLOCK) a
			WHERE a.contact_id = cstd_contact_flat.contact_id
			AND a.action_code = 'APPOINT'
			and (a.result_code is not null and a.result_code != '')),
		no_show_appointments =
		(select count(*) from #actemp (NOLOCK) a
			WHERE a.contact_id = cstd_contact_flat.contact_id
			AND a.action_code = 'APPOINT'
			and (a.result_code = 'NOSHOW')),
		show_sale_appointments =
		(select count(*) from #actemp (NOLOCK) a
			WHERE a.contact_id = cstd_contact_flat.contact_id
			AND a.action_code = 'APPOINT'
			and (a.result_code = 'SHOWSALE')),
		canceled_appointments =
		(select count(*) from #actemp (NOLOCK) a
			WHERE a.contact_id = cstd_contact_flat.contact_id
			AND a.action_code = 'APPOINT'
			and (a.result_code = 'CANCEL')),
		rescheduled_appointments =
		(select count(*) from #actemp (NOLOCK) a
			WHERE a.contact_id = cstd_contact_flat.contact_id
			AND a.action_code = 'APPOINT'
			and (a.result_code = 'RESCHEDULE'))

	SET @Text = 'Set Phone Number: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Refresh Contact Flat Data', @Text)

	CREATE TABLE #uncallablecontactphones (contact_phone_id nchar(10))

	INSERT INTO #uncallablecontactphones
	SELECT DISTINCT contact_phone_id FROM
	(
		SELECT contact_phone_id
		FROM oncd_contact_phone cp
		INNER JOIN cstd_contact_flat cf ON cf.contact_id = cp.contact_id
		INNER JOIN cstd_phone_dnc_wireless dw ON dw.phonenumber = cp.cst_full_phone_number AND dw.dnc_flag = 'Y'
		WHERE cp.cst_valid_flag = 'Y'
		UNION ALL
		SELECT contact_phone_id
		FROM oncd_contact_phone cp
		INNER JOIN cstd_contact_flat cf ON cf.contact_id = cp.contact_id
		INNER JOIN cstd_phone_dnc_wireless dw ON dw.phonenumber = cp.cst_full_phone_number AND dw.ebr_dnc_flag = 'Y' AND cp.phone_type_code = 'SKIP'
		WHERE cp.cst_valid_flag = 'Y'
		UNION ALL
		SELECT contact_phone_id
		FROM oncd_contact_phone cp WITH (NOLOCK)
		INNER JOIN cstd_contact_flat cf ON cf.contact_id = cp.contact_id
		INNER JOIN cstd_phone_dnc_wireless dw ON dw.phonenumber = cp.cst_full_phone_number AND dw.ebr_dnc_flag = 'Y'
		WHERE NOT EXISTS (SELECT 1 FROM
			oncd_activity_contact ac WITH (NOLOCK)
			INNER JOIN oncd_activity a WITH (NOLOCK) ON a.activity_id = ac.activity_id
			AND ((a.action_code IN ('INCALL','INHOUSE','BOSLEAD','BOSCLIENT')
				AND a.result_code IS NOT NULL
				AND a.result_code NOT IN ('WRNGNUM', 'PRANK', 'NOCALL', 'NOCONTACT', 'NOTEXT'))
			OR a.result_code = 'SHOWNOSALE')
			AND a.creation_date > DATEADD(d,-90,GETDATE())
			WHERE ac.contact_id = cp.contact_id)
		AND cp.cst_valid_flag = 'Y'
	) t

	CREATE NONCLUSTERED INDEX ucp_1 ON #uncallablecontactphones (contact_phone_id ASC)

	SET @Text = 'Create Uncallable contact phones temp: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Refresh Contact Flat Data', @Text)

	--Update phone information; SKIP exeption introduced 12/2015 MJW Workwise
	--Reverse changes for SKIP 2016-04-01	MJW Workwise
	--Reimplement the sort_order logic element of the SKIP-related change; leave out the SKIP phone type logic 2016-04-06	MJW Workwise

	--Set Primary Phone
	-- Populate the primary phone
	---- unless it is a Cell Phone except if
	---- the lead has a confirmation call
--	UPDATE cstd_contact_flat SET
--		primary_country_code_prefix = cp.country_code_prefix,
--		primary_area_code = LEFT(cp.area_code,3),
--		primary_phone_number = LEFT(cp.phone_number,10),
--		primary_phone_type_code = cp.phone_type_code,
--		primary_phone_type_description = LEFT(pt.description,10),
--		primary_phone_id = cp.contact_phone_id
--	FROM cstd_contact_flat
--	LEFT OUTER JOIN	oncd_contact_phone (NOLOCK) cp ON cp.contact_id = cstd_contact_flat.contact_id
--		AND cp.primary_flag = 'Y'
--		AND cp.cst_valid_flag = 'Y'
----		AND cp.phone_type_code <> 'SKIP' --SKIP specific logic
--		--AND dbo.pso_IsPhoneCallable(cp.cst_full_phone_number, cstd_contact_flat.contact_id) = 'Y'
--		AND NOT EXISTS (SELECT 1 FROM #uncallablecontactphones WHERE contact_phone_id = cp.contact_phone_id)
--	LEFT OUTER JOIN onca_phone_type (NOLOCK) pt on pt.phone_type_code = cp.phone_type_code

--	SET @Text = 'Set Phone Number Primary: ' + CAST(GETDATE() AS CHAR)
--	RAISERROR(@Text,0,1) WITH NOWAIT
--	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Refresh Contact Flat Data', @Text)

	----SKIP logic for primary phone
	--sort_order logic for primary phone
	UPDATE cstd_contact_flat SET
		primary_country_code_prefix = cp.country_code_prefix,
		primary_area_code = LEFT(cp.area_code,3),
		primary_phone_number = LEFT(cp.phone_number,10),
		primary_phone_type_code = cp.phone_type_code,
		primary_phone_type_description = LEFT(pt.description,10),
		primary_phone_id = cp.contact_phone_id
	FROM cstd_contact_flat
	LEFT OUTER JOIN	oncd_contact_phone (NOLOCK) cp ON cp.contact_id = cstd_contact_flat.contact_id
		AND cp.contact_phone_id = (SELECT TOP 1 contact_phone_id FROM oncd_contact_phone cp2 WHERE cp2.contact_id = cstd_contact_flat.contact_id  AND cst_valid_flag = 'Y' --AND phone_type_code = 'SKIP'
--			AND dbo.pso_IsPhoneCallable(cp.cst_full_phone_number,cstd_contact_flat.contact_id) = 'Y'
		AND NOT EXISTS (SELECT 1 FROM #uncallablecontactphones WHERE contact_phone_id = cp.contact_phone_id)
			ORDER BY primary_flag DESC, sort_order)
	LEFT OUTER JOIN onca_phone_type (NOLOCK) pt on pt.phone_type_code = cp.phone_type_code
--	WHERE NOT (cstd_contact_flat.has_open_confirmation_call = 'Y')
--		AND EXISTS (SELECT 1 FROM oncd_contact_phone cps WHERE cps.contact_id = cstd_contact_flat.contact_id AND cst_valid_flag = 'Y' AND phone_type_code = 'SKIP'
----		AND dbo.pso_IsPhoneCallable(cp.cst_full_phone_number,cstd_contact_flat.contact_id) = 'Y'
--		AND NOT EXISTS (SELECT 1 FROM #uncallablecontactphones WHERE contact_phone_id = cp.contact_phone_id)
--		)

--	SET @Text = 'Set Phone Number Primary SKIP: ' + CAST(GETDATE() AS CHAR)
	SET @Text = 'Set Phone Number Primary by sort: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Refresh Contact Flat Data', @Text)

	--Set Primary Phone 2
	-- Get the primary phones for the lead if their primary is a Cell Phone
	-- and they don't have a confirmation call
--	UPDATE cstd_contact_flat SET
--		secondary_country_code_prefix = cp.country_code_prefix,
--		secondary_area_code = LEFT(cp.area_code,3),
--		secondary_phone_number = LEFT(cp.phone_number,10),
--		secondary_phone_type_code = cp.phone_type_code,
--		secondary_phone_type_description = LEFT(pt.description,10),
--		secondary_phone_id = cp.contact_phone_id
--	FROM cstd_contact_flat
--	LEFT OUTER JOIN oncd_contact_phone (NOLOCK) cp on cstd_contact_flat.contact_id = cp.contact_id
--		AND cp.contact_phone_id = (
--			SELECT TOP 1 contact_phone_id
--			FROM oncd_contact_phone (NOLOCK)
--			INNER JOIN onca_phone_type (NOLOCK) on onca_phone_type.phone_type_code = oncd_contact_phone.phone_type_code
--			WHERE
--			oncd_contact_phone.contact_id = cstd_contact_flat.contact_id AND
--			onca_phone_type.cst_is_cell_phone = 'N'
----			AND dbo.pso_IsPhoneCallable(oncd_contact_phone.cst_full_phone_number,cstd_contact_flat.contact_id) = 'Y'
--			AND NOT EXISTS (SELECT 1 FROM #uncallablecontactphones WHERE contact_phone_id = oncd_contact_phone.contact_phone_id)
--			ORDER BY sort_order)
--		AND cp.cst_valid_flag = 'Y'
--	LEFT OUTER JOIN onca_phone_type (NOLOCK) pt on pt.phone_type_code = cp.phone_type_code

--	SET @Text = 'Set Phone Number Secondary: ' + CAST(GETDATE() AS CHAR)
--	RAISERROR(@Text,0,1) WITH NOWAIT
--	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Refresh Contact Flat Data', @Text)

	----SKIP logic for secondary phone
	--sort_order logic for secondary phone
	--it should be the same as primary, so it is finally output to Noble file
	--in the Pri position either way
	UPDATE cstd_contact_flat SET
		secondary_country_code_prefix = cp.country_code_prefix,
		secondary_area_code = LEFT(cp.area_code,3),
		secondary_phone_number = LEFT(cp.phone_number,10),
		secondary_phone_type_code = cp.phone_type_code,
		secondary_phone_type_description = LEFT(pt.description,10),
		secondary_phone_id = cp.contact_phone_id
	FROM cstd_contact_flat
	LEFT OUTER JOIN	oncd_contact_phone (NOLOCK) cp ON cp.contact_id = cstd_contact_flat.contact_id
		AND cp.contact_phone_id = (SELECT TOP 1 contact_phone_id FROM oncd_contact_phone cp2 WHERE cp2.contact_id = cstd_contact_flat.contact_id AND cst_valid_flag = 'Y' --AND phone_type_code = 'SKIP'
--		AND dbo.pso_IsPhoneCallable(cp2.cst_full_phone_number, cstd_contact_flat.contact_id) = 'Y'
		AND NOT EXISTS (SELECT 1 FROM #uncallablecontactphones WHERE contact_phone_id = cp2.contact_phone_id)
		ORDER BY sort_order)
	LEFT OUTER JOIN onca_phone_type (NOLOCK) pt on pt.phone_type_code = cp.phone_type_code

--	SET @Text = 'Set Phone Number Secondary SKIP: ' + CAST(GETDATE() AS CHAR)
	SET @Text = 'Set Phone Number Secondary sort_order: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Refresh Contact Flat Data', @Text)


--	--Set Business Phone
--	UPDATE cstd_contact_flat SET
--		business_country_code_prefix = cp.country_code_prefix,
--		business_area_code = LEFT(cp.area_code,3),
--		business_phone_number = LEFT(cp.phone_number,10),
--		business_phone_type_description = LEFT(pt.description,10),
--		business_phone_id = cp.contact_phone_id
--	FROM cstd_contact_flat
--	LEFT OUTER JOIN oncd_contact_phone (NOLOCK) cp on cstd_contact_flat.contact_id = cp.contact_id
--		and cp.phone_type_code = 'BUSINESS'
--		AND cp.cst_valid_flag = 'Y'
----		AND dbo.pso_IsPhoneCallable(cp.cst_full_phone_number, cstd_contact_flat.contact_id) = 'Y'
--		AND NOT EXISTS (SELECT 1 FROM #uncallablecontactphones WHERE contact_phone_id = cp.contact_phone_id)
--	LEFT OUTER JOIN onca_phone_type (NOLOCK) pt on pt.phone_type_code = cp.phone_type_code

--	SET @Text = 'Set Phone Number Business: ' + CAST(GETDATE() AS CHAR)
--	RAISERROR(@Text,0,1) WITH NOWAIT
--	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Refresh Contact Flat Data', @Text)
--	WHERE NOT (cstd_contact_flat.has_open_confirmation_call = 'Y')
--		AND EXISTS (SELECT 1 FROM oncd_contact_phone cps WHERE cps.contact_id = cstd_contact_flat.contact_id AND cst_valid_flag = 'Y')-- AND phone_type_code = 'SKIP')

	----SKIP logic for Business phone
	--sort_order logic for Business phone
	UPDATE cstd_contact_flat SET
		business_country_code_prefix = cp.country_code_prefix,
		business_area_code = LEFT(cp.area_code,3),
		business_phone_number = LEFT(cp.phone_number,10),
		business_phone_type_description = LEFT(pt.description,10),
		business_phone_id = cp.contact_phone_id
	FROM cstd_contact_flat
	LEFT OUTER JOIN	oncd_contact_phone (NOLOCK) cp ON cp.contact_id = cstd_contact_flat.contact_id
		AND cp.contact_phone_id = (SELECT TOP 1 contact_phone_id FROM oncd_contact_phone cp2 WHERE cp2.contact_id = cstd_contact_flat.contact_id AND cst_valid_flag = 'Y' AND contact_phone_id NOT IN (primary_phone_id, secondary_phone_id)-- AND phone_type_code = 'SKIP')
--		AND dbo.pso_IsPhoneCallable(cp2.cst_full_phone_number, cstd_contact_flat.contact_id) = 'Y'
		AND NOT EXISTS (SELECT 1 FROM #uncallablecontactphones WHERE contact_phone_id = cp2.contact_phone_id)
		ORDER BY sort_order)
	LEFT OUTER JOIN onca_phone_type (NOLOCK) pt on pt.phone_type_code = cp.phone_type_code
--	WHERE NOT (cstd_contact_flat.has_open_confirmation_call = 'Y')
--		AND EXISTS (SELECT 1 FROM oncd_contact_phone cps WHERE cps.contact_id = cstd_contact_flat.contact_id AND cst_valid_flag = 'Y'-- AND phone_type_code = 'SKIP'
----		AND dbo.pso_IsPhoneCallable(cps.cst_full_phone_number, cstd_contact_flat.contact_id) = 'Y'
--		AND NOT EXISTS (SELECT 1 FROM #uncallablecontactphones WHERE contact_phone_id = cps.contact_phone_id)
--		)

--	SET @Text = 'Set Phone Number Business SKIP: ' + CAST(GETDATE() AS CHAR)
	SET @Text = 'Set Phone Number Business sort_order: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Refresh Contact Flat Data', @Text)

--	--Set Home Phone
--	UPDATE cstd_contact_flat SET
--		home_country_code_prefix = cp.country_code_prefix,
--		home_area_code = LEFT(cp.area_code,3),
--		home_phone_number = LEFT(cp.phone_number,10),
--		home_phone_type_description = LEFT(pt.description,10),
--		home_phone_id = cp.contact_phone_id
--	FROM cstd_contact_flat
--	LEFT OUTER JOIN oncd_contact_phone (NOLOCK) cp on cstd_contact_flat.contact_id = cp.contact_id
--		and cp.phone_type_code = 'HOME'
--		AND cp.cst_valid_flag = 'Y'
----		AND dbo.pso_IsPhoneCallable(cp.cst_full_phone_number, cstd_contact_flat.contact_id) = 'Y'
--		AND NOT EXISTS (SELECT 1 FROM #uncallablecontactphones WHERE contact_phone_id = cp.contact_phone_id)
--	LEFT OUTER JOIN onca_phone_type (NOLOCK) pt on pt.phone_type_code = cp.phone_type_code

--	SET @Text = 'Set Phone Number Home: ' + CAST(GETDATE() AS CHAR)
--	RAISERROR(@Text,0,1) WITH NOWAIT
--	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Refresh Contact Flat Data', @Text)

	----SKIP logic for Home phone
	--sort_order logic for Home phone
	UPDATE cstd_contact_flat SET
		home_country_code_prefix = cp.country_code_prefix,
		home_area_code = LEFT(cp.area_code,3),
		home_phone_number = LEFT(cp.phone_number,10),
		home_phone_type_description = LEFT(pt.description,10),
		home_phone_id = cp.contact_phone_id
	FROM cstd_contact_flat
	LEFT OUTER JOIN	oncd_contact_phone (NOLOCK) cp ON cp.contact_id = cstd_contact_flat.contact_id
		AND cp.contact_phone_id = (SELECT TOP 1 contact_phone_id FROM oncd_contact_phone cp2 WHERE cp2.contact_id = cstd_contact_flat.contact_id AND cst_valid_flag = 'Y' AND contact_phone_id NOT IN (primary_phone_id, secondary_phone_id, business_phone_id) --AND phone_type_code = 'SKIP'
--		AND dbo.pso_IsPhoneCallable(cp2.cst_full_phone_number, cstd_contact_flat.contact_id) = 'Y'
		AND NOT EXISTS (SELECT 1 FROM #uncallablecontactphones WHERE contact_phone_id = cp2.contact_phone_id)
		ORDER BY sort_order)
	LEFT OUTER JOIN onca_phone_type (NOLOCK) pt on pt.phone_type_code = cp.phone_type_code
--	WHERE NOT (cstd_contact_flat.has_open_confirmation_call = 'Y')
--		AND EXISTS (SELECT 1 FROM oncd_contact_phone cps WHERE cps.contact_id = cstd_contact_flat.contact_id AND cst_valid_flag = 'Y' --AND phone_type_code = 'SKIP'
----		AND dbo.pso_IsPhoneCallable(cps.cst_full_phone_number, cstd_contact_flat.contact_id) = 'Y'
--		AND NOT EXISTS (SELECT 1 FROM #uncallablecontactphones WHERE contact_phone_id = cps.contact_phone_id)
--		)

--	SET @Text = 'Set Phone Number Home SKIP: ' + CAST(GETDATE() AS CHAR)
	SET @Text = 'Set Phone Number Home sort_order: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Refresh Contact Flat Data', @Text)

--	--Set Cell Phone
--	-- Cell phone numbers are no longer exported to Noble
--	-- EXCEPT when the lead has a confirmation call.
--	UPDATE cstd_contact_flat SET
--		cell_country_code_prefix = cp.country_code_prefix,
--		cell_area_code = LEFT(cp.area_code,3),
--		cell_phone_number = LEFT(cp.phone_number,10),
--		cell_phone_type_description = LEFT(pt.description,10),
--		cell_phone_id = cp.contact_phone_id
--	FROM cstd_contact_flat
--	LEFT OUTER JOIN oncd_contact_phone (NOLOCK) cp on cstd_contact_flat.contact_id = cp.contact_id
--		and cp.phone_type_code = 'CELL'
--		AND cp.cst_valid_flag = 'Y'
----		AND dbo.pso_IsPhoneCallable(cp.cst_full_phone_number, cstd_contact_flat.contact_id) = 'Y'
--		AND NOT EXISTS (SELECT 1 FROM #uncallablecontactphones WHERE contact_phone_id = cp.contact_phone_id)
--	LEFT OUTER JOIN onca_phone_type (NOLOCK) pt on pt.phone_type_code = cp.phone_type_code
----	WHERE dbo.psoHasOpenConfirmationCall(cp.contact_id) = 'Y'

--	SET @Text = 'Set Phone Number Cell: ' + CAST(GETDATE() AS CHAR)
--	RAISERROR(@Text,0,1) WITH NOWAIT
--	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Refresh Contact Flat Data', @Text)

	----SKIP logic for Cell phone
	--sort_order logic for Cell phone
	UPDATE cstd_contact_flat SET
		cell_country_code_prefix = cp.country_code_prefix,
		cell_area_code = LEFT(cp.area_code,3),
		cell_phone_number = LEFT(cp.phone_number,10),
		cell_phone_type_description = LEFT(pt.description,10),
		cell_phone_id = cp.contact_phone_id
	FROM cstd_contact_flat
	LEFT OUTER JOIN	oncd_contact_phone (NOLOCK) cp ON cp.contact_id = cstd_contact_flat.contact_id
		AND cp.contact_phone_id = (SELECT TOP 1 contact_phone_id FROM oncd_contact_phone cp2 WHERE cp2.contact_id = cstd_contact_flat.contact_id AND cst_valid_flag = 'Y' AND contact_phone_id NOT IN (primary_phone_id, secondary_phone_id, business_phone_id, home_phone_id) --AND phone_type_code = 'SKIP'
--		AND dbo.pso_IsPhoneCallable(cp2.cst_full_phone_number, cstd_contact_flat.contact_id) = 'Y'
		AND NOT EXISTS (SELECT 1 FROM #uncallablecontactphones WHERE contact_phone_id = cp2.contact_phone_id)
		ORDER BY sort_order)
	LEFT OUTER JOIN onca_phone_type (NOLOCK) pt on pt.phone_type_code = cp.phone_type_code
--	WHERE NOT (cstd_contact_flat.has_open_confirmation_call = 'Y')
--		AND EXISTS (SELECT 1 FROM oncd_contact_phone cps WHERE cps.contact_id = cstd_contact_flat.contact_id AND cst_valid_flag = 'Y'-- AND phone_type_code = 'SKIP'
----		AND dbo.pso_IsPhoneCallable(cps.cst_full_phone_number, cstd_contact_flat.contact_id) = 'Y'
--		AND NOT EXISTS (SELECT 1 FROM #uncallablecontactphones WHERE contact_phone_id = cps.contact_phone_id)
--		)

----	SET @Text = 'Set Phone Number Cell SKIP: ' + CAST(GETDATE() AS CHAR)
--	SET @Text = 'Set Phone Number Cell sort_order: ' + CAST(GETDATE() AS CHAR)
--	RAISERROR(@Text,0,1) WITH NOWAIT
--	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Refresh Contact Flat Data', @Text)

--	--Set Home 2 Phone
--	UPDATE cstd_contact_flat SET
--		home_2_country_code_prefix = cp.country_code_prefix,
--		home_2_area_code = LEFT(cp.area_code,3),
--		home_2_phone_number = LEFT(cp.phone_number,10),
--		home_2_phone_type_description = LEFT(pt.description,10),
--		home_2_phone_id = cp.contact_phone_id
--	FROM cstd_contact_flat
--	LEFT OUTER JOIN oncd_contact_phone (NOLOCK) cp on cstd_contact_flat.contact_id = cp.contact_id
--		and cp.phone_type_code = 'HOME2'
--		AND cp.cst_valid_flag = 'Y'
----		AND dbo.pso_IsPhoneCallable(cp.cst_full_phone_number, cstd_contact_flat.contact_id) = 'Y'
--		AND NOT EXISTS (SELECT 1 FROM #uncallablecontactphones WHERE contact_phone_id = cp.contact_phone_id)
--	LEFT OUTER JOIN onca_phone_type (NOLOCK) pt on pt.phone_type_code = cp.phone_type_code

--	SET @Text = 'Set Phone Number Home 2: ' + CAST(GETDATE() AS CHAR)
--	RAISERROR(@Text,0,1) WITH NOWAIT
--	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Refresh Contact Flat Data', @Text)

	-----SKIP logic for Home 2 phone
	--sort_order logic for Home 2 phone
	UPDATE cstd_contact_flat SET
		home_2_country_code_prefix = cp.country_code_prefix,
		home_2_area_code = LEFT(cp.area_code,3),
		home_2_phone_number = LEFT(cp.phone_number,10),
		home_2_phone_type_description = LEFT(pt.description,10),
		home_2_phone_id = cp.contact_phone_id
	FROM cstd_contact_flat
	LEFT OUTER JOIN	oncd_contact_phone (NOLOCK) cp ON cp.contact_id = cstd_contact_flat.contact_id
		AND cp.contact_phone_id = (SELECT TOP 1 contact_phone_id FROM oncd_contact_phone cp2 WHERE cp2.contact_id = cstd_contact_flat.contact_id AND cst_valid_flag = 'Y' AND contact_phone_id NOT IN (primary_phone_id, secondary_phone_id, business_phone_id, home_phone_id, cell_phone_id) --AND phone_type_code = 'SKIP'
--		AND dbo.pso_IsPhoneCallable(cp2.cst_full_phone_number, cstd_contact_flat.contact_id) = 'Y'
		AND NOT EXISTS (SELECT 1 FROM #uncallablecontactphones WHERE contact_phone_id = cp2.contact_phone_id)
		ORDER BY sort_order)
	LEFT OUTER JOIN onca_phone_type (NOLOCK) pt on pt.phone_type_code = cp.phone_type_code
--	WHERE NOT (cstd_contact_flat.has_open_confirmation_call = 'Y')
--		AND EXISTS (SELECT 1 FROM oncd_contact_phone cps WHERE cps.contact_id = cstd_contact_flat.contact_id AND cst_valid_flag = 'Y' --AND phone_type_code = 'SKIP'
----		AND dbo.pso_IsPhoneCallable(cps.cst_full_phone_number, cstd_contact_flat.contact_id) = 'Y'
--		AND NOT EXISTS (SELECT 1 FROM #uncallablecontactphones WHERE contact_phone_id = cps.contact_phone_id)
--		)

	--SET @Text = 'Set Phone Number Home 2 SKIP: ' + CAST(GETDATE() AS CHAR)
	SET @Text = 'Set Phone Number Home 2 sort_order: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Refresh Contact Flat Data', @Text)

	--END SKIP phone_type customizations


	UPDATE cstd_contact_flat SET
		call_country_code_prefix = primary_country_code_prefix,
		call_area_code = primary_area_code,
		call_phone_number = primary_phone_number,
		call_phone_type_code = primary_phone_type_code,
		call_phone_type_description = primary_phone_type_description,
		call_phone_id  = primary_phone_id
	FROM cstd_contact_flat
	INNER JOIN onca_phone_type pt ON pt.phone_type_code = cstd_contact_flat.primary_phone_type_code
		AND pt.cst_is_cell_phone = 'N'

	UPDATE cstd_contact_flat SET
		call_country_code_prefix = primary_country_code_prefix,
		call_area_code = primary_area_code,
		call_phone_number = primary_phone_number,
		call_phone_type_code = primary_phone_type_code,
		call_phone_type_description = primary_phone_type_description,
		call_phone_id  = primary_phone_id
	FROM cstd_contact_flat
	WHERE call_phone_id IS NULL
		AND has_open_confirmation_call = 'Y'

	UPDATE cstd_contact_flat SET
		call_country_code_prefix = secondary_country_code_prefix,
		call_area_code = secondary_area_code,
		call_phone_number = secondary_phone_number,
		call_phone_type_code = secondary_phone_type_code,
		call_phone_type_description = secondary_phone_type_description,
		call_phone_id  = secondary_phone_id
	FROM cstd_contact_flat
	WHERE call_phone_id IS NULL

	SET @Text = 'Completed: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Refresh Contact Flat Data', @Text)


END
GO
