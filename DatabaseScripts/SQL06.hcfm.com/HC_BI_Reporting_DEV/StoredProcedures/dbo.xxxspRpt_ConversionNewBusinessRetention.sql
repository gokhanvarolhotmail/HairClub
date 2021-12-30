/* CreateDate: 11/14/2013 13:31:50.723 , ModifyDate: 03/27/2017 17:06:19.697 */
GO
/***********************************************************************
PROCEDURE:				spRpt_ConversionNewBusinessRetention
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			Conversion Retention
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Marlon Burrell
DATE IMPLEMENTED:		11/14/2013
------------------------------------------------------------------------
NOTES:

02/06/2014 - DL - The drill down into the 'Active' column for the regional subtotals are pulling incorrect centers (#97344)
11/20/2014 - RH - Added FST.NB_XTRConvCnt as a @ConversionType
02/04/2015 - RH - Changed logic to match the Detail for PCP
10/26/2016 - RH - (#130802) Added filter SC.SalesCodeKey NOT IN(665,654,393) -- Transfer Out, Removal - New Member
01/13/2017 - RH - (#130802) Changed code to find the transfers separately and then remove them; Added CenterManagementAreaSSID and Description
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_ConversionNewBusinessRetention '1/1/2017', '1/31/2017', 'C', 3

EXEC spRpt_ConversionNewBusinessRetention '1/1/2017', '1/31/2017', 'C', 2

EXEC spRpt_ConversionNewBusinessRetention '1/1/2017', '1/31/2017', 'C', 1

***********************************************************************/
CREATE PROCEDURE [dbo].[xxxspRpt_ConversionNewBusinessRetention]
(
	@StartDate	DATETIME
,	@EndDate	DATETIME
,	@sType VARCHAR(10)
,	@ConversionType INT
)
AS
BEGIN

SET NOCOUNT OFF;


/*
@sType
C = Corporate
F = Franchise

@ConversionType
1 = BIO
2 = EXT
3 = XTR
*/


--Declare variables
DECLARE @PCPDate DATETIME  --Beginning of current month


/****************** Initialize variables ***********************************************************************/

SELECT @PCPDate = CONVERT(VARCHAR(25), DATEADD(dd, -(DAY(GETDATE()) - 1), GETDATE()), 101)  --Matches the Detail

/****************** Create temp tables *************************************************************************/

CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	CenterManagementAreaSSID INT
,	CenterManagementAreaDescription NVARCHAR(50)
,	CenterKey INT
,	CenterSSID INT
,	CenterDescription VARCHAR(255)
,	CenterType VARCHAR(50)
)

CREATE TABLE #Conversions (
		CenterSSID INT
	,	ClientKey INT
	,	ConversionDate DATETIME
	,	NB_BIOConvCnt INT
	,	NB_EXTConvCnt INT
	,	NB_XTRConvCnt INT
	,	ConversionCount INT
)

CREATE TABLE #Transfers (
		CenterSSID INT
	,   ClientKey INT
	,   ConversionDate DATETIME
	,   NB_BIOConvCnt INT
	,	NB_EXTConvCnt INT
	,	NB_XTRConvCnt INT
	,	TransferOut NVARCHAR(50)
)

/***************** Populate #Centers **********************************************************************/

IF @sType = 'C'
BEGIN
		INSERT INTO #Centers
			SELECT  DR.RegionSSID
			,       DR.RegionDescription
			,		CMA.CenterManagementAreaSSID
			,		CMA.CenterManagementAreaDescription
			,       DC.CenterKey
			,       DC.CenterSSID
			,       DC.CenterDescriptionNumber
			,       DCT.CenterTypeDescriptionShort
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
						ON DC.CenterTypeKey = DCT.CenterTypeKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
						ON DC.RegionKey = DR.RegionKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
						ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
			WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
					AND DC.Active = 'Y'
END
ELSE
BEGIN
		INSERT INTO #Centers
			SELECT  DR.RegionSSID
			,       DR.RegionDescription
			,		CMA.CenterManagementAreaSSID
			,		CMA.CenterManagementAreaDescription
			,       DC.CenterKey
			,       DC.CenterSSID
			,       DC.CenterDescriptionNumber
			,       DCT.CenterTypeDescriptionShort
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
						ON DC.CenterTypeKey = DCT.CenterTypeKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
						ON DC.RegionKey = DR.RegionKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
						ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
			WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
					AND DC.Active = 'Y'
END

/****************** Find Conversions ***********************************************************************/


IF @ConversionType = 1
BEGIN
	INSERT INTO #Conversions
	SELECT  C.CenterSSID
	,       CLT.ClientKey
	,       MIN(DD.FullDate) AS 'ConversionDate'
	,		FST.NB_BIOConvCnt
	,		NULL AS EXTConvCnt
	,		NULL AS XTRConvCnt
	,		1 AS ConversionCount
	FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FST.OrderDateKey = DD.DateKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				ON FST.CenterKey = DC.CenterKey
			INNER JOIN #Centers C
				ON DC.CenterSSID = C.CenterSSID
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
				ON FST.ClientKey = CLT.ClientKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership MBR
				ON FST.MembershipKey = MBR.MembershipKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
				ON FST.SalesCodeKey = SC.SalesCodeKey
	WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
			AND FST.NB_BIOConvCnt >= 1
	GROUP BY C.CenterSSID
	,       CLT.ClientKey
	,		FST.NB_BIOConvCnt
END
ELSE IF @ConversionType = 2
BEGIN
	INSERT INTO #Conversions
	SELECT  C.CenterSSID
	,       CLT.ClientKey
	,       MIN(DD.FullDate) AS 'ConversionDate'
	,		NULL AS NB_BIOConvCnt
	,		FST.NB_EXTConvCnt
	,		NULL AS NB_XTRConvCnt
	,		1 AS ConversionCount
	FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FST.OrderDateKey = DD.DateKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				ON FST.CenterKey = DC.CenterKey
			INNER JOIN #Centers C
				ON DC.ReportingCenterSSID = C.CenterSSID
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
				ON FST.ClientKey = CLT.ClientKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership MBR
				ON FST.MembershipKey = MBR.MembershipKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
				ON FST.SalesCodeKey = SC.SalesCodeKey
	WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
			AND FST.NB_EXTConvCnt >= 1
	GROUP BY C.CenterSSID
	,       CLT.ClientKey
	,		FST.NB_EXTConvCnt
END
ELSE
BEGIN
	INSERT INTO #Conversions
	SELECT  C.CenterSSID
	,       CLT.ClientKey
	,       MIN(DD.FullDate) AS 'ConversionDate'
	,		NULL AS NB_BIOConvCnt
	,		NULL AS NB_EXTConvCnt
	,		FST.NB_XTRConvCnt
	,		1 AS ConversionCount
	FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FST.OrderDateKey = DD.DateKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				ON FST.CenterKey = DC.CenterKey
			INNER JOIN #Centers C
				ON DC.CenterSSID = C.CenterSSID
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
				ON FST.ClientKey = CLT.ClientKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership MBR
				ON FST.MembershipKey = MBR.MembershipKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
				ON FST.SalesCodeKey = SC.SalesCodeKey
	WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
			AND FST.NB_XTRConvCnt >= 1
	GROUP BY C.CenterSSID
	,       CLT.ClientKey
	,		FST.NB_XTRConvCnt
END


/****************** Find Transfers ***********************************************************************/

INSERT INTO #Transfers
SELECT  C.CenterSSID
,       CLT.ClientKey
,       MIN(DD.FullDate) AS 'TransferDate'
,		FST.NB_BIOConvCnt
,		FST.NB_EXTConvCnt
,		FST.NB_XTRConvCnt
,		CASE WHEN SC.SalesCodeKey = 665 THEN 'TransferMemberOut'
			ELSE ''END AS 'TransferOut'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON FST.CenterKey = DC.CenterKey
		INNER JOIN #Centers C
			ON DC.CenterSSID = C.CenterSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership MBR
			ON FST.MembershipKey = MBR.MembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON FST.SalesCodeKey = SC.SalesCodeKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
		AND SC.SalesCodeKey IN(665) -- Transfer Out
GROUP BY C.CenterSSID
,       CLT.ClientKey
,		FST.NB_BIOConvCnt
,		FST.NB_EXTConvCnt
,		FST.NB_XTRConvCnt
,		SC.SalesCodeKey


/****************** Remove from #Conversions any transfer out clients ***************************************/

DELETE FROM #Conversions WHERE ClientKey IN(SELECT ClientKey FROM #Transfers)

/****************** Find PCP Counts *************************************************************************/

SELECT  C.MainGroup AS 'RegionDescription'
,       C.CenterSSID
,       CLT.ClientKey
,       CLT.GenderSSID
,       M.MembershipDescription AS 'Membership'
,       @PCPDate AS 'PCPDate'
,		1 AS 'PCP'
INTO #PCP
FROM    HC_Accounting.dbo.FactPCPDetail PD
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON PD.DateKey = DD.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON PD.CenterKey = DC.CenterKey
		INNER JOIN #Centers C
			ON DC.CenterSSID = C.CenterSSID
		INNER JOIN #Conversions CONV
			ON PD.ClientKey = CONV.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON PD.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON PD.MembershipKey = M.MembershipKey
WHERE   MONTH(DD.FullDate) = MONTH(@PCPDate)
		AND YEAR(DD.FullDate) = YEAR(@PCPDate)


/****************** Join result sets ***********************************************************************/

SELECT  C.MainGroup AS 'RegionDescription'
,       C.MainGroupID AS 'RegionSSID'
,		C.CenterManagementAreaSSID
,		C.CenterManagementAreaDescription
,       C.CenterDescription AS 'CenterDescriptionNumber'
,       C.CenterSSID
,       SUM(CASE WHEN CLT.GenderSSID = 2 THEN Conv.ConversionCount
					ELSE 0
			END) AS 'Conv_Female'
,       SUM(CASE WHEN CLT.GenderSSID <> 2 THEN Conv.ConversionCount
					ELSE 0
			END) AS 'Conv_Male'
,       SUM(CASE WHEN CLT.GenderSSID = 2 THEN ISNULL(P.PCP, 0)
					ELSE 0
			END) AS 'ActivePCP_Female'
,       SUM(CASE WHEN CLT.GenderSSID <> 2 THEN ISNULL(P.PCP, 0)
					ELSE 0
			END) AS 'ActivePCP_Male'
,       @PCPDate AS 'ActiveDate'
FROM    #Centers C
		LEFT OUTER JOIN #Conversions Conv
			ON C.CenterSSID = Conv.CenterSSID
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON Conv.ClientKey = CLT.ClientKey
		LEFT OUTER JOIN #PCP P
			ON P.CenterSSID = C.CenterSSID
				AND Conv.ClientKey = P.ClientKey
GROUP BY C.MainGroup
,       C.MainGroupID
,		C.CenterManagementAreaSSID
,		C.CenterManagementAreaDescription
,       C.CenterDescription
,       C.CenterSSID

END
GO
