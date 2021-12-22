/* CreateDate: 11/19/2013 15:11:24.303 , ModifyDate: 03/27/2017 17:06:37.323 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*==============================================================================
PROCEDURE:				spRpt_ConversionNewBusinessRetentionDetailsConversions
DESTINATION SERVER:		SQL06
DESTINATION DATABASE: 	HC_BI_REPORTING
IMPLEMENTOR: 			Marlon Burrell
DATE IMPLEMENTED:		11/14/2013
LAST REVISION DATE: 	11/14/2013
==============================================================================
DESCRIPTION:	Shows conversion details for the selected date range
==============================================================================
NOTES:
11/20/2014 - RH - Added NB_XTRConvCnt
07/13/2015 - RH - Changed FactPCPDetail to vwFactPCPDetail
07/16/2015 - RH - Current Membership now comes from the PCP query; All Memberships are shown
10/26/2016 - RH - (#130802) Added filter SC.SalesCodeKey NOT IN(665,654,393) -- Transfer Out, Removal - New Member
01/13/2017 - RH - (#130802) Changed code to find the transfers separately and then remove them; Added CenterManagementAreaSSID and Description; Added @Filter
==============================================================================
SAMPLE EXECUTION:

EXEC spRpt_ConversionNewBusinessRetentionDetailsConversions '11/1/2016', '1/30/2017', 250, 1, 1, 3

==============================================================================*/
CREATE PROCEDURE [dbo].[xxxspRpt_ConversionNewBusinessRetentionDetailsConversions]
	@StartDate	DATETIME
,	@EndDate	DATETIME
,	@CenterSSID INT
,	@GenderSSID INT
,	@ConversionType INT
,	@Filter INT
AS
BEGIN
--SET FMTONLY OFF
SET NOCOUNT OFF

/*==============================================================================
	@ConversionType			@Filter
		1 = BIO				1 = By Region
		2 = EXT				2 = By Area
		3 = XTR				3 = By Center
==============================================================================*/



DECLARE @PCPDate DATETIME

/****************** Initialize variables ***********************************************************************/

SELECT @PCPDate = CONVERT(VARCHAR(25), DATEADD(dd, -(DAY(GETDATE()) - 1), GETDATE()), 101)

/****************** Create temp tables *************************************************************************/

CREATE TABLE #Centers (
	RegionSSID INT
,	RegionDescription VARCHAR(50)
,	CenterManagementAreaSSID INT
,	CenterManagementAreaDescription NVARCHAR(50)
,	CenterKey INT
,	CenterSSID INT
,	CenterDescriptionNumber VARCHAR(255)
,	CenterType VARCHAR(50)
)

CREATE TABLE #Genders (
	GenderSSID INT
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

IF (@Filter = 1 AND @CenterSSID IN ( -2, 2, 3, 4, 5, 6, 1, 7, 8, 9, 10, 11, 12, 13, 14, 15 )) -- A Region has been selected.
BEGIN
INSERT  INTO #Centers
		SELECT  DR.RegionSSID
		,		DR.RegionDescription
		,		CMA.CenterManagementAreaSSID
		,		CMA.CenterManagementAreaDescription
		,		DC.CenterKey
		,		DC.CenterSSID
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionKey = DR.RegionKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
					ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
		WHERE   DR.RegionSSID = @CenterSSID
				AND DC.Active = 'Y'
END
ELSE
IF @Filter = 2										-- An Area has been selected.
BEGIN
INSERT  INTO #Centers
		SELECT  DR.RegionSSID
		,		DR.RegionDescription
		,		CMA.CenterManagementAreaSSID
		,		CMA.CenterManagementAreaDescription
		,		DC.CenterKey
		,		DC.CenterSSID
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionKey = DR.RegionKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
					ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
		WHERE   DC.CenterManagementAreaSSID = @CenterSSID
				AND DC.Active = 'Y'
END
ELSE
IF (@Filter = 3 AND  @CenterSSID BETWEEN 200 AND 900) -- A Center has been selected.
BEGIN
INSERT  INTO #Centers
		SELECT  DR.RegionSSID
		,		DR.RegionDescription
		,		CMA.CenterManagementAreaSSID
		,		CMA.CenterManagementAreaDescription
		,		DC.CenterKey
		,		DC.CenterSSID
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionKey = DR.RegionKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
					ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
		WHERE   DC.CenterSSID = @CenterSSID
				AND DC.Active = 'Y'
END

/***************** Populate #Genders **********************************************************************/

IF @GenderSSID IN (1,2)
	BEGIN
		INSERT INTO #Genders
		SELECT @GenderSSID
	END
ELSE
	BEGIN
		INSERT INTO #Genders (GenderSSID) VALUES (1)
		INSERT INTO #Genders (GenderSSID) VALUES (2)
	END


/*==============================================================================
Get conversions for dates specified
==============================================================================*/


SELECT  C.CenterSSID
,	DC.CenterKey
,	FST.ClientKey
,	CLT.ClientFullName
,	CLT.ClientGenderDescription
,	CLT.ClientEthinicityDescriptionShort
,	CLT.ClientDateOfBirth
,	DD.FullDate AS 'ConversionDate'
,	FST.NB_BIOConvCnt AS 'BIOConv'
,	FST.NB_EXTConvCnt AS 'EXTConv'
,	FST.NB_XTRConvCnt AS 'XTRConv'
,	PREV.MembershipDescription AS 'Membership_Old'
,	NEW.MembershipDescription AS 'Membership_New'
,	CMPREV.ClientMembershipBeginDate AS 'NB1_SaleDate'
,	NB1A.AppDate AS 'NB1_AppDate'
INTO    #Conversions
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
    INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
        ON FST.OrderDateKey = DD.DateKey
    INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
        ON FST.ClientKey = CLT.ClientKey
    INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
		ON FST.ClientMembershipKey = CM.ClientMembershipKey
    INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		ON CM.CenterKey = DC.CenterKey  --Home Center
    INNER JOIN #Centers C
        ON DC.CenterSSID = C.CenterSSID
    INNER JOIN #Genders G
        ON ISNULL(CLT.GenderSSID, 1) = G.GenderSSID
    INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
		ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
		ON FST.SalesCodeKey = SC.SalesCodeKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CMPREV
		ON SOD.PreviousClientMembershipSSID = CMPREV.ClientMembershipSSID
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership PREV
		ON CMPREV.MembershipKey = PREV.MembershipKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
		ON FST.SalesOrderKey = SO.SalesOrderKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CMNEW
		ON SO.ClientMembershipKey = CMNEW.ClientMembershipKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership NEW
		ON CMNEW.MembershipKey = NEW.MembershipKey
	LEFT OUTER JOIN (
		SELECT FST.ClientKey
		,	MIN(DD.FullDate) AS 'AppDate'
		FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FST.OrderDateKey = DD.DateKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
				ON FST.SalesCodeKey = SC.SalesCodeKey
		WHERE DD.FullDate BETWEEN DATEADD(YEAR, -2, @EndDate) AND @EndDate
			AND SC.SalesCodeKey = 601
		GROUP BY FST.ClientKey
	) NB1A
		ON FST.ClientKey = NB1A.ClientKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
    AND ( CASE WHEN @ConversionType = 1 THEN FST.NB_BIOConvCnt
				WHEN @ConversionType = 2 THEN FST.NB_EXTConvCnt
				ELSE FST.NB_XTRConvCnt
            END ) >= 1

/*==============================================================================
Did any of these clients Upgrade, and if so, what was their Upgrade date?
==============================================================================*/

SELECT  FST.ClientKey
	,	DD.Fulldate AS 'UpgradeDate'
INTO    #Upgrades
FROM    #Conversions CONV
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		ON CONV.ClientKey = FST.ClientKey
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FST.OrderDateKey = DD.DateKey
WHERE DD.FullDate BETWEEN @StartDate AND @EndDate
	AND FST.PCP_UpgCnt = 1

/*==============================================================================
Did any of these clients Transfer? And if so, remove them.
==============================================================================*/
INSERT INTO #Transfers
SELECT  C.CenterSSID
,       CLT.ClientKey
,       MIN(DD.FullDate) AS 'TransferDate'
,		FST.NB_BIOConvCnt
,		FST.NB_EXTConvCnt
,		FST.NB_XTRConvCnt
,		CASE WHEN SC.SalesCodeKey = 665 THEN 'TransferMemberOut'
			WHEN SC.SalesCodeKey = 654 THEN 'NewMemberTransfer'
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
		AND SC.SalesCodeKey IN(665,654) -- Transfer Out
GROUP BY C.CenterSSID
,       CLT.ClientKey
,		FST.NB_BIOConvCnt
,		FST.NB_EXTConvCnt
,		FST.NB_XTRConvCnt
,		SC.SalesCodeKey

/****************** Remove from #Conversions any transfer out clients *****/

DELETE FROM #Conversions WHERE ClientKey IN(SELECT T.ClientKey
											FROM #Transfers T
											INNER JOIN #Conversions C
												ON T.ClientKey = C.ClientKey AND T.CenterSSID = C.CenterSSID)

/*==============================================================================
Do these clients qualify as PCP for this current month?
==============================================================================*/

SELECT  C.RegionDescription
,       C.CenterDescriptionNumber
,       CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'ClientName'
,		PD.ClientKey
,       CLT.ClientGenderDescription
,       M.MembershipDescription AS 'Membership'
,       @PCPDate AS 'PCPDate'
,		Upg.UpgradeDate
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
	LEFT JOIN #Upgrades Upg
        ON PD.ClientKey = Upg.ClientKey
    INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
        ON PD.ClientKey = CLT.ClientKey
    INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
        ON PD.MembershipKey = M.MembershipKey
WHERE   MONTH(DD.FullDate) = MONTH(@PCPDate)
		AND YEAR(DD.FullDate) = YEAR(@PCPDate)


/*==============================================================================
Final Select
==============================================================================*/
SELECT C.RegionDescription
,	C.RegionSSID
,	C.CenterManagementAreaSSID
,	C.CenterManagementAreaDescription
,   C.CenterDescriptionNumber
,	CONV.ClientFullName AS 'ClientName'
,	CONV.ClientKey
,	CONV.ClientGenderDescription
,	CONV.ConversionDate
,	CONV.Membership_Old
,	CONV.Membership_New
,	P.Membership AS 'CurrentMembership'
,	CONV.BIOConv
,	CONV.EXTConv
,	CONV.XTRConv
,	CONV.NB1_SaleDate
,	CONV.NB1_AppDate
,	CONV.ClientEthinicityDescriptionShort AS 'EthnicityDescription'
,	CONV.ClientDateOfBirth
,	CASE WHEN P.ClientKey IS NOT NULL THEN 'Y' ELSE 'N' END AS 'IsActive'
,	@PCPDate AS 'PCPDate'
,	Upg.UpgradeDate
FROM #Centers C
	LEFT OUTER JOIN #Conversions CONV
		ON C.CenterKey = CONV.CenterKey
	LEFT OUTER JOIN #PCP P
		ON CONV.ClientKey = P.ClientKey
	LEFT OUTER JOIN #Upgrades Upg
        ON CONV.ClientKey = Upg.ClientKey
WHERE CONV.ClientKey IS NOT NULL


END
GO
