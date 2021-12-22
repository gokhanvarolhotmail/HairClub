/* CreateDate: 11/29/2006 10:54:17.247 , ModifyDate: 05/01/2010 14:48:09.430 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE UpdateDncInHcm

AS

declare @dnc_table Table(
phone varchar(10),
dnc bit)

INSERT INTO @dnc_table (phone,dnc)
SELECT phone,(CASE WHEN flag1 = 'DNC' THEN 1 ELSE 0 END) dnc
FROM cstd_hcmtbl_national_registry
WHERE flag1 = 'DNC'

UPDATE oncd_activity
SET result_code = 'NOCALL', completion_date = GETDATE()
FROM oncd_contact
INNER JOIN oncd_activity_contact on oncd_contact.contact_id = oncd_activity_contact.contact_id
INNER JOIN oncd_activity on oncd_activity.activity_id = oncd_activity_contact.activity_id
INNER JOIN oncd_contact_phone ON oncd_contact.contact_id = oncd_contact_phone.contact_id
INNER JOIN @dnc_table AS doNotCall on doNotCall.phone = (LEFT(oncd_contact_phone.area_code,3) + oncd_contact_phone.phone_number)
WHERE oncd_activity.action_code = 'OUTCALL'
AND   (oncd_activity.result_code = '' or oncd_activity.result_code is null)
GO
