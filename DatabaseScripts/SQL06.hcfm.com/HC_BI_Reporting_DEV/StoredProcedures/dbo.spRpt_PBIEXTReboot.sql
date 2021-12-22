/***********************************************************************
PROCEDURE:				spRpt_PBIEXTReboot
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			PBIEXTReboot
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		01/22/2019
------------------------------------------------------------------------
NOTES:


------------------------------------------------------------------------
CHANGE HISTORY:

------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC [spRpt_PBIEXTReboot]
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_PBIEXTReboot]

AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


/********************************** Create temp table objects *************************************/

CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	CenterNumber INT
,	CenterKey INT
,	CenterDescription VARCHAR(50)
,	CenterDescriptionNumber VARCHAR(255)
,	CenterType VARCHAR(50)
)


CREATE TABLE #Rolling13Months (
	DateKey INT
,	FullDate DATETIME
,	FirstDateOfMonth DATETIME
,	MonthNumber INT
,	YearNumber INT
)


CREATE TABLE #EXT(
	CenterNumber INT
,	FirstDateOfMonth DATETIME
,	YearNumber INT
,	YearMonthNumber INT
,	NB_ExtCnt INT
,	EXTConvCnt_Actual INT
,	EXTConvCnt_Budget INT
,	EXTPCPCount INT
,	EXTPCPCount_Budget INT
,	ConvToSales DECIMAL(18,4)
)

/********************************** Get list of centers *************************************/

INSERT  INTO #Centers
SELECT  CMA.CenterManagementAreaSSID AS 'MainGroupID'
,		CMA.CenterManagementAreaDescription AS 'MainGroup'
,		CTR.CenterNumber
,		CTR.CenterKey
,		CTR.CenterDescription
,		CTR.CenterDescriptionNumber
,		DCT.CenterTypeDescription
FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
			ON CTR.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
			ON CTR.CenterTypeKey = DCT.CenterTypeKey
WHERE  DCT.CenterTypeDescriptionShort = 'C'
		AND CMA.Active = 'Y'


/********************************** Find Dates **********************************************/

INSERT INTO #Rolling13Months
SELECT	DD.DateKey
,	DD.FullDate
,	DD.FirstDateOfMonth
,	DD.MonthNumber
,	DD.YearNumber
FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
WHERE DD.FullDate BETWEEN DATEADD(Month, -1,(DATEADD(yy, -1, DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0)) ))  --First date of year 13 months ago
	AND DATEADD(MINUTE,-1,(DATEADD(DAY,DATEDIFF(DAY,0,GETDATE()+1),0) )) --KEEP Today at 11:59PM
GROUP BY DD.DateKey
,	DD.FullDate
,	DD.FirstDateOfMonth
,	DD.MonthNumber
,	DD.YearNumber


/********* Find values *************************************************************************************/

INSERT INTO #EXT
SELECT DRB.CenterNumber
,	DRB.FirstDateOfMonth
,	DRB.YearNumber
,	DRB.YearMonthNumber
,	DRB.NB_ExtCnt
,	DRB.EXTConvCnt_Actual
,	DRB.EXTConvCnt_Budget
,	DRB.EXTPCPCount
,	DRB.EXTPCPCount_Budget
,	dbo.DIVIDE_DECIMAL(DRB.EXTConvCnt_Actual,DRB.NB_ExtCnt) AS ConvToSales
FROM HC_BI_Datazen.dbo.dashRecurringBusiness DRB
INNER JOIN #Rolling13Months ROLL
	ON DRB.FirstDateOfMonth = ROLL.FirstDateOfMonth
INNER JOIN #Centers CTR
	ON DRB.CenterNumber = CTR.CenterNumber
GROUP BY DRB.CenterNumber
,	DRB.FirstDateOfMonth
,	DRB.YearNumber
,	DRB.YearMonthNumber
,	DRB.NB_ExtCnt
,	DRB.EXTConvCnt_Actual
,	DRB.EXTConvCnt_Budget
,	DRB.EXTPCPCount
,	DRB.EXTPCPCount_Budget



SELECT CenterNumber
,		FirstDateOfMonth
,		YearNumber
,		YearMonthNumber
,       NB_ExtCnt
,       EXTConvCnt_Actual
,       EXTConvCnt_Budget
,       EXTPCPCount
,       EXTPCPCount_Budget
,       ConvToSales
FROM #EXT

END
