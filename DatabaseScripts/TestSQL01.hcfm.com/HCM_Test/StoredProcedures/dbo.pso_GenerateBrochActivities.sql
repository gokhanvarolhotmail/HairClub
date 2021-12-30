/* CreateDate: 12/09/2008 00:09:48.203 , ModifyDate: 05/01/2010 14:48:11.460 */
GO
CREATE PROCEDURE [dbo].[pso_GenerateBrochActivities] AS
BEGIN
	DECLARE @contact_id nchar(10)
	DECLARE @activity_id nchar(10)
	DECLARE @activity_contact_id nchar(10)
	DECLARE @activity_user_id nchar(10)
	DECLARE @time_zone_code nchar(10)
	DECLARE @record_count int
	DECLARE @two_years_ago datetime

	SET @two_years_ago = dbo.CombineDates(DATEADD(yy,-2,getdate()), null)
	SET @record_count = 0

	IF (SELECT user_code FROM onca_user WHERE user_code = 'NOBLE') IS NULL
	INSERT INTO onca_user (user_code, description, display_name, active) VALUES ('Noble', 'Noble', 'Noble', 'N')

	DECLARE contact_cursor CURSOR FOR
		select top 25000 oncd_contact.contact_id, oncd_contact_address.time_zone_code
		from oncd_contact
		left outer join oncd_contact_address on oncd_contact_address.contact_id = oncd_contact.contact_id
			and oncd_contact_address.primary_flag = 'Y'
		where
		cst_do_not_call = 'N'
		and do_not_solicit = 'N'
		and contact_status_code = 'LEAD'
		and oncd_contact.creation_date < dbo.CombineDates(DATEADD(dd,1,getdate()),null)
		and not (exists ( select * from oncd_activity
			inner join oncd_activity_contact ac on ac.activity_id = oncd_activity.activity_id
			and ac.contact_id = oncd_contact.contact_id
			where oncd_activity.action_code in ('APPOINT','OUTSELECT','CONFIRM','EXOUTCALL','OUTCALL','BROCHCALL','CANCELCALL','NOSHOWCALL')
			and (oncd_activity.result_code is null or oncd_activity.result_code = '')
		))
		and not (exists ( select * from oncd_activity
			inner join oncd_activity_contact ac2 on ac2.activity_id = oncd_activity.activity_id
			and ac2.contact_id = oncd_contact.contact_id
			where oncd_activity.action_code ='BROCHCALL'
			and oncd_activity.created_by_user_code = 'NOBLE'
		))

	open contact_cursor
	FETCH NEXT FROM contact_cursor into @contact_id, @time_zone_code
	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC onc_create_primary_key 10,'oncd_activity', 'activity_id', @activity_id OUTPUT, 'DCL'
		EXEC onc_create_primary_key 10,'oncd_activity_contact', 'activity_contact_id', @activity_contact_id OUTPUT, 'DCL'
		EXEC onc_create_primary_key 10,'oncd_activity_user', 'activity_user_id', @activity_user_id OUTPUT, 'DCL'

		insert into oncd_activity(
		activity_id,
		due_date,
		start_time,
		action_code,
		description,
		creation_date,
		created_by_user_code,
		updated_date,
		updated_by_user_code,
		cst_activity_type_code,
		cst_time_zone_code)
			values (
		@activity_id,
		@two_years_ago,
		@two_years_ago,
		'BROCHCALL',
		'Outbound Brochure Call',
		@two_years_ago,
		'NOBLE',
		@two_years_ago,
		'NOBLE',
		'OUTBOUND',
		@time_zone_code
		)

		insert into oncd_activity_contact(
			activity_contact_id,
			activity_id,
			contact_id,
			assignment_date,
			attendance,
			sort_order,
			creation_date,
			created_by_user_code,
			updated_date,
			updated_by_user_code,
			primary_flag)
		values(
			@activity_contact_id,
			@activity_id,
			@contact_id,
			getdate(),
			'Y',
			1,
			@two_years_ago,
			'NOBLE',
			@two_years_ago,
			'NOBLE',
			'Y')

		insert into oncd_activity_user(
		activity_user_id,
		activity_id,
		user_code,
		assignment_date,
		attendance,
		sort_order,
		creation_date,
		created_by_user_code,
		primary_flag,
		updated_date,
		updated_by_user_code
		)
			values(
		@activity_user_id,
		@activity_id,
		'NOBLE',
		getdate(),
		'Y',
		1,
		@two_years_ago,
		'NOBLE',
		'Y',
		dbo.CombineDates(getdate(),null),
		'NOBLE')

		set @record_count = @record_count + 1
		print @record_count
		--print 'Brochure activity created for ' + @contact_id
		FETCH NEXT FROM contact_cursor into @contact_id, @time_zone_code
	END

	CLOSE contact_cursor
	DEALLOCATE contact_cursor
	print 'Record Count'
	print @record_count

	--exec spapp_UpdateContactTimeZone
	--exec spapp_UpdateActivityTimeZone
END
GO
