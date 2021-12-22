/***********************************************************************
VIEW:					[vwd_FranchisePCPCounts]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:		07/01/2016
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM [vwd_FranchisePCPCounts] where CenterSSID = 804 order by YearMonthNumber

SELECT * FROM [vwd_FranchisePCPCounts] order by CenterSSID, YearMonthNumber
***********************************************************************/
CREATE VIEW [dbo].[vwd_FranchisePCPCounts]
AS


WITH FranchisePCP AS (
	SELECT FirstDateOfMonth
	,	YearNumber
	,	YearMonthNumber
	,	CenterSSID
	,	BIOPCPCount
	,	XtrandsPCPCount
	,	EXTPCPCount
	FROM dbo.dashRecurringBusiness
	WHERE FirstDateOfMonth > DATEADD(MM,-14,GETDATE())
	AND CenterSSID LIKE '[78]%'
),

DecemberCounts AS (
	SELECT FirstDateOfMonth
	,	YearNumber
	,	YearMonthNumber
	,	CenterSSID
	,	BIOPCPCount AS 'BIOPCPBudget'
	,	XtrandsPCPCount AS 'XtrandsPCPBudget'
	,	EXTPCPCount AS 'EXTPCPBudget'
	FROM dbo.dashRecurringBusiness RB
		WHERE CenterSSID LIKE '[78]%'
	AND RB.YearMonthNumber like '%12'
)

SELECT FR.FirstDateOfMonth
     , FR.YearNumber
     , FR.YearMonthNumber
     , FR.CenterSSID
     , FR.BIOPCPCount
     , FR.XtrandsPCPCount
     , FR.EXTPCPCount
     , DC.BIOPCPBudget
     , DC.XtrandsPCPBudget
     , DC.EXTPCPBudget
FROM FranchisePCP FR
LEFT JOIN DecemberCounts DC
	ON DC.CenterSSID = FR.CenterSSID
WHERE DC.YearNumber = (FR.YearNumber - 1)
