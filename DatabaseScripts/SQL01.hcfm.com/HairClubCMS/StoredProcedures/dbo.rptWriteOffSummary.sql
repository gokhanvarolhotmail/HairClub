/*===============================================================================================
-- Procedure Name:			rptWriteOffSummary
-- Procedure Description:
--
-- Created By:				Michael Maass
-- Implemented By:			Michael Maass
-- Last Modified By:		Michael Maass
--
-- Date Created:			10/03/13
-- Destination Server:		SQL01
-- Destination Database:	HairClubCMS
-- Related Application:		CMS
================================================================================================
NOTES: 	10/03/13	MLM		Initial Creation
================================================================================================
CHANGE HISTORY:
10/29/2014 - RH - Changed SO.OrderDate to SO.ctrOrderDate so that the center's date would be reported.
04/09/2015 - RH - Changed the OrderDate to ISNULL(so.ctrOrderDate,so.OrderDate) as OrderDate
05/20/2015 - RH - (#114447) Added LEFT JOIN to datNotesClient Write-Off notes
09/24/2015 - RH - (#119008) Rewrote stored procedure to remove duplicate client Write-Off notes.
01/07/2016 - RH - (#122149) Changed to VARCHAR(MAX)- ClientFullNameCalc, NotesClient
================================================================================================
Sample Execution:
EXEC [rptWriteOffSummary] '849', '1/1/2016', '1/24/2016'

================================================================================================
*/
CREATE PROCEDURE [dbo].[rptWriteOffSummary]
(
	@CenterIDs NVARCHAR(MAX),
	@StartDate DATETIME,
	@EndDate DATETIME
)
AS
BEGIN
-- SET NOCOUNT ON added to prevent extra result sets from
-- interfering with SELECT statements.
SET NOCOUNT ON;

SET @EndDate = DATEADD(DAY,1,@EndDate)

/*************************** Create temp tables **********************************************************/

CREATE TABLE #Writeoff(
		CenterDescriptionFullCalc NVARCHAR(50)
	,	ClientFullNameCalc NVARCHAR(MAX)
	,	ClientGUID UNIQUEIDENTIFIER
    ,	MembershipDescription  NVARCHAR(50)
    ,	ClientMembershipStatusDescription  NVARCHAR(50)
    ,	ARBalance MONEY
    ,	InvoiceNumber  NVARCHAR(50)
    ,	OrderDate  DATETIME
    ,	SalesCodeTypeDescription NVARCHAR(50)
    ,	[Description] NVARCHAR(250)
    ,	ExtendedPriceCalc MONEY
    ,	TotalTaxCalc MONEY
    ,	PriceTaxCalc MONEY
    ,	UserLogin NVARCHAR(50)
    ,	NotesClient	NVARCHAR(MAX)
)

CREATE TABLE #Notes(
		Ranking INT
	,	ClientGUID UNIQUEIDENTIFIER
	,	NotesClient NVARCHAR(MAX)
)

/*************************** Populate the main table #Writeoff **********************************************************/

INSERT INTO #Writeoff
SELECT  ctr.CenterDescriptionFullCalc
	,	c.ClientFullNameCalc
	,	so.ClientGUID
    ,	m.MembershipDescription
    ,	cms.ClientMembershipStatusDescription
    ,	c.ARBalance
    ,	so.InvoiceNumber
    ,	ISNULL(CAST(so.ctrOrderDate AS DATE),CAST(so.OrderDate AS DATE )) AS OrderDate  --RH Changed to ISNULL statement 04/09/2015
    ,	sct.SalesCodeTypeDescription
    ,	CASE WHEN sct.SalesCodeTypeDescriptionShort = 'Product'
            THEN 'Write Off Product Revenue'
            WHEN sct.SalesCodeTypeDescriptionShort = 'Service'
            THEN 'Write Off Service Revenue'
            WHEN sct.SalesCodeTypeDescriptionShort = 'Membership'
                AND rg.RevenueGroupDescriptionShort = 'PCP'
            THEN 'Write Off PCP Revenue'
            WHEN sct.SalesCodeTypeDescriptionShort = 'Membership'
                AND rg.RevenueGroupDescriptionShort = 'NB'
            THEN 'Write Off New Business Revenue'
            WHEN sct.SalesCodeTypeDescriptionShort = 'Misc'
            THEN 'Write Off Miscellanous Revenue'
            ELSE 'Write Off Miscellanous Revenue'
		END AS [Description]
    ,	ABS(sod.ExtendedPriceCalc) AS ExtendedPriceCalc
    ,	ABS(sod.TotalTaxCalc) AS TotalTaxCalc
    ,	ABS(sod.PriceTaxCalc) AS PriceTaxCalc
    ,	emp.UserLogin
    ,	NULL AS NotesClient
FROM    datSalesOrder so
    INNER JOIN datSalesOrderDetail sod ON so.SalesOrderGUID = sod.SalesOrderGUID
    INNER JOIN cfgSalesCode sc ON sod.SalesCodeID = sc.SalesCodeID
    INNER JOIN lkpSalesCodeType sct ON sc.SalesCodeTypeID = sct.SalesCodeTypeID
    INNER JOIN datClient c ON so.ClientGUID = c.ClientGUID
	INNER JOIN dbo.cfgCenter ctr ON c.CenterID = ctr.CenterID
    INNER JOIN datClientMembership cm ON so.ClientMembershipGUID = cm.ClientMembershipGUID
                                            AND c.ClientGUID = cm.ClientGUID
    INNER JOIN cfgMembership m ON cm.MembershipID = m.MembershipID
    INNER JOIN lkpRevenueGroup rg ON m.RevenueGroupID = rg.RevenueGroupID
    INNER JOIN lkpClientMembershipStatus cms ON cm.ClientMembershipStatusID = cms.ClientMembershipStatusID
    INNER JOIN datEmployee emp ON so.EmployeeGUID = emp.EmployeeGUID

WHERE   so.IsWrittenOffFlag = 1
    AND so.CenterID IN (SELECT  item
                        FROM    fnSplit(@CenterIDs ,','))
    AND ISNULL(so.ctrOrderDate,so.OrderDate) BETWEEN @StartDate AND @EndDate
	AND so.IsVoidedFlag = 0
GROUP BY ISNULL(CAST(so.ctrOrderDate AS DATE),CAST(so.OrderDate AS DATE ))
       , CASE WHEN sct.SalesCodeTypeDescriptionShort = 'Product'
       THEN 'Write Off Product Revenue'
       WHEN sct.SalesCodeTypeDescriptionShort = 'Service'
       THEN 'Write Off Service Revenue'
       WHEN sct.SalesCodeTypeDescriptionShort = 'Membership'
       AND rg.RevenueGroupDescriptionShort = 'PCP'
       THEN 'Write Off PCP Revenue'
       WHEN sct.SalesCodeTypeDescriptionShort = 'Membership'
       AND rg.RevenueGroupDescriptionShort = 'NB'
       THEN 'Write Off New Business Revenue'
       WHEN sct.SalesCodeTypeDescriptionShort = 'Misc'
       THEN 'Write Off Miscellanous Revenue'
       ELSE 'Write Off Miscellanous Revenue'
       END
       , ABS(sod.ExtendedPriceCalc)
       , ABS(sod.TotalTaxCalc)
       , ABS(sod.PriceTaxCalc)
       , ctr.CenterDescriptionFullCalc
       , c.ClientFullNameCalc
       , so.ClientGUID
       , m.MembershipDescription
       , cms.ClientMembershipStatusDescription
       , c.ARBalance
       , so.InvoiceNumber
       , sct.SalesCodeTypeDescription
       , emp.UserLogin

/*************************** Populate #Notes **********************************************************/

INSERT INTO #Notes
SELECT ROW_NUMBER()OVER (PARTITION BY #Writeoff.ClientGUID ORDER BY #Writeoff.ClientGUID) AS Ranking
,	#Writeoff.ClientGUID
,	nc.NotesClient
FROM #Writeoff
LEFT JOIN dbo.datNotesClient nc
	ON #Writeoff.ClientGUID = nc.ClientGUID AND nc.NoteSubTypeID = 4  --Write-Off
GROUP BY #Writeoff.ClientGUID
,	nc.NotesClient

/*************************** Final select ************************************************************/

SELECT  CenterDescriptionFullCalc
		,	ClientFullNameCalc
        ,	MembershipDescription
        ,	ClientMembershipStatusDescription
        ,	ARBalance
        ,	InvoiceNumber
        ,	OrderDate
        ,	SalesCodeTypeDescription
        ,	[Description]
        ,	SUM(ExtendedPriceCalc) AS ExtendedPriceCalc
        ,	SUM(TotalTaxCalc) AS TotalTaxCalc
        ,	SUM(PriceTaxCalc) AS PriceTaxCalc
        ,	UserLogin
		,	#Notes.NotesClient
FROM    #Writeoff
	LEFT JOIN #Notes
		ON #Writeoff.ClientGUID = #Notes.ClientGUID
WHERE #Notes.Ranking = 1
GROUP BY CenterDescriptionFullCalc
		,	ClientFullNameCalc
        ,	MembershipDescription
        ,	ClientMembershipStatusDescription
        ,	ARBalance
        ,	InvoiceNumber
        ,	OrderDate
        ,	SalesCodeTypeDescription
        ,	[Description]
        ,	UserLogin
		,	#Notes.NotesClient


END
