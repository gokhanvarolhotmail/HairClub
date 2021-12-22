/* CreateDate: 12/09/2014 09:53:49.750 , ModifyDate: 12/09/2014 09:53:49.750 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[pso_InsertCstdContactFlatContacts]
AS

BEGIN
	DECLARE @counter int
	DECLARE @Text NVARCHAR(500)

	CREATE TABLE #ctemp ( contact_id nchar(10) NOT NULL)

	--Get list of new contact_ids to insert
	INSERT INTO #ctemp SELECT contact_id FROM (
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
		) temp WHERE contact_id NOT IN (SELECT contact_id FROM cstd_contact_flat)



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
	( SELECT contact_id FROM #ctemp)

	SET @counter = @@ROWCOUNT
	SET @Text = CONVERT(varchar(10),@counter) + ' Contacts added to Flat: ' + CAST(GETDATE() AS CHAR)
	RAISERROR(@Text,0,1) WITH NOWAIT
	INSERT INTO cstd_sql_job_log (name, message) VALUES ('Refresh Contact Flat Data', @Text)

	--Primary Center Update
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
		AND cstd_contact_flat.contact_id IN (SELECT contact_id FROM #ctemp)

	--Address Update
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
		AND oncd_contact.contact_id IN (SELECT contact_id FROM #ctemp)

	--Set Primary Source
	update cstd_contact_flat set
		primary_source_description = s.description
	from onca_source (NOLOCK) s
		inner join oncd_contact_source (NOLOCK) cs on cs.source_code = s.source_code
		and cs.primary_flag = 'Y'
	where cs.contact_id = cstd_contact_flat.contact_id
	AND cstd_contact_flat.contact_id IN (SELECT contact_id FROM #ctemp)


	INSERT INTO cstd_contact_flat_add (
		contact_id,
		date_added
		)
		SELECT contact_id, GETDATE() FROM #ctemp

END
GO
