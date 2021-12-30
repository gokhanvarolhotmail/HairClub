/* CreateDate: 03/20/2009 14:12:23.743 , ModifyDate: 06/22/2015 11:03:22.567 */
GO
/***********************************************************************

PROCEDURE:		spsvc_DNC_Get_Phone_Numbers

DESTINATION SERVER:	hcsql3\sql2005

DESTINATION DATABASE: 	HCM

RELATED APPLICATION:  	DNC Processing

AUTHOR: 		OnContact PSO Fred Remers

IMPLEMENTOR: 		Fred Remers

DATE IMPLEMENTED:

LAST REVISION DATE: 	2015-06-11	MJW 	Don't include invalid phones in select and delete invalid phones after select based on psoIsValidPhone logic

------------------------------------------------------------------------
NOTES: populate DNC staging table
------------------------------------------------------------------------

SAMPLE EXECUTION: EXEC spsvc_DNC_Get_Phone_Numbers

***********************************************************************/
CREATE PROCEDURE [dbo].[spsvc_DNC_Get_Phone_Numbers]
AS
DECLARE @Sales TABLE(
	contactId VARCHAR(10)
	)
DECLARE @Date90  datetime
DECLARE @Date120 datetime
DECLARE @Date150 datetime
DECLARE @Date180 datetime
DECLARE @Date210 datetime
DECLARE @Date240 datetime
DECLARE @Date270 datetime
DECLARE @Date300 datetime
DECLARE @Date330 datetime
DECLARE @Date360 datetime
DECLARE @Date390 datetime
DECLARE @Date420 datetime
DECLARE @Date450 datetime
DECLARE @Date480 datetime
DECLARE @Date510 datetime
DECLARE @Date540 datetime
DECLARE @Date570 datetime
DECLARE @Date600 datetime
DECLARE @Date630 datetime
DECLARE @Date660 datetime
DECLARE @Date690 datetime
DECLARE @Date720 datetime

DECLARE @Date750 datetime
DECLARE @Date780 datetime
DECLARE @Date810 datetime
DECLARE @Date840 datetime
DECLARE @Date870 datetime
DECLARE @Date900 datetime
DECLARE @Date930 datetime
DECLARE @Date960 datetime
DECLARE @Date990 datetime
DECLARE @Date1020 datetime
DECLARE @Date1050 datetime
DECLARE @Date1080 datetime
DECLARE @Date1110 datetime
DECLARE @Date1140 datetime
DECLARE @Date1170 datetime
DECLARE @Date1200 datetime
DECLARE @Date1230 datetime
DECLARE @Date1260 datetime
DECLARE @Date1290 datetime
DECLARE @Date1320 datetime
DECLARE @Date1350 datetime
DECLARE @Date1380 datetime
DECLARE @Date1410 datetime
DECLARE @Date1440 datetime

-- get all the time intervals
Select @Date90 =  DateAdd(day, -90, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date120 = DateAdd(day, -120, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date150 = DateAdd(day, -150, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date180 = DateAdd(day, -180, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date210 = DateAdd(day, -210, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date240 = DateAdd(day, -240, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date270 = DateAdd(day, -270, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date300 = DateAdd(day, -300, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date330 = DateAdd(day, -330, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date360 = DateAdd(day, -360, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date390 = DateAdd(day, -390, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date420 = DateAdd(day, -420, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date450 = DateAdd(day, -450, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date480 = DateAdd(day, -480, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date510 = DateAdd(day, -510, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date540 = DateAdd(day, -540, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date570 = DateAdd(day, -570, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date600 = DateAdd(day, -600, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date630 = DateAdd(day, -630, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date660 = DateAdd(day, -660, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date690 = DateAdd(day, -690, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date720 = DateAdd(day, -720, CAST(Convert(Varchar(11),GetDate()) as DateTime))

Select @Date750 = DateAdd(day, -750, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date780 = DateAdd(day, -780, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date810 = DateAdd(day, -810, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date840 = DateAdd(day, -840, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date870 = DateAdd(day, -870, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date900 = DateAdd(day, -900, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date930 = DateAdd(day, -930, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date960 = DateAdd(day, -960, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date990 = DateAdd(day, -990, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date1020 = DateAdd(day, -1020, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date1050 = DateAdd(day, -1050, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date1080 = DateAdd(day, -1080, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date1110 = DateAdd(day, -1110, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date1140 = DateAdd(day, -1140, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date1170 = DateAdd(day, -1170, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date1200 = DateAdd(day, -1200, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date1230 = DateAdd(day, -1230, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date1260 = DateAdd(day, -1260, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date1290 = DateAdd(day, -1290, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date1320 = DateAdd(day, -1320, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date1350 = DateAdd(day, -1350, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date1380 = DateAdd(day, -1380, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date1410 = DateAdd(day, -1410, CAST(Convert(Varchar(11),GetDate()) as DateTime))
Select @Date1440 = DateAdd(day, -1440, CAST(Convert(Varchar(11),GetDate()) as DateTime))

DECLARE @Text NVARCHAR(500)

SET @Text = 'Variables Set: ' + CAST(GETDATE() AS CHAR)
RAISERROR(@Text,0,1) WITH NOWAIT

-- Find all sales for our population of incalls and store in variable
insert into @Sales
SELECT oncd_contact.contact_id FROM oncd_contact WITH (NOLOCK)
	INNER JOIN oncd_activity_contact WITH (NOLOCK) ON oncd_activity_contact.contact_id = oncd_contact.contact_id
	INNER JOIN oncd_activity WITH (NOLOCK) on oncd_activity.activity_id = oncd_activity_contact.activity_id
		and oncd_activity.action_code = 'INCALL'
		--and oncd_activity.result_code = 'APPOINT'
		and oncd_activity.due_date IN ( @Date90, @Date120,@Date150,@Date180,@Date210,@Date240,@Date270,
			@Date300,@Date330,@Date360,@Date390,@Date420,@Date450, @Date480,
			@Date510,@Date540,@Date570,@Date600,@Date630,@Date660,@Date690,@Date720,
			@Date750,@Date780,@Date810,@Date840,@Date870,@Date900,@Date930,
			@Date960,@Date990,@Date1020,@Date1050,@Date1080,@Date1110,@Date1140,
			@Date1170,@Date1200,@Date1230,@Date1260,@Date1290,@Date1320,@Date1350,
			@Date1380,@Date1410,@Date1440)
	AND EXISTS (select * from oncd_activity a WITH (NOLOCK)
		inner join oncd_activity_contact ac WITH (NOLOCK) on ac.activity_id = a.activity_id
			and ac.contact_id = oncd_activity_contact.contact_id
			and a.action_code = 'APPOINT'
			and a.result_code = 'SHOWSALE')

SET @Text = 'Temp Populated: ' + CAST(GETDATE() AS CHAR)
RAISERROR(@Text,0,1) WITH NOWAIT

-- get our incalls and subtract the sales and insert into dnc_staging
insert into cstd_dnc_staging
	(contact_id, phone)
select oncd_contact_phone.contact_id,
	(LTRIM(RTRIM(oncd_contact_phone.area_code)) + LTRIM(RTRIM(oncd_contact_phone.phone_number))) as phone
	from oncd_contact_phone WITH (NOLOCK)
	inner join oncd_activity_contact ac WITH (NOLOCK) on ac.contact_id = oncd_contact_phone.contact_id
	inner join oncd_activity a WITH (NOLOCK) on a.activity_id = ac.activity_id
		and a.action_code = 'INCALL'
		and a.due_date IN ( @Date90, @Date120,@Date150,@Date180,@Date210,@Date240,@Date270,
			@Date300,@Date330,@Date360,@Date390,@Date420,@Date450, @Date480,
			@Date510,@Date540,@Date570,@Date600,@Date630,@Date660,@Date690,@Date720,
			@Date750,@Date780,@Date810,@Date840,@Date870,@Date900,@Date930,
			@Date960,@Date990,@Date1020,@Date1050,@Date1080,@Date1110,@Date1140,
			@Date1170,@Date1200,@Date1230,@Date1260,@Date1290,@Date1320,@Date1350,
			@Date1380,@Date1410,@Date1440)
	where 1=1 --oncd_contact_phone.contact_id NOT IN (select contactId from @Sales)
	and LEN(area_code) = 3 and LEN(phone_number) = 7
	and SUBSTRING(area_code,1,1) BETWEEN '2' AND '9'
	AND cst_valid_flag = 'Y'
--	and area_code <> '999' and phone_number <> '9999999'
ORDER BY area_code, phone_number, contact_id
DELETE cstd_dnc_staging WHERE LEFT(phone,3) = '999' OR SUBSTRING(phone,4,7) = '9999999'
DELETE cstd_dnc_staging WHERE dbo.psoIsValidPhone(LEFT(phone,3), SUBSTRING(phone,4,7)) = 'N'

SET @Text = 'Staging insert completed: ' + CAST(GETDATE() AS CHAR)
RAISERROR(@Text,0,1) WITH NOWAIT

DELETE cstd_dnc_staging WHERE contact_id IN (SELECT contactId FROM @Sales)
SET @Text = 'Process Complete: ' + CAST(GETDATE() AS CHAR)
RAISERROR(@Text,0,1) WITH NOWAIT
GO
