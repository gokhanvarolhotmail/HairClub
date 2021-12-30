/* CreateDate: 09/17/2014 10:09:38.777 , ModifyDate: 09/26/2014 21:05:02.417 */
GO
CREATE PROCEDURE [dbo].[psoPopulateContactFlat] AS
BEGIN
	DECLARE @Text NVARCHAR(500)
	DECLARE @start_time datetime
	DECLARE @end_time datetime
	DECLARE @maxtextwidth int

	SET @maxtextwidth = 40

	SET @Text = 'Start Truncation (01/17)'
	SET @start_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@start_time,121)
	RAISERROR(@Text,0,1) WITH NOWAIT

	TRUNCATE TABLE cstd_contact_flat

	SET @Text = 'End   Truncation'
	SET @end_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@end_time,121)
	SET @Text = @Text + ' (' + SUBSTRING(CONVERT(nchar(23),DATEADD(millisecond, DATEDIFF(millisecond, @start_time, @end_time),'1/1/1900'),121),15,9) + ')' + CHAR(13)
	RAISERROR(@Text,0,1) WITH NOWAIT


	SET @Text = 'Start Initial Insert (02/17)'
	SET @start_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@start_time,121)
	RAISERROR(@Text,0,1) WITH NOWAIT

	INSERT INTO cstd_contact_flat (
		contact_id,
		first_name,
		last_name,
		lead_creation_date,
		lead_created_by_display_name,
		age_range_description,
		hair_loss_alternative_description,
		language_description,
		promotion_description,
		gender_description,
		do_not_call,
		do_not_solicit,
		contact_status_code,
		total_appointments,
		no_show_appointments,
		show_sale_appointments,
		canceled_appointments,
		rescheduled_appointments,
		created_by_user_code
		)
	SELECT
		oncd_contact.contact_id,
		dbo.psoRemoveNonAlphaNumeric(oncd_contact.first_name),
		dbo.psoRemoveNonAlphaNumeric(oncd_contact.last_name),
		CONVERT(varchar(10), oncd_contact.creation_date, 101),
		dbo.psoRemoveNonAlphaNumeric(onca_user.display_name),
		dbo.psoRemoveNonAlphaNumeric(csta_contact_age_range.description),
		dbo.psoRemoveNonAlphaNumeric(csta_contact_hair_loss.description),
		dbo.psoRemoveNonAlphaNumeric(csta_contact_language.description),
		dbo.psoRemoveNonAlphaNumeric(csta_promotion_code.description),
		CASE oncd_contact.cst_gender_code
			WHEN 'MALE' THEN 'Male'
			WHEN 'FEMALE' THEN 'Female'
		END,
		oncd_contact.cst_do_not_call,
		oncd_contact.do_not_solicit,
		oncd_contact.contact_status_code,
		(select count(*) from oncd_activity (NOLOCK) a
			inner join oncd_activity_contact (NOLOCK) ac on ac.activity_id = a.activity_id
			and ac.contact_id = oncd_contact.contact_id
			where a.action_code = 'APPOINT'
			and (a.result_code is not null and a.result_code != '')),
		(select count(*) from oncd_activity (NOLOCK) a
			inner join oncd_activity_contact (NOLOCK) ac on ac.activity_id = a.activity_id
			and ac.contact_id = oncd_contact.contact_id
			where a.action_code = 'APPOINT'
			and (a.result_code = 'NOSHOW')),
		(select count(*) from oncd_activity (NOLOCK) a
			inner join oncd_activity_contact (NOLOCK) ac on ac.activity_id = a.activity_id
			and ac.contact_id = oncd_contact.contact_id
			where a.action_code = 'APPOINT'
			and (a.result_code = 'SHOWSALE')),
		(select count(*) from oncd_activity (NOLOCK) a
			inner join oncd_activity_contact (NOLOCK) ac on ac.activity_id = a.activity_id
			and ac.contact_id = oncd_contact.contact_id
			where a.action_code = 'APPOINT'
			and (a.result_code = 'CANCEL')),
		(select count(*) from oncd_activity (NOLOCK) a
			inner join oncd_activity_contact (NOLOCK) ac on ac.activity_id = a.activity_id
			and ac.contact_id = oncd_contact.contact_id
			where a.action_code = 'APPOINT'
			and (a.result_code = 'RESCHEDULE')),
		oncd_contact.created_by_user_code
	FROM oncd_contact
	LEFT OUTER JOIN onca_user ON
		oncd_contact.created_by_user_code = onca_user.user_code
	LEFT OUTER JOIN csta_contact_hair_loss ON
		oncd_contact.cst_hair_loss_code = csta_contact_hair_loss.hair_loss_code
	LEFT OUTER JOIN csta_contact_age_range ON
		oncd_contact.cst_age_range_code = csta_contact_age_range.age_range_code
	LEFT OUTER JOIN csta_contact_language ON
		oncd_contact.cst_language_code = csta_contact_language.language_code
	LEFT OUTER JOIN csta_promotion_code ON
		oncd_contact.cst_promotion_code = csta_promotion_code.promotion_code
	WHERE contact_id IN
	(
		SELECT contact_id
		FROM oncd_contact
		WHERE
			(cst_do_not_call = 'N' AND do_not_solicit = 'N'
			AND contact_status_code = 'LEAD'
			and (exists ( select 1 from oncd_activity (NOLOCK) a
			inner join oncd_activity_contact (NOLOCK) ac on ac.activity_id = a.activity_id
			and ac.contact_id = oncd_contact.contact_id where dbo.CombineDates(a.due_date,null) <= dbo.CombineDates(getdate(),null)
			and (ISNULL(a.result_code,'') = '' )--or a.result_code is null)
			and a.action_code <> 'APPOINT')))
		UNION ALL
		SELECT contact_id
		FROM oncd_contact
		WHERE
			(cst_do_not_call = 'N' AND do_not_solicit = 'N'
			AND exists( select 1 from oncd_activity (NOLOCK) a2
				inner join oncd_activity_contact (NOLOCK) ac2 on ac2.activity_id = a2.activity_id
				and ac2.contact_id = oncd_contact.contact_id where a2.action_code = 'CONFIRM'
				and (ISNULL(a2.result_code,'') = ''))) --or a2.result_code is null) ))
		UNION ALL
		SELECT contact_id
		FROM oncd_contact
		WHERE 	(cst_do_not_call = 'N' AND do_not_solicit = 'N'
			AND contact_status_code = 'LEAD'
			and oncd_contact.created_by_user_code = 'TM 600'
			and (exists ( select 1 from oncd_activity (NOLOCK) a
			inner join oncd_activity_contact (NOLOCK) ac on ac.activity_id = a.activity_id
			and ac.contact_id = oncd_contact.contact_id where dbo.CombineDates(a.due_date,null) >= dbo.CombineDates(getdate(),null)
			and (ISNULL(a.result_code,'') = '')-- or a.result_code is null)
			and a.action_code = 'BROCHCALL')))
	)

	SET @Text = 'End   Initial Insert'
	SET @end_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@end_time,121)
	SET @Text = @Text + ' (' + SUBSTRING(CONVERT(nchar(23),DATEADD(millisecond, DATEDIFF(millisecond, @start_time, @end_time),'1/1/1900'),121),15,9) + ')' + CHAR(13)
	RAISERROR(@Text,0,1) WITH NOWAIT
--02:36

	SET @Text = 'Start Primary Center Update (03/17)'
	SET @start_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@start_time,121)
	RAISERROR(@Text,0,1) WITH NOWAIT

	UPDATE cstd_contact_flat SET
		primary_center_name = dbo.psoRemoveNonAlphaNumeric(oncd_company.company_name_1),
		primary_center_number = oncd_company.cst_center_number
	FROM oncd_contact_company
	INNER JOIN oncd_company ON
		oncd_contact_company.company_id = oncd_company.company_id
	WHERE
		cstd_contact_flat.contact_id = oncd_contact_company.contact_id
		AND oncd_contact_company.primary_flag = 'Y'
		AND primary_center_name IS NULL

	SET @Text = 'End   Primary Center Update'
	SET @end_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@end_time,121)
	SET @Text = @Text + ' (' + SUBSTRING(CONVERT(nchar(23),DATEADD(millisecond, DATEDIFF(millisecond, @start_time, @end_time),'1/1/1900'),121),15,9) + ')' + CHAR(13)
	RAISERROR(@Text,0,1) WITH NOWAIT
--00:48


	SET @Text = 'Start Address Update (04/17)'
	SET @start_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@start_time,121)
	RAISERROR(@Text,0,1) WITH NOWAIT

	UPDATE cstd_contact_flat SET
		city = ca1.city,
		state_description = onca_state.description,
		zip_code = ca1.zip_code,
		time_zone_code = ca1.time_zone_code,
		contact_address_id = ca1.contact_address_id
	FROM oncd_contact
	INNER JOIN oncd_contact_address ca1 ON
		oncd_contact.contact_id = ca1.contact_id AND
		ca1.city IS NOT NULL AND
		ca1.city <> ''
	LEFT OUTER JOIN oncd_contact_address ca2 ON
		oncd_contact.contact_id = ca2.contact_id AND
		ca2.city IS NOT NULL AND
		ca2.city <> '' AND
		(ca1.primary_flag < ca2.primary_flag OR (ca1.primary_flag = ca2.primary_flag AND ca1.sort_order > ca2.sort_order) OR (ca1.primary_flag = ca2.primary_flag AND ca1.sort_order = ca2.sort_order AND ca1.contact_address_id > ca2.contact_address_id))
	LEFT OUTER JOIN onca_state ON
		ca1.state_code = onca_state.state_code
	WHERE oncd_contact.contact_id = cstd_contact_flat.contact_id
		AND ca2.contact_address_id IS NULL

	SET @Text = 'End   Address Update'
	SET @end_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@end_time,121)
	SET @Text = @Text + ' (' + SUBSTRING(CONVERT(nchar(23),DATEADD(millisecond, DATEDIFF(millisecond, @start_time, @end_time),'1/1/1900'),121),15,9) + ')' + CHAR(13)
	RAISERROR(@Text,0,1) WITH NOWAIT
--01:23


	--Set Primary Phone
	-- Populate the primary phone
	---- unless it is a Cell Phone except if
	---- the lead has a confirmation call
	SET @Text = 'Start Primary Phone Update (05/17)'
	SET @start_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@start_time,121)
	RAISERROR(@Text,0,1) WITH NOWAIT

	UPDATE cstd_contact_flat SET
		primary_country_code_prefix = cp.country_code_prefix,
		primary_area_code = LEFT(cp.area_code,3),
		primary_phone_number = LEFT(cp.phone_number,10),
		primary_phone_type_code = cp.phone_type_code,
		primary_phone_type_description = LEFT(pt.description,10),
		primary_phone_id = cp.contact_phone_id
	FROM oncd_contact c
	LEFT OUTER JOIN oncd_contact_phone (NOLOCK) cp on c.contact_id = cp.contact_id
			AND cp.primary_flag = 'Y'
	--		AND cp.cst_valid_flag = 'Y'
	INNER JOIN cstd_contact_flat ON c.contact_id = cstd_contact_flat.contact_id
	LEFT OUTER JOIN onca_phone_type (NOLOCK) pt on pt.phone_type_code = cp.phone_type_code

	SET @Text = 'End   Primary Phone Update'
	SET @end_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@end_time,121)
	SET @Text = @Text + ' (' + SUBSTRING(CONVERT(nchar(23),DATEADD(millisecond, DATEDIFF(millisecond, @start_time, @end_time),'1/1/1900'),121),15,9) + ')' + CHAR(13)
	RAISERROR(@Text,0,1) WITH NOWAIT
--01:57

	--Set Primary Phone 2
	-- Get the primary phones for the lead if their primary is a Cell Phone
	-- and they don't have a confirmation call
	SET @Text = 'Start Primary Phone 2 Update (06/17)'
	SET @start_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@start_time,121)
	RAISERROR(@Text,0,1) WITH NOWAIT

	UPDATE cstd_contact_flat SET
		secondary_country_code_prefix = cp.country_code_prefix,
		secondary_area_code = LEFT(cp.area_code,3),
		secondary_phone_number = LEFT(cp.phone_number,10),
		secondary_phone_type_code = cp.phone_type_code,
		secondary_phone_type_description = LEFT(pt.description,10),
		secondary_phone_id = cp.contact_phone_id
	FROM oncd_contact c
	LEFT OUTER JOIN oncd_contact_phone (NOLOCK) cp on c.contact_id = cp.contact_id
		AND	cp.contact_phone_id = (
			SELECT TOP 1 contact_phone_id
			FROM oncd_contact_phone (NOLOCK)
			INNER JOIN onca_phone_type (NOLOCK) on onca_phone_type.phone_type_code = oncd_contact_phone.phone_type_code
			WHERE
			oncd_contact_phone.contact_id = c.contact_id AND
			onca_phone_type.cst_is_cell_phone = 'N'
			ORDER BY sort_order)
--		AND cp.cst_valid_flag = 'Y'
	INNER JOIN cstd_contact_flat ON c.contact_id = cstd_contact_flat.contact_id
	LEFT OUTER JOIN onca_phone_type (NOLOCK) pt on pt.phone_type_code = cp.phone_type_code

	SET @Text = 'End   Primary Phone 2 Update'
	SET @end_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@end_time,121)
	SET @Text = @Text + ' (' + SUBSTRING(CONVERT(nchar(23),DATEADD(millisecond, DATEDIFF(millisecond, @start_time, @end_time),'1/1/1900'),121),15,9) + ')' + CHAR(13)
	RAISERROR(@Text,0,1) WITH NOWAIT
--00:26

	--Set Business Phone
	SET @Text = 'Start Business Phone Update (07/17)'
	SET @start_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@start_time,121)
	RAISERROR(@Text,0,1) WITH NOWAIT

	UPDATE cstd_contact_flat SET
		business_country_code_prefix = cp.country_code_prefix,
		business_area_code = LEFT(cp.area_code,3),
		business_phone_number = LEFT(cp.phone_number,10),
		business_phone_type_description = LEFT(pt.description,10),
		business_phone_id = cp.contact_phone_id
	FROM oncd_contact c
	LEFT OUTER JOIN oncd_contact_phone (NOLOCK) cp on c.contact_id = cp.contact_id
		and cp.phone_type_code = 'BUSINESS'
		--		AND cp.cst_valid_flag = 'Y'
	INNER JOIN cstd_contact_flat ON c.contact_id = cstd_contact_flat.contact_id
	LEFT OUTER JOIN onca_phone_type (NOLOCK) pt on pt.phone_type_code = cp.phone_type_code


	SET @Text = 'End   Business Phone Update'
	SET @end_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@end_time,121)
	SET @Text = @Text + ' (' + SUBSTRING(CONVERT(nchar(23),DATEADD(millisecond, DATEDIFF(millisecond, @start_time, @end_time),'1/1/1900'),121),15,9) + ')' + CHAR(13)
	RAISERROR(@Text,0,1) WITH NOWAIT
--00:02


	--Set Home Phone
	SET @Text = 'Start Home Phone Update (08/17)'
	SET @start_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@start_time,121)
	RAISERROR(@Text,0,1) WITH NOWAIT

	UPDATE cstd_contact_flat SET
		home_country_code_prefix = cp.country_code_prefix,
		home_area_code = LEFT(cp.area_code,3),
		home_phone_number = LEFT(cp.phone_number,10),
		home_phone_type_description = LEFT(pt.description,10),
		home_phone_id = cp.contact_phone_id
	FROM oncd_contact c
	LEFT OUTER JOIN oncd_contact_phone (NOLOCK) cp on c.contact_id = cp.contact_id
		and cp.phone_type_code = 'HOME'
		--		AND cp.cst_valid_flag = 'Y'
	INNER JOIN cstd_contact_flat ON c.contact_id = cstd_contact_flat.contact_id
	LEFT OUTER JOIN onca_phone_type (NOLOCK) pt on pt.phone_type_code = cp.phone_type_code


	SET @Text = 'End Home Phone Update'
	SET @end_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@end_time,121)
	SET @Text = @Text + ' (' + SUBSTRING(CONVERT(nchar(23),DATEADD(millisecond, DATEDIFF(millisecond, @start_time, @end_time),'1/1/1900'),121),15,9) + ')' + CHAR(13)
	RAISERROR(@Text,0,1) WITH NOWAIT
--00:02

	--Set Cell Phone
	-- Cell phone numbers are no longer exported to Noble
	-- EXCEPT when the lead has a confirmation call.
	SET @Text = 'Start Cell Phone Update (09/17)'
	SET @start_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@start_time,121)
	RAISERROR(@Text,0,1) WITH NOWAIT

	UPDATE cstd_contact_flat SET
		cell_country_code_prefix = cp.country_code_prefix,
		cell_area_code = LEFT(cp.area_code,3),
		cell_phone_number = LEFT(cp.phone_number,10),
		cell_phone_type_description = LEFT(pt.description,10),
		cell_phone_id = cp.contact_phone_id
	FROM oncd_contact c
	LEFT OUTER JOIN oncd_contact_phone (NOLOCK) cp on c.contact_id = cp.contact_id
		and cp.phone_type_code = 'CELL'
		--		AND cp.cst_valid_flag = 'Y'
	INNER JOIN cstd_contact_flat ON c.contact_id = cstd_contact_flat.contact_id
	LEFT OUTER JOIN onca_phone_type (NOLOCK) pt on pt.phone_type_code = cp.phone_type_code

	SET @Text = 'End   Cell Phone Update'
	SET @end_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@end_time,121)
	SET @Text = @Text + ' (' + SUBSTRING(CONVERT(nchar(23),DATEADD(millisecond, DATEDIFF(millisecond, @start_time, @end_time),'1/1/1900'),121),15,9) + ')' + CHAR(13)
	RAISERROR(@Text,0,1) WITH NOWAIT
--00:04


	--Set Home 2 Phone
	SET @Text = 'Start Home Phone 2 Update (10/17)'
	SET @start_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@start_time,121)
	RAISERROR(@Text,0,1) WITH NOWAIT

	UPDATE cstd_contact_flat SET
		home_2_country_code_prefix = cp.country_code_prefix,
		home_2_area_code = LEFT(cp.area_code,3),
		home_2_phone_number = LEFT(cp.phone_number,10),
		home_2_phone_type_description = LEFT(pt.description,10),
		home_2_phone_id = cp.contact_phone_id
	FROM oncd_contact c
	LEFT OUTER JOIN oncd_contact_phone (NOLOCK) cp on c.contact_id = cp.contact_id
		and cp.phone_type_code = 'HOME2'
		--		AND cp.cst_valid_flag = 'Y'
	INNER JOIN cstd_contact_flat ON c.contact_id = cstd_contact_flat.contact_id
	LEFT OUTER JOIN onca_phone_type (NOLOCK) pt on pt.phone_type_code = cp.phone_type_code


	SET @Text = 'End   Home Phone 2 Update'
	SET @end_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@end_time,121)
	SET @Text = @Text + ' (' + SUBSTRING(CONVERT(nchar(23),DATEADD(millisecond, DATEDIFF(millisecond, @start_time, @end_time),'1/1/1900'),121),15,9) + ')' + CHAR(13)
	RAISERROR(@Text,0,1) WITH NOWAIT
--00:00


	--Set Current Source
	SET @Text = 'Start Current Source Update (11/17)'
	SET @start_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@start_time,121)
	RAISERROR(@Text,0,1) WITH NOWAIT

	update cstd_contact_flat set
		current_source_description = s.description
	from oncd_activity (NOLOCK) a
		left join onca_source s (NOLOCK) ON a.source_code = s.source_code
		INNER JOIN oncd_activity_contact (NOLOCK) ac ON ac.activity_id = a.activity_id
	WHERE cstd_contact_flat.contact_id = ac.contact_id
		AND current_source_description IS NULL
		AND	a.activity_id =
		(
		  SELECT TOP 1 oncd_activity.activity_id
		  FROM oncd_activity (NOLOCK)
			INNER JOIN oncd_activity_contact (NOLOCK) ON
				oncd_activity_contact.contact_id = cstd_contact_flat.contact_id AND
				oncd_activity_contact.activity_id = oncd_activity.activity_id
			ORDER BY oncd_activity.due_date DESC, oncd_activity.start_time DESC
		)

	SET @Text = 'End   Current Source Update'
	SET @end_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@end_time,121)
	SET @Text = @Text + ' (' + SUBSTRING(CONVERT(nchar(23),DATEADD(millisecond, DATEDIFF(millisecond, @start_time, @end_time),'1/1/1900'),121),15,9) + ')' + CHAR(13)
	RAISERROR(@Text,0,1) WITH NOWAIT
--00:01


	--Set Primary Source
	SET @Text = 'Start Primary Source Update (12/17)'
	SET @start_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@start_time,121)
	RAISERROR(@Text,0,1) WITH NOWAIT

	update cstd_contact_flat set
		primary_source_description = s.description
	from onca_source (NOLOCK) s
		inner join oncd_contact_source (NOLOCK) cs on cs.source_code = s.source_code
		and cs.primary_flag = 'Y'
	where cs.contact_id = cstd_contact_flat.contact_id

	SET @Text = 'End   Primary Source Update'
	SET @end_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@end_time,121)
	SET @Text = @Text + ' (' + SUBSTRING(CONVERT(nchar(23),DATEADD(millisecond, DATEDIFF(millisecond, @start_time, @end_time),'1/1/1900'),121),15,9) + ')' + CHAR(13)
	RAISERROR(@Text,0,1) WITH NOWAIT
--00:05


	--Last Activity Data
	SET @Text = 'Start Last Activity Update (13/17)'
	SET @start_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@start_time,121)
	RAISERROR(@Text,0,1) WITH NOWAIT

	UPDATE cstd_contact_flat SET
		last_activity_date = CONVERT(varchar(10),a.completion_date,101),
		last_activity_result_description = ar.description
	FROM oncd_activity a WITH (NOLOCK)
	INNER JOIN onca_result ar WITH (NOLOCK) ON a.result_code = ar.result_code
	WHERE
	a.result_code IS NOT NULL AND
	a.activity_id = (
		SELECT TOP 1 oncd_activity.activity_id
		FROM oncd_contact c WITH (NOLOCK)
		INNER JOIN oncd_activity_contact ac WITH (NOLOCK) ON c.contact_id = ac.contact_id
		INNER JOIN oncd_activity WITH (NOLOCK) ON ac.activity_id = oncd_activity.activity_id
		WHERE
		c.contact_id = cstd_contact_flat.contact_id AND
		oncd_activity.result_code is not null AND oncd_activity.completion_date is not null
		ORDER BY oncd_activity.completion_date desc, oncd_activity.completion_time desc)

	SET @Text = 'End   Last Activity Update'
	SET @end_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@end_time,121)
	SET @Text = @Text + ' (' + SUBSTRING(CONVERT(nchar(23),DATEADD(millisecond, DATEDIFF(millisecond, @start_time, @end_time),'1/1/1900'),121),15,9) + ')' + CHAR(13)
	RAISERROR(@Text,0,1) WITH NOWAIT

--02:32


	SET @Text = 'Start Last Activity 2 Update (14/17)'
	SET @start_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@start_time,121)
	RAISERROR(@Text,0,1) WITH NOWAIT

	update cstd_contact_flat set
		last_activity_date = CONVERT(varchar(10),a.completion_time,101),
		last_activity_result_description = ar.description
	from oncd_activity (NOLOCK) a
		inner join onca_result (NOLOCK) ar on ar.result_code = a.result_code
		inner join oncd_activity_contact (NOLOCK) ac on ac.activity_id = a.activity_id
	where a.result_code is not null
		and a.activity_id =
		(
		  select top 1 oncd_activity.activity_id from oncd_activity (NOLOCK)
		    inner join oncd_activity_contact (NOLOCK) on oncd_activity_contact.contact_id = ac.contact_id
	        and oncd_activity_contact.activity_id = oncd_activity.activity_id
		  where oncd_activity.result_code is not null
			and oncd_activity.completion_time is not null
			order by oncd_activity.completion_time desc
		)
		and ac.contact_id = cstd_contact_flat.contact_id
		and cstd_contact_flat.last_activity_date is null

	SET @Text = 'End   Last Activity 2 Update'
	SET @end_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@end_time,121)
	SET @Text = @Text + ' (' + SUBSTRING(CONVERT(nchar(23),DATEADD(millisecond, DATEDIFF(millisecond, @start_time, @end_time),'1/1/1900'),121),15,9) + ')' + CHAR(13)
	RAISERROR(@Text,0,1) WITH NOWAIT

--01:46

	--Populate Opecn Call Activity Data
	-- Remove EXOUTCALL from list of calls per Erika Defalco on 18 April 2014.
	SET @Text = 'Start Open Call Activity Update (15/17)'
	SET @start_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@start_time,121)
	RAISERROR(@Text,0,1) WITH NOWAIT

	update cstd_contact_flat set
		open_call_activity_id = a1.activity_id,
		open_call_action_description = a1.description,
		open_call_due_date = CONVERT(varchar(10),a1.due_date,101),
		open_call_start_time = CONVERT(varchar(5),a1.start_time,8)--,
		--current_source_description = s.description
	from oncd_activity (NOLOCK) a1
		left join onca_source s (NOLOCK) ON a1.source_code = s.source_code
		inner join oncd_activity_contact (NOLOCK) ac1 on ac1.activity_id = a1.activity_id
		and a1.result_code is null
		and a1.action_code IN ('CONFIRM','OUTSELECT','BROCHCALL','CANCELCALL','NOSHOWCALL','SHNOBUYCAL')
	where ac1.contact_id = cstd_contact_flat.contact_id

	SET @Text = 'End   Open Call Activity Update'
	SET @end_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@end_time,121)
	SET @Text = @Text + ' (' + SUBSTRING(CONVERT(nchar(23),DATEADD(millisecond, DATEDIFF(millisecond, @start_time, @end_time),'1/1/1900'),121),15,9) + ')' + CHAR(13)
	RAISERROR(@Text,0,1) WITH NOWAIT
--01:01


	-- Remove records without an Open Call Activity Id
	--DELETE FROM cstd_contact_flat WHERE open_call_activity_id IS NULL


	--Set Current Appointment Data
	SET @Text = 'Start Current Appt. Activity Update (16/17)'
	SET @start_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@start_time,121)
	RAISERROR(@Text,0,1) WITH NOWAIT

	UPDATE cstd_contact_flat SET
		current_appointment_date = CONVERT(varchar(10),a.due_date,101),
		current_appointment_time = CONVERT(varchar(5),a.start_time,8),
		current_appointment_type = LEFT(at.description,20)
	FROM oncd_activity (NOLOCK) a
		INNER JOIN csta_activity_type (NOLOCK) at on at.activity_type_code = a.cst_activity_type_code
	WHERE
		a.action_code = 'APPOINT' AND
		a.result_code IS NULL AND
		a.activity_id =
		(
		  SELECT TOP 1 oncd_activity.activity_id
		  FROM oncd_activity (NOLOCK)
			INNER JOIN oncd_activity_contact (NOLOCK) ON
				oncd_activity_contact.contact_id = cstd_contact_flat.contact_id AND
				oncd_activity_contact.activity_id = oncd_activity.activity_id
		  WHERE
			oncd_activity.action_code = 'APPOINT' AND
			oncd_activity.result_code IS NULL
			ORDER BY oncd_activity.due_date DESC, oncd_activity.start_time DESC
		)

	SET @Text = 'End   Current Appt. Activity Update'
	SET @end_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@end_time,121)
	SET @Text = @Text + ' (' + SUBSTRING(CONVERT(nchar(23),DATEADD(millisecond, DATEDIFF(millisecond, @start_time, @end_time),'1/1/1900'),121),15,9) + ')' + CHAR(13)
	RAISERROR(@Text,0,1) WITH NOWAIT
--01:54


	--Set Last Appointment Data:
	SET @Text = 'Start Last Appt. Activity Update (17/17)'
	SET @start_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@start_time,121)
	RAISERROR(@Text,0,1) WITH NOWAIT

	UPDATE cstd_contact_flat SET
		last_appointment_date = CONVERT(varchar(10),a.due_date,101),
		last_appointment_result_description = LEFT(r.description,50)
	FROM oncd_activity (NOLOCK) a
		INNER JOIN onca_result (NOLOCK) r on r.result_code = a.result_code
		INNER JOIN oncd_activity_contact (NOLOCK) ac ON ac.activity_id = a.activity_id
	WHERE
		ac.contact_id = cstd_contact_flat.contact_id AND
		a.action_code = 'APPOINT' AND
		a.result_code IS NOT NULL AND
		a.activity_id =
		(
		  SELECT TOP 1 oncd_activity.activity_id
		  FROM oncd_activity (NOLOCK)
			INNER JOIN oncd_activity_contact (NOLOCK) ON
				oncd_activity_contact.contact_id = cstd_contact_flat.contact_id AND
				oncd_activity_contact.activity_id = oncd_activity.activity_id
		  WHERE
			oncd_activity.action_code = 'APPOINT' AND
			oncd_activity.result_code IS NOT NULL
			ORDER BY oncd_activity.due_date DESC, oncd_activity.start_time DESC
		)

	SET @Text = 'End   Last Appt. Activity Update'
	SET @end_time = GETDATE()
	SET @Text = LEFT(@Text + SPACE(@maxtextwidth),@maxtextwidth)
	SET @Text = @Text + ' - ' + CONVERT(varchar(30),@end_time,121)
	SET @Text = @Text + ' (' + SUBSTRING(CONVERT(nchar(23),DATEADD(millisecond, DATEDIFF(millisecond, @start_time, @end_time),'1/1/1900'),121),15,9) + ')' + CHAR(13)
	RAISERROR(@Text,0,1) WITH NOWAIT
--07:07
END
GO
