/***********************************************************************
PROCEDURE:				spRpt_NewBusinessRetention
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			New Business Retention
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		08/12/2015
------------------------------------------------------------------------
NOTES:
04/18/2016 - RH - Changed parameters @GenderID and @EthnicityID to @Gender and @Ethnicity to match the SSRS report NBRetention.rdl
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_NewBusinessRetention 2, 0, 'ALL', 0, '2/1/2016', '3/31/2016'
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_NewBusinessRetention]
(
	@CenterType INT,
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


--Declare variables
DECLARE @PCPDate DATETIME


--Initialize variables
SELECT @PCPDate = CONVERT(VARCHAR(25), DATEADD(dd, -(DAY(GETDATE()) - 1), GETDATE()), 101)


/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	RegionSSID INT
,	RegionDescription VARCHAR(50)
,	CenterSSID INT
,	CenterDescription VARCHAR(255)
,	CenterType VARCHAR(50)
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
IF @CenterType = 2
	BEGIN
		INSERT  INTO #Centers
				SELECT  DR.RegionSSID
				,		DR.RegionDescription
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionSSID = DR.RegionKey
				WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
						AND DC.Active = 'Y'
	END


IF @CenterType = 8
	BEGIN
		INSERT  INTO #Centers
				SELECT  DR.RegionSSID
				,		DR.RegionDescription
				,		DC.CenterSSID
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionKey = DR.RegionKey
				WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[78]%'
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
SELECT  CTR.CenterSSID AS 'CenterSSID'
,		FST.ClientKey
,       (ISNULL(FST.NB_TradCnt, 0) + ISNULL(FST.NB_ExtCnt, 0) + ISNULL(FST.NB_XTRCnt, 0) + ISNULL(FST.NB_GradCnt, 0)
        + ISNULL(FST.S_SurCnt, 0) + ISNULL(FST.S_PostExtCnt, 0)) AS 'NetNB1Count'
INTO	#Sales
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON DD.DateKey = FST.OrderDateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON CLT.ClientKey = FST.ClientKey
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
            ON C.CenterSSID = CTR.ReportingCenterSSID
		INNER JOIN #Gender G
			ON G.GenderSSID = CLT.GenderSSID
		INNER JOIN #Memberships M
			ON M.MembershipSSID = DM.MembershipSSID
		LEFT OUTER JOIN #Ethnicity E
			ON CLT.EthinicitySSID = E.EthnicitySSID
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
		AND DSC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
        AND DSOD.IsVoidedFlag = 0


/********************************** Get PCP Data *************************************/
SELECT  CTR.CenterSSID AS 'CenterSSID'
,		FPD.ClientKey
,       FPD.PCP
,		FPD.EXT
,		FPD.XTR
INTO    #PCP
FROM    HC_Accounting.dbo.FactPCPDetail FPD
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON DD.DateKey = FPD.DateKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
            ON CTR.CenterKey = FPD.CenterKey
        INNER JOIN #Centers C
            ON C.CenterSSID = CTR.CenterSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON CLT.ClientKey = FPD.ClientKey
WHERE   MONTH(DD.FullDate) = MONTH(@PCPDate)
        AND YEAR(DD.FullDate) = YEAR(@PCPDate)
		AND FPD.ClientKey IN ( SELECT DISTINCT S.ClientKey FROM #Sales S )


-- Return Results
SELECT  C.RegionSSID
,		C.RegionDescription
,       C.CenterSSID
,       C.CenterDescription AS 'CenterName'
,       SD.NetNB1Count AS 'NB1Sold'
,       PD.PCP AS 'ActivePCP'
,       dbo.DIVIDE_DECIMAL(PD.PCP, SD.NetNB1Count) AS 'ActivePCPPercentage'
FROM    #Centers C
        CROSS APPLY ( SELECT    S.CenterSSID
                      ,         SUM(S.NetNB1Count) AS 'NetNB1Count'
                      FROM      #Sales S
                      WHERE     S.CenterSSID = C.CenterSSID
                      GROUP BY  S.CenterSSID
                    ) SD
        CROSS APPLY ( SELECT    P.CenterSSID
                      ,         SUM(PCP) AS 'PCP'
                      FROM      #PCP P
                      WHERE     P.CenterSSID = C.CenterSSID
                      GROUP BY  P.CenterSSID
                    ) PD


END
