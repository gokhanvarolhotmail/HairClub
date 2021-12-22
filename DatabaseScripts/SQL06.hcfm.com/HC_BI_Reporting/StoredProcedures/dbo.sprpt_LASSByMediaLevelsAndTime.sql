/* CreateDate: 08/30/2011 10:32:19.737 , ModifyDate: 12/12/2019 14:05:00.133 */
GO
/***********************************************************************

PROCEDURE:		sprpt_LASSByMediaLevelsAndTime

VERSION:		v2.0

DESTINATION SERVER:	HCDEVWH1

DESTINATION DATABASE: 	Warehouse

RELATED APPLICATION:  	Bookings Report

AUTHOR: 		Howard Abelow 03/16/2006

IMPLEMENTOR: 		Howard Abelow ONCV

DATE IMPLEMENTED: 	10/12/2007

LAST REVISION DATE: 	8/30/2011

08/29/2011 - HDu - Updated for SQL06 BI DB
12/12/2019 - RH  - Changed ContactSSID to SFDC_LeadID
------------------------------------------------------------------------
NOTES: Gets Query For Report
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC sprpt_LASSByMediaLevelsAndTime '12/1/2019', '12/1/2019',  '12/1/2019', '12/11/2019'

***********************************************************************/

CREATE   PROCEDURE [dbo].[sprpt_LASSByMediaLevelsAndTime]
	@leadbegdt datetime
,	@leadenddt datetime
,	@actbegdt datetime
,	@actenddt datetime

AS
-- get all leads by source between dates
SELECT
	DC.CenterSSID AS 'Center' -- Lead.Center
,	CON.SFDC_LeadID 'RecordID' --,	Lead.RecordID
,	CON.ContactFirstName 'FirstName' --,	Lead.FirstName
,	CON.ContactLastName 'LastName'--,	Lead.LastName
,	DS.Media 'Media'--,	LTRIM(RTRIM(Source.Media)) 'Media'
,	DS.Level02Location 'Level_1' --,	LTRIM(RTRIM(Source.[Level 1])) 'Level_1'
,	LTRIM(RTRIM(DS.Level03Language)) 'Level_2' --,	LTRIM(RTRIM(Source.[Level 2])) 'Level_2'
,	CASE WHEN LTRIM(RTRIM(DS.SourceSSID))='' THEN 'Unknown' ELSE LTRIM(RTRIM(DS.SourceSSID)) END AS  'Source'
INTO #LEAD
  FROM HC_BI_MKTG_DDS.bi_mktg_dds.vwFactLead FL
 	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
 		ON DC.CenterKey = FL.CenterKey
	INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwDimContact CON
		ON CON.ContactKey = FL.ContactKey
	-- Date Filter
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimDate DD
		ON DD.DateKey = FL.LeadCreationDateKey AND DD.FullDate BETWEEN @leadbegdt AND @leadenddt + '12:59:59'
  INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwDimSource DS --Need synonym
	ON DS.SourceKey = FL.SourceKey


-- get the count of leads by source
SELECT
	#LEAD.Media
,	#LEAD.Level_1
,	#LEAD.Level_2
,	#LEAD.Source
,	COUNT(*) AS Leads
INTO #LeadCount
FROM #LEAD
GROUP BY #LEAD.Media
,	#LEAD.Level_1
,	#LEAD.Level_2
,	#Lead.Source


-- find the appts, shows, sales form activity for each lead by creative
SELECT
	#LEAD.Media
,	#LEAD.Level_1
,	#LEAD.Level_2
,	#Lead.Source
,	SUM(CAST(Activity.IsAppointment AS int)) AS Appointments
,	SUM(CAST(Activity.IsShow AS int)) AS Shows
,	SUM(CAST(Activity.IsSale AS int)) AS Sales
INTO #ActivityCounts
FROM #Lead
LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwDimActivity Activity
	ON #Lead.RecordID = Activity.SFDC_LeadID

WHERE 	Activity.ActivityDueDate BETWEEN @actbegdt AND @actenddt + '12:59:59' AND
	(Activity.IsAppointment = 1 OR Activity.IsShow = 1 OR Activity.IsSale = 1)
GROUP BY #LEAD.Media
,	#LEAD.Level_1
,	#LEAD.Level_2
,	#Lead.Source

-- display the results along with rates
SELECT
	#LeadCount.Media
,	#LeadCount.Level_1
,	#LeadCount.Level_2
,	#LeadCount.Source
,	#LeadCount.Leads
,	ISNULL(#ActivityCounts.Appointments,0) AS 'Appointments'
,	ISNULL(dbo.DIVIDE_NOROUND(#ActivityCounts.Appointments,#LeadCount.Leads),0) AS 'Appt Rate'
,	ISNULL(#ActivityCounts.Shows,0) AS 'Shows'
,	ISNULL(dbo.DIVIDE_NOROUND(#ActivityCounts.Shows,#ActivityCounts.Appointments),0) AS 'Show Rate'
,	ISNULL(#ActivityCounts.Sales,0) AS 'Sales'
,	ISNULL(dbo.DIVIDE_NOROUND(#ActivityCounts.Sales,#ActivityCounts.Shows),0) AS 'Sale Rate'
,	ISNULL(dbo.DIVIDE_NOROUND(#ActivityCounts.Sales,#LeadCount.Leads),0) AS 'Sales To Lead'
FROM #LeadCount
LEFT OUTER JOIN #ActivityCounts
	ON #LeadCount.Source=#ActivityCounts.Source
ORDER BY #LeadCount.Media, #LeadCount.Level_1, #LeadCount.Level_2, #LeadCount.SOURCE

Drop Table #Lead
Drop Table #LeadCount
Drop Table #ActivityCounts
GO
