/* CreateDate: 10/15/2013 14:03:10.387 , ModifyDate: 01/06/2019 21:17:29.717 */
GO
/***********************************************************************
PROCEDURE:				spRpt_FlashNewBusinessDetails
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			NB1 Flash Details
AUTHOR:					Marlon Burrell
IMPLEMENTOR:			Marlon Burrell
DATE IMPLEMENTED:
------------------------------------------------------------------------
NOTES: @Filter = 1 is By Regions, 2 is Area Managers, 3 is By Centers
------------------------------------------------------------------------
CHANGE HISTORY:
12/26/2012 - MB - Changed query so that surgery monies go to appropriate center
01/22/2013 - MB - Changed query to bring back contract price for some drilldowns (WO# 82649)
02/22/2013 - KM - Modified Group by to by Sales Code - Member1
03/05/2013 - KM - Modified Group by to be by Member1 only
04/08/2013 - KM - Modified ClientNo to be ClientIdentifer rather than ClientKey
05/22/2013 - MB - Added filter for IsVoidedFlag
06/04/2013 - MB - Added InvoiceNumber and SalesOrderDetailKey to output (WO# 87259)
06/13/2013 - KM - (#86761) Modified select to derive membership from SOD rather than SO for SC = 'CANCEL'
06/13/2013 - KM - (#86761) Modified quantity for INITASG Surgery Sales to be 1 rather than Graft Count (found in testing)
10/08/2013 - DL - (#89184) Added Group By Region/RSM filter
10/15/2013 - DL - (#89184) Added @Filter procedure parameter
10/15/2013 - DL - (#89184) Added additional RSM roll-up filters
10/19/2013 - DL - Removed the following line from the procedure: SET @enddt = @enddt + ' 23:59:59'
01/27/2014 - DL - (#94826) Added additional query to determine Applications using Transaction Center.
04/07/2014 - RH - (#100145) Changed WHERE DR.RegionSSID = @CenterSSID to WHERE DC.RegionSSID = @CenterSSID (under Region code for #Center)
05/03/2014 - RH - (#102515) Added @type 32 = Xtrands # and 33 = Xtrands $; Added NB_XtrCnt and NB_XtrAmt to the fields and the totals for NB_NetNBCnt and NB_NetNBAmt.
04/21/2015 - RH - (Kevin) Changed prevm. to m. in code to find Member1 to remove 'Unknown' in the report.
01/04/2016 - RH - (#120705) Changed groupings to include by Area Managers and by Centers; (Franchise is only by Region)
04/27/2016 - RH - (#125714) Changed to Home-center based (CM.CenterSSID) for Applications - to match the NB Flash Summary and the NB Warboard
08/04/2016 - DL - (#126571) Added Laser Therapy column query for #Net Sales count drilldown
10/10/2016 - RH - (#123213) Added CM.MembershipCancelReasonDescription from datClientMembership synonym; Changed to MembershipKey
01/05/2017 - RH - (#132688) Changed EmployeeKey to CenterManagementAreaSSID; Added @Filter
01/18/2017 - RH - (#132688) Added CenterManagementAreaSSID,CenterManagementAreaDescription to #Output
04/14/2017 - RH - (#137105) Changed logic for finding Area centers to use DimCenterManagementArea
08/07/2017 - RH - (#141865) (For @type = 8) Changed Qty to S_SurCnt for "Surgery #" and Qty to "Grafts"
01/11/2018 - RH - (#145957) Added join on CenterType and removed Corporate Regions
06/18/2018 - RH - Added Hans Wiemannn CT.CenterTypeDescriptionShort IN('C','HW')
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_FlashNewBusinessDetails 6, 22,	'6/1/2018', '6/30/2018', 2
EXEC spRpt_FlashNewBusinessDetails 11, 17,	'6/1/2018', '6/30/2018', 2
EXEC spRpt_FlashNewBusinessDetails 804, 18,	'6/1/2018', '6/30/2018', 3
EXEC spRpt_FlashNewBusinessDetails 355, 10,	'5/1/2018', '6/30/2018', 3
***********************************************************************/
--THIS DETAIL STORED PROC/REPORT IS ALSO USED BY THE REPORT: KPI SUMMARY

CREATE PROCEDURE [dbo].[xxxspRpt_FlashNewBusinessDetails]
(
	@center NVARCHAR(20)  --May be CenterType
,	@type INT
,	@begdt DATETIME
,	@enddt DATETIME
,	@Filter INT
)
AS
BEGIN

   /*
	  @Type = Flash Heading

	  1 = Total NB1 Gross #
	  2 = Traditional #
	  3 = Traditional $
	  4 = Gradual #
	  5 = Gradual $
	  6 = Extreme #
	  7 = Extreme $
	  8 = Surgery #
	  9 = Surgery $
	  10 = Applications
	  11 = Conversions (Excludes EXT Conversions)
	  32 = Xtrands #
	  33 = Xtrands $
	  16 = Post Ext #
	  17 = Total NB1 Net #
	  18 = Total NB1 Net $
	  19 = Post Ext $
   */


/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	CenterID INT
	,	CenterNumber INT
)

CREATE TABLE #Output (
	center INT
,	center_name VARCHAR(60)
,	Region VARCHAR(60)
,	CenterManagementAreaSSID INT
,	CenterManagementAreaDescription NVARCHAR(50)
,	ClientKey INT
,	client_no VARCHAR(50)
,	last_name VARCHAR(50)
,	first_name VARCHAR(50)
,	transact_No VARCHAR(20)
,	ticket_No VARCHAR(50)
,	[date] SMALLDATETIME
,	code VARCHAR(50)
,	[description] VARCHAR(60)
,	qty INT
,	price MONEY
,	tax_1 MONEY
,	tax_2 MONEY
,	performer VARCHAR(50)
,	CancelReasonDescription VARCHAR(MAX)
,	Department VARCHAR(50)
,	performer2 VARCHAR(50)
,	Voided VARCHAR(10)
,	Member1 VARCHAR(50) --Changed to 50 from 40 for MembershipDescription 05/01/2018 RH
,	ClientMembershipKey INT
,	NB_GrossNB1Cnt INT
,	NB_TradCnt INT
,	NB_TradAmt INT
,	NB_GradCnt INT
,	NB_GradAmt INT
,	NB_ExtCnt INT
,	NB_ExtAmt INT
,	NB_XtrCnt INT
,	NB_XtrAmt INT
,	S_SurCnt INT
,	S_SurAmt INT
,	S_PostExtCnt INT
,	S_PostExtAmt INT
,	NB_AppsCnt INT
,	NB_BIOConvCnt INT
,	NB_NetNBCnt INT
,	NB_NetNBAmt INT
)


/********************************** Get list of centers *************************************/
IF @Filter = 1										-- A Franchise Region has been selected.
	BEGIN
		INSERT INTO #Centers
		SELECT DISTINCT
				DC.CenterSSID
				,	DC.CenterNumber
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
					ON DC.RegionSSID = DR.RegionSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
		WHERE   DC.RegionSSID = @Center
				AND DC.Active = 'Y'
				AND CT.CenterTypeDescriptionShort IN ('F','JV')
	END
ELSE
	IF @Filter = 2									-- An Area Manager has been selected
	BEGIN
		INSERT INTO #Centers
		SELECT DISTINCT DC.CenterSSID
		,	DC.CenterNumber
		FROM   HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON CT.CenterTypeKey = DC.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
					ON DC.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
		WHERE   CMA.CenterManagementAreaSSID = @Center
				AND CMA.Active = 'Y'
				AND CT.CenterTypeDescriptionShort IN('C','HW')
	END
ELSE
IF @Filter = 3 									-- A Center has been selected.
	BEGIN
		INSERT INTO #Centers
		SELECT DISTINCT
				DC.CenterSSID
				,	DC.CenterNumber
		FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
		WHERE   DC.CenterNumber = @Center
				AND DC.Active = 'Y'

	END



/******************************************************************************************/

IF @Type=10
BEGIN
	INSERT  INTO #Output
			SELECT  C.CenterNumber AS 'center'
			,       C.CenterDescription AS 'center_name'
			,       R.RegionDescription AS 'Region'
			,		CMA.CenterManagementAreaSSID
			,		CMA.CenterManagementAreaDescription
			,		CLT.ClientKey
			,       CLT.ClientIdentifier AS 'client_no'
			,       CLT.ClientLastName AS 'last_name'
			,       CLT.ClientFirstName AS 'first_name'
			,       CASE WHEN sod.TransactionNumber_Temp = -1 THEN CONVERT(VARCHAR, sod.SalesOrderDetailKey)
						 ELSE CONVERT(VARCHAR, sod.TransactionNumber_Temp)
					END AS 'Transact_No'
			,       CASE WHEN so.TicketNumber_Temp = 0 THEN CONVERT(VARCHAR, SO.InvoiceNumber)
						 ELSE CONVERT(VARCHAR, so.TicketNumber_Temp)
					END AS 'Ticket_No'
			,       DD.FullDate AS 'date'
			,       SC.SalesCodeDescriptionShort AS 'code'
			,       sc.SalesCodeDescription AS 'description'
			,       CASE WHEN SC.SalesCodeDescriptionShort = 'CANCEL' THEN -1
						 WHEN m.BusinessSegmentSSID = 3
							  AND SC.Salescodedepartmentssid = 1010 THEN 1
						 ELSE FST.Quantity
					END AS 'qty'
			,       CASE WHEN @Type IN ( 1, 2, 4, 6, 17 ) THEN DCM.ClientMembershipContractPrice
						 ELSE FST.ExtendedPrice
					END AS 'price'
			,       FST.Tax1 AS 'tax_1'
			,       FST.Tax2 AS 'tax_2'
			,       E.EmployeeInitials AS 'performer'
			,       CASE WHEN sc.SalesCodeDescriptionShort = 'CANCEL' THEN CM.MembershipCancelReasonDescription ELSE NULL END AS 'CancelReasonDescription'
			,       sc.SalesCodeDepartmentSSID AS 'Department'
			,       E2.EmployeeInitials AS 'performer2'
			,       CASE WHEN ISNULL(SO.IsVoidedFlag, 0) = 1 THEN 'v'
						 ELSE ''
					END AS 'Voided'
			,       CASE WHEN so.IsGuaranteeFlag = 1
							  AND sc.SalesCodeDescriptionShort = 'CANCEL' THEN m.MembershipDescription  ----RH - 04/21/2015
						 ELSE M.MembershipDescription
					END AS 'Member1'
			,		DCM.ClientMembershipKey
			,       ISNULL(FST.NB_GrossNB1Cnt, 0) AS 'NB_GrossNB1Cnt'
			,       ISNULL(FST.NB_TradCnt, 0) AS 'NB_TradCnt'
			,       ISNULL(FST.NB_TradAmt, 0) AS 'NB_TradAmt'
			,       ISNULL(FST.NB_GradCnt, 0) AS 'NB_GradCnt'
			,       ISNULL(FST.NB_GradAmt, 0) AS 'NB_GradAmt'
			,       ISNULL(FST.NB_ExtCnt, 0) AS 'NB_ExtCnt'
			,       ISNULL(FST.NB_ExtAmt, 0) AS 'NB_ExtAmt'
			,       ISNULL(FST.NB_XtrCnt, 0) AS 'NB_XtrCnt'
			,       ISNULL(FST.NB_XtrAmt, 0) AS 'NB_XtrAmt'
			,       ISNULL(FST.S_SurCnt, 0) AS 'S_SurCnt'
			,       ISNULL(FST.S_SurAmt, 0) AS 'S_SurAmt'
			,       ISNULL(FST.S_PostExtCnt, 0) AS 'S_PostExtCnt'
			,       ISNULL(FST.S_PostExtAmt, 0) AS 'S_PostExtAmt'
			,       ISNULL(FST.NB_AppsCnt, 0) AS 'NB_AppsCnt'
			,       ISNULL(FST.NB_BIOConvCnt, 0) AS 'NB_BIOConvCnt'
			,       ( ISNULL(FST.NB_TradCnt, 0) + ISNULL(FST.NB_GradCnt, 0) + ISNULL(FST.NB_ExtCnt, 0) + ISNULL(FST.NB_XtrCnt, 0) + ISNULL(FST.S_SurCnt, 0) + ISNULL(FST.S_PostExtCnt, 0) ) AS 'NB_NetNBCnt'
			,       ( ISNULL(FST.NB_TradAmt, 0) + ISNULL(FST.NB_GradAmt, 0) + ISNULL(FST.NB_ExtAmt, 0) + ISNULL(FST.NB_XtrAmt, 0) + ISNULL(FST.S_SurAmt, 0) + ISNULL(FST.S_PostExtAmt, 0) ) AS 'NB_NetNBAmt'
			FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON FST.OrderDateKey = dd.DateKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
						ON fst.SalesCodeKey = sc.SalesCodeKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
						ON FST.ClientKey = CLT.ClientKey
					LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
						ON FST.Employee1Key = E.EmployeeKey
					LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E2
						ON FST.Employee2Key = E2.EmployeeKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
						ON FST.SalesOrderKey = SO.SalesOrderKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
						ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
						ON SO.ClientMembershipKey = DCM.ClientMembershipKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
						ON DCM.MembershipKey = m.MembershipKey   ---Changed to MembershipKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
						--ON FST.CenterKey = c.CenterKey  --Keep Home-Center based to match the summary
						ON DCM.CenterKey = C.CenterKey
					LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
						ON C.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON C.CenterTypeKey = CT.CenterTypeKey
					INNER JOIN #Centers
						ON C.CenterNumber = #Centers.CenterNumber
					LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
						ON R.RegionKey = C.RegionKey
					LEFT JOIN HC_BI_Reporting.dbo.DimCancelReason cr
						ON cr.CancelReasonID = sod.CancelReasonID
					LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership prevcm
						ON SOD.PreviousClientMembershipSSID = prevcm.ClientMembershipSSID
					LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership prevm
						ON prevcm.MembershipSSID = prevm.MembershipSSID
					LEFT OUTER JOIN [dbo].[synHairclubCMS_datClientMembership] CM
						ON CM.ClientMembershipGUID = DCM.ClientMembershipSSID
			WHERE   DD.FullDate BETWEEN @BegDt AND @EndDt
					AND SC.SalesCodeKey NOT IN (665, 654, 393, 668)
					AND SO.IsVoidedFlag = 0
END
ELSE
BEGIN
	INSERT  INTO #Output
			SELECT  C.CenterNumber AS 'center'
			,       C.CenterDescription AS 'center_name'
			,       R.RegionDescription AS 'Region'
			,		CMA.CenterManagementAreaSSID
			,		CMA.CenterManagementAreaDescription
			,		CLT.ClientKey
			,       CLT.ClientIdentifier AS 'client_no'
			,       CLT.ClientLastName AS 'last_name'
			,       CLT.ClientFirstName AS 'first_name'
			,       CASE WHEN sod.TransactionNumber_Temp = -1 THEN CONVERT(VARCHAR, sod.SalesOrderDetailKey)
						 ELSE CONVERT(VARCHAR, sod.TransactionNumber_Temp)
					END AS 'Transact_No'
			,       CASE WHEN so.TicketNumber_Temp = 0 THEN CONVERT(VARCHAR, SO.InvoiceNumber)
						 ELSE CONVERT(VARCHAR, so.TicketNumber_Temp)
					END AS 'Ticket_No'
			,       DD.FullDate AS 'date'
			,       SC.SalesCodeDescriptionShort AS 'code'
			,       sc.SalesCodeDescription AS 'description'
			,       CASE WHEN SC.SalesCodeDescriptionShort = 'CANCEL' THEN -1
						 WHEN m.BusinessSegmentSSID = 3
							  AND SC.Salescodedepartmentssid = 1010 THEN 1
						 ELSE FST.Quantity
					END AS 'qty'
			,       CASE WHEN @Type IN ( 1, 2, 4, 6, 17 ) THEN DCM.ClientMembershipContractPrice
						 ELSE FST.ExtendedPrice
					END AS 'price'
			,       FST.Tax1 AS 'tax_1'
			,       FST.Tax2 AS 'tax_2'
			,       E.EmployeeInitials AS 'performer'
			,       CASE WHEN sc.SalesCodeDescriptionShort = 'CANCEL' THEN CM.MembershipCancelReasonDescription ELSE NULL END AS 'CancelReasonDescription'

			,       sc.SalesCodeDepartmentSSID AS 'Department'
			,       E2.EmployeeInitials AS 'performer2'
			,       CASE WHEN ISNULL(SO.IsVoidedFlag, 0) = 1 THEN 'v'
						 ELSE ''
					END AS 'Voided'
			,       CASE WHEN so.IsGuaranteeFlag = 1
							  AND sc.SalesCodeDescriptionShort = 'CANCEL' THEN m.MembershipDescription  --RH - 04/21/2015
						 ELSE M.MembershipDescription
					END AS 'Member1'
			,		DCM.ClientMembershipKey
			,       ISNULL(FST.NB_GrossNB1Cnt, 0) AS 'NB_GrossNB1Cnt'
			,       ISNULL(FST.NB_TradCnt, 0) AS 'NB_TradCnt'
			,       ISNULL(FST.NB_TradAmt, 0) AS 'NB_TradAmt'
			,       ISNULL(FST.NB_GradCnt, 0) AS 'NB_GradCnt'
			,       ISNULL(FST.NB_GradAmt, 0) AS 'NB_GradAmt'
			,       ISNULL(FST.NB_ExtCnt, 0) AS 'NB_ExtCnt'
			,       ISNULL(FST.NB_ExtAmt, 0) AS 'NB_ExtAmt'
			,       ISNULL(FST.NB_XtrCnt, 0) AS 'NB_XtrCnt'
			,       ISNULL(FST.NB_XtrAmt, 0) AS 'NB_XtrAmt'
			,       ISNULL(FST.S_SurCnt, 0) AS 'S_SurCnt'
			,       ISNULL(FST.S_SurAmt, 0) AS 'S_SurAmt'
			,       ISNULL(FST.S_PostExtCnt, 0) AS 'S_PostExtCnt'
			,       ISNULL(FST.S_PostExtAmt, 0) AS 'S_PostExtAmt'
			,       ISNULL(FST.NB_AppsCnt, 0) AS 'NB_AppsCnt'
			,       ISNULL(FST.NB_BIOConvCnt, 0) AS 'NB_BIOConvCnt'
			,       ( ISNULL(FST.NB_TradCnt, 0) + ISNULL(FST.NB_GradCnt, 0) + ISNULL(FST.NB_ExtCnt, 0) + ISNULL(FST.NB_XtrCnt, 0) + ISNULL(FST.S_SurCnt, 0) + ISNULL(FST.S_PostExtCnt, 0) ) AS 'NB_NetNBCnt'
			,       ( ISNULL(FST.NB_TradAmt, 0) + ISNULL(FST.NB_GradAmt, 0) + ISNULL(FST.NB_ExtAmt, 0) + ISNULL(FST.NB_XtrAmt, 0) + ISNULL(FST.S_SurAmt, 0) + ISNULL(FST.S_PostExtAmt, 0) ) AS 'NB_NetNBAmt'
			FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
					INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
						ON FST.OrderDateKey = dd.DateKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
						ON fst.SalesCodeKey = sc.SalesCodeKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
						ON FST.ClientKey = CLT.ClientKey
					LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
						ON FST.Employee1Key = E.EmployeeKey
					LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E2
						ON FST.Employee2Key = E2.EmployeeKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
						ON FST.SalesOrderKey = SO.SalesOrderKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
						ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
						ON SO.ClientMembershipKey = DCM.ClientMembershipKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
						ON DCM.MembershipKey = m.MembershipKey			--Changed to MembershipKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
						ON DCM.CenterKey = C.CenterKey
					LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
						ON R.RegionKey = C.RegionKey
					LEFT JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
						ON C.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON C.CenterTypeKey = CT.CenterTypeKey
					INNER JOIN #Centers
						ON C.CenterNumber = #Centers.CenterNumber
					LEFT JOIN HC_BI_Reporting.dbo.DimCancelReason cr
						ON cr.CancelReasonID = sod.CancelReasonID
					LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership prevcm
						ON SOD.PreviousClientMembershipSSID = prevcm.ClientMembershipSSID
					LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership prevm
						ON prevcm.MembershipSSID = prevm.MembershipSSID
					LEFT OUTER JOIN [dbo].[synHairclubCMS_datClientMembership] CM
						ON CM.ClientMembershipGUID = DCM.ClientMembershipSSID
			WHERE   DD.FullDate BETWEEN @BegDt AND @EndDt
					AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668)
					AND SO.IsVoidedFlag = 0
					--ADDED BELOW
					AND (ISNULL(FST.NB_TradCnt, 0) <> 0
						OR ISNULL(FST.NB_GradCnt, 0) <> 0
						OR ISNULL(FST.NB_ExtCnt, 0) <> 0
						OR ISNULL(FST.NB_XtrCnt, 0) <> 0
						OR ISNULL(FST.S_SurCnt, 0) <> 0
						OR ISNULL(FST.S_PostExtCnt, 0) <> 0

						OR ISNULL(FST.NB_TradAmt, 0) <> 0
						OR ISNULL(FST.NB_GradAmt, 0) <> 0
						OR ISNULL(FST.NB_ExtAmt, 0) <> 0
						OR ISNULL(FST.NB_XtrAmt, 0) <> 0
						OR ISNULL(FST.S_SurAmt, 0) <> 0
						OR ISNULL(FST.S_PostExtAmt, 0) <> 0
						)    --ADDED THIS -- 6/19/2018 - RH
			ORDER BY R.RegionSSID
			,       C.ReportingCenterSSID
			,       CLT.ClientKey
END


	IF @Type=1 --Total NB1 Gross #
		BEGIN
			SELECT center,center_name,Region,CenterManagementAreaSSID,CenterManagementAreaDescription,client_no,last_name,first_name,transact_no,ticket_no,[date],code,[description],NB_GrossNB1Cnt as 'qty',NULL AS 'grafts',price,tax_1,tax_2,performer,CancelReasonDescription,Department,performer2,Voided,Member1
			,  	  Member1  AS 'GroupBy'
			,	'' AS 'LaserTherapy'
			FROM #Output
			WHERE NB_GrossNB1Cnt<>0
		END
	ELSE IF @Type=2 --Traditional #
		BEGIN
			SELECT center,center_name,Region,CenterManagementAreaSSID,CenterManagementAreaDescription,client_no,last_name,first_name,transact_no,ticket_no,[date],code,[description],qty,NULL AS 'grafts',price,tax_1,tax_2,performer,CancelReasonDescription,Department,performer2,Voided,Member1
			,	 Member1  AS 'GroupBy'
			,	'' AS 'LaserTherapy'
			FROM #Output
			WHERE NB_TradCnt<>0
		END
	ELSE IF @Type=3 --Traditional $
		BEGIN
			SELECT center,center_name,Region,client_no,last_name,first_name,transact_no,ticket_no,[date],code,[description],qty,NULL AS 'grafts',price,tax_1,tax_2,performer,CancelReasonDescription,Department,performer2,Voided,Member1
			,	 Member1  AS 'GroupBy'
			,	'' AS 'LaserTherapy'
			FROM #Output
			WHERE NB_TradAmt<>0
		END
	ELSE IF @Type=4 --Gradual #
		BEGIN
			SELECT center,center_name,Region,CenterManagementAreaSSID,CenterManagementAreaDescription,client_no,last_name,first_name,transact_no,ticket_no,[date],code,[description],qty,NULL AS 'grafts',price,tax_1,tax_2,performer,CancelReasonDescription,Department,performer2,Voided,Member1
			,	 Member1  AS 'GroupBy'
			,	'' AS 'LaserTherapy'
			FROM #Output
			WHERE NB_GradCnt<>0
		END
	ELSE IF @Type=5 --Gradual $
		BEGIN
			SELECT center,center_name,Region,CenterManagementAreaSSID,CenterManagementAreaDescription,client_no,last_name,first_name,transact_no,ticket_no,[date],code,[description],qty,NULL AS 'grafts',price,tax_1,tax_2,performer,CancelReasonDescription,Department,performer2,Voided,Member1
			,	Member1  AS 'GroupBy'
			,	'' AS 'LaserTherapy'
			FROM #Output
			WHERE NB_GradAmt<>0
		END
	ELSE IF @Type=6 --Extreme #
		BEGIN
			SELECT center,center_name,Region,CenterManagementAreaSSID,CenterManagementAreaDescription,client_no,last_name,first_name,transact_no,ticket_no,[date],code,[description],qty,NULL AS 'grafts',price,tax_1,tax_2,performer,CancelReasonDescription,Department,performer2,Voided,Member1
			,	Member1  AS 'GroupBy'
			,	'' AS 'LaserTherapy'
			FROM #Output
			WHERE NB_ExtCnt<>0
		END
	ELSE IF @Type=7 --Extreme $
		BEGIN
			SELECT center,center_name,Region,CenterManagementAreaSSID,CenterManagementAreaDescription,client_no,last_name,first_name,transact_no,ticket_no,[date],code,[description],qty,NULL AS 'grafts',price,tax_1,tax_2,performer,CancelReasonDescription,Department,performer2,Voided,Member1
			,	Member1 AS 'GroupBy'
			,	'' AS 'LaserTherapy'
			FROM #Output
			WHERE NB_ExtAmt<>0
		END
	ELSE IF @Type=8 --Surgery #
		BEGIN
			SELECT center,center_name,Region,CenterManagementAreaSSID,CenterManagementAreaDescription,client_no,last_name,first_name,transact_no,ticket_no,[date],code,[description],S_SurCnt AS 'qty',qty AS 'grafts',price,tax_1,tax_2,performer,CancelReasonDescription,Department,performer2,Voided,Member1
			,	Member1  AS 'GroupBy'
			,	'' AS 'LaserTherapy'
			FROM #Output
			WHERE S_SurCnt<>0
		END
	ELSE IF @Type=9 --Surgery $
		BEGIN
			SELECT center,center_name,Region,CenterManagementAreaSSID,CenterManagementAreaDescription,client_no,last_name,first_name,transact_no,ticket_no,[date],code,[description],S_SurCnt AS 'qty',qty AS 'grafts',price,tax_1,tax_2,performer,CancelReasonDescription,Department,performer2,Voided,Member1
			,	Member1  AS 'GroupBy'
			,	'' AS 'LaserTherapy'
			FROM #Output
			WHERE S_SurAmt<>0
		END
	ELSE IF @Type=10 --Applications
		BEGIN
			SELECT center,center_name,Region,CenterManagementAreaSSID,CenterManagementAreaDescription,client_no,last_name,first_name,transact_no,ticket_no,[date],code,[description],qty,NULL AS 'grafts',price,tax_1,tax_2,performer,CancelReasonDescription,Department,performer2,Voided,Member1
			,	Member1 AS 'GroupBy'
			,	'' AS 'LaserTherapy'
			FROM #Output
			WHERE NB_AppsCnt<>0
		END
	ELSE IF @Type=11 --Conversions (Excludes EXT Conversions)
		BEGIN
			SELECT center,center_name,Region,CenterManagementAreaSSID,CenterManagementAreaDescription,client_no,last_name,first_name,transact_no,ticket_no,[date],code,[description],qty,NULL AS 'grafts',price,tax_1,tax_2,performer,CancelReasonDescription,Department,performer2,Voided,Member1
			,	Member1 AS 'GroupBy'
			,	'' AS 'LaserTherapy'
			FROM #Output
			WHERE NB_BIOConvCnt<>0
		END
	ELSE IF @Type=32 --Xtrands #
		BEGIN
			SELECT center,center_name,Region,CenterManagementAreaSSID,CenterManagementAreaDescription,client_no,last_name,first_name,transact_no,ticket_no,[date],code,[description],qty,NULL AS 'grafts',price,tax_1,tax_2,performer,CancelReasonDescription,Department,performer2,Voided,Member1
			,	Member1 AS 'GroupBy'
			,	'' AS 'LaserTherapy'
			FROM #Output
			WHERE NB_XtrCnt<>0
		END
	ELSE IF @Type=33 --Xtrands $
		BEGIN
			SELECT center,center_name,Region,CenterManagementAreaSSID,CenterManagementAreaDescription,client_no,last_name,first_name,transact_no,ticket_no,[date],code,[description],qty,NULL AS 'grafts',price,tax_1,tax_2,performer,CancelReasonDescription,Department,performer2,Voided,Member1
			,	Member1 AS 'GroupBy'
			,	'' AS 'LaserTherapy'
			FROM #Output
			WHERE NB_XtrAmt<>0
		END

	ELSE IF @Type=16 --Post Ext #
		BEGIN
			SELECT center,center_name,Region,CenterManagementAreaSSID,CenterManagementAreaDescription,client_no,last_name,first_name,transact_no,ticket_no,[date],code,[description],qty,NULL AS 'grafts',price,tax_1,tax_2,performer,CancelReasonDescription,Department,performer2,Voided,Member1
			,	Member1 AS 'GroupBy'
			,	'' AS 'LaserTherapy'
			FROM #Output
			WHERE S_PostExtCnt<>0
		END
	ELSE IF @Type=17 --Total NB1 Net #
		BEGIN
            SELECT  O.center
            ,       O.center_name
            ,       O.Region
			,		O.CenterManagementAreaSSID
			,		O.CenterManagementAreaDescription
            ,       O.client_no
            ,       O.last_name
            ,       O.first_name
            ,       O.transact_no
            ,       O.ticket_no
            ,       O.[date]
            ,       O.code
            ,       O.[description]
            ,       O.qty
			,		NULL AS 'grafts'
            ,       O.price
            ,       O.tax_1
            ,       O.tax_2
            ,       O.performer
            ,       O.CancelReasonDescription
            ,       O.Department
            ,       O.performer2
            ,       O.Voided
            ,       O.Member1
            ,       O.Member1 AS 'GroupBy'
			,		ISNULL(o_LSR.SalesCodeDescription, '') AS 'LaserTherapy'
            FROM    #Output O
                    OUTER APPLY (
								  -- Get Laser Device sales
                                  SELECT    TOP 1
											FST.ClientKey
                                  ,         DCM.ClientMembershipKey
                                  ,         DSC.SalesCodeDescriptionShort
                                  ,         REPLACE(DSC.SalesCodeDescription, ' Payment', '') AS 'SalesCodeDescription'
                                  FROM      HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST WITH ( NOLOCK )
                                            INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD WITH ( NOLOCK )
                                                ON FST.OrderDateKey = DD.DateKey
                                            INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC WITH ( NOLOCK )
                                                ON FST.SalesCodeKey = DSC.SalesCodeKey
                                            INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO WITH ( NOLOCK )
                                                ON FST.SalesOrderKey = DSO.SalesOrderKey
                                            INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD WITH ( NOLOCK )
                                                ON FST.SalesOrderDetailKey = DSOD.SalesOrderDetailKey
                                            INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM WITH ( NOLOCK )
                                                ON DSO.ClientMembershipKey = DCM.ClientMembershipKey
                                  WHERE     DSC.SalesCodeSSID IN ( 682, 781, 853, 855, 856, 857, 858, 859, 673, 674, 780, 852, 854 )
                                            AND DSO.IsVoidedFlag = 0
											AND FST.ClientKey = O.ClientKey
											AND DCM.ClientMembershipKey = O.ClientMembershipKey
								  ORDER BY DD.FullDate DESC
                                ) o_LSR
            WHERE   NB_NetNBCnt <> 0
		END
	ELSE IF @Type=18 --Total NB1 Net $
		BEGIN
			SELECT center,center_name,Region,CenterManagementAreaSSID,CenterManagementAreaDescription,client_no,last_name,first_name,transact_no,ticket_no,[date],code,[description],qty,NULL AS 'grafts',price,tax_1,tax_2,performer,CancelReasonDescription,Department,performer2,Voided,Member1
			,	Member1  AS 'GroupBy'
			,	'' AS 'LaserTherapy'
			FROM #Output
			WHERE NB_NetNBAmt<>0
		END
	ELSE IF @Type=19 --Post Ext $
		BEGIN
			SELECT center,center_name,Region,CenterManagementAreaSSID,CenterManagementAreaDescription,client_no,last_name,first_name,transact_no,ticket_no,[date],code,[description],qty,NULL AS 'grafts',price,tax_1,tax_2,performer,CancelReasonDescription,Department,performer2,Voided,Member1
			,	Member1 AS 'GroupBy'
			,	'' AS 'LaserTherapy'
			FROM #Output
			WHERE S_PostExtAmt<>0
		END
END
GO
