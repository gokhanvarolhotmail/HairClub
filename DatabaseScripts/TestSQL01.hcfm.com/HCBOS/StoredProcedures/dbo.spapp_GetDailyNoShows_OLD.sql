/* CreateDate: 09/15/2006 13:55:26.147 , ModifyDate: 01/25/2010 08:11:31.790 */
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE   PROCEDURE [dbo].[spapp_GetDailyNoShows_OLD]

AS

/* spapp_GetDailyNoShows

**  Populates the NoShowDaily table

** Revision History:

** ------------------------------------------------------------------

**  Date       Name      Description     	Project

** ------------------------------------------------------------------

**  09/15/06  HABELOW   CREATE     	No Show Emails

**  09/21/06  HABELOW   Added intelligence for next date

**

*/



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
GO
