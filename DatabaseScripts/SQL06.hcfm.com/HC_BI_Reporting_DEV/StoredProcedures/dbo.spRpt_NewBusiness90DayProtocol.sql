/* CreateDate: 11/04/2013 13:38:24.637 , ModifyDate: 07/14/2015 11:53:58.643 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_NewBusiness90DayProtocol
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			New Business 90 Day Protocol
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		10/22/2013
------------------------------------------------------------------------
NOTES:

12/11/2012 - MB - Reformatted query and created temp table ahead of time to prevent issue where
				  different length string data was inserted after the table is already created (WO# 82050)
01/15/2013 - MB - Added new 4th checkup and stylist columns to report (WO# 82823)
01/25/2013 - MB - Changed code for 24 hour checkup from "CKUK24" to "CKU24"
07/26/2013 - MB - Filtered out "New Client" memberships (WO# 89248)
09/09/2013 - MB - Added NB1 Removal columns (WO# 90126)
10/08/2013 - MB - Fixed data type column of Removal stylist from INT to VARCHAR (WO# 92375)
10/22/2013 - DL - Re-wrote stored procedure for SQL06 environment (WO# 91014)
11/04/2013 - RH - Removed "Show No Sale" from the list (WO# 93340) by adding "AND dbo.GetCurrentMembershipKey(CLT.ClientKey) != 110"
01/22/2014 - DL - Added SalesCode 723 (GUARANTEE) to #Clients query (#96336)
02/25/2014 - MB - Removed EXT memberships from report
07/16/2014 - RH - Removed HCFK memberships from report
08/21/2014 - RH - Added WHEN 'SVCSOL' THEN 'SERVICE' END AS 'DateCol' for new Sales Codes for women
08/28/2014 - RH - Added WHEN 'EXTMEMSVCSOL' THEN 'SERVICE' END AS 'DateCol' for new Sales Codes for women
10/03/2014 - RH - Added WHEN 'EXTSVCXTD' THEN 'SERVICE' AS 'DateCol' for new Sales Codes for Xtrands
01/09/2015 - RH - Added WHEN SalesCodeDescriptionShort in ('SAPHOH','SAPHOHP') THEN 'SERVICE' --New Women's Sales Codes (WO#109419);
					and removed 'EXTMEMSVCSOL' from this list as EXT memberships are not included in this report
07/14/2015 - RH - Added code to exclude EXT memberships generically
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_NewBusiness90DayProtocol 230, '4/1/2015', '6/30/2015'

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_NewBusiness90DayProtocol]
(
	@CenterID INT
,	@StartDate DATETIME
,	@EndDate DATETIME
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;

/********************************** Create temp table objects *************************************/
CREATE TABLE #Clients (
	RegionSSID INT
,	Region VARCHAR(255)
,	CenterSSID INT
,	Center VARCHAR(255)
,	ClientKey INT
,	Client VARCHAR(255)
,	SaleDate DATETIME
,	CurrentMembership VARCHAR(255)
,	CurrentMembershipKey INT
,	NB1AppDate DATETIME
,	NB1AppStylist VARCHAR(50)
,	RemovalDate DATETIME
,	RemovalStylist VARCHAR(50)
)

CREATE TABLE #Pivot (
	RegionSSID INT
,	Region VARCHAR(255)
,	CenterSSID INT
,	Center VARCHAR(255)
,	ClientKey INT
,	Client VARCHAR(255)
,	SaleDate DATETIME
,	EmployeeInitials VARCHAR(50)
,	CurrentMembership VARCHAR(255)
,	CurrentMembershipKey INT
,	NB1AppDate DATETIME
,	NB1AppStylist VARCHAR(50)
,	RemovalDate DATETIME
,	RemovalStylist VARCHAR(50)
,	DateCol VARCHAR(100)
,	DateColVal DATETIME
,	Ranking INT
)


/********************************** Get Client Data *************************************/
INSERT	INTO #Clients
		SELECT  DR.RegionSSID AS 'RegionSSID'
		,       DR.RegionDescription AS 'Region'
		,       DC.CenterSSID AS 'CenterSSID'
		,       DC.CenterDescriptionNumber AS 'Center'
		,		CLT.ClientKey
		,       CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'Client'
		,		MAX(DD.FullDate) AS 'SaleDate'
		,       dbo.GetCurrentMembershipDescription(CLT.ClientKey) AS 'CurrentMembership'
		,		dbo.GetCurrentMembershipKey(CLT.ClientKey) AS 'CurrentMembershipKey'
		,		NB1App.NB1AppDate
		,		NB1App.NB1AppStylist
		,		NB1Rem.RemovalDate
		,		NB1Rem.RemovalStylist
		FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
					ON FST.OrderDateKey = DD.DateKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
					ON FST.CenterKey = DC.CenterKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionKey = DR.RegionKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
					ON FST.SalesCodeKey = SC.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
					ON FST.SalesOrderKey = SO.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
					ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
					ON FST.ClientKey = CLT.ClientKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
					ON FST.ClientMembershipKey = CM.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
					ON CM.MembershipSSID = M.MembershipSSID
				LEFT OUTER JOIN (
					-- Get NB1 Application Data
					SELECT  FST.ClientKey
					,       DD.FullDate AS 'NB1AppDate'
					,		EM.EmployeeInitials AS 'NB1AppStylist'
					,       ROW_NUMBER() OVER ( PARTITION BY FST.ClientKey ORDER BY DD.FullDate DESC ) AS 'Ranking'
					FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
							INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
								ON FST.OrderDateKey = DD.DateKey
							INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
								ON FST.CenterKey = DC.CenterKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
								ON FST.SalesCodeKey = SC.SalesCodeKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
								ON FST.SalesOrderKey = SO.SalesOrderKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
								ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee EM
								ON FST.Employee2Key = EM.EmployeeKey
					WHERE   DC.CenterSSID = @CenterID
							AND SC.SalesCodeSSID = 648  --Initial Application
				) NB1App
					ON CLT.ClientKey = NB1App.ClientKey
						AND NB1App.Ranking = 1
				LEFT OUTER JOIN (
					-- Get NB1 Removal Data
					SELECT  FST.ClientKey
					,       DD.FullDate AS 'RemovalDate'
					,		EM.EmployeeInitials AS 'RemovalStylist'
					,       ROW_NUMBER() OVER ( PARTITION BY FST.ClientKey ORDER BY DD.FullDate DESC ) AS 'Ranking'
					FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
							INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
								ON FST.OrderDateKey = DD.DateKey
							INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
								ON FST.CenterKey = DC.CenterKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
								ON FST.SalesCodeKey = SC.SalesCodeKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
								ON FST.SalesOrderKey = SO.SalesOrderKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
								ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee EM
								ON FST.Employee2Key = EM.EmployeeKey
					WHERE   DC.CenterSSID = @CenterID
							AND SC.SalesCodeSSID = 399 --Removal - New Member
				) NB1Rem
					ON CLT.ClientKey = NB1Rem.ClientKey
						AND NB1Rem.Ranking = 1
		WHERE   DC.CenterSSID = @CenterID
				AND DD.FullDate BETWEEN @StartDate AND @EndDate
				AND SO.IsVoidedFlag = 0
				AND SC.SalesCodeSSID IN ( 347, 723 )
				AND	M.RevenueGroupSSID = 1
				AND M.BusinessSegmentSSID = 1
				AND dbo.GetCurrentMembershipKey(CLT.ClientKey) NOT IN (110)  --Remove "ShowNoSale"
				AND	dbo.GetCurrentMembershipKey(CLT.ClientKey) NOT IN (SELECT MembershipKey FROM HC_BI_CMS_DDS.bi_cms_dds.DimMembership
																		WHERE MembershipDescription LIKE '%EXT%') --Remove EXT memberships from the list
		GROUP BY DR.RegionSSID
		,       DR.RegionDescription
		,       DC.CenterSSID
		,       DC.CenterDescriptionNumber
		,       CLT.ClientKey
		,       CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName
		,		NB1App.NB1AppDate
		,		NB1App.NB1AppStylist
		,		NB1Rem.RemovalDate
		,		NB1Rem.RemovalStylist


/********************************** Get Checkups After NB1App Data *************************************/
INSERT	INTO #Pivot
		SELECT  C.RegionSSID
		,       C.Region
		,       C.CenterSSID
		,       C.Center
		,       C.ClientKey
		,       C.Client
		,       C.SaleDate
		,		CKU.CheckupStylist
		,       C.CurrentMembership
		,       C.CurrentMembershipKey
		,       C.NB1AppDate
		,       C.NB1AppStylist
		,       C.RemovalDate
		,       C.RemovalStylist
		,		'CHECKUP' AS 'DateCol'
		,		CKU.CheckupDate AS 'DateColVal'
		,		CKU.Ranking
		FROM	#Clients C
				LEFT OUTER JOIN (
					-- Get Checkup Data
					SELECT  FST.ClientKey
					,       DD.FullDate AS 'CheckupDate'
					,		EM.EmployeeInitials AS 'CheckupStylist'
					,       ROW_NUMBER() OVER ( PARTITION BY FST.ClientKey ORDER BY DD.FullDate ASC ) AS 'Ranking'
					FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
							INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
								ON FST.OrderDateKey = DD.DateKey
							INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
								ON FST.CenterKey = DC.CenterKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
								ON FST.SalesCodeKey = SC.SalesCodeKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
								ON FST.SalesOrderKey = SO.SalesOrderKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
								ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee EM
								ON FST.Employee2Key = EM.EmployeeKey
					WHERE   DC.CenterSSID = @CenterID
							AND SC.SalesCodeSSID = 389 --Checkup - New Member
				) CKU
					ON C.ClientKey = CKU.ClientKey
						AND CKU.CheckupDate > C.NB1AppDate

/********************************** Get Checkup Data *************************************/
INSERT	INTO #Pivot
		SELECT  C.RegionSSID
		,       C.Region
		,       C.CenterSSID
		,       C.Center
		,       C.ClientKey
		,       C.Client
		,       C.SaleDate
		,		EM.EmployeeInitials
		,       C.CurrentMembership
		,       C.CurrentMembershipKey
		,       C.NB1AppDate
		,       C.NB1AppStylist
		,       C.RemovalDate
		,       C.RemovalStylist
		,		CASE SC.SalesCodeDescriptionShort
					WHEN 'CKUPRE' THEN 'PRECHECK'
					WHEN 'CKU24' THEN 'CHECK24'
					WHEN 'SVC' THEN 'SERVICE'
					WHEN 'SVCPCP' THEN 'SERVICE'
					WHEN 'SVCSOL' THEN 'SERVICE'		--Added 08/21/2014 RH
					--WHEN 'EXTMEMSVCSOL' THEN 'SERVICE'  --Added 08/28/2014 RH
					WHEN 'EXTSVCXTD' THEN 'SERVICE'		--Added 10/03/2014 RH
					WHEN 'SAPHOH' THEN 'SERVICE'		--Added 01/09/2015 RH
					WHEN 'SAPHOHP' THEN 'SERVICE'		--Added 01/09/2015 RH
				END AS 'DateCol'
		,		DD.FullDate AS 'DateColVal'
		,		ROW_NUMBER() OVER(PARTITION BY C.ClientKey, SC.SalesCodeDescriptionShort ORDER BY DD.FullDate ASC) AS 'Ranking'
		FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
					ON FST.OrderDateKey = DD.DateKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
					ON FST.SalesCodeKey = SC.SalesCodeKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
					ON FST.SalesOrderKey = SO.SalesOrderKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
					ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee EM
					ON FST.Employee2Key = EM.EmployeeKey
				INNER JOIN #Clients C
					ON FST.ClientKey = C.ClientKey
		WHERE	SC.SalesCodeSSID IN ( 407, 667, 711, 727, 728, 782, 788 )


			/*407 Full Service - New Member
			667	Checkup - Membership
			711	Full Service - Membership
			727	Checkup - 24 Hour
			728	Checkup - Pre Check
			782	Full Service Solutions
			788	EXT Service - Xtrands
			*/


/********************************** Display Data *************************************/
SELECT	RegionSSID
,		Region
,		CenterSSID
,		Center
,		ClientKey
,		Client
,		CONVERT(VARCHAR, SaleDate, 101) AS 'SaleDate'
,		CurrentMembership
,		CurrentMembershipKey
,		CONVERT(VARCHAR, MIN(CASE DateCol WHEN 'PRECHECK' THEN DateColVal ELSE NULL END), 101) AS 'PreCheckDate'
,		MAX(CASE DateCol WHEN 'PRECHECK' THEN EmployeeInitials ELSE '' END) AS 'PreCheckStylist'
,		CONVERT(VARCHAR, MAX(CASE DateCol WHEN 'CHECK24' THEN DateColVal ELSE NULL END), 101) AS 'Check24Date'
,		MAX(CASE DateCol WHEN 'CHECK24' THEN EmployeeInitials ELSE '' END) AS 'Check24Stylist'
,		CONVERT(VARCHAR, NB1AppDate, 101) AS 'NB1AppDate'
,		NB1AppStylist
,		CONVERT(VARCHAR, MAX(CASE WHEN DateCol = 'CHECKUP' AND Ranking = 1 THEN DateColVal ELSE NULL END), 101) AS 'Check1Date'
,		MAX(CASE WHEN DateCol = 'CHECKUP' AND Ranking = 1 THEN EmployeeInitials ELSE '' END) AS 'Check1Stylist'
,		CONVERT(VARCHAR, MAX(CASE WHEN DateCol = 'CHECKUP' AND Ranking = 2 THEN DateColVal ELSE NULL END), 101) AS 'Check2Date'
,		MAX(CASE WHEN DateCol = 'CHECKUP' AND Ranking = 2 THEN EmployeeInitials ELSE '' END) AS 'Check2Stylist'
,		CONVERT(VARCHAR, MAX(CASE WHEN DateCol = 'CHECKUP' AND Ranking = 3 THEN DateColVal ELSE NULL END), 101) AS 'Check3Date'
,		MAX(CASE WHEN DateCol = 'CHECKUP' AND Ranking = 3 THEN EmployeeInitials ELSE '' END) AS 'Check3Stylist'
,		CONVERT(VARCHAR, MAX(CASE WHEN DateCol = 'CHECKUP' AND Ranking = 4 THEN DateColVal ELSE NULL END), 101) AS 'Check4Date'
,		MAX(CASE WHEN DateCol = 'CHECKUP' AND Ranking = 4 THEN EmployeeInitials ELSE '' END) AS 'Check4Stylist'
,		CONVERT(VARCHAR, MAX(CASE WHEN DateCol = 'SERVICE' AND Ranking = 1 THEN DateColVal ELSE NULL END), 101) AS 'Service1Date'
,		MAX(CASE WHEN DateCol = 'SERVICE' AND Ranking = 1 THEN EmployeeInitials ELSE '' END) AS 'Service1Stylist'
,		CONVERT(VARCHAR, MAX(CASE WHEN DateCol = 'SERVICE' AND Ranking = 2 THEN DateColVal ELSE NULL END), 101) AS 'Service2Date'
,		MAX(CASE WHEN DateCol = 'SERVICE' AND Ranking = 2 THEN EmployeeInitials ELSE '' END) AS 'Service2Stylist'
,		CONVERT(VARCHAR, MAX(CASE WHEN DateCol = 'SERVICE' AND Ranking = 3 THEN DateColVal ELSE NULL END), 101) AS 'Service3Date'
,		MAX(CASE WHEN DateCol = 'SERVICE' AND Ranking = 3 THEN EmployeeInitials ELSE '' END) AS 'Service3Stylist'
,		CONVERT(VARCHAR, RemovalDate, 101) AS 'RemovalDate'
,		RemovalStylist
FROM	#Pivot P
GROUP BY RegionSSID
,		Region
,		CenterSSID
,		Center
,		ClientKey
,		Client
,		SaleDate
,		CurrentMembership
,		CurrentMembershipKey
,		NB1AppDate
,		NB1AppStylist
,		RemovalDate
,		RemovalStylist
ORDER BY Client

END
GO
