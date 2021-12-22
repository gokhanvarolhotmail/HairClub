/* CreateDate: 01/08/2007 12:15:19.643 , ModifyDate: 01/25/2010 08:11:31.777 */
GO
CREATE PROCEDURE [dbo].[spsvc_InsertDailyEmailConfirmationsOLD]

AS
	INSERT INTO HCM.dbo.EmailConfirm
	(
		RecordID
	,	MergeField01
	,	MergeField02
	,	MergeField03
	,	MergeField04
	,	MergeField05
	,	MergeField06
	,	MergeField07
	,	MergeField08
	,	MergeField09
	,	MergeField10
	,	Type
	,	Status
	)
	SELECT
		recordid
	,	email_
	,	appt_date
	,	appt_time
	,	center
	,	contact_fname
	,	'No Merge Data Specified'
	,	'No Merge Data Specified'
	,	'No Merge Data Specified'
	,	'No Merge Data Specified'
	,	'No Merge Data Specified'
	,	'ApptNotify'
	,	'SENT'

	FROM dbo.EmailConfirmations
GO
