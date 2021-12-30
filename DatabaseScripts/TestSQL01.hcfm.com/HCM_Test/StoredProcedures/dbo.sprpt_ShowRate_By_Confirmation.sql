/* CreateDate: 10/17/2007 08:55:09.090 , ModifyDate: 05/01/2010 14:48:10.020 */
GO
/***********************************************************************

PROCEDURE:		sprpt_ShowRate_By_Confirmation

VERSION:		v2.0

DESTINATION SERVER:	HCSQL3

DESTINATION DATABASE: 	HCM

RELATED APPLICATION:  	Email Confirmation Report

AUTHOR: 		Howard Abelow 02/01/2006

IMPLEMENTOR: 		Howard Abelow ONCV

DATE IMPLEMENTED: 	10/12/2007

LAST REVISION DATE: 	10/12/2007

------------------------------------------------------------------------
NOTES: Analysis of Show Rate by Appointment Date for 8 different categories of confirmations:
	4 by Phone(Y1, Y2, Y3, Y5) and 4 by Phone and Email (Y1 + Email, Y2 + Email, Y3 + Email, Y5 + Email)
	The email data is joined from the EmailConfirm Table
------------------------------------------------------------------------

SAMPLE EXECUTION: EXEC sprpt_ShowRate_By_Confirmation '8/1/07', '8/11/07'

***********************************************************************/
CREATE   PROCEDURE [dbo].[sprpt_ShowRate_By_Confirmation]
(
	@date1 As datetime
, 	@date2 As datetime
)
AS

-- the #Final_Report table simply does the math to provide us with show rates and totals - needs to be static
IF OBJECT_ID('tempdb..#Final_Report') IS NOT NULL
BEGIN
            DROP TABLE #Final_Report
END
-- create the table
CREATE TABLE #Final_Report
( [Date]			datetime,
  Total_Appts  			int,
  [Phone Appointments Only]	int,
  [Phone Shows Only]    	int,
  [Phone Show Rate]		float,
  [Phone + Email Appointments]	int,
  [Phone + Email Shows]		int,
  [Emails Show Rate]   		float,
  [Y1 Shows]			int,
  [Y1 + Email Shows]		int,
  [Y1 No Shows]			int,
  [Y1 + Email No Shows]		int,
  [Y1 Show Rate]   		float,
  [Y1 + Email Show Rate]	float,
  [Y2 Shows]			int,
  [Y2 + Email Shows]		int,
  [Y2 No Shows]			int,
  [Y2 + Email No Shows]		int,
  [Y2 Show Rate]   		float,
  [Y2 + Email Show Rate]	float,
  [Y3 Shows]			int,
  [Y3 + Email Shows]		int,
  [Y3 No Shows]			int,
  [Y3 + Email No Shows]		int,
  [Y3 Show Rate]   		float,
  [Y3 + Email Show Rate]	float,
  [Y5 Shows]			int,
  [Y5 + Email Shows]		int,
  [Y5 No Shows]			int,
  [Y5 + Email No Shows]		int,
  [Y5 Show Rate]   		float,
  [Y5 + Email Show Rate]	float
)

/*
set the date variables for testing only
declare @date1 datetime
declare @date2 datetime
set @date1 = '3/01/06'
set @date2 = '3/31/06'
*/

declare @apptDate datetime
set @apptDate = @date1

-- set the math variables
DECLARE @phoneAppts INTEGER
DECLARE @phoneShows INTEGER
DECLARE @emailAppts INTEGER
DECLARE @emailShows INTEGER

-- loop through the range of dates
WHILE (DATEDIFF ( dd , @apptDate , @date2 ) > -1 )

BEGIN

IF OBJECT_ID('tempdb..#raw_data') IS NOT NULL
BEGIN
            DROP TABLE #raw_data
END

CREATE TABLE #raw_data
( All_Id   	nchar(10),
  Email_Id	nchar(10),
  Act_Code      nchar(10),
  Result_Code	nchar(10),
  Act_Date      datetime,
  Status	varchar(8),
  Email_Date	datetime
)

/* -- testing only -----------
declare @apptDate datetime
SET @apptDate = '1/24/06'
---------------------------*/


-- The first query gets the raw result set with appointments for appt date
INSERT #raw_data
Select ac.contact_id  'All_Id' -- will show all recordid's with appts
, 	ec.Recordid  'Email_Id' -- NULL or recordID depending if email was sent as well -- CHANGED TO RecordID BK
, 	action_code 'Act_Code' -- gets the last activity (appt) up to appt date
, 	result_code 'Result_Code' -- gets the lowest Value Y confirmation
,	due_date 'Act_Date' -- gets the appointment date
,	ec.status 'Status' -- 'sent' or 'not sent' or NULL(see above)
,	CONVERT(Datetime, ec.[ApptDate])
from oncd_activity a
	INNER JOIN oncd_activity_contact ac
		ON ac.activity_id = a.activity_id AND ac.primary_flag = 'Y'
	LEFT OUTER JOIN [hcmtbl_email_log] ec ON
		ac.contact_id = ec.Recordid  -- CHANGED TO RecordID BK
	WHERE
	-- find only appts for the date here
	 ac.contact_id IN
	(
		SELECT contact_id FROM oncd_activity_contact ac1
			INNER JOIN oncd_activity a1 ON a1.activity_id = ac1.activity_id AND ac1.primary_flag = 'Y'
		WHERE a1.due_date = @apptDate
			AND dbo.ISAPPT(a1.action_code) = 1
	)
AND
((a.result_code IN('DRCTCNFIRM', 'VMCONFIRM', 'INDCONFIRM', 'NOANSWER')) -- find the phone confirms
OR
((dbo.ISAPPT(a.action_code)=1) OR (dbo.ISSHOW(a.result_code)=1))) -- find appts or shows
AND
(a.due_date between DATEADD(dd, -2, @apptDate) AND @apptDate) -- go back 2 days to get a last confirm


--GROUP BY gm.recordid, act_code, ec.recordid, ec.status
order by ac.contact_id

--Select * FROM #raw_data
--Select Count(Distinct All_ID) APPTS From #raw_data where dbo.ISAPPT(act_code)=1 AND act_date = '1/24/06'
--Select Count(Distinct All_ID) APPTS From #raw_data where dbo.ISAPPT(act_code)=1 AND act_date = '1/23/06'
--Select Count(All_ID) SHOWS From #raw_data where dbo.ISSHOW(result_code)=1 AND act_date = '1/24/06'


--Select all_id FROM #raw_data group by all_id having count(all_id) > 2
-- #Confirms temp table sets up the data in spreadsheet format adding a confirm_code column
IF OBJECT_ID('tempdb..#Confirms') IS NOT NULL
BEGIN
            DROP TABLE #Confirms
END

CREATE TABLE #Confirms
( Act_Date      datetime,
  All_Id   	nchar(10),
  Email_Id	nchar(10),
  Act_Code      nchar(10),
  Result_Code	nchar(10),
  Confirm_Code	nchar(10)
)


INSERT #Confirms
Select MAX(Act_Date)
,	All_ID
,	CASE When (MAX(Email_Date) BETWEEN DATEADD(dd, -2, MAX(Act_Date)) AND MAX(Act_Date)) Then Email_Id ELSE NULL END
,	MAX(Act_code)
,	Result_Code
,	'none' 'confirm_code' -- new column to track the confirms
FROM #raw_data
WHERE (dbo.ISAPPT(act_code)=1) AND (Status='SENT' OR Status IS NULL)
GROUP BY All_Id, Email_Id, Result_Code

-- the update now matches back the recordid and adds the confirm_code into the same row
-- this will let us see both the appt, show and confirm all in one row
UPDATE #Confirms
SET confirm_code = #raw_data.Result_Code
FROM #raw_data
WHERE #raw_data.All_ID = #Confirms.All_ID
AND #raw_data.Result_Code IN('DRCTCNFIRM', 'VMCONFIRM', 'INDCONFIRM', 'NOANSWER')

--for testing only
--Select * FROM #Confirms
--END

-- #Show_Rate temp table sets up the data to be counted for all categories
IF OBJECT_ID('tempdb..#Show_Rate') IS NOT NULL
BEGIN
            DROP TABLE #Show_Rate
END

CREATE TABLE #Show_Rate
( [Date]	datetime,
  Total_Appts  	int,
  y1_show	int,
  y1_no_show    int,
  y1e_show	int,
  y1e_no_show	int,
  y2_show	int,
  y2_no_show    int,
  y2e_show	int,
  y2e_no_show	int,
  y3_show	int,
  y3_no_show    int,
  y3e_show	int,
  y3e_no_show	int,
  y5_show	int,
  y5_no_show    int,
  y5e_show	int,
  y5e_no_show	int
)


INSERT #Show_Rate
SELECT MAX(act_date) 'Date'
,	SUM(CASE WHEN dbo.ISAPPT(act_code)=1 THEN 1 ELSE 0 END) 'Total_Appts'
,	SUM(CASE WHEN confirm_code='DRCTCNFIRM' AND dbo.ISSHOW(result_code)=1 AND (email_id IS NULL) THEN 1 ELSE 0 END) 'y1_show'
,	SUM(CASE WHEN confirm_code='DRCTCNFIRM' AND dbo.ISSHOW(result_code)=0 AND (email_id IS NULL) THEN 1 ELSE 0 END) 'y1_no_show'
,	SUM(CASE WHEN confirm_code='DRCTCNFIRM' AND dbo.ISSHOW(result_code)=1 AND (email_id IS NOT NULL) then 1 ELSE 0 END) 'y1e_show'
,	SUM(CASE WHEN confirm_code='DRCTCNFIRM' AND dbo.ISSHOW(result_code)=0 AND (email_id IS NOT NULL) then 1 ELSE 0 END) 'y1e_no_show'
,	SUM(CASE WHEN confirm_code='VMCONFIRM' AND dbo.ISSHOW(result_code)=1 AND (email_id IS NULL) THEN 1 ELSE 0 END) 'y2_show'
,	SUM(CASE WHEN confirm_code='VMCONFIRM' AND dbo.ISSHOW(result_code)=0 AND (email_id IS NULL) THEN 1 ELSE 0 END) 'y2_no_show'
,	SUM(CASE WHEN confirm_code='VMCONFIRM' AND dbo.ISSHOW(result_code)=1 AND (email_id IS NOT NULL) then 1 ELSE 0 END) 'y2e_show'
,	SUM(CASE WHEN confirm_code='VMCONFIRM' AND dbo.ISSHOW(result_code)=0 AND (email_id IS NOT NULL) then 1 ELSE 0 END) 'y2e_no_show'
,	SUM(CASE WHEN confirm_code='INDCONFIRM' AND dbo.ISSHOW(result_code)=1 AND (email_id IS NULL) THEN 1 ELSE 0 END) 'y3_show'
,	SUM(CASE WHEN confirm_code='INDCONFIRM' AND dbo.ISSHOW(result_code)=0 AND (email_id IS NULL) THEN 1 ELSE 0 END) 'y3_no_show'
,	SUM(CASE WHEN confirm_code='INDCONFIRM' AND dbo.ISSHOW(result_code)=1 AND (email_id IS NOT NULL) then 1 ELSE 0 END) 'y3e_show'
,	SUM(CASE WHEN confirm_code='INDCONFIRM' AND dbo.ISSHOW(result_code)=0 AND (email_id IS NOT NULL) then 1 ELSE 0 END) 'y3e_no_show'
,	SUM(CASE WHEN (confirm_code='NOANSWER' OR confirm_code='none') AND dbo.ISSHOW(result_code)=1 AND (email_id IS NULL) THEN 1 ELSE 0 END) 'y5_show'
,	SUM(CASE WHEN (confirm_code='NOANSWER' OR confirm_code='none') AND dbo.ISSHOW(result_code)=0 AND (email_id IS NULL) THEN 1 ELSE 0 END) 'y5_no_show'
,	SUM(CASE WHEN (confirm_code='NOANSWER' OR confirm_code='none') AND dbo.ISSHOW(result_code)=1 AND (email_id IS NOT NULL) then 1 ELSE 0 END) 'y5e_show'
,	SUM(CASE WHEN (confirm_code='NOANSWER' OR confirm_code='none') AND dbo.ISSHOW(result_code)=0 AND (email_id IS NOT NULL) then 1 ELSE 0 END) 'y5e_no_show'
FROM #Confirms

SELECT @phoneAppts = (SELECT y1_show + y1_no_show + y2_show + y2_no_show + y3_show + y3_no_show + y5_show + y5_no_show FROM #Show_rate)
SELECT @phoneShows = (SELECT y1_show + y2_show + y3_show + y5_show FROM #Show_rate)
SELECT @emailAppts = (SELECT y1e_show + y1e_no_show + y2e_show + y2e_no_show + y3e_show + y3e_no_show + y5e_show + y5e_no_show FROM #Show_rate)
SELECT @emailShows = (SELECT y1e_show + y2e_show + y3e_show + y5e_show FROM #Show_rate)

-- start building the rows for the final report
INSERT #Final_Report
SELECT [Date]
,	Total_Appts
,	ISNULL(@phoneAppts,0) 'Phone Appointments Only'
,	ISNULL(@phoneShows,0) 'Phone Shows Only'
,	dbo.Divide(@phoneShows, @phoneAppts) 'Phones Show Rate'
,	ISNULL(@emailAppts,0) 'Phone + Email Appointments'
,	ISNULL(@emailShows,0) 'Phone + Email Shows'
,	dbo.Divide(@emailShows, @emailAppts) 'Emails Show Rate'
,	y1_show 'Y1 Shows'
,	y1e_show 'Y1 + Email Shows'
,	y1_no_show 'Y1 No Shows'
,	y1e_no_show 'Y1 + Email No Shows'
,	dbo.Divide(y1_show, y1_show + y1_no_show) 'Y1 Show Rate'
,	dbo.Divide(y1e_show, y1e_show + y1e_no_show) 'Y1 + Email Show Rate'
,	y2_show 'Y2 Shows'
,	y2e_show 'Y2 + Email Shows'
,	y2_no_show 'Y2 No Shows'
,	y2e_no_show 'Y2 + Email No Shows'
,	dbo.Divide(y2_show, y2_show + y2_no_show) 'Y2 Show Rate'
,	dbo.Divide(y2e_show, y2e_show + y2e_no_show) 'Y2 + Email Show Rate'
,	y3_show 'Y3 Shows'
,	y3e_show 'Y3 + Email Shows'
,	y3_no_show 'Y3 No Shows'
,	y3e_no_show 'Y3 + Email No Shows'
,	dbo.Divide(y3_show, y3_show + y3_no_show) 'Y3 Show Rate'
,	dbo.Divide(y3e_show, y3e_show + y3e_no_show) 'Y3 + Email Show Rate'
,	y5_show 'Y5 Shows'
,	y5e_show 'Y5 + Email Shows'
,	y5_no_show 'Y5 No Shows'
,	y5e_no_show 'Y5 + Email No Shows'
,	dbo.Divide(y5_show, y5_show + y5_no_show) 'Y5 Show Rate'
,	dbo.Divide(y5e_show, y5e_show + y5e_no_show) 'Y5 + Email Show Rate'
FROM #Show_Rate

SET @apptDate = DATEADD(dd, 1, @apptDate)

END

-- get the report
Select * FROM #Final_Report
WHERE [Date] IS NOT NULL

-- drop the tables
DROP TABLE #raw_data
DROP TABLE #Confirms
DROP TABLE #Show_Rate
DROP TABLE #Final_Report
GO
