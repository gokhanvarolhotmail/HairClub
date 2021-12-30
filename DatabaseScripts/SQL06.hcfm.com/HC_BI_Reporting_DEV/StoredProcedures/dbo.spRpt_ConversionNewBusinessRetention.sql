/* CreateDate: 03/22/2017 16:47:43.280 , ModifyDate: 04/26/2019 17:50:15.630 */
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
03/22/2017 - RH - (#130802) Changed to only show transfers OUT after the Conversion Date
01/15/2018 - RH - (#145957) Removed Regions for Corporate; added joins on DimCenterType
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_ConversionNewBusinessRetention '4/1/2019', '4/25/2019', 'C', 2

EXEC spRpt_ConversionNewBusinessRetention '12/1/2017', '1/1/2018', 'C', 2

EXEC spRpt_ConversionNewBusinessRetention '12/1/2017', '1/1/2018', 'F', 1

EXEC spRpt_ConversionNewBusinessRetention '1/1/2019', '3/22/2019', 'C', 2


***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_ConversionNewBusinessRetention]
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

SELECT @PCPDate = CONVERT(VARCHAR(25), DATEADD(dd, -(DAY(GETDATE()) - 1), GETDATE()), 101)  --Matches the Detail

/****************** Create temp tables *************************************************************************/

CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	CenterKey INT
,	CenterSSID INT
,	CenterDescription VARCHAR(255)
,	CenterType VARCHAR(50)
)

CREATE TABLE #Conversions (
		CenterKey INT
	,	CenterSSID INT
	,	ClientKey INT
	,	ConversionDate DATETIME
	,	NB_BIOConvCnt INT
	,	NB_EXTConvCnt INT
	,	NB_XTRConvCnt INT
	,	ConversionCount INT
)


/***************** Populate #Centers **********************************************************************/


IF @sType = 'C'
BEGIN
		INSERT INTO #Centers
			SELECT  CMA.CenterManagementAreaSSID AS 'MainGroupID'
			,		CMA.CenterManagementAreaDescription AS 'MainGroup'
			,       DC.CenterKey
			,       DC.CenterSSID
			,       DC.CenterDescriptionNumber
			,       DCT.CenterTypeDescriptionShort
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
						ON DC.CenterTypeKey = DCT.CenterTypeKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
						ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = DC.CenterTypeKey
			WHERE   CT.CenterTypeDescriptionShort = 'C'
					AND DC.Active = 'Y'
END
ELSE
BEGIN
		INSERT INTO #Centers
			SELECT  DR.RegionSSID AS 'MainGroupID'
			,       DR.RegionDescription AS 'MainGroup'
			,       DC.CenterKey
			,       DC.CenterSSID
			,       DC.CenterDescriptionNumber
			,       DCT.CenterTypeDescriptionShort
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
						ON DC.CenterTypeKey = DCT.CenterTypeKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
						ON DC.RegionKey = DR.RegionKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = DC.CenterTypeKey
			WHERE   CT.CenterTypeDescriptionShort IN ('F','JV')
					AND DC.Active = 'Y'
END

/****************** Find Conversions ***********************************************************************/
IF @ConversionType = 1
BEGIN
	INSERT INTO #Conversions
	SELECT  C.CenterKey
	,		C.CenterSSID
	,       CLT.ClientKey
	,       MIN(DD.FullDate) AS 'ConversionDate'
	,		FST.NB_BIOConvCnt
	,		NULL AS EXTConvCnt
	,		NULL AS XTRConvCnt
--	,		1 AS ConversionCount
	,       SUM(FST.NB_BIOConvCnt)
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
	GROUP BY C.CenterKey
	,		C.CenterSSID
	,		CLT.ClientKey
	,		FST.NB_BIOConvCnt
END
ELSE IF @ConversionType = 2
BEGIN
	INSERT INTO #Conversions
	SELECT  C.CenterKey
	,		C.CenterSSID
	,       CLT.ClientKey
	,       MIN(DD.FullDate) AS 'ConversionDate'
	,		NULL AS NB_BIOConvCnt
	,		FST.NB_EXTConvCnt
	,		NULL AS NB_XTRConvCnt
	--,		1 AS ConversionCount
	,		SUM(FST.NB_EXTConvCnt) AS ConversionCount
	FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FST.OrderDateKey = DD.DateKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				ON FST.CenterKey = DC.CenterKey
			INNER JOIN #Centers C
				--ON DC.ReportingCenterSSID = C.CenterSSID
				ON DC.CenterSSID = C.CenterSSID
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
				ON FST.ClientKey = CLT.ClientKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership MBR
				ON FST.MembershipKey = MBR.MembershipKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
				ON FST.SalesCodeKey = SC.SalesCodeKey
	WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
			AND FST.NB_EXTConvCnt >= 1
	GROUP BY C.CenterKey
	,		C.CenterSSID
	,		CLT.ClientKey
	,		FST.NB_EXTConvCnt
END
ELSE
BEGIN
	INSERT INTO #Conversions
	SELECT  C.CenterKey
	,		C.CenterSSID
	,       CLT.ClientKey
	,       MIN(DD.FullDate) AS 'ConversionDate'
	,		NULL AS NB_BIOConvCnt
	,		NULL AS NB_EXTConvCnt
	,		FST.NB_XTRConvCnt
--	,		1 AS ConversionCount
	,		SUM(FST.NB_XTRConvCnt) AS ConversionCount
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
	GROUP BY C.CenterKey
	,		C.CenterSSID
	,		CLT.ClientKey
		   , FST.NB_XTRConvCnt
END

/*==============================================================================
Did any of these clients Transfer Out after their conversion?
==============================================================================*/

SELECT  DC.CenterSSID
,		R.RegionDescription
,		R.RegionSSID
,       DC.CenterDescriptionNumber
,		DC.CenterManagementAreaSSID
,		DCMA.CenterManagementAreaDescription
,       CLT.ClientKey
,		CLT.ClientIdentifier
,		CLT.ClientFullName
,		CLT.GenderSSID
,		CONV.ConversionDate
,       MIN(DD.FullDate) AS 'TransferDate'
,		M.MembershipDescription
,		CASE WHEN SC.SalesCodeKey = 665 THEN 1
			ELSE 0 END AS 'TransferOut'


INTO #Transfers
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN #Conversions CONV
			ON CONV.ClientKey = FST.ClientKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON FST.CenterKey = DC.CenterKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
			ON DC.RegionKey = R.RegionKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea DCMA
			ON DC.CenterManagementAreaSSID = DCMA.CenterManagementAreaSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON FST.MembershipKey = M.MembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON FST.SalesCodeKey = SC.SalesCodeKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
		AND SC.SalesCodeKey IN(665)					-- Transfer Out
		AND DD.FullDate >= CONV.ConversionDate		-- Transferred after the conversion
		AND FST.CenterKey = CONV.CenterKey
GROUP BY CASE WHEN SC.SalesCodeKey = 665 THEN 1
       ELSE 0
       END
       ,	DC.CenterSSID
       ,	R.RegionDescription
       ,	R.RegionSSID
       ,	DC.CenterDescriptionNumber
       ,	DC.CenterManagementAreaSSID
       ,	DCMA.CenterManagementAreaDescription
       ,	CLT.ClientKey
       ,	CLT.ClientIdentifier
       ,	CLT.ClientFullName
	   ,	CLT.GenderSSID
       ,	CONV.ConversionDate
	   ,	M.MembershipDescription

/***************** Remove these clients that transferred out ************************************************/

DELETE FROM #Conversions WHERE ClientKey IN (SELECT ClientKey FROM #Transfers)

/****************** Find PCP Counts *************************************************************************/

SELECT  C.MainGroup AS 'RegionDescription'
,       C.CenterSSID
,       CLT.ClientKey
,       CLT.GenderSSID
,       M.MembershipDescription AS 'Membership'
,       @PCPDate AS 'PCPDate'
,		1 AS 'PCP'
,		'Y' AS 'IsActive'
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



--SELECT @PCPDate, * FROM #PCP
--WHERE clientkey = 334641

/****************** Join result sets ***********************************************************************/

SELECT  C.MainGroup
,       C.MainGroupID
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
,       C.CenterDescription
,       C.CenterSSID

ORDER BY 1

END




----Declare variables
--DECLARE @PCPDate DATETIME  --Beginning of current month

--SELECT @PCPDate = CONVERT(VARCHAR(25), DATEADD(dd, -(DAY(GETDATE()) - 1), GETDATE()), 101)  --Matches the Detail


--SELECT *
--FROM    HC_Accounting.dbo.FactPCPDetail PD
--		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
--			ON PD.DateKey = DD.DateKey
--WHERE   MONTH(DD.FullDate) = MONTH(@PCPDate)
--		  AND YEAR(DD.FullDate) = YEAR(@PCPDate)
--        AND clientkey = 334641


--SELECT * FROM #PCP WHERE RegionDescription= 'West'
GO
