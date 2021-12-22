/* CreateDate: 01/14/2015 11:11:10.143 , ModifyDate: 05/13/2019 14:32:24.447 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				sprpt_XtrFlash

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	HC_BI_REPORTING

IMPLEMENTOR: 			Rachelen Hut

DATE IMPLEMENTED:		01/14/2015

==============================================================================
DESCRIPTION:	Xtr Flash
==============================================================================
NOTES:
@sType = 'C' for Corporate or 'F' for Franchise
@Filter = 1 for Region, 2 for Area, 3 for Center
==============================================================================
CHANGE HISTORY:

02/03/2015 - RH - Added CurrentXtrandsClientMembershipSSID to the COALESCE statement
02/04/2015 - RH - (WO#111093) Added Retention
04/29/2015 - RH - (WO#111709) Added EXT MEM upgrades
06/11/2015 - RH - (WO#114338) Added fields MonthPCPBegin, YearPCPBegin, MonthPCPEnd, YearPCPEnd
06/15/2015 - RH - Changed joins for center to ClientMembership center instead of FST; SUM(CASE WHEN FST.NB_XtrCnt > 0 THEN 1 ELSE 0 END) AS 'NBcountnet'
07/28/2015 - RH - (WO#116552) Changed PCP headings, not values, to one month earlier
12/15/2015 - RH - (WO#121495) Changed Retention formula to the RetentionX formula that removes the timeframe
03/14/2018 - RH - (#145957) Added CenterNumber and replaced CenterSSID
06/28/2018 - RH - (#151215) Changed the sorting in the report; Added CASE WHEN @Center = 'F' THEN  R.RegionSortOrder ELSE CMA.CenterManagementAreaSortOrder END  AS 'RegionSortOrder'
06/29/2018 - RH - (#151215) Changed the parameters to include @sType and @Filter
==============================================================================
SAMPLE EXECUTION:

EXEC [sprpt_XtrFlash] '6/1/2018', '7/1/2018','C', 2
EXEC [sprpt_XtrFlash] '6/1/2018', '7/1/2018','C', 3

EXEC [sprpt_XtrFlash] '6/1/2018', '7/1/2018','F', 1
EXEC [sprpt_XtrFlash] '6/1/2018', '7/1/2018','F', 3

==============================================================================
*/
CREATE PROCEDURE [dbo].[sprpt_XtrFlash] (
	@StartDate SMALLDATETIME
,	@EndDate SMALLDATETIME
,	@sType CHAR(1)
,	@Filter INT

) AS
BEGIN

	SET FMTONLY OFF
	SET NOCOUNT OFF



	/********************************** Create temp table objects *************************************/
	CREATE TABLE #Centers (
		MainGroupID INT
	,	MainGroup VARCHAR(50)
	,	MainGroupSortOrder INT
	,	CenterNumber INT
	,	CenterKey INT
	,	CenterDescription VARCHAR(50)
	,	CenterDescriptionNumber VARCHAR(104)
	)

	CREATE TABLE #XtrExpirations (
		CenterNumber INT
	,	Expirations INT
	)

	CREATE TABLE #OpenPCP (
		CenterNumber INT
	,	OpenPCP INT
	,	MonthPCPBegin INT
	,	YearPCPBegin INT
	)

	CREATE TABLE #ClosePCP (
		CenterNumber INT
	,	ClosePCP INT
	,	MonthPCPEnd INT
	,	YearPCPEnd INT
	)

	CREATE TABLE #NBNetSales (
		CenterNumber INT
	,	NetSales INT
	)



/********************************** Get list of centers *************************************/


	IF @sType = 'C' AND @Filter = 2  --By Area Managers
	BEGIN
		INSERT  INTO #Centers
				SELECT  CMA.CenterManagementAreaSSID AS 'MainGroupID'
				,		CMA.CenterManagementAreaDescription AS 'MainGroup'
				,		CMA.CenterManagementAreaSortOrder AS 'MainGroupSortOrder'
				,		DC.CenterNumber
				,		DC.CenterKey
				,		DC.CenterDescription
				,		DC.CenterDescriptionNumber
				FROM	HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
							ON CT.CenterTypeKey = DC.CenterTypeKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
							ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
				WHERE	DC.Active = 'Y'
				AND CMA.Active = 'Y'
				AND CT.CenterTypeDescriptionShort IN ( 'C')
	END
	IF @sType = 'C' AND @Filter = 3  -- By Centers
	BEGIN
		INSERT  INTO #Centers
				SELECT  DC.CenterNumber AS 'MainGroupID'
				,		DC.CenterDescriptionNumber AS 'MainGroup'
				,		DC.CenterNumber AS 'MainGroupSortOrder'
				,		DC.CenterNumber
				,		DC.CenterKey
				,		DC.CenterDescription
				,		DC.CenterDescriptionNumber
				FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
							ON CT.CenterTypeKey = DC.CenterTypeKey
				WHERE	DC.Active = 'Y'
						AND CT.CenterTypeDescriptionShort IN ( 'C')
	END


IF @sType = 'F' AND @Filter IN(1,3)
BEGIN
	INSERT  INTO #Centers
			SELECT  DR.RegionSSID AS 'MainGroupID'
			,		DR.RegionDescription AS 'MainGroup'
			,		DR.RegionSortOrder AS 'MainGroupSortOrder'
			,		DC.CenterNumber
			,		DC.CenterKey
			,		DC.CenterDescription
			,		DC.CenterDescriptionNumber
			FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = DC.CenterTypeKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
						ON DC.RegionKey = DR.RegionKey
			WHERE	CT.CenterTypeDescriptionShort IN('F','JV')
					AND DC.Active = 'Y'
END



	/********************************** Get NB Net Sales data *************************************/
	INSERT INTO #NBNetSales
	SELECT C.CenterNumber AS 'Center'
	,	SUM(ISNULL(FST.NB_TradCnt, 0))
			+ SUM(ISNULL(FST.NB_ExtCnt, 0))
			+ SUM(ISNULL(FST.NB_XtrCnt, 0))
			+ SUM(ISNULL(FST.NB_GradCnt, 0))
			+ SUM(ISNULL(FST.S_SurCnt, 0))
			+ SUM(ISNULL(FST.S_PostExtCnt, 0))
		AS 'NetNB1Count'
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = dd.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
			ON fst.SalesCodeKey = sc.SalesCodeKey
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
			ON C.CenterKey = #Centers.CenterKey
	WHERE DD.FullDate BETWEEN @StartDate AND @EndDate
	GROUP BY C.CenterNumber


	/********************************** Get Xtr Expiration data *************************************/
	INSERT INTO #XtrExpirations
	SELECT cntr.CenterNumber
	,	COUNT(clt.ClientSSID) AS 'Expires'
	FROM HC_BI_CMS_DDS.bi_cms_dds.DimClient clt
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
			ON ctr.CenterSSID = clt.CenterSSID
		INNER JOIN #Centers cntr
			ON ctr.CenterKey = cntr.CenterKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
			ON COALESCE(clt.CurrentXtrandsClientMembershipSSID,clt.CurrentBioMatrixClientMembershipSSID,clt.CurrentSurgeryClientMembershipSSID,clt.CurrentExtremeTherapyClientMembershipSSID) = DCM.ClientMembershipSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
			ON DCM.MembershipSSID = m.MembershipSSID
	WHERE M.MembershipSSID IN (70,75)
		AND DCM.ClientMembershipEndDate BETWEEN @StartDate AND @EndDate
	GROUP BY cntr.CenterNumber

	/*MembershipSSID	MembershipDescription
		70				Xtrands (New)			NB
		75				Xtrands 6				NB
	*/

		/********************************** Get Cancels *************************************/
			-- Get Cancellations
			SELECT q.CenterNumber
			,	SUM(q.XtrCancel) AS 'RRcancels'
			INTO #cancels
			FROM
				(SELECT  cntr.CenterNumber
					,	FST.ClientKey
					,	DSC.SalesCodeSSID
					,	FST.Employee2Key
					,	1 AS 'XtrCancel'
					,	DD.FullDate AS 'XtrCancelDate'
					,	ROW_NUMBER() OVER(PARTITION BY FST.ClientKey ORDER BY DD.FullDate DESC) AS FirstRank
				FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
					ON FST.OrderDateKey = dd.DateKey
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
				INNER JOIN #Centers cntr
					ON C.CenterKey = cntr.CenterKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
					ON FST.SalesCodeKey = DSC.SalesCodeKey
				WHERE DSC.SalesCodeDepartmentSSID = 1099  --Cancellations
				AND FST.MembershipKey IN(SELECT MembershipKey FROM HC_BI_CMS_DDS.bi_cms_dds.DimMembership
											WHERE MembershipDescription LIKE '%Xtr%Mem%')
				AND DD.FullDate BETWEEN @StartDate AND @EndDate --Find cancels that belong to the clients in this report
				)q
			WHERE FirstRank = 1
			GROUP BY q.CenterNumber


		/********************************** Get Renewals *************************************/
			-- Get Renewals
			SELECT q.CenterNumber
			,	SUM(q.XtrRenew) AS 'RRrenewals'
			INTO #renewals
			FROM
				(SELECT  cntr.CenterNumber
					,	FST.ClientKey
					,	DSC.SalesCodeSSID
					,	FST.Employee2Key
					,	1 AS 'XtrRenew'
					,	DD.FullDate AS 'XtrRenewDate'
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
				INNER JOIN #Centers cntr
					ON C.CenterKey = cntr.CenterKey

				WHERE DSC.SalesCodeDepartmentSSID = 1090  --Renewals
				AND FST.MembershipKey IN(SELECT MembershipKey FROM HC_BI_CMS_DDS.bi_cms_dds.DimMembership
											WHERE MembershipDescription LIKE '%Xtr%Mem%')
				AND DD.FullDate BETWEEN @StartDate AND @EndDate --Find renewals that belong to the clients in this report
				)q
			GROUP BY q.CenterNumber


	/********************************** Get Open PCP data *************************************/
	--PCP for this month
	INSERT INTO #OpenPCP
	SELECT q.CenterNumber
	,	SUM(q.XTR) AS 'OpenPCP'
	,	MONTH(DATEADD(MONTH,-1,@StartDate)) AS 'MonthPCPBegin'
	,	YEAR(DATEADD(MONTH,-1,@StartDate)) AS 'YearPCPBegin'
	 FROM( SELECT DC.CenterNumber AS 'CenterNumber'
			 ,      DC.CenterDescription AS 'Center'
			 ,      DCLT.ClientIdentifier AS 'Client_No'
			 ,      DCLT.ClientFirstName AS 'FirstName'
			 ,      DCLT.ClientLastName AS 'LastName'
			 ,      M.MembershipDescription AS 'Membership'
			 ,		PD.XTR
			 FROM   HC_Accounting.dbo.FactPCPDetail PD
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON PD.DateKey = DD.DateKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						ON PD.CenterKey = DC.CenterKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient DCLT
						ON PD.ClientKey = DCLT.ClientKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
						ON PD.MembershipKey = M.MembershipKey
					INNER JOIN #CENTERS C
						--ON DC.CenterSSID = C.CenterSSID
						ON PD.CenterKey = C.CenterKey
			 WHERE  MONTH(DD.FullDate) = MONTH(@StartDate)
					AND YEAR(DD.FullDate) = YEAR(@StartDate)
					AND PD.XTR = 1
			)q
		GROUP BY q.CenterNumber



	/********************************** Get Close PCP data *************************************/
	--PCP for last month
	INSERT INTO #ClosePCP
	SELECT r.CenterNumber
	,	SUM(r.XTR) AS 'ClosePCP'
	,	MONTH(DATEADD(MONTH,-1,@EndDate)) AS 'MonthPCPEnd'
	,	YEAR(DATEADD(MONTH,-1,@EndDate)) AS 'YearPCPEnd'
	 FROM( SELECT DC.CenterNumber AS 'CenterNumber'
			 ,      DC.CenterDescription AS 'Center'
			 ,      DCLT.ClientIdentifier AS 'Client_No'
			 ,      DCLT.ClientFirstName AS 'FirstName'
			 ,      DCLT.ClientLastName AS 'LastName'
			 ,      M.MembershipDescription AS 'Membership'
			 ,		PD.XTR
			 FROM   HC_Accounting.dbo.FactPCPDetail PD
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON PD.DateKey = DD.DateKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
						ON PD.CenterKey = DC.CenterKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient DCLT
						ON PD.ClientKey = DCLT.ClientKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
						ON PD.MembershipKey = M.MembershipKey
					INNER JOIN #CENTERS C
						--ON DC.CenterSSID = C.CenterSSID
						ON PD.CenterKey = C.CenterKey
			 WHERE  MONTH(DD.FullDate) = MONTH(@EndDate)
					AND YEAR(DD.FullDate) = YEAR(@EndDate)
					AND PD.XTR = 1
			)r
		GROUP BY r.CenterNumber


	/********************************** Get Sales data *************************************/
	SELECT C.CenterNumber
	,	SUM(FST.NB_GrossNB1Cnt) AS 'NBcount'
	,	SUM(CASE WHEN FST.NB_XtrCnt > 0 THEN 1 ELSE 0 END) AS 'NBcountnet'
	,	SUM(FST.NB_XtrAmt) AS 'NBsales'
	,	SUM(CASE WHEN FST.NB_XtrAmt < 0 THEN FST.NB_XtrAmt ELSE 0 END) AS 'NBrefunds'  --Show negative amounts or zero
	,	SUM(FST.NB_XtrConvCnt) AS 'NBconversions'
	,	SUM(FST.PCP_XtrAmt) AS 'RRsales'
	,	SUM(CASE WHEN DSC.SalesCodeDepartmentSSID IN (5038) THEN 1 ELSE 0 END) AS 'RR_XtrServices' --5038	Xtrand Services (Member) XTRANDMBR
	,	SUM(CASE WHEN DSC.SalesCodeSSID IN (787) AND DSC.SalesCodeDepartmentSSID = 1070 THEN 1 ELSE 0 END) AS 'UpgFromEXT' ----Upgrade to Xtrands MEM -- EXTMEMXU
	INTO #Final
	FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
			ON FST.OrderDateKey = DD.DateKey
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
			ON C.CenterKey = #Centers.CenterKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON C.CenterTypeKey = CT.CenterTypeKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
			ON C.RegionKey = r.RegionKey

	WHERE DD.FullDate BETWEEN @StartDate AND @EndDate
	GROUP BY C.CenterNumber


	/*****************************************************************/

	SELECT CTR.CenterNumber AS 'Center'
	,	CTR.CenterDescriptionNumber AS 'CenterName'
	,	CT.CenterTypeDescriptionShort
	,	CASE WHEN @sType = 'F' THEN  R.RegionDescription WHEN F.CenterNumber = 100 then 'Corporate(100)' ELSE CMA.CenterManagementAreaDescription END AS 'Region' --The report has all the drill-downs pointing to Region
	,	CASE WHEN @sType = 'F' THEN  R.RegionSSID WHEN F.CenterNumber = 100 THEN 100 ELSE CMA.CenterManagementAreaSSID END  AS 'RegionID'
	,	CASE WHEN @sType = 'F' THEN  R.RegionSortOrder WHEN F.CenterNumber = 100 THEN 100 ELSE CMA.CenterManagementAreaSortOrder END  AS 'RegionSortOrder'

	,	SUM(ISNULL(F.NBcount,0)) AS 'NBCount'
	,	SUM(ISNULL(F.NBcountnet,0)) AS 'NBcountnet'
	,	SUM(ISNULL(NB_NS.NetSales, 0)) AS 'NetSales'
	,	SUM(ISNULL(F.NBsales, 0)) AS 'NBsales'
	,	CASE WHEN SUM(ISNULL(NB_NS.NetSales,0)) = 0 THEN 0 ELSE dbo.Divide(SUM(ISNULL(F.NBsales,0)), SUM(ISNULL(NB_NS.NetSales,0))) END AS 'NBsalesmix'
	,	SUM(ISNULL(F.NBrefunds, 0)) AS 'NBrefunds'
	,	CASE WHEN SUM(ISNULL(F.NBcountnet,0)) = 0 THEN 0 ELSE dbo.Divide(SUM(ISNULL(F.NBsales,0)), SUM(ISNULL(F.NBcountnet,0))) END AS 'NBnetmoney'
	,	SUM(ISNULL(EXPR.Expirations, 0)) AS 'NBexpirations'
	,	SUM(ISNULL(F.NBconversions,0)) AS 'NBconversions'
	,	CASE WHEN SUM(ISNULL(F.NBcountnet, 0)) = 0 THEN 0 ELSE dbo.Divide(SUM(ISNULL(F.NBconversions, 0)), SUM(ISNULL(F.NBcountnet,0))) END AS 'NBpcntcnv'
	,	SUM(ISNULL(F.RRsales,0)) AS 'RRSales'
	,	0 AS 'RRrefunds'
	,	SUM(ISNULL(REN.RRrenewals,0)) AS 'RRrenewals'
	,	SUM(ISNULL(CAN.RRcancels,0)) AS 'RRcancels'
	,	SUM(ISNULL(OPCP.OpenPCP, 0)) AS 'RRactive'
	,	dbo.Divide(SUM(ISNULL(REN.RRrenewals,0)), SUM(ISNULL(OPCP.OpenPCP, 0))) AS 'RRrenewrate'
	,	SUM(ISNULL(OPCP.OpenPCP,0)) AS 'OpenPCP'
	,	SUM(ISNULL(CPCP.ClosePCP,0)) AS 'ClosePCP'
	,	dbo.RetentionX(SUM(ISNULL(OPCP.OpenPCP, 0)), SUM(ISNULL(CPCP.ClosePCP, 0)), SUM(ISNULL(F.NBconversions,0))) AS 'Retention'
	,	SUM(ISNULL(F.RR_XtrServices, 0)) AS 'RR_XtrServices'
	,	SUM(ISNULL(F.UpgFromEXT, 0)) AS 'UpgFromEXT'
	,	MONTH(DATEADD(MONTH,-1,@StartDate)) AS 'MonthPCPBegin'
	,	YEAR(DATEADD(MONTH,-1,@StartDate)) AS 'YearPCPBegin'
	,	MONTH(DATEADD(MONTH,-1,@EndDate)) AS 'MonthPCPEnd'
	,	YEAR(DATEADD(MONTH,-1,@EndDate)) AS 'YearPCPEnd'

	FROM #Final F
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
			ON F.CenterNumber = C.CenterNumber
		INNER JOIN #Centers CTR
			ON CTR.CenterKey = C.CenterKey
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
			ON CT.CenterTypeKey = C.CenterTypeKey
		LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
			ON C.RegionKey = R.RegionKey
		LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
			ON CMA.CenterManagementAreaSSID = C.CenterManagementAreaSSID
		LEFT JOIN #NBNetSales NB_NS
			ON F.CenterNumber = NB_NS.CenterNumber
		LEFT JOIN #XtrExpirations EXPR
			ON F.CenterNumber = EXPR.CenterNumber
		LEFT JOIN #cancels CAN
			ON F.CenterNumber = CAN.CenterNumber
		LEFT JOIN #renewals REN
			ON F.CenterNumber = REN.CenterNumber
		LEFT JOIN #OpenPCP OPCP
			ON F.CenterNumber = OPCP.CenterNumber
		LEFT JOIN #ClosePCP CPCP
			ON F.CenterNumber = CPCP.CenterNumber
	GROUP BY CTR.CenterNumber
	,	F.CenterNumber
	,	CTR.CenterDescriptionNumber
	,	CT.CenterTypeDescriptionShort
	,	R.RegionDescription
	,	R.RegionSSID
	,	R.RegionSortOrder
	,	CMA.CenterManagementAreaDescription
	,	CMA.CenterManagementAreaSSID
	,	CMA.CenterManagementAreaSortOrder

END
GO
