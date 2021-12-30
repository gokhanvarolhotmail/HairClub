/* CreateDate: 10/30/2018 16:39:47.077 , ModifyDate: 04/06/2020 10:55:38.257 */
GO
/***********************************************************************
PROCEDURE:				[spRpt_LorenasData]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		10/30/2018
------------------------------------------------------------------------
NOTES:
Run this per month - it will create records for each Source
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [dbo].[spRpt_LorenasData] '4/1/2019', '4/1/2019'

***********************************************************************/

CREATE PROCEDURE [dbo].[xxxspRpt_LorenasData] (
 @leadbegdt DATETIME
,		@actbegdt DATETIME)

AS
BEGIN



CREATE TABLE #Dates	(
DateID INT IDENTITY(1,1)
,	FullDate DATETIME
)


CREATE TABLE #Final(LeadBeginDate DATETIME
,	LeadEndDate DATETIME
,	ActivityBeginDate DATETIME
,	ActivityEndDate DATETIME
,	Media NVARCHAR(50)
,	Level_1 NVARCHAR(50)
,	Level_2 NVARCHAR(50)
,	Level_4 NVARCHAR(50)
,	Level_4_Form NVARCHAR(50)
,	Level_5 NVARCHAR(50)
--,	[Source] NVARCHAR(150)
,	Leads INT
,	Appointments INT
,	ApptRate DECIMAL(18,4)
,	Shows INT
,	ShowRate DECIMAL(18,4)
,	Sales INT
,	SaleRate DECIMAL(18,4)
,	SalesToLead DECIMAL(18,4)
)

INSERT INTO #Dates
SELECT FullDate
FROM HC_BI_ENT_DDS.bief_dds.DimDate
WHERE MonthNumber = MONTH(@leadbegdt)
AND YearNumber = YEAR(@leadbegdt)



/********** BEGIN Loop ***************************************************************************/
--Set the @ProjectID Variable for first iteration
DECLARE @ID INT

SELECT @ID = MIN(DateID)
FROM #Dates

--Loop through each project
WHILE @ID IS NOT NULL
BEGIN


DECLARE @leadenddt DATETIME
DECLARE	@actenddt DATETIME

SET	@leadenddt = (SELECT FullDate  FROM #Dates WHERE DateID = @ID)
SET	@actenddt = (SELECT FullDate  FROM #Dates WHERE DateID = @ID)


-- get all leads by source between dates

IF OBJECT_ID('tempdb..#LeadCount') IS NOT NULL
BEGIN
	DROP TABLE #LeadCount
END

CREATE TABLE #LeadCount(Media NVARCHAR(50)
,	Level_1 NVARCHAR(50)
,	Level_2 NVARCHAR(50)
,	Level_4 NVARCHAR(50)
,	Level_4_Form NVARCHAR(50)
,	Level_5 NVARCHAR(50)
--,	[Source] NVARCHAR(30)
,	Leads INT
,	Appointments INT
,	Shows INT
,	Sales INT
,	NoShows INT
,	NoSales INT
)

INSERT INTO #LeadCount
SELECT	DS.Media Media
,	DS.Level02Location Level_1
,	LTRIM(RTRIM(DS.Level03Language)) Level_2
,	LTRIM(RTRIM(DS.Level04Format)) Level_4
,	CASE WHEN DS.Level04Format=':120' THEN 'ShortForm'
		 WHEN DS.Level04Format=':60' THEN 'ShortForm'
	ELSE 'LongForm' END AS Level_4_Form
,	LTRIM(RTRIM(DS.Level05Creative)) Level_5
--,	CASE WHEN LTRIM(RTRIM(DS.SourceSSID))='' THEN 'Unknown' ELSE LTRIM(RTRIM(DS.SourceSSID)) END AS  Source
,	SUM(vw.Leads) AS Leads
,	SUM(vw.Appointments) AS Appointments
,	SUM(vw.Shows) AS Shows
,	SUM(vw.Sales) AS Sales
,	SUM(vw.NoShows) AS NoShows
,	SUM(vw.NoSales) AS NoSales
FROM HC_BI_MKTG_DDS.bi_mktg_dds.vwFactLead vw
INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
	ON DD.FullDate = vw.PartitionDate
	AND DD.FullDate BETWEEN @leadbegdt AND @leadenddt
INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource DS
	ON DS.SourceKey = vw.SourceKey
GROUP BY LTRIM(RTRIM(DS.Level03Language)),
         LTRIM(RTRIM(DS.Level04Format)),
         CASE
         WHEN DS.Level04Format = ':120' THEN
         'ShortForm'
         WHEN DS.Level04Format = ':60' THEN
         'ShortForm'
         ELSE
         'LongForm'
         END,
         LTRIM(RTRIM(DS.Level05Creative)),
         --CASE
         --WHEN LTRIM(RTRIM(DS.SourceSSID)) = '' THEN
         --'Unknown'
         --ELSE
         --LTRIM(RTRIM(DS.SourceSSID))
         --END,
         DS.Media,
         DS.Level02Location

-- display the results along with rates


INSERT INTO #Final
SELECT @leadbegdt LeadBeginDate
,	@leadenddt LeadEndDate
,	@actbegdt ActivityBeginDate
,	@actenddt ActivityEndDate
,	#LeadCount.Media
,	#LeadCount.Level_1
,	#LeadCount.Level_2
,	#LeadCount.Level_4
,	#LeadCount.Level_4_Form
,	#LeadCount.Level_5
--,	#LeadCount.[Source]
,	#LeadCount.Leads
,	ISNULL(#LeadCount.Appointments,0) AS Appointments
,	ISNULL(dbo.DIVIDE_NOROUND(#LeadCount.Appointments,#LeadCount.Leads),0) AS [Appt Rate]
,	ISNULL(#LeadCount.Shows,0) AS Shows
,	ISNULL(dbo.DIVIDE_NOROUND(#LeadCount.Shows,#LeadCount.Appointments),0) AS [Show Rate]
,	ISNULL(#LeadCount.Sales,0) AS Sales
,	ISNULL(dbo.DIVIDE_NOROUND(#LeadCount.Sales,#LeadCount.Shows),0) AS [Sale Rate]
,	ISNULL(dbo.DIVIDE_NOROUND(#LeadCount.Sales,#LeadCount.Leads),0) AS [Sales To Lead]
FROM #LeadCount
ORDER BY #LeadCount.Media
, #LeadCount.Level_1
, #LeadCount.Level_2
,	#LeadCount.Level_4
,	#LeadCount.Level_4_Form
,	#LeadCount.Level_5
--, #LeadCount.[Source]

/************************* END Loop *****************************************************************/
--Then at the end of the loop
	SELECT @ID = MIN(DateID)
		FROM #Dates
		WHERE DateID > @ID
END

SELECT * FROM #Final

END
GO
