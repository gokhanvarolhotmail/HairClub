/* CreateDate: 11/16/2015 16:52:34.570 , ModifyDate: 07/24/2018 14:22:20.140 */
GO
/***********************************************************************
PROCEDURE:				[spRpt_QuarterlyARforBonus]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			spRpt_QuarterlyARForBonus
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		11/16/2015
------------------------------------------------------------------------
NOTES:
@Quarter
1 = 1/1/2015 - 3/31/2015
2 = 4/1/2015 - 6/30/2015
3 = 7/1/2015 - 9/30/2015
4 = 10/1/2015 - 12/31/2015

------------------------------------------------------------------------
CHANGE HISTORY:

------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC [spRpt_QuarterlyARforBonus] 6, 2018

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_QuarterlyARforBonus]
(
	@Quarter INT
,	@Year INT
)

AS
BEGIN


CREATE TABLE #Dates(Datekey INT)

DECLARE @StartDate DATE
DECLARE @EndDate DATE

IF @Quarter = 1 --First Quarter
BEGIN
	SET @StartDate = '1/1/' + CAST(@Year AS CHAR(4))
	SET @EndDate = '3/31/' + CAST(@Year AS CHAR(4))
	INSERT INTO #Dates
	SELECT CAST((CAST(@Year AS CHAR(4))+ '0131') AS INT)AS 'Datekey'
	INSERT INTO #Dates  --Allow for leap years
	SELECT CASE WHEN @Year IN(2016, 2020, 2024) THEN CAST((CAST(@Year AS CHAR(4))+ '0229') AS INT) ELSE CAST((CAST(@Year AS CHAR(4))+ '0228') AS INT) END AS 'Datekey'
	INSERT INTO #Dates
	SELECT CAST((CAST(@Year AS CHAR(4))+ '0331') AS INT)AS 'Datekey'
END
ELSE IF @Quarter = 2
BEGIN
	SET @StartDate = '4/1/' + CAST(@Year AS CHAR(4))
	SET @EndDate = '6/30/' + CAST(@Year AS CHAR(4))
	INSERT INTO #Dates
	SELECT CAST((CAST(@Year AS CHAR(4))+ '0430') AS INT)AS 'Datekey'
	INSERT INTO #Dates
	SELECT CAST((CAST(@Year AS CHAR(4))+ '0531') AS INT)AS 'Datekey'
	INSERT INTO #Dates
	SELECT CAST((CAST(@Year AS CHAR(4))+ '0630') AS INT)AS 'Datekey'
END
ELSE
IF @Quarter = 3
BEGIN
	SET @StartDate = '7/1/' + CAST(@Year AS CHAR(4))
	SET @EndDate = '9/30/' + CAST(@Year AS CHAR(4))
	INSERT INTO #Dates
	SELECT CAST((CAST(@Year AS CHAR(4))+ '0731') AS INT)AS 'Datekey'
	INSERT INTO #Dates
	SELECT CAST((CAST(@Year AS CHAR(4))+ '0831') AS INT)AS 'Datekey'
	INSERT INTO #Dates
	SELECT CAST((CAST(@Year AS CHAR(4))+ '0930') AS INT)AS 'Datekey'
END
ELSE
BEGIN
	SET @StartDate = '10/1/' + CAST(@Year AS CHAR(4))
	SET @EndDate = '12/31/' + CAST(@Year AS CHAR(4))
	INSERT INTO #Dates
	SELECT CAST((CAST(@Year AS CHAR(4))+ '1031') AS INT)AS 'Datekey'
	INSERT INTO #Dates
	SELECT CAST((CAST(@Year AS CHAR(4))+ '1130') AS INT)AS 'Datekey'
	INSERT INTO #Dates
	SELECT CAST((CAST(@Year AS CHAR(4))+ '1231') AS INT)AS 'Datekey'
END

PRINT '@StartDate = ' + CAST(@StartDate AS NVARCHAR(12))
PRINT '@EndDate = ' + CAST(@EndDate AS NVARCHAR(12))

--SELECT * FROM #Dates

	CREATE TABLE #Centers (
		CenterNumber INT
	,	CenterDescription NVARCHAR(50)
	,	CenterDescriptionNumber NVARCHAR(50)
	,	CenterManagementAreaSSID INT
	,	CenterManagementAreaDescription NVARCHAR(50)
	)


	CREATE TABLE #Receivables (
		CenterNumber INT
	,	Receivable MONEY
	)

	CREATE TABLE #Sales (
		CenterNumber INT
	,	NB2 MONEY
	,	PCP MONEY
	)

	CREATE TABLE #WriteOffs (
		CenterNumber INT
	,	ExtendedPrice MONEY
	)



/********************************** Get list of centers *************************************/

-- Corporate Centers.

	INSERT  INTO #Centers
			SELECT  DC.CenterNumber
			,		DC.CenterDescription
            ,       DC.CenterDescriptionNumber
            ,       CMA.CenterManagementAreaSSID
            ,       CMA.CenterManagementAreaDescription
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
						ON CMA.CenterManagementAreaSSID = DC.CenterManagementAreaSSID
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = DC.CenterTypeKey
			WHERE   CT.CenterTypeDescriptionShort = 'C'
					AND DC.Active = 'Y'

/**************** Insert into #Receivables where there is a Balance in FactReceivables ************************/

	INSERT INTO #Receivables
	SELECT q.CenterNumber
		,       SUM(q.Balance) AS 'Receivable'
	FROM(
			SELECT CNTR.CenterNumber, CLT.ClientIdentifier, CLT.ClientFullName, FR.Balance, DD.DateKey
			FROM    HC_Accounting.dbo.FactReceivables FR
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
				ON FR.ClientKey = CLT.ClientKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CNTR
				ON FR.CenterKey = CNTR.CenterKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
				ON( CLT.CurrentBioMatrixClientMembershipSSID = CM.ClientMembershipSSID
						OR CLT.CurrentExtremeTherapyClientMembershipSSID = CM.ClientMembershipSSID
						OR CLT.CurrentXtrandsClientMembershipSSID = CM.ClientMembershipSSID
						OR CLT.CurrentSurgeryClientMembershipSSID = CM.ClientMembershipSSID) --Added Surgery 7/17/2018 RH
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
				ON CM.MembershipSSID = M.MembershipSSID
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FR.DateKey = dd.DateKey
			INNER JOIN #Centers C
				ON CNTR.CenterNumber = C.CenterNumber
			WHERE   FR.DateKey IN (SELECT DateKey FROM #Dates)
				AND M.RevenueGroupSSID = 2


			GROUP BY CNTR.CenterNumber, CLT.ClientIdentifier, CLT.ClientFullName, FR.Balance, DD.DateKey


		)q
	GROUP BY q.CenterNumber

/**************** Insert into #Sales where AccountID in (10530,10540) NB2 and PCP ********************************/

	INSERT INTO #Sales
	SELECT FA.CenterID
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10540, 10530) THEN Flash ELSE 0 END, 0)) AS 'NB2'
	,	SUM(ISNULL(CASE WHEN FA.AccountID IN (10530) THEN Flash ELSE 0 END, 0)) AS 'PCP'
	FROM HC_Accounting.dbo.FactAccounting FA
	INNER JOIN #Centers C
		ON FA.CenterID = C.CenterNumber  --CenterID in FactAccounting is 238 for Colorado Springs
	WHERE FA.PartitionDate BETWEEN @StartDate AND @EndDate
		  AND FA.AccountID IN (10530, 10540)
	GROUP BY FA.CenterID

/**************** Insert into the write-off temp table where SalesOrderTypeKey is 5 - NSF/ChargebackOrder *********/

	INSERT INTO #WriteOffs
	SELECT DC.CenterNumber
	,	SUM( ABS(FST.ExtendedPrice) ) AS 'ExtendedPrice'
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = dd.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON fst.SalesCodeKey = sc.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
			ON FST.ClientMembershipKey = DCM.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
			ON DCM.MembershipSSID = DM.MembershipSSID
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON DCM.CenterKey = DC.CenterKey
		INNER JOIN #Centers C
			ON DC.CenterNumber = C.CenterNumber
	WHERE DD.FullDate BETWEEN @StartDate AND @EndDate
	AND (SC.SalesCodeSSID IN ( 646, 694, 715, 708 )
			OR FST.SalesOrderTypeKey = 5 )--NSF/Chargeback Order
		AND DM.RevenueGroupDescription = 'Recurring Business'
	GROUP BY DC.CenterNumber

/**************** Final select *********************************************************************************/


	SELECT 	@StartDate AS 'StartDate'
	,	@EndDate AS 'EndDate'
	,	C.CenterNumber
	,	C.CenterDescription
	,	C.CenterDescriptionNumber
	,	ISNULL(S.NB2, 0) AS 'NB2Revenue'
	,	ISNULL(S.PCP, 0) AS 'PCPRevenue'
	,	ISNULL(RCV.Receivable, 0) AS 'Receivables'
	,	ISNULL(WO.ExtendedPrice, 0) AS 'ExtendedPrice'
	FROM #Centers C
		LEFT OUTER JOIN #Receivables RCV
			ON C.CenterNumber = RCV.CenterNumber
		LEFT OUTER JOIN #Sales S
			ON C.CenterNumber = S.CenterNumber
		LEFT OUTER JOIN #WriteOffs WO
			ON C.CenterNumber = WO.CenterNumber
END
GO
