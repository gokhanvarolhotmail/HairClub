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
03/22/2017 - RH - (#130802) Changed to find transfers out and show them as a "T"
01/15/2018 - RH - (#145957) Removed Regions for Corporate; added joins on DimCenterType
05/20/2019 - JL - (Case 4824) Added drill down to report

==============================================================================
SAMPLE EXECUTION:
EXEC spRpt_ConversionNewBusinessRetentionDetailsConversions '12/1/2017', '1/1/2018', 6, 0 , 1, 'F', 1
EXEC spRpt_ConversionNewBusinessRetentionDetailsConversions '12/1/2017', '1/1/2018', 2, 0 , 1, 'C', 2
EXEC spRpt_ConversionNewBusinessRetentionDetailsConversions '12/1/2017', '1/1/2018', 209, 0 , 1, 'C', 3
EXEC spRpt_ConversionNewBusinessRetentionDetailsConversions '12/1/2017', '1/1/2018', 745, 0 , 1, 'F', 3
EXEC spRpt_ConversionNewBusinessRetentionDetailsConversions '1/1/2017', '3/22/2017', 0, 0 , 1, 'C', 2
EXEC spRpt_ConversionNewBusinessRetentionDetailsConversions '1/1/2019', '3/22/2019', 0, 0 , 2, 'C', 2

==============================================================================*/
CREATE PROCEDURE [dbo].[spRpt_ConversionNewBusinessRetentionDetailsConversions]
	@StartDate	DATETIME
,	@EndDate	DATETIME
,	@CenterSSID INT
,	@GenderSSID INT
,	@ConversionType INT
,	@sType NVARCHAR(1)
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

SELECT @PCPDate = CONVERT(VARCHAR(25), DATEADD(dd, -(DAY(GETDATE()) - 1), GETDATE()), 101) --Beginning of the current month

/****************** Create temp tables *************************************************************************/

CREATE TABLE #Centers (
	MainGroupID INT
,	MainGroup VARCHAR(50)
,	CenterKey INT
,	CenterSSID INT
,	CenterDescriptionNumber VARCHAR(255)
,	CenterTypeDescriptionShort VARCHAR(50)
)

CREATE TABLE #Genders (
	GenderSSID INT
)


/***************** Populate #Centers **********************************************************************/

IF @Filter = 1	AND @sType = 'F'									-- A Region has been selected - Franchises
BEGIN
INSERT  INTO #Centers
		SELECT  DR.RegionSSID AS 'MainGroupID'
		,		DR.RegionDescription AS 'MainGroup'
		,		DC.CenterKey
		,		DC.CenterSSID
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionKey = DR.RegionKey
		WHERE   (DR.RegionSSID = @CenterSSID OR @CenterSSID = 0)
				AND DC.Active = 'Y'
				AND DCT.CenterTypeDescriptionShort IN ('F','JV')
END
ELSE
IF @Filter = 2	AND @sType = 'C'									-- An Area has been selected.
BEGIN
INSERT  INTO #Centers
		SELECT  CMA.CenterManagementAreaSSID AS 'MainGroupID'
		,		CMA.CenterManagementAreaDescription AS 'MainGroup'
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
		WHERE   (DC.CenterManagementAreaSSID = @CenterSSID OR @CenterSSID = 0)
				AND DC.Active = 'Y'
				AND DCT.CenterTypeDescriptionShort = 'C'
END
ELSE
IF @Filter = 3	AND @sType = 'C'									-- A Corporate Center has been selected.
BEGIN
INSERT  INTO #Centers
		SELECT  DC.CenterSSID AS 'MainGroupID'
		,		DC.CenterDescriptionNumber AS 'MainGroup'
		,		DC.CenterKey
		,		DC.CenterSSID
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
					ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
		WHERE   (DC.CenterSSID = @CenterSSID OR @CenterSSID = 0)
				AND DC.Active = 'Y'
END
IF @Filter = 3	AND @sType = 'F'									-- A Franchise Center has been selected.
BEGIN
INSERT  INTO #Centers
		SELECT  DC.CenterSSID AS 'MainGroupID'
		,		DC.CenterDescriptionNumber AS 'MainGroup'
		,		DC.CenterKey
		,		DC.CenterSSID
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
					ON R.RegionKey = DC.RegionKey
		WHERE   (DC.CenterSSID = @CenterSSID OR @CenterSSID = 0)
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
,	CLT.ClientFullName + ' (' + CAST(CLT.ClientIdentifier AS NVARCHAR(10)) + ')' AS 'ClientName'
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
			AND SC.SalesCodeKey = 601										--Initial New Style
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
	,	MAX(DD.Fulldate) AS 'UpgradeDate'
INTO    #Upgrades
FROM    #Conversions CONV
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		ON CONV.ClientKey = FST.ClientKey
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FST.OrderDateKey = DD.DateKey
WHERE DD.FullDate BETWEEN @StartDate AND @EndDate
	AND FST.PCP_UpgCnt = 1
GROUP BY FST.ClientKey

/*==============================================================================
Did any of these clients Transfer out after their conversion?
==============================================================================*/

SELECT  DC.CenterSSID
,		DC.CenterDescriptionNumber AS 'TransferOutCity'
,       CLT.ClientKey
,       MAX(DD.FullDate) AS 'TransferOutDate'
,		CASE WHEN SC.SalesCodeKey = 665 THEN 1
			ELSE 0 END AS 'TransferOut'

INTO #TransfersOut
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			ON FST.CenterKey = DC.CenterKey
		INNER JOIN #Conversions CONV
			ON	CONV.ClientKey = FST.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership MBR
			ON FST.MembershipKey = MBR.MembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON FST.SalesCodeKey = SC.SalesCodeKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
		AND (SC.SalesCodeKey IN(665)) --TransferOut
		AND DD.FullDate >= CONV.ConversionDate
		AND FST.CenterKey = CONV.CenterKey
GROUP BY CASE WHEN SC.SalesCodeKey = 665 THEN 1
       ELSE 0
       END
       , DC.CenterSSID
       , DC.CenterDescriptionNumber
       , CLT.ClientKey



SELECT  DC.CenterDescriptionNumber AS 'TransferInCity'
,   CLT.ClientKey
,	CLT.ClientIdentifier
,   MAX(DD.FullDate) AS 'TransferDate'
,	CASE WHEN SC.SalesCodeKey = 1723 THEN 1
		ELSE 0 END AS 'TransferIn'
INTO #TransfersIn
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
	INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
		ON FST.OrderDateKey = DD.DateKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		ON FST.CenterKey = DC.CenterKey
	INNER JOIN #Conversions CONV
		ON	CONV.ClientKey = FST.ClientKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
		ON FST.ClientKey = CLT.ClientKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership MBR
		ON FST.MembershipKey = MBR.MembershipKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
		ON FST.SalesCodeKey = SC.SalesCodeKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
	AND (SC.SalesCodeKey IN(1723))						--TransferIn
	AND DD.FullDate >= CONV.ConversionDate
	AND FST.CenterKey <> CONV.CenterKey
GROUP BY CASE WHEN SC.SalesCodeKey = 1723 THEN 1
       ELSE 0
       END
       , DC.CenterDescriptionNumber
       , CLT.ClientKey
       , CLT.ClientIdentifier


/***************** Remove these clients that transferred out ************************************************/

DELETE FROM #Conversions WHERE ClientKey IN (SELECT ClientKey FROM #TransfersOut)
--DELETE FROM #Conversions WHERE ClientKey IN (SELECT ClientKey FROM #TransfersIN)

/*==============================================================================
Do these clients qualify as PCP for this current month?
==============================================================================*/

SELECT  C.MainGroup
,       C.MainGroupID
,       ClientFullName + ' (' + CAST(ClientIdentifier AS NVARCHAR(10)) + ')' AS 'ClientName'
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
        ON PD.CenterKey = C.CenterKey
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
SELECT C.MainGroup
,	C.MainGroupID
,   C.CenterDescriptionNumber
,	CONV.ClientName
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
,	CASE WHEN #TransfersOut.TransferOut = 1 THEN 'T'
		WHEN P.ClientKey IS NOT NULL THEN 'Y'
		ELSE 'N' END AS 'IsActive'
,	@PCPDate AS 'PCPDate'
,	Upg.UpgradeDate
,	#TransfersOut.TransferOutCity
,	#TransfersOut.ClientKey AS 'TransfersOutClientKey'
,	#TransfersOut.TransferOutDate
,	#TransfersOut.TransferOut
,	#TransfersIn.TransferInCity

FROM #Centers C
	LEFT OUTER JOIN #Conversions CONV
		ON C.CenterKey = CONV.CenterKey
	LEFT OUTER JOIN #PCP P
		ON CONV.ClientKey = P.ClientKey
	LEFT OUTER JOIN #Upgrades Upg
		ON CONV.ClientKey = Upg.ClientKey
	LEFT JOIN #TransfersOut
		ON #TransfersOut.ClientKey = CONV.ClientKey
	LEFT JOIN #TransfersIn
		ON #TransfersIn.ClientKey = CONV.ClientKey
WHERE CONV.ClientKey IS NOT NULL

END
