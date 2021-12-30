/* CreateDate: 12/29/2008 12:21:49.703 , ModifyDate: 03/22/2017 16:53:20.900 */
GO
-- =============================================
-- Author:		Oncontact PSO Fred Remers
-- Create date: 12/29/08
-- Description:	Broke out periodic processing because of updated filter on nightly run.
--				Updated filter would have filtered out the periodic records.
--				Fill noble Data Table with contact data
--				using passed in filter to filter data
--
-- Updated 7/28/2009 Oncontact PSO Fred Remers
-- Added NOLOCKs and combined queries
--
-- 2015-06-11	Workwise, LLC	MJW
--	Add logic to respect cst_valid_flag
--
-- 2015-12-04	Workwise, LLC	MJW
--	Add logic to separately process SKIP phone type
--
-- 2016-04-01	Workwise, LLC	MJW
--	Reverse above logic
--
-- 2016-04-01	Workwise, LLC	MJW
--	Add back sort_order element of SKIP logic; not SKIP phone type
--
-- 2017-03-14	Workwise, LLC	MJW
--	Set Update to respect onca_action.cst_noble_addition flag instead of hardcoded list of Actions
-- =============================================
CREATE PROCEDURE [dbo].[pso_PopluatePeriodicNobleData] (
	@filter nchar(1000)
)
AS

BEGIN
	SET NOCOUNT ON

	DECLARE @sql varchar(MAX)

	truncate table cstd_noble_export_data

	SET @sql = '
	insert into cstd_noble_export_data (
	ContactID,
	FirstName,
	LastName,
	LeadCreationDate,
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
	NumOfReschedAppts
	)
	select
	oncd_contact.contact_id,
	oncd_contact.first_name,
	oncd_contact.last_name,
	CONVERT(varchar(10),oncd_contact.creation_date,101),
	REPLACE(ca1.city,'','',''''),
	st.description,
	ca1.zip_code,
	ca1.time_zone_code,
	csta_contact_hair_loss.description,
	csta_contact_age_range.description,
	csta_contact_language.description,
	csta_promotion_code.description,
	case when oncd_contact.cst_gender_code = ''MALE'' then ''Male''
		 when oncd_contact.cst_gender_code = ''FEMALE'' then ''Female''
	end,
	(select count(*) from oncd_activity (NOLOCK)
		inner join oncd_activity_contact (NOLOCK) on oncd_activity_contact.activity_id = oncd_activity.activity_id
		and oncd_activity_contact.contact_id = oncd_contact.contact_id
		where oncd_activity.action_code = ''APPOINT''
		and (oncd_activity.result_code is not null and oncd_activity.result_code != '''')),
	(select count(*) from oncd_activity (NOLOCK)
		inner join oncd_activity_contact (NOLOCK) on oncd_activity_contact.activity_id = oncd_activity.activity_id
		and oncd_activity_contact.contact_id = oncd_contact.contact_id
		where oncd_activity.action_code = ''APPOINT''
		and (oncd_activity.result_code = ''NOSHOW'')),
	(select count(*) from oncd_activity (NOLOCK)
		inner join oncd_activity_contact (NOLOCK) on oncd_activity_contact.activity_id = oncd_activity.activity_id
		and oncd_activity_contact.contact_id = oncd_contact.contact_id
		where oncd_activity.action_code = ''APPOINT''
		and (oncd_activity.result_code = ''SHOWSALE'')),
	(select count(*) from oncd_activity (NOLOCK)
		inner join oncd_activity_contact (NOLOCK) on oncd_activity_contact.activity_id = oncd_activity.activity_id
		and oncd_activity_contact.contact_id = oncd_contact.contact_id
		where oncd_activity.action_code = ''APPOINT''
		and (oncd_activity.result_code = ''CANCEL'')),
	(select count(*) from oncd_activity (NOLOCK) inner join oncd_activity_contact (NOLOCK) on oncd_activity_contact.activity_id = oncd_activity.activity_id
		and oncd_activity_contact.contact_id = oncd_contact.contact_id
		where oncd_activity.action_code = ''APPOINT''
		and (oncd_activity.result_code = ''RESCHEDULE''))
	from oncd_contact (NOLOCK)
	left outer join oncd_contact_address (NOLOCK) ca1 on ca1.contact_id = oncd_contact.contact_id
	and ca1.primary_flag = ''Y''
	and ca1.cst_valid_flag = ''Y''
	inner join onca_state (NOLOCK) st on st.state_code = ca1.state_code
	left outer join csta_contact_hair_loss (NOLOCK) on csta_contact_hair_loss.hair_loss_code = oncd_contact.cst_hair_loss_code
	left outer join csta_contact_age_range (NOLOCK) on csta_contact_age_range.age_range_code = oncd_contact.cst_age_range_code
	left outer join csta_contact_language (NOLOCK) on csta_contact_language.language_code = oncd_contact.cst_language_code
	left outer join csta_promotion_code (NOLOCK) on csta_promotion_code.promotion_code = oncd_contact.cst_promotion_code
	where ((do_not_solicit = ''N'' and cst_do_not_call = ''N'' and contact_status_code = ''LEAD'')
	OR
	(cst_do_not_call = ''N''
		and exists( select * from oncd_activity (NOLOCK) a
		inner join oncd_activity_contact (NOLOCK) ac on ac.activity_id = a.activity_id
		and ac.contact_id = oncd_contact.contact_id where a.action_code = ''CONFIRM''
		and (a.result_code = '''' or a.result_code is null) )))
	and (' + dbo.psoQueueDialerFilter(GETDATE()) + ') AND ' + @filter


--	SET @sql = '
--	insert into cstd_noble_export_data (
--	ContactID,
--	FirstName,
--	LastName,
--	LeadCreationDate
--	)
--	select
--	contact_id,
--	first_name,
--	last_name,
--	CONVERT(varchar(10),creation_date,101)
--	from oncd_contact (NOLOCK)
--	where ((do_not_solicit = ''N'' and cst_do_not_call = ''N'' and contact_status_code = ''LEAD'')
--	OR
--	(cst_do_not_call = ''N''
--		and exists( select * from oncd_activity (NOLOCK) a
--		inner join oncd_activity_contact (NOLOCK) ac on ac.activity_id = a.activity_id
--		and ac.contact_id = oncd_contact.contact_id where a.action_code = ''CONFIRM''
--		and (a.result_code = '''' or a.result_code is null) )))
--	and ' + @filter

	EXEC (@sql)

--	update cstd_noble_export_data set
--		City = REPLACE(ca.city,',',''),
--		StateName = st.description,
--		ZipCode = ca.zip_code,
--		TimeZone = ca.time_zone_code
--	from oncd_contact_address (NOLOCK) ca
--		inner join onca_state (NOLOCK) st on st.state_code = ca.state_code
--	where ca.contact_id = cstd_noble_export_data.ContactID
--		and ca.primary_flag = 'Y'

	update cstd_noble_export_data set
		City = REPLACE(ca.city,',',''),
		StateName = st.description,
		ZipCode = ca.zip_code,
		TimeZone = ca.time_zone_code
	from oncd_contact_address (NOLOCK) ca
		inner join onca_state (NOLOCK) st on st.state_code = ca.state_code
	where (cstd_noble_export_data.City is null or cstd_noble_export_data.City = '')
		and ca.contact_id = cstd_noble_export_data.ContactID
		and ca.sort_order = 0
		AND ca.cst_valid_flag = 'Y'

	update cstd_noble_export_data set
		City = REPLACE(ca.city,',',''),
		StateName = st.description,
		ZipCode = ca.zip_code,
		TimeZone = ca.time_zone_code
	from oncd_contact_address (NOLOCK) ca
		inner join onca_state (NOLOCK) st on st.state_code = ca.state_code
	where (cstd_noble_export_data.City is null or cstd_noble_export_data.City = '')
		and ca.contact_id = cstd_noble_export_data.ContactID
		and ca.sort_order = 1
		AND ca.cst_valid_flag = 'Y'

	update cstd_noble_export_data set
		City = REPLACE(ca.city,',',''),
		StateName = st.description,
		ZipCode = ca.zip_code,
		TimeZone = ca.time_zone_code
	from oncd_contact_address (NOLOCK) ca
		inner join onca_state (NOLOCK) st on st.state_code = ca.state_code
	where (cstd_noble_export_data.City is null or cstd_noble_export_data.City = '')
		and ca.contact_id = cstd_noble_export_data.ContactID
		and ca.sort_order = 2
		AND ca.cst_valid_flag = 'Y'

	update cstd_noble_export_data set
		City = REPLACE(ca.city,',',''),
		StateName = st.description,
		ZipCode = ca.zip_code,
		TimeZone = ca.time_zone_code
	from oncd_contact_address (NOLOCK) ca
		inner join onca_state (NOLOCK) st on st.state_code = ca.state_code
	where (cstd_noble_export_data.City is null or cstd_noble_export_data.City = '')
		and ca.contact_id = cstd_noble_export_data.ContactID
		and ca.sort_order = 3
		AND ca.cst_valid_flag = 'Y'

	update cstd_noble_export_data set
		City = REPLACE(ca.city,',',''),
		StateName = st.description,
		ZipCode = ca.zip_code,
		TimeZone = ca.time_zone_code
	from oncd_contact_address (NOLOCK) ca
		inner join onca_state (NOLOCK) st on st.state_code = ca.state_code
	where (cstd_noble_export_data.City is null or cstd_noble_export_data.City = '')
		and ca.contact_id = cstd_noble_export_data.ContactID
		and ca.sort_order = 4
		AND ca.cst_valid_flag = 'Y'

	update cstd_noble_export_data set
		City = REPLACE(ca.city,',',''),
		StateName = st.description,
		ZipCode = ca.zip_code,
		TimeZone = ca.time_zone_code
	from oncd_contact_address (NOLOCK) ca
		inner join onca_state (NOLOCK) st on st.state_code = ca.state_code
	where (cstd_noble_export_data.City is null or cstd_noble_export_data.City = '')
		and ca.contact_id = cstd_noble_export_data.ContactID
		and (ca.sort_order is null or ca.sort_order = '')
		AND ca.cst_valid_flag = 'Y'

	delete from cstd_noble_export_data where TimeZone is null or TimeZone = ''

	update cstd_noble_export_data set
		FirstName = REPLACE(FirstName,',',''),
		LastName  = REPLACE(LastName,',','')

--	update cstd_noble_export_data set HairLossAltDesc =
--	(select csta_contact_hair_loss.description from csta_contact_hair_loss (NOLOCK)
--		inner join oncd_contact (NOLOCK) on oncd_contact.cst_hair_loss_code = csta_contact_hair_loss.hair_loss_code
--		and oncd_contact.contact_id = cstd_noble_export_data.ContactID)
--
--	update cstd_noble_export_data set AgeRangeDesc =
--	(select csta_contact_age_range.description from csta_contact_age_range (NOLOCK)
--		inner join oncd_contact (NOLOCK) on oncd_contact.cst_age_range_code = csta_contact_age_range.age_range_code
--		and oncd_contact.contact_id = cstd_noble_export_data.ContactID)
--
--	update cstd_noble_export_data set LanguageDesc =
--	(select csta_contact_language.description from csta_contact_language
--		inner join oncd_contact on oncd_contact.cst_language_code = csta_contact_language.language_code
--		and oncd_contact.contact_id = cstd_noble_export_data.ContactID)
--
--	update cstd_noble_export_data set PromoCodeDesc =
--	(select csta_promotion_code.description from csta_promotion_code (NOLOCK)
--		inner join oncd_contact (NOLOCK) on oncd_contact.cst_promotion_code = csta_promotion_code.promotion_code
--		and oncd_contact.contact_id = cstd_noble_export_data.ContactID)
--
--	update cstd_noble_export_data set GenderDesc =
--	(select
--		case when oncd_contact.cst_gender_code = 'MALE' then 'Male'
--			 when oncd_contact.cst_gender_code = 'FEMALE' then 'Female'
--		end
--		from oncd_contact (NOLOCK)
--		where oncd_contact.contact_id = cstd_noble_export_data.ContactId)
--
--	update cstd_noble_export_data set TotalNumOfAppts =
--	(select count(*) from oncd_activity (NOLOCK)
--		inner join oncd_activity_contact (NOLOCK) on oncd_activity_contact.activity_id = oncd_activity.activity_id
--		and oncd_activity_contact.contact_id = cstd_noble_export_data.ContactID
--		where oncd_activity.action_code = 'APPOINT'
--		and (oncd_activity.result_code is not null and oncd_activity.result_code != ''))
--
--	update cstd_noble_export_data set NumOfNoShowAppts =
--	(select count(*) from oncd_activity (NOLOCK)
--		inner join oncd_activity_contact (NOLOCK) on oncd_activity_contact.activity_id = oncd_activity.activity_id
--		and oncd_activity_contact.contact_id = cstd_noble_export_data.ContactID
--		where oncd_activity.action_code = 'APPOINT'
--		and (oncd_activity.result_code = 'NOSHOW'))
--
--	update cstd_noble_export_data set NumOfShowSaleAppts =
--	(select count(*) from oncd_activity (NOLOCK)
--		inner join oncd_activity_contact (NOLOCK) on oncd_activity_contact.activity_id = oncd_activity.activity_id
--		and oncd_activity_contact.contact_id = cstd_noble_export_data.ContactID
--		where oncd_activity.action_code = 'APPOINT'
--		and (oncd_activity.result_code = 'SHOWSALE'))
--
--	update cstd_noble_export_data set NumOfCancelAppts =
--	(select count(*) from oncd_activity (NOLOCK)
--		inner join oncd_activity_contact (NOLOCK) on oncd_activity_contact.activity_id = oncd_activity.activity_id
--		and oncd_activity_contact.contact_id = cstd_noble_export_data.ContactID
--		where oncd_activity.action_code = 'APPOINT'
--		and (oncd_activity.result_code = 'CANCEL'))
--
--	update cstd_noble_export_data set NumOfReschedAppts =
--	(select count(*) from oncd_activity (NOLOCK) inner join oncd_activity_contact (NOLOCK) on oncd_activity_contact.activity_id = oncd_activity.activity_id
--		and oncd_activity_contact.contact_id = cstd_noble_export_data.ContactID
--		where oncd_activity.action_code = 'APPOINT'
--		and (oncd_activity.result_code = 'RESCHEDULE'))

	update cstd_noble_export_data set
		PrimaryCenterNum = e.cst_center_number,
		PrimaryCenterName = e.company_name_1
	from oncd_company (NOLOCK) e
		inner join oncd_contact_company (NOLOCK) cc on cc.company_id = e.company_id
		and cc.primary_flag = 'Y'
	where cstd_noble_export_data.ContactId = cc.contact_id

	update cstd_noble_export_data set
		OpenCallActivityId = a1.activity_id,
		ActionCodeDesc = a1.description,
		DueDate = CONVERT(varchar(10),a1.due_date,101),
		StartTime = CONVERT(varchar(5),a1.start_time,8)
	from oncd_activity (NOLOCK) a1
		inner join oncd_activity_contact (NOLOCK) ac1 on ac1.activity_id = a1.activity_id
		and (a1.result_code = '' or a1.result_code is null)
		INNER JOIN onca_action ac ON ac.action_code = a1.action_code
		----Removed 2017-03-09 MJW; seems redundant to what oncd_activity.pso_NobleAdditions trigger is doing in populating cstd_noble_contacts which is included in @filter
		----and (a1.action_code = 'CONFIRM' or a1.action_code = 'EXOUTCALL' or a1.action_code = 'OUTSELECT' or a1.action_code = 'BROCHCALL' or a1.action_code = 'CANCELCALL' or a1.action_code = 'NOSHOWCALL' or a1.action_code = 'SHNOBUYCAL')
		AND ac.cst_noble_addition = 'Y'
		--inner join onca_source asc1 on asc1.source_code = a1.source_code
	where ac1.contact_id = cstd_noble_export_data.ContactID

	DECLARE @QueueId NCHAR(10)
	SET @QueueId = dbo.psoQueueDialerId(GETDATE())

	UPDATE oncd_activity
	SET cst_queue_id = @QueueId, cst_in_noble_queue = 'Y'
	FROM oncd_activity
	INNER JOIN cstd_noble_export_data ON oncd_activity.activity_id = cstd_noble_export_data.OpenCallActivityId

	update cstd_noble_export_data set
		LastActvityDate = CONVERT(varchar(10),a.completion_date,101),
		LastResultDesc = ar.description
	from oncd_activity (NOLOCK) a
		inner join onca_result (NOLOCK) ar on ar.result_code = a.result_code
		inner join oncd_activity_contact (NOLOCK) ac on ac.activity_id = a.activity_id
	where (a.result_code is not null and a.result_code != '')
		and a.activity_id =
		(
		  select top 1 oncd_activity.activity_id from oncd_activity (NOLOCK)
		    inner join oncd_activity_contact (NOLOCK) on oncd_activity_contact.contact_id = ac.contact_id
	        and oncd_activity_contact.activity_id = oncd_activity.activity_id
		  where (oncd_activity.result_code is not null and oncd_activity.result_code != '')
			and (oncd_activity.completion_date is not null and oncd_activity.completion_date <> '')
			order by oncd_activity.completion_date desc, oncd_activity.completion_time desc
		)
		and ac.contact_id = cstd_noble_export_data.ContactId

	update cstd_noble_export_data set
		LastActvityDate = CONVERT(varchar(10),a.completion_time,101),
		LastResultDesc = ar.description
	from oncd_activity (NOLOCK) a
		inner join onca_result (NOLOCK) ar on ar.result_code = a.result_code
		inner join oncd_activity_contact (NOLOCK) ac on ac.activity_id = a.activity_id
	where (a.result_code is not null and a.result_code != '')
		and a.activity_id =
		(
		  select top 1 oncd_activity.activity_id from oncd_activity (NOLOCK)
		    inner join oncd_activity_contact (NOLOCK) on oncd_activity_contact.contact_id = ac.contact_id
	        and oncd_activity_contact.activity_id = oncd_activity.activity_id
		  where (oncd_activity.result_code is not null and oncd_activity.result_code != '')
			and (oncd_activity.completion_time is not null and oncd_activity.completion_time <> '')
			order by oncd_activity.completion_time desc
		)
		and ac.contact_id = cstd_noble_export_data.ContactId
		and cstd_noble_export_data.LastActvityDate is null

	update cstd_noble_export_data set
		CurrOpenApptDate = CONVERT(varchar(10),a.due_date,101),
		CurrOpenApptTime = CONVERT(varchar(5),a.start_time,8),
		CurrOpenApptType = Left(at.description,20)
	from oncd_activity (NOLOCK) a
		inner join oncd_activity_contact (NOLOCK) ac on ac.activity_id = a.activity_id
		inner join csta_activity_type (NOLOCK) at on at.activity_type_code = a.cst_activity_type_code
	where a.action_code = 'APPOINT'
		and (a.result_code is null or a.result_code = '')
		and ac.contact_id = cstd_noble_export_data.ContactId

	update cstd_noble_export_data set
		DateOfLastAppt = CONVERT(varchar(10),a.due_date,101),
		LastApptResultDesc = ar.description
	from oncd_activity (NOLOCK) a
		inner join onca_result (NOLOCK) ar on ar.result_code = a.result_code
		inner join oncd_activity_contact (NOLOCK) ac on ac.activity_id = a.activity_id
	where a.result_code is not null and a.result_code != ''
		and a.activity_id =
		(
			select top 1 oncd_activity.activity_id from oncd_activity (NOLOCK)
			inner join oncd_activity_contact (NOLOCK) on oncd_activity_contact.activity_id = oncd_activity.activity_id
				and oncd_activity_contact.contact_id = ac.contact_id
			where oncd_activity.action_code = 'APPOINT'
			and (oncd_activity.result_code is not null and oncd_activity.result_code != '')
			and oncd_activity.completion_date =
			(
				select max(completion_date)
				from oncd_activity (NOLOCK)
				inner join oncd_activity_contact (NOLOCK) on oncd_activity_contact.contact_id = ac.contact_id
				and oncd_activity_contact.activity_id = oncd_activity.activity_id
				where oncd_activity.action_code = 'APPOINT'
				and (completion_date is not null and completion_date <> '')
				and (oncd_activity.result_code is not null and oncd_activity.result_code != '')
			)

		)
		and ac.contact_id = cstd_noble_export_data.ContactID

	update cstd_noble_export_data set
		DateOfLastAppt = CONVERT(varchar(10),a.due_date,101),
		LastApptResultDesc = ar.description
	from oncd_activity (NOLOCK) a
		inner join onca_result (NOLOCK) ar on ar.result_code = a.result_code
		inner join oncd_activity_contact (NOLOCK) ac on ac.activity_id = a.activity_id
	where a.result_code is not null and a.result_code != ''
		and a.activity_id =
		(
			select top 1 oncd_activity.activity_id from oncd_activity (NOLOCK)
			inner join oncd_activity_contact (NOLOCK) on oncd_activity_contact.activity_id = oncd_activity.activity_id
				and oncd_activity_contact.contact_id = ac.contact_id
			where oncd_activity.action_code = 'APPOINT'
			and (oncd_activity.result_code is not null and oncd_activity.result_code != '')
			and oncd_activity.completion_date =
			(
				select max(completion_time)
				from oncd_activity (NOLOCK)
				inner join oncd_activity_contact on oncd_activity_contact.contact_id = ac.contact_id
				and oncd_activity_contact.activity_id = oncd_activity.activity_id
				where oncd_activity.action_code = 'APPOINT'
				and (completion_time is not null and completion_time <> '')
				and (oncd_activity.result_code is not null and oncd_activity.result_code != '')
			)

		)
		and ac.contact_id = cstd_noble_export_data.ContactID
		and cstd_noble_export_data.DateOfLastAppt is null

	update cstd_noble_export_data set
		PriSourceCodeDesc = s.description
	from onca_source (NOLOCK) s
		inner join oncd_contact_source (NOLOCK) cs on cs.source_code = s.source_code
		and cs.primary_flag = 'Y'
	where cs.contact_id = cstd_noble_export_data.ContactID

	update cstd_noble_export_data set
		CurrentSourceCode = s.description
	from onca_source (NOLOCK) s
		inner join oncd_activity (NOLOCK) a on a.source_code = s.source_code
		inner join oncd_activity_contact (NOLOCK) ac on ac.activity_id = a.activity_id
	where (a.source_code is not null and a.source_code != '')
		and a.activity_id =
		(
			select top 1 oncd_activity.activity_id from oncd_activity (NOLOCK)
				inner join oncd_activity_contact (NOLOCK) on oncd_activity_contact.contact_id = ac.contact_id
				and oncd_activity_contact.activity_id = oncd_activity.activity_id
				where (oncd_activity.source_code is not null and oncd_activity.source_code != '')
				and oncd_activity.due_date =
				(
					select max(due_date)
					from oncd_activity (NOLOCK)
					inner join oncd_activity_contact (NOLOCK) on oncd_activity_contact.contact_id = ac.contact_id
					and oncd_activity_contact.activity_id = oncd_activity.activity_id
					where (oncd_activity.source_code is not null and oncd_activity.source_code != '')
				)
		)
	and ac.contact_id = cstd_noble_export_data.ContactID


	--Modified for SKIP phone_type logic 2015-12-04 MJW Workwise
	--SKIP Modifications removed	2016-04-01	MJW Workwise
	--Reimplement sort_order element of above SKIP logic, but not SKIP phone_type specific logic 2016-04-06		MJW Workwise

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
		AND cp.contact_id IN (SELECT ContactID FROM cstd_noble_export_data)
	) t

	CREATE NONCLUSTERED INDEX ucp_1 ON #uncallablecontactphones (contact_phone_id ASC)


	-- Export a the primary phone unless it is a Cell Phone except if
	-- the lead has a confirmation call
	update cstd_noble_export_data set
		CntryCodePrePri = cp.country_code_prefix,
		AreaCodePri = LEFT(cp.area_code,3),
		PhoneNumberPri = LEFT(cp.phone_number,10),
		PhoneTypeCodePri = LEFT(pt.description,10)
	from oncd_contact_phone (NOLOCK) cp
		inner join onca_phone_type (NOLOCK) pt on pt.phone_type_code = cp.phone_type_code
	where cp.contact_id = cstd_noble_export_data.ContactID and
		((cp.primary_flag = 'Y' and pt.cst_is_cell_phone = 'N') OR dbo.psoHasOpenConfirmationCall(cp.contact_id) = 'Y')
		AND cp.cst_valid_flag = 'Y'
--		AND cp.phone_type_code <> 'SKIP'

	-- Get the primary phones for the lead if their primary is a Cell Phone
	-- and they don't have a confirmation call
	update cstd_noble_export_data set
		CntryCodePrePri = cp.country_code_prefix,
		AreaCodePri = LEFT(cp.area_code,3),
		PhoneNumberPri = LEFT(cp.phone_number,10),
		PhoneTypeCodePri = LEFT(pt.description,10)
	from oncd_contact_phone (NOLOCK) cp
		inner join onca_phone_type (NOLOCK) pt on pt.phone_type_code = cp.phone_type_code
	where
	CntryCodePrePri IS NULL AND AreaCodePri IS NULL AND PhoneNumberPri IS NULL AND PhoneTypeCodePri IS NULL AND
		cp.contact_phone_id = (
			SELECT TOP 1 contact_phone_id
			FROM oncd_contact_phone
			INNER JOIN onca_phone_type (NOLOCK) on onca_phone_type.phone_type_code = oncd_contact_phone.phone_type_code
			WHERE
			oncd_contact_phone.contact_id = cstd_noble_export_data.ContactID AND
			onca_phone_type.cst_is_cell_phone = 'N'
			AND oncd_contact_phone.cst_valid_flag = 'Y'
			ORDER BY sort_order)

	----SKIP logic for primary phone
	--sort_order logic for primary phone
	update cstd_noble_export_data set
		CntryCodePrePri = cp.country_code_prefix,
		AreaCodePri = LEFT(cp.area_code,3),
		PhoneNumberPri = LEFT(cp.phone_number,10),
		PhoneTypeCodePri = LEFT(pt.description,10)
	from oncd_contact_phone (NOLOCK) cp
		inner join onca_phone_type (NOLOCK) pt on pt.phone_type_code = cp.phone_type_code
	WHERE cp.contact_phone_id = (SELECT TOP 1 contact_phone_id FROM oncd_contact_phone cp2 WHERE cp2.contact_id = cstd_noble_export_data.ContactID AND cst_valid_flag = 'Y'
					AND NOT EXISTS (SELECT 1 FROM #uncallablecontactphones WHERE contact_phone_id = cp2.contact_phone_id)
		ORDER BY primary_flag DESC, sort_order) --AND phone_type_code = 'SKIP'


	update cstd_noble_export_data set
		CntryCodePreBus = cp.country_code_prefix,
		AreaCodeBus = LEFT(cp.area_code,3),
		PhoneNumberBus = LEFT(cp.phone_number,10),
		PhoneTypeCodeBus = LEFT(pt.description,10)
	from oncd_contact_phone (NOLOCK) cp
		inner join onca_phone_type (NOLOCK) pt on pt.phone_type_code = cp.phone_type_code
		and pt.phone_type_code = 'BUSINESS'
		AND cp.cst_valid_flag = 'Y'
	where cp.contact_id = cstd_noble_export_data.ContactID

	----SKIP logic for business phone
	--sort_order logic for business phone
	update cstd_noble_export_data set
		CntryCodePreBus = cp.country_code_prefix,
		AreaCodeBus = LEFT(cp.area_code,3),
		PhoneNumberBus = LEFT(cp.phone_number,10),
		PhoneTypeCodeBus = LEFT(pt.description,10)
	from oncd_contact_phone (NOLOCK) cp
		inner join onca_phone_type (NOLOCK) pt on pt.phone_type_code = cp.phone_type_code
	WHERE cp.contact_id = cstd_noble_export_data.ContactID
		AND cp.contact_phone_id = (SELECT TOP 1 contact_phone_id FROM oncd_contact_phone cp2 WHERE cp2.contact_id = cstd_noble_export_data.ContactID AND cst_valid_flag = 'Y' AND LEFT(cp2.phone_number,10) NOT IN (PhoneNumberPri)
					AND NOT EXISTS (SELECT 1 FROM #uncallablecontactphones WHERE contact_phone_id = cp2.contact_phone_id)
		ORDER BY primary_flag DESC, sort_order) --AND phone_type_code = 'SKIP'


	update cstd_noble_export_data set
		CntryCodePreHM = cp.country_code_prefix,
		AreaCodeHM = LEFT(cp.area_code,3),
		PhoneNumberHM = LEFT(cp.phone_number,10),
		PhoneTypeCodeHM = LEFT(pt.description,10)
	from oncd_contact_phone (NOLOCK) cp
		inner join onca_phone_type (NOLOCK) pt on pt.phone_type_code = cp.phone_type_code
		and pt.phone_type_code = 'HOME'
		AND cp.cst_valid_flag = 'Y'
	where cp.contact_id = cstd_noble_export_data.ContactID


	----SKIP logic for home phone
	--sort_order logic for home phone
	update cstd_noble_export_data set
		CntryCodePreHM = cp.country_code_prefix,
		AreaCodeHM = LEFT(cp.area_code,3),
		PhoneNumberHM = LEFT(cp.phone_number,10),
		PhoneTypeCodeHM = LEFT(pt.description,10)
	from oncd_contact_phone (NOLOCK) cp
		inner join onca_phone_type (NOLOCK) pt on pt.phone_type_code = cp.phone_type_code
	WHERE cp.contact_id = cstd_noble_export_data.ContactID
		AND cp.contact_phone_id = (SELECT TOP 1 contact_phone_id FROM oncd_contact_phone cp2 WHERE cp2.contact_id = cstd_noble_export_data.ContactID AND cst_valid_flag = 'Y' AND LEFT(cp2.phone_number,10) NOT IN (PhoneNumberPri, PhoneNumberBus)
					AND NOT EXISTS (SELECT 1 FROM #uncallablecontactphones WHERE contact_phone_id = cp2.contact_phone_id)
		ORDER BY primary_flag DESC, sort_order) --AND phone_type_code = 'SKIP'

	-- Cell phone numbers are no longer exported to Noble
	--update cstd_noble_export_data set
	--	CntryCodePreCL = cp.country_code_prefix,
	--	AreaCodeCL = LEFT(cp.area_code,3),
	--	PhoneNumberCL = LEFT(cp.phone_number,10),
	--	PhoneTypeCodeCL = LEFT(pt.description,10)
	--from oncd_contact_phone (NOLOCK) cp
	--	inner join onca_phone_type (NOLOCK) pt on pt.phone_type_code = cp.phone_type_code
	--	and pt.phone_type_code = 'CELL'
	--where cp.contact_id = cstd_noble_export_data.ContactID

	----SKIP logic for cell phone
	--sort_order logic for cell phone
	update cstd_noble_export_data set
		CntryCodePreCL = cp.country_code_prefix,
		AreaCodeCL = LEFT(cp.area_code,3),
		PhoneNumberCL = LEFT(cp.phone_number,10),
		PhoneTypeCodeCL = LEFT(pt.description,10)
	from oncd_contact_phone (NOLOCK) cp
		inner join onca_phone_type (NOLOCK) pt on pt.phone_type_code = cp.phone_type_code
	WHERE cp.contact_id = cstd_noble_export_data.ContactID
		AND cp.contact_phone_id = (SELECT TOP 1 contact_phone_id FROM oncd_contact_phone cp2 WHERE cp2.contact_id = cstd_noble_export_data.ContactID AND cst_valid_flag = 'Y' AND LEFT(cp2.phone_number,10) NOT IN (PhoneNumberPri, PhoneNumberBus, PhoneNumberHM)
					AND NOT EXISTS (SELECT 1 FROM #uncallablecontactphones WHERE contact_phone_id = cp2.contact_phone_id)
		ORDER BY primary_flag DESC, sort_order) --AND phone_type_code = 'SKIP'

	update cstd_noble_export_data set
		CntryCodePreHM2 = cp.country_code_prefix,
		AreaCodeHM2 = LEFT(cp.area_code,3),
		PhoneNumberHM2 = LEFT(cp.phone_number,10),
		PhoneTypeCodeHM2 = LEFT(pt.description,10)
	from oncd_contact_phone (NOLOCK) cp
		inner join onca_phone_type (NOLOCK) pt on pt.phone_type_code = cp.phone_type_code
		and pt.phone_type_code = 'HOME2'
		AND cp.cst_valid_flag = 'Y'
	where cp.contact_id = cstd_noble_export_data.ContactID

	----SKIP logic for Home2 phone
	--sort_order logic for Home2 phone
	update cstd_noble_export_data set
		CntryCodePreHM2 = cp.country_code_prefix,
		AreaCodeHM2 = LEFT(cp.area_code,3),
		PhoneNumberHM2 = LEFT(cp.phone_number,10),
		PhoneTypeCodeHM2 = LEFT(pt.description,10)
	from oncd_contact_phone (NOLOCK) cp
		inner join onca_phone_type (NOLOCK) pt on pt.phone_type_code = cp.phone_type_code
	WHERE cp.contact_id = cstd_noble_export_data.ContactID
		AND cp.contact_phone_id = (SELECT TOP 1 contact_phone_id FROM oncd_contact_phone cp2 WHERE cp2.contact_id = cstd_noble_export_data.ContactID AND cst_valid_flag = 'Y' AND LEFT(cp2.phone_number,10) NOT IN (PhoneNumberPri, PhoneNumberBus, PhoneNumberHM, PhoneNumberCL)
					AND NOT EXISTS (SELECT 1 FROM #uncallablecontactphones WHERE contact_phone_id = cp2.contact_phone_id)
		ORDER BY primary_flag, sort_order) --AND phone_type_code = 'SKIP'

	EXEC pso_RemoveNobleExportDataUnicode
END
GO
