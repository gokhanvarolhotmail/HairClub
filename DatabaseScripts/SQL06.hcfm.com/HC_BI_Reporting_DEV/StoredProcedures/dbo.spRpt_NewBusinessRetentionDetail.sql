/***********************************************************************
PROCEDURE:				spRpt_NewBusinessRetentionDetail
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			New Business Retention
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		08/12/2015
------------------------------------------------------------------------
NOTES:
04/18/2016 - RH - (#123530) Added Regional drill-down and changed to INNER JOIN on lkpEthnicity
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_NewBusinessRetentionDetail 201, 0, 'ALL', 4, '2/1/2016', '2/29/2016'
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_NewBusinessRetentionDetail]
(
	@CenterID INT,
	@Gender INT,
	@Membership VARCHAR(10),
	@Ethnicity INT,
	@StartDate DATETIME,
	@EndDate DATETIME
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	CenterSSID INT
,	CenterDescription VARCHAR(50)
,	CenterDescriptionNumber VARCHAR(255)
,	CenterType VARCHAR(50)
,	RegionSSID INT
,	RegionDescription VARCHAR(50)
)

CREATE TABLE #Gender (
	GenderSSID INT
,	GenderDescription VARCHAR(50)
)

CREATE TABLE #Memberships (
	MembershipSSID INT
,	MembershipDescription VARCHAR(50)
,	MembershipDescriptionShort VARCHAR(10)
,	MembershipSortOrder INT
,	MembershipGrouping VARCHAR(50)
)

CREATE TABLE #Ethnicity (
	EthnicitySSID INT
,	EthnicityDescription VARCHAR(50)
)


/********************************** Get list of centers *************************************/
IF @CenterID IN (2,3,4,5,6,7,8,9,13,14,15)					--A region has been selected
BEGIN
INSERT  INTO #Centers
		SELECT  DC.CenterSSID
		,		DC.CenterDescription
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		,		R.RegionSSID
		,		R.RegionDescription
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
				ON DC.CenterTypeKey = DCT.CenterTypeKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
				ON DC.RegionKey = R.RegionKey
		WHERE   R.RegionSSID = @CenterID
				AND DC.Active = 'Y'
END
ELSE
BEGIN
INSERT  INTO #Centers										--A center has been selected
		SELECT  DC.CenterSSID
		,		DC.CenterDescription
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		,		R.RegionSSID
		,		R.RegionDescription
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
				ON DC.CenterTypeKey = DCT.CenterTypeKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
				ON DC.RegionKey = R.RegionKey
		WHERE   DC.CenterSSID = @CenterID
				AND DC.Active = 'Y'

END


/********************************** Get list of genders *************************************/
INSERT  INTO #Gender
        SELECT  1
        ,       'Male'
        UNION
		SELECT  2
        ,       'Female'


IF @Gender <> 0
BEGIN
	DELETE G FROM #Gender G WHERE G.GenderSSID <> @Gender
END


/********************************** Get list of memberships *************************************/
INSERT  INTO #Memberships
		SELECT  DM.MembershipSSID
		,		DM.MembershipDescription
		,       DM.MembershipDescriptionShort
		,       DM.MembershipSortOrder
		,       CASE UPPER(LEFT(DM.MembershipDescription, 4))
				  WHEN 'XTRA' THEN 'XTRALL'
				  WHEN 'FIRS' THEN 'SURALL'
				  WHEN 'ADDI' THEN 'SURALL'
				  WHEN 'POST' THEN 'SURALL'
				  ELSE RTRIM(UPPER(LEFT(DM.MembershipDescription, 4))) + 'ALL'
				END AS 'MembershipGrouping'
		FROM    HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
		WHERE   DM.RevenueGroupSSID = 1
				AND DM.MembershipSSID NOT IN ( 1, 2, 42, 57, 58 )
		ORDER BY DM.MembershipSortOrder


IF @Membership <> 'ALL'
BEGIN
	DELETE M FROM #Memberships M WHERE ( M.MembershipGrouping <> @Membership AND M.MembershipDescriptionShort <> @Membership )
END


/********************************** Get list of ethicities *************************************/
INSERT  INTO #Ethnicity
		SELECT  DE.EthnicitySSID
		,		DE.EthnicityDescription
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimEthnicity DE
		WHERE   DE.EthnicityKey <> -1


IF @Ethnicity <> 0
BEGIN
	DELETE E FROM #Ethnicity E WHERE E.EthnicitySSID <> @Ethnicity
END


/********************************** Get Sales Data *************************************/
SELECT  C.RegionSSID
,		C.RegionDescription
,		CTR.CenterSSID AS 'CenterSSID'
,       CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'ClientName'
,       DC.DateOfBirth
,       DC.Gender
,       DC.Age
,		E.EthnicitySSID AS 'EthnicitySSID'
,       E.EthnicityDescription AS 'Ethnicity'
,       DC.InitialSaleDate
,       DC.MembershipSold
,       DC.SoldBy
,       DC.BIO_Membership
,       DC.BIO_BeginDate
,       DC.BIO_EndDate
,       DC.BIO_MembershipStatus
,       DC.BIO_MonthlyFee
,       DC.BIO_ContractPrice
,       DC.BIO_TotalPayments
,       DC.BIO_CancelDate
,       DC.BIO_CancelReason
,       DC.EXT_Membership
,       DC.EXT_BeginDate
,       DC.EXT_EndDate
,       DC.EXT_MembershipStatus
,       DC.EXT_MonthlyFee
,       DC.EXT_ContractPrice
,       DC.EXT_TotalPayments
,       DC.EXT_CancelDate
,       DC.EXT_CancelReason
,       DC.SUR_Membership
,       DC.SUR_BeginDate
,       DC.SUR_EndDate
,       DC.SUR_MembershipStatus
,       DC.SUR_MonthlyFee
,       DC.SUR_ContractPrice
,       DC.SUR_TotalPayments
,       DC.SUR_CancelDate
,       DC.SUR_CancelReason
,       DC.XTR_Membership
,       DC.XTR_BeginDate
,       DC.XTR_EndDate
,       DC.XTR_MembershipStatus
,       DC.XTR_MonthlyFee
,       DC.XTR_ContractPrice
,       DC.XTR_TotalPayments
,       DC.XTR_CancelDate
,       DC.XTR_CancelReason
,       (ISNULL(FST.NB_TradCnt, 0) + ISNULL(FST.NB_ExtCnt, 0) + ISNULL(FST.NB_XTRCnt, 0) + ISNULL(FST.NB_GradCnt, 0)
        + ISNULL(FST.S_SurCnt, 0) + ISNULL(FST.S_PostExtCnt, 0)) AS 'NetNB1Count'
,       (ISNULL(FST.NB_TradAmt, 0) + ISNULL(FST.NB_ExtAmt, 0) + ISNULL(FST.NB_XTRAmt, 0) + ISNULL(FST.NB_GradAmt, 0)
        + ISNULL(FST.S_SurAmt, 0) + ISNULL(FST.S_PostExtAmt, 0)) AS 'NetNB1Sales'
INTO    #Sales
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON DD.DateKey = FST.OrderDateKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
            ON CLT.ClientKey = FST.ClientKey
        INNER JOIN HC_Accounting.dbo.dbaClient DC
            ON DC.ClientIdentifier = CLT.ClientIdentifier
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
            ON DSC.SalesCodeKey = FST.SalesCodeKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
            ON DSO.SalesOrderKey = FST.SalesOrderKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD
            ON DSOD.SalesOrderDetailKey = FST.SalesOrderDetailKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
            ON DCM.ClientMembershipKey = DSO.ClientMembershipKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
            ON DM.MembershipKey = DCM.MembershipKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
            ON CTR.CenterKey = DCM.CenterKey
        INNER JOIN #Centers C
            ON C.CenterSSID = CTR.CenterSSID
        INNER JOIN #Gender G
            ON G.GenderSSID = CLT.GenderSSID
        INNER JOIN #Memberships M
            ON M.MembershipSSID = DM.MembershipSSID
        INNER JOIN #Ethnicity E
            ON CLT.EthinicitySSID = E.EthnicitySSID
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
        AND DSC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
        AND DSOD.IsVoidedFlag = 0


-- Return Results
SELECT  SD.RegionSSID
,		SD.RegionDescription
,		C.CenterSSID
,       C.CenterDescription
,		C.CenterDescriptionNumber
,       C.CenterType
,       SD.ClientName
,       SD.DateOfBirth
,       SD.Gender
,       SD.Age
,       SD.Ethnicity
,       SD.InitialSaleDate
,       SD.MembershipSold
,       SD.SoldBy
,       SD.BIO_Membership
,       SD.BIO_BeginDate
,       SD.BIO_EndDate
,       SD.BIO_MembershipStatus
,       SD.BIO_MonthlyFee
,       SD.BIO_ContractPrice
,       SD.BIO_TotalPayments
,       SD.BIO_CancelDate
,       SD.BIO_CancelReason
,       SD.EXT_Membership
,       SD.EXT_BeginDate
,       SD.EXT_EndDate
,       SD.EXT_MembershipStatus
,       SD.EXT_MonthlyFee
,       SD.EXT_ContractPrice
,       SD.EXT_TotalPayments
,       SD.EXT_CancelDate
,       SD.EXT_CancelReason
,       SD.SUR_Membership
,       SD.SUR_BeginDate
,       SD.SUR_EndDate
,       SD.SUR_MembershipStatus
,       SD.SUR_MonthlyFee
,       SD.SUR_ContractPrice
,       SD.SUR_TotalPayments
,       SD.SUR_CancelDate
,       SD.SUR_CancelReason
,       SD.XTR_Membership
,       SD.XTR_BeginDate
,       SD.XTR_EndDate
,       SD.XTR_MembershipStatus
,       SD.XTR_MonthlyFee
,       SD.XTR_ContractPrice
,       SD.XTR_TotalPayments
,       SD.XTR_CancelDate
,       SD.XTR_CancelReason
,       SUM(SD.NetNB1Count) AS 'NetNB1Count'
,       SUM(SD.NetNB1Sales) AS 'NetNB1Sales'
FROM    #Centers C
        CROSS APPLY ( SELECT    S.RegionSSID
					  ,			S.RegionDescription
					  ,			S.CenterSSID
                      ,         S.ClientName
                      ,         S.DateOfBirth
                      ,         S.Gender
                      ,         S.Age
                      ,         S.Ethnicity
                      ,         S.InitialSaleDate
                      ,         S.MembershipSold
                      ,         S.SoldBy
                      ,         S.BIO_Membership
                      ,         S.BIO_BeginDate
                      ,         S.BIO_EndDate
                      ,         S.BIO_MembershipStatus
                      ,         S.BIO_MonthlyFee
                      ,         S.BIO_ContractPrice
                      ,         S.BIO_TotalPayments
                      ,         S.BIO_CancelDate
                      ,         S.BIO_CancelReason
                      ,         S.EXT_Membership
                      ,         S.EXT_BeginDate
                      ,         S.EXT_EndDate
                      ,         S.EXT_MembershipStatus
                      ,         S.EXT_MonthlyFee
                      ,         S.EXT_ContractPrice
                      ,         S.EXT_TotalPayments
                      ,         S.EXT_CancelDate
                      ,         S.EXT_CancelReason
                      ,         S.SUR_Membership
                      ,         S.SUR_BeginDate
                      ,         S.SUR_EndDate
                      ,         S.SUR_MembershipStatus
                      ,         S.SUR_MonthlyFee
                      ,         S.SUR_ContractPrice
                      ,         S.SUR_TotalPayments
                      ,         S.SUR_CancelDate
                      ,         S.SUR_CancelReason
                      ,         S.XTR_Membership
                      ,         S.XTR_BeginDate
                      ,         S.XTR_EndDate
                      ,         S.XTR_MembershipStatus
                      ,         S.XTR_MonthlyFee
                      ,         S.XTR_ContractPrice
                      ,         S.XTR_TotalPayments
                      ,         S.XTR_CancelDate
                      ,         S.XTR_CancelReason
                      ,         S.NetNB1Count
					  ,         S.NetNB1Sales
                      FROM      #Sales S
                      WHERE     S.CenterSSID = C.CenterSSID
								AND S.NetNB1Count <> 0
                    ) SD
GROUP BY SD.RegionSSID
,		SD.RegionDescription
,		C.CenterSSID
,       C.CenterDescription
,       C.CenterDescriptionNumber
,       C.CenterType
,       SD.ClientName
,       SD.DateOfBirth
,       SD.Gender
,       SD.Age
,       SD.Ethnicity
,       SD.InitialSaleDate
,       SD.MembershipSold
,       SD.SoldBy
,       SD.BIO_Membership
,       SD.BIO_BeginDate
,       SD.BIO_EndDate
,       SD.BIO_MembershipStatus
,       SD.BIO_MonthlyFee
,       SD.BIO_ContractPrice
,       SD.BIO_TotalPayments
,       SD.BIO_CancelDate
,       SD.BIO_CancelReason
,       SD.EXT_Membership
,       SD.EXT_BeginDate
,       SD.EXT_EndDate
,       SD.EXT_MembershipStatus
,       SD.EXT_MonthlyFee
,       SD.EXT_ContractPrice
,       SD.EXT_TotalPayments
,       SD.EXT_CancelDate
,       SD.EXT_CancelReason
,       SD.SUR_Membership
,       SD.SUR_BeginDate
,       SD.SUR_EndDate
,       SD.SUR_MembershipStatus
,       SD.SUR_MonthlyFee
,       SD.SUR_ContractPrice
,       SD.SUR_TotalPayments
,       SD.SUR_CancelDate
,       SD.SUR_CancelReason
,       SD.XTR_Membership
,       SD.XTR_BeginDate
,       SD.XTR_EndDate
,       SD.XTR_MembershipStatus
,       SD.XTR_MonthlyFee
,       SD.XTR_ContractPrice
,       SD.XTR_TotalPayments
,       SD.XTR_CancelDate
,       SD.XTR_CancelReason
HAVING	SUM(SD.NetNB1Count) <> 0
ORDER BY SD.ClientName


END
