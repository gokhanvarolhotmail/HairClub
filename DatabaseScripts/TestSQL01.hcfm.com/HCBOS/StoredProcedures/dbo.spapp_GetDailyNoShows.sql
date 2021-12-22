/* CreateDate: 08/09/2007 14:33:41.213 , ModifyDate: 01/25/2010 08:11:31.777 */
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[spapp_GetDailyNoShows]

AS

/* spapp_GetDailyNoShows

**  Populates the NoShowDaily table

** Revision History:

** ------------------------------------------------------------------

**  Date       Name      Description     	Project

** ------------------------------------------------------------------

**  09/15/06  HABELOW   CREATE     	No Show Emails

**  09/21/06  HABELOW   Added intelligence for next date

**  08/02/07  MWEGNER(ONC)   Updated for ONCV compatibility



SET NOCOUNT ON
-- declare all variables!
DECLARE @startDate datetime

-- get the last date table was updated
SELECT @startDate = MAX(NoShowDate) FROM dbo.NoShowsDaily

INSERT INTO dbo.NoShowsDaily
SELECT  mngr.recordid
,	CASE WHEN LEN(info.cst_gender) > 0 OR info.cst_gender IS NOT NULL  THEN info.cst_gender ELSE 'Unknown' END as Gender
,	CASE WHEN LEN(info.email_) > 0 OR info.email_ IS NOT NULL THEN 1 ELSE 0 END as HasEmail
,	0 as SentEmail
,	0 as IsBounced
,	mngr.Date_ as NoShowDate
,	DATEPART(WEEK, mngr.Date_) as NoShowWeek
,	DATEPART(Year, mngr.Date_) as NoShowYear
,	NULL as NextApptDateBooked
,	0 as BookedWeekNumber
, 	0 as isShow
FROM HCM.dbo.gmin_mngr mngr INNER JOIN HCM.dbo.gminfo info ON
	     mngr.recordid = info.recordid
Where date_  > @startDate
	AND HCM.dbo.ISAPPT(mngr.act_code) = 1
	AND HCM.dbo.ISSHOW(mngr.result_code) = 0
	-- H. Abelow 9/11/2006
	-- added this new function to only count completed appts
	AND HCM.dbo.ISCOMPLETED(mngr.result_code) = 1
ORDER BY NoShowDate
*/

SET NOCOUNT ON
-- declare all variables!
DECLARE @startDate datetime

-- get the last date table was updated
SELECT @startDate = MAX(NoShowDate) FROM dbo.NoShowsDaily

INSERT INTO dbo.NoShowsDaily
SELECT  ac.contact_id
,	CASE WHEN LEN(c.cst_gender_code) > 0 OR c.cst_gender_code IS NOT NULL  THEN c.cst_gender_code ELSE 'Unknown' END as Gender
,	CASE WHEN LEN(ce.email) > 0 OR ce.email IS NOT NULL THEN 1 ELSE 0 END as HasEmail
,	0 as SentEmail
,	0 as IsBounced
,	a.due_date as NoShowDate
,	DATEPART(WEEK, a.due_date) as NoShowWeek
,	DATEPART(Year, a.due_date) as NoShowYear
,	NULL as NextApptDateBooked
,	0 as BookedWeekNumber
, 	0 as isShow
FROM HCM.dbo.oncd_activity a
INNER JOIN HCM.dbo.oncd_activity_contact ac ON ac.activity_id = a.activity_id
INNER JOIN HCM.dbo.oncd_contact c ON ac.contact_id = c.contact_id AND ac.primary_flag = 'Y'
LEFT OUTER JOIN HCM.dbo.oncd_contact_email ce ON ce.contact_id = c.contact_id AND ce.primary_flag = 'Y'
Where a.due_date  > @startDate
	AND HCM.dbo.ISAPPT(a.action_code) = 1
	AND HCM.dbo.ISSHOW(a.result_code) = 0
	-- H. Abelow 9/11/2006
	-- added this new function to only count completed appts
	AND HCM.dbo.ISCOMPLETED(a.result_code) = 1
ORDER BY NoShowDate
GO
