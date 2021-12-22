/***********************************************************************
PROCEDURE:				pop_dashbdBudget
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:
AUTHOR:					Rachelen Hut

------------------------------------------------------------------------
CHANGE HISTORY:
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC [pop_dashbdBudget]
***********************************************************************/
CREATE PROCEDURE [dbo].[pop_dashbdBudget]

AS
BEGIN

CREATE TABLE #budget (
	CenterID INT
	,	CenterDescriptionNumber NVARCHAR(100)
	,	DateKey INT
	,	PartitionDate DATETIME
	,	AccountID INT
	,	Budget DECIMAL(13,2)
	,	Actual DECIMAL(13,2)
	,	AccountDescription NVARCHAR(100)
	,	Type NVARCHAR(1)
	,	RegionKey INT
	,	RegionDescription NVARCHAR(100)
	)


INSERT INTO #budget
SELECT
	a.CenterID
	,	c.CenterDescriptionNumber
	,	a.DateKey
	,	a.PartitionDate
	,	a.AccountID
	,	a.Budget
	,	a.Flash AS Actual
	,	acc.AccountDescription
	,	RIGHT(acc.AccountDescription,1) AS Type
	,	c.RegionKey
	,	r.RegionDescription
FROM HC_Accounting.dbo.FactAccounting a
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter c
		ON a.[CenterID] = c.CenterSSID
	INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].[DimAccount]acc
		ON a.AccountID = acc.AccountID
	INNER JOIN [HC_BI_ENT_DDS].[bi_ent_dds].DimRegion r
		ON r.RegionKey = c.RegionKey

WHERE a.AccountID IN(10205,10305,10210,10310,10215,10315,10225,10325,10220,10320)
AND a.PartitionDate BETWEEN '2014-01-01 00:00:00.000'
	AND CAST(CAST(MONTH(GETDATE()) AS VARCHAR(2))+'/1/'+ CAST(YEAR(GETDATE()) AS VARCHAR(4)) AS DATE)

ORDER BY a.CenterID, PartitionDate


--merge records with Target and Source
MERGE dashbdBudget AS Target
USING (SELECT CenterID
		,	CenterDescriptionNumber
		,	DateKey
		,	PartitionDate
		,	AccountID
		,	Budget
		,	Actual
		,	AccountDescription
		,	[Type]
		,	RegionKey
		,	RegionDescription
		FROM #budget
		GROUP BY CenterID
		,	CenterDescriptionNumber
		,	DateKey
		,	PartitionDate
		,	AccountID
		,	Budget
		,	Actual
		,	AccountDescription
		,	[Type]
		,	RegionKey
		,	RegionDescription) AS Source
ON (Target.CenterID = Source.CenterID AND Target.DateKey = Source.DateKey
		AND Target.PartitionDate = Source.PartitionDate AND Target.RegionKey = Source.RegionKey
		AND Target.AccountID = Source.AccountID)
WHEN MATCHED THEN
	UPDATE SET Target.Budget = Source.Budget
	,	Target.Actual = Source.Actual


WHEN NOT MATCHED BY TARGET THEN
	INSERT(CenterID
		,	CenterDescriptionNumber
		,	DateKey
		,	PartitionDate
		,	AccountID
		,	Budget
		,	Actual
		,	AccountDescription
		,	[Type]
		,	RegionKey
		,	RegionDescription)
	VALUES(Source.CenterID
		,	Source.CenterDescriptionNumber
		,	Source.DateKey
		,	Source.PartitionDate
		,	Source.AccountID
		,	Source.Budget
		,	Source.Actual
		,	Source.AccountDescription
		,	Source.[Type]
		,	Source.RegionKey
		,	Source.RegionDescription)
		;
END
