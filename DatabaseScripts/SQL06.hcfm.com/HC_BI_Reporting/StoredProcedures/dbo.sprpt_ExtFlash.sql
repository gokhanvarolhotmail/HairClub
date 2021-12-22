/* CreateDate: 07/09/2012 09:23:00.110 , ModifyDate: 05/08/2019 09:37:57.140 */
GO
/*
==============================================================================

PROCEDURE:				sprpt_ExtFlash

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Marlon Burrell

DATE IMPLEMENTED:		04/18/2013

==============================================================================
DESCRIPTION:	EXT Flash

@sType = 'C' or 'F'

@Filter = 1 is By Regions, 2 is Area Managers, 3 is By Centers
==============================================================================
NOTES:
11/27/2013 - RH - Commented out "AND cm.ClientMembershipStatusSSID IN (1)" for expirations.
04/07/2014 - RH - Added SUM(CASE WHEN SC.SalesCodeDepartmentSSID IN (5035) THEN 1 ELSE 0 END) AS 'RR_EXTServices'
05/16/2014 - RH - Changed [0 AS 'NBpcntcnv'] TO [dbo.Divide(F.NBconversions, NB_NS.NetSales) AS 'NBpcntcnv']
10/06/2014 - RH - Added 5037 where SalesCodeDepartmentSSID = 5037 for Xtrands Services (New)
12/01/2014 - RH - Added OR SC.SalesCodeDescriptionShort IN('XTRNEWSRV','EXTSVCXTD') to capture Xtrands Services
02/18/2015 - RH - Added Retention
03/23/2015 - RH - Added groupings for Region, RSM, RSM - MA, RTM (WO#110054)
06/01/2015 - RH - Changed joins to match NB Flash; SUM(CASE WHEN FST.NB_EXTCnt > 0 THEN 1 ELSE 0 END) AS 'NBcountnet'
07/28/2015 - RH - (#116552) Changed PCP headings, not values, to one month earlier
10/2/2015 -  RH - (#115873) Changed SUM(CASE WHEN FST.NB_EXTCnt > 0 THEN 1 ELSE 0 END) to SUM(FST.NB_EXTCnt) AS 'NBcountnet'
12/15/2015 - RH - (#121495) Changed Retention formula to the RetentionX formula that removes the timeframe
01/04/2016 - RH - (#120705) Changed groupings to include by Area Managers and by Centers; (Franchise is only by Region)
02/02/2016 - RH - (#122554) Changed to vwFactPCPDetail from FactPCPDetail for PCP counts; JOIN for CenterKey on PD.CenterKey
11/02/2016 - RH - (#132224) Changed to SUM(NB_GrossNB1Cnt) for NetCount; Added AND DSC.SalesCodeKey NOT IN (665, 654, 393, 668) AND SOD.IsVoidedFlag = 0; Changed OpenPCP to ClosePCP AS 'RRactive'
01/05/2017 - RH - (#132688) Changed EmployeeKey to CenterManagementAreaSSID as AreaManagerID and CenterManagementAreaDescription as description
03/07/2018 - RH - (#145957) Changed CenterSSID to CenterNumber
==============================================================================
SAMPLE EXECUTION:
EXEC [sprpt_ExtFlash] 'C', 2, '08/2/2018', '08/2/2018'
EXEC [sprpt_ExtFlash] 'C', 3, '01/1/2018', '01/31/2018'
EXEC [sprpt_ExtFlash] 'F', 1, '01/1/2018', '01/31/2018'

==============================================================================
*/
CREATE PROCEDURE [dbo].[sprpt_ExtFlash] (
	@sType CHAR(1)
,	@Filter INT
,	@begdt DATETIME
,	@enddt DATETIME




) AS
BEGIN

	SET FMTONLY OFF
	SET NOCOUNT OFF

	/********************************** Create temp table objects *************************************/
	CREATE TABLE #Centers (
		MainGroupID INT
	,	MainGroup VARCHAR(50)
	,	CenterNumber INT
	,	CenterKey INT
	,	CenterDescription VARCHAR(50)
	,	CenterDescriptionNumber VARCHAR(255)
	,	CenterType VARCHAR(50)
	)

	CREATE TABLE #EXTExpirations (
		CenterNumber INT
	,	Expirations INT
	)


/********************************** Get list of centers *************************************/
IF @sType = 'F' AND @Filter = 1  --By Region
	BEGIN
		INSERT  INTO #Centers
				SELECT  DR.RegionSSID AS 'MainGroupID'
				,		DR.RegionDescription AS 'MainGroup'
				,		DC.CenterNumber
				,		DC.CenterKey
				,		DC.CenterDescription
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				FROM    HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
							ON DC.RegionSSID = DR.RegionSSID
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DCT.CenterTypeKey = DC.CenterTypeKey
				WHERE  DCT.CenterTypeDescriptionShort IN('F','JV')
						AND DC.Active = 'Y'
	END


IF @sType = 'C' AND @Filter = 2  --By Area manager
	BEGIN
		INSERT  INTO #Centers
				SELECT  CMA.CenterManagementAreaSSID AS 'MainGroupID'
				,		CMA.CenterManagementAreaDescription AS 'MainGroup'
				,		CTR.CenterNumber
				,		CTR.CenterKey
				,		CTR.CenterDescription
				,		CTR.CenterDescriptionNumber
				,		DCT.CenterTypeDescription
				FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
							ON CTR.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON CTR.CenterTypeKey = DCT.CenterTypeKey
				WHERE  DCT.CenterTypeDescriptionShort = 'C'
						AND CMA.Active = 'Y'
	END


IF @sType = 'C' AND @Filter = 3  --By Corporate Center
	BEGIN
		INSERT  INTO #Centers
				SELECT  DC.CenterNumber AS 'MainGroupID'
				,		DC.CenterDescriptionNumber AS 'MainGroup'
				,		DC.CenterNumber
				,		DC.CenterKey
				,		DC.CenterDescription
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
				WHERE  DCT.CenterTypeDescriptionShort = 'C'
						AND DC.Active = 'Y'
	END

IF @sType = 'F' AND @Filter = 3  --By Franchise Center
	BEGIN
		INSERT  INTO #Centers
				SELECT  DC.CenterNumber AS 'MainGroupID'
				,		DC.CenterDescriptionNumber AS 'MainGroup'
				,		DC.CenterNumber
				,		DC.CenterKey
				,		DC.CenterDescription
				,		DC.CenterDescriptionNumber
				,		DCT.CenterTypeDescriptionShort
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
							ON DC.CenterTypeKey = DCT.CenterTypeKey
				WHERE  DCT.CenterTypeDescriptionShort IN('F','JV')
						AND DC.Active = 'Y'
	END


	/********************************** Get Open PCP data *************************************/

	SELECT CenterNumber
	, COUNT(ClientIdentifier) AS 'OpenPCP'
	,	r.MonthPCPBegin
	,	r.YearPCPBegin
	INTO #OpenPCP
	FROM
          (SELECT DC.CenterNumber								--Must be C.CenterSSID
         ,      DC.CenterDescription AS 'Center'
         ,      DCLT.ClientIdentifier
         ,      DCLT.ClientFirstName AS 'FirstName'
         ,      DCLT.ClientLastName AS 'LastName'
         ,      M.MembershipDescription AS 'Membership'
         ,		MONTH(DATEADD(MONTH,-1,@begdt)) AS 'MonthPCPBegin'
		  ,		YEAR(DATEADD(MONTH,-1,@begdt)) AS 'YearPCPBegin'

        FROM   HC_Accounting.dbo.vwFactPCPDetail PD
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON PD.DateKey = DD.DateKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient DCLT
                    ON PD.ClientKey = DCLT.ClientKey
				INNER JOIN #CENTERS C
                    ON PD.CenterKey = C.CenterKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
                    ON PD.CenterKey = DC.CenterKey							--Must join on PD.CenterKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
                    ON PD.MembershipKey = M.MembershipKey
         WHERE  MONTH(DD.FullDate) = MONTH(@begdt)
                AND YEAR(DD.FullDate) = YEAR(@begdt)
                AND PD.ActiveEXT = 1
		)r
	GROUP BY r.CenterNumber
	,	r.MonthPCPBegin
	,	r.YearPCPBegin



	/********************************** Get Close PCP data *************************************/
	SELECT CenterNumber
	, COUNT(ClientIdentifier) AS 'ClosePCP'
	,	r.MonthPCPEnd
	,	r.YearPCPEnd
	INTO #ClosePCP
	FROM
          (SELECT DC.CenterNumber 								--Must be C.CenterSSID
         ,      DC.CenterDescription AS 'Center'
         ,      DCLT.ClientIdentifier
         ,      DCLT.ClientFirstName AS 'FirstName'
         ,      DCLT.ClientLastName AS 'LastName'
         ,      M.MembershipDescription AS 'Membership'
         ,		MONTH(DATEADD(MONTH,-1,@enddt)) AS 'MonthPCPEnd'
		  ,		YEAR(DATEADD(MONTH,-1,@enddt)) AS 'YearPCPEnd'
        FROM   HC_Accounting.dbo.vwFactPCPDetail PD
                INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                    ON PD.DateKey = DD.DateKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient DCLT
                    ON PD.ClientKey = DCLT.ClientKey
				INNER JOIN #CENTERS C
                    ON PD.CenterKey = C.CenterKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
                    ON PD.CenterKey = DC.CenterKey							--Must join on PD.CenterKey
                INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
                    ON PD.MembershipKey = M.MembershipKey
         WHERE  MONTH(DD.FullDate) = MONTH(@enddt)
                AND YEAR(DD.FullDate) = YEAR(@enddt)
                AND PD.ActiveEXT = 1
		)r
	GROUP BY r.CenterNumber
		,	r.MonthPCPEnd
		,	r.YearPCPEnd

	/********************************** Get NB Net GROSS data *************************************/

	SELECT C.CenterNumber
	,	SUM(ISNULL(FST.NB_GrossNB1Cnt,0)) AS 'NBcount'
	INTO #NBNetSales
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = dd.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON fst.SalesCodeKey = sc.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
						ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
			ON FST.ClientMembershipKey = cm.ClientMembershipKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON cm.CenterKey = c.CenterKey
		INNER JOIN #Centers
			ON C.CenterNumber = #Centers.CenterNumber
	WHERE DD.FullDate BETWEEN @begdt AND @enddt
		AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
		AND SOD.IsVoidedFlag = 0
	GROUP BY C.CenterNumber


	/********************************** Get Sales data *************************************/
	SELECT C.CenterNumber
	,	SUM(ISNULL(FST.NB_EXTCnt,0)) AS 'NBcountnet'
	,	SUM(ISNULL(FST.NB_ExtAmt,0)) AS 'NBsales'
	,	SUM(CASE WHEN FST.NB_ExtAmt < 0 THEN FST.NB_ExtAmt ELSE 0 END) AS 'NBrefunds'
	,	SUM(FST.NB_EXTConvCnt) AS 'NBconversions'
	,	SUM(FST.PCP_ExtMemAmt) AS 'RRsales'
	,	SUM(CASE WHEN DSC.SalesCodeDepartmentSSID IN (1090) THEN 1 ELSE 0 END) AS 'RRrenewals'
	,	SUM(CASE WHEN DSC.SalesCodeDepartmentSSID IN (1099) THEN 1 ELSE 0 END) AS 'RRcancels'
	,	SUM(CASE WHEN DSC.SalesCodeDepartmentSSID IN (5035,5036) THEN 1 ELSE 0 END) AS 'RR_EXTServices'
	INTO #Final
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = dd.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
            ON FST.SalesOrderKey = DSO.SalesOrderKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
			ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
            ON DSO.ClientMembershipKey = DCM.ClientMembershipKey --Change FST to DSO
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON DCM.MembershipKey = M.MembershipKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON DCM.CenterKey = C.CenterKey  --Change FST to DCM
		INNER JOIN #Centers
			ON C.CenterNumber = #Centers.CenterNumber
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient DC
			ON FST.ClientKey = DC.ClientKey
	WHERE DD.FullDate BETWEEN @begdt AND @enddt
		AND DSC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
		AND SOD.IsVoidedFlag = 0
	GROUP BY C.CenterNumber


/****************************** GET FINAL DATA SET ***********************************/
	SELECT  CTR.CenterType AS 'Type'
	,		CTR.MainGroupID
	,		CTR.MainGroup
	,		CTR.CenterNumber
	,		CTR.CenterDescription
	,		CTR.CenterDescriptionNumber AS 'CenterName'
	,	NB_NS.NBcount
	,	F.NBcountnet
	,	dbo.Divide(F.NBcountnet, ISNULL(NB_NS.NBcount, 0)) AS 'NBsalesmix'
	,	ISNULL(NB_NS.NBcount, 0) AS 'NB1netsales'
	,	F.NBsales
	,	F.NBrefunds
	,	dbo.Divide(F.NBsales, F.NBcountnet) AS 'NBnetmoney'
	,	ISNULL(EXPR.Expirations, 0) AS 'NBexpirations'
	,	F.NBconversions
	,	dbo.Divide(F.NBconversions, F.NBcountnet) AS 'NBpcntcnv'
	,	F.RRsales
	,	0 AS 'RRrefunds'
	,	F.RRrenewals
	,	F.RRcancels
	,	ISNULL(CPCP.ClosePCP, 0) AS 'RRactive'
	,	dbo.Divide(F.RRrenewals, ISNULL(OPCP.OpenPCP, 0)) AS 'RRrenewrate'
	,	OPCP.OpenPCP AS 'open_pcp'
	,	CPCP.ClosePCP AS 'close_pcp'
	,	dbo.Attrition(ISNULL(OPCP.OpenPCP, 0), ISNULL(CPCP.ClosePCP, 0), F.NBconversions, @begdt, @enddt) AS 'Attrition'
	,	dbo.RetentionX(ISNULL(OPCP.OpenPCP, 0), ISNULL(CPCP.ClosePCP, 0), F.NBconversions) AS 'Retention'
	,	ISNULL(F.RR_EXTServices, 0) AS 'RR_EXTServices'
	,	MONTH(DATEADD(MONTH,-1,@begdt)) AS 'MonthPCPBegin'
	,	YEAR(DATEADD(MONTH,-1,@begdt)) AS 'YearPCPBegin'
	,	MONTH(DATEADD(MONTH,-1,@enddt)) AS 'MonthPCPEnd'
	,	YEAR(DATEADD(MONTH,-1,@enddt)) AS 'YearPCPEnd'
	FROM #Final F
		INNER JOIN #Centers CTR
			ON F.CenterNumber = CTR.CenterNumber
		LEFT JOIN #NBNetSales NB_NS
			ON F.CenterNumber = NB_NS.CenterNumber
		LEFT JOIN #EXTExpirations EXPR
			ON F.CenterNumber = EXPR.CenterNumber
		LEFT JOIN #OpenPCP OPCP
			ON F.CenterNumber = OPCP.CenterNumber
		LEFT JOIN #ClosePCP CPCP
			ON F.CenterNumber = CPCP.CenterNumber


END
GO
