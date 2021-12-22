/****** Object:  StoredProcedure [dbo].[spRpt_HolidayPromoContest]    Script Date: 11/07/2014 09:35:22 ******/

/***********************************************************************
PROCEDURE:				spRpt_HolidayPromoContest
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			HolidayPromoContest.rdl
Author of this version:	Rachelen Hut
DATE IMPLEMENTED:		11/1/2014
------------------------------------------------------------------------
NOTES: Keep POST EXT Sales (Revenue)
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_HolidayPromoContest

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_HolidayPromoContest]

AS
BEGIN

	DECLARE @ContestSSID INT
	DECLARE @StartDate DATETIME
	DECLARE @EndDate DATETIME



	SET @ContestSSID = (SELECT C.ContestSSID FROM Contest C WHERE C.ContestName = 'HolidayPromo')
	SET @StartDate = '11/1/2014'
	SET @EndDate = '12/31/2014'


	SET FMTONLY OFF;
	SET NOCOUNT OFF;



	/********************************** Create Temp Table Objects *************************************/
	CREATE TABLE #Centers (
		ContestReportGroupSSID INT
	,	GroupDescription VARCHAR(50)
	,	GroupImage VARCHAR(100)
	,	CenterSSID INT
	,	CenterDescriptionNumber VARCHAR(255)
	,	CenterTypeDescriptionShort VARCHAR(50)
	,	CenterSortOrder INT
	)


	CREATE TABLE #Sales (
		CenterSSID INT
	,	CenterDescriptionNumber NVARCHAR(103)
	,	CenterTypeDescriptionShort  NVARCHAR(50)
	,	Promo INT
	)

	/********************************** Get List of Centers *************************************/
	INSERT  INTO #Centers
		SELECT  CRG.ContestReportGroupSSID
		,		CRG.GroupDescription
		,		CRG.GroupImage
		,		DC.CenterSSID
		,		DC.CenterDescriptionNumber
		,		DCT.CenterTypeDescriptionShort
		,		CCRG.CenterSortOrder
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
					ON DC.CenterTypeKey = DCT.CenterTypeKey
				INNER JOIN ContestCenterReportGroup CCRG
					ON DC.CenterSSID = CCRG.CenterSSID
						AND CCRG.ContestSSID = @ContestSSID
				INNER JOIN ContestReportGroup CRG
					ON CCRG.ContestReportGroupSSID = CRG.ContestReportGroupSSID
						AND CRG.ContestSSID = @ContestSSID
			WHERE   CONVERT(VARCHAR, DC.CenterSSID) LIKE '[278]%'
				AND DC.Active = 'Y'

	/********************************** Get Sales Data *************************************/
	INSERT  INTO #Sales
		SELECT  DC.CenterSSID
			,	DC.CenterDescriptionNumber
			,	DCT.CenterTypeDescriptionShort
			,	SUM(FST.Quantity) AS 'Promo'
			FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON FST.OrderDateKey = dd.DateKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
                    ON fst.SalesCodeKey = sc.SalesCodeKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
                    ON FST.ClientMembershipKey = cm.ClientMembershipKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
                    ON cm.MembershipSSID = m.MembershipSSID
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
                    ON cm.CenterKey = DC.CenterKey
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
                    ON DC.CenterTypeKey = DCT.CenterTypeKey
                INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
                    ON DC.RegionKey = r.RegionKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
                    ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey

			WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
						AND CONVERT(VARCHAR(10), DC.CenterSSID) LIKE '[278]%'
						AND DC.Active = 'Y'
						AND FST.SalesCodeKey = 1743
						AND SOD.IsVoidedFlag = 0
			GROUP BY DC.CenterSSID
				,	DC.CenterDescriptionNumber
				,	DCT.CenterTypeDescriptionShort

	/****************Final Select ****************************************/

	SELECT ContestReportGroupSSID
				,	GroupDescription
				,	GroupImage
				,	CenterSSID
				,	CenterDescriptionNumber
				,	CenterTypeDescriptionShort
				,	CenterSortOrder
				,	ISNULL(Promo,0) AS 'PromoCount'
	FROM
	(SELECT  ContestReportGroupSSID
				,	GroupDescription
				,	GroupImage
				,	C.CenterSSID
				,	C.CenterDescriptionNumber
				,	C.CenterTypeDescriptionShort
				,	CenterSortOrder
				,	Promo
		FROM    #Centers C
				LEFT OUTER JOIN #Sales S
					ON C.CenterSSID = S.CenterSSID)q

END
