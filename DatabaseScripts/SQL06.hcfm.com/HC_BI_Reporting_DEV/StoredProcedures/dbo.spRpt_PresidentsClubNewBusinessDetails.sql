/* CreateDate: 03/23/2017 15:54:11.260 , ModifyDate: 05/19/2017 15:35:25.290 */
GO
/***********************************************************************
PROCEDURE:				spRpt_PresidentsClubNewBusinessDetails
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			President's Club
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		10/04/2013
------------------------------------------------------------------------
NOTES:
06/03/2014 - RH - Added NB_XtrCnt and NB_XtrAmt for Xtrands to the fields and to the Net Sales counts.
11/24/2014 - RH - Removed Xtrands to be added Jan 2015.  Removed PostEXT.
12/03/2014 - RH - Added back PostEXT; Added back Xtrands
01/08/2015 - RH - Added IF @Type = 11 --EXT Count (WO#110249)
01/13/2015 - RH - Added Xtrands to the totals
09/02/2015 - RH - Added FST.ExtendedPrice for NetSales# drill-down as Revenue Collected; Increased performance by rewriting the query.
05/19/2017 - RH - (#138367) Changed "performer" field name to "EmployeeInitials", changed @Performer to @EmployeeKey
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_PresidentsClubNewBusinessDetails 17, '1/1/2017', '3/20/2017', 209, NULL

EXEC spRpt_PresidentsClubNewBusinessDetails 10, '3/1/2017', '3/31/2017', 205, NULL

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_PresidentsClubNewBusinessDetails]
(
	@type INT
,	@StartDate DATETIME
,	@EndDate DATETIME
,	@center INT
--,	@Performer VARCHAR(255) = NULL
,	@EmployeeKey INT = NULL
)
AS
BEGIN

--SET FMTONLY OFF;
SET NOCOUNT OFF;

/*
@Type

10	= Applications
17	= Total NB1 Net #
300	= Hair Sales #
400	= EXT/Trad/Grad/Xtr #
401	= EXT/Trad/Grad/Xtr $

*/


/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	CenterSSID INT
)

/********************************** Get Center/Region Data *************************************/
IF @Center > 200
    BEGIN
        INSERT  INTO #Centers
                SELECT  DC.CenterSSID
                FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
                        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
                            ON DC.RegionSSID = DR.RegionKey
                        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
                            ON DC.CenterTypeKey = DCT.CenterTypeKey
                WHERE   DC.CenterSSID = @Center
                        AND DC.Active = 'Y'
    END
ELSE
    BEGIN
        INSERT  INTO #Centers
                SELECT  DC.CenterSSID
                FROM    HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
                        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
                            ON DC.RegionSSID = DR.RegionKey
                        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
                            ON DC.CenterTypeKey = DCT.CenterTypeKey
                WHERE   DC.RegionSSID = @Center
                        AND DC.Active = 'Y'
    END


/********************************** Get Performer Data *************************************/
--This code will no longer be used if we pass EmployeeKey as the @Performer
--DECLARE @EmployeeSSID UNIQUEIDENTIFIER

--IF @Center > 200 AND @Performer IS NOT NULL
--BEGIN
--	SELECT  @EmployeeSSID = EmployeeSSID
--	FROM    HC_BI_CMS_DDS.bi_cms_dds.DimEmployee
--	WHERE   CenterSSID = @Center
--			AND EmployeeFullName = @Performer
--END

/********************************** Get Transaction Data *************************************/


IF @Type = 10 --Applications
BEGIN
	SELECT  C.CenterSSID AS 'Center'
		,       C.CenterDescriptionNumber AS 'CenterName'
		,       CASE WHEN SO.TicketNumber_Temp = 0
					 THEN CONVERT(VARCHAR, SO.InvoiceNumber)
					 ELSE CONVERT(VARCHAR, SO.TicketNumber_Temp)
				END AS 'ticket_no'
		,       CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'ClientName'
		,       CASE WHEN SO.IsGuaranteeFlag = 1 AND SC.SalesCodeDescriptionShort = 'CANCEL' THEN PREVM.MembershipDescription
					 ELSE M.MembershipDescription END AS 'Membership'
		,       DD.FullDate AS 'date'
		,       SC.SalesCodeDescriptionShort AS 'code'
		,       SC.SalesCodeDescription AS 'description'
		,       CASE WHEN SC.SalesCodeDescriptionShort = 'CANCEL' THEN -1
					 WHEN M.BusinessSegmentSSID = 3
						  AND SC.Salescodedepartmentssid = 1010 THEN 1
					 ELSE FST.Quantity
				END AS 'qty'
		,		CM.ClientMembershipContractPrice AS 'ContractPrice'
		,		ROUND(FST.ExtendedPrice,0) AS 'ExtendedPrice'
		,		ISNULL(E.EmployeeInitials, E2.EmployeeInitials) AS 'EmployeeInitials'

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
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
					ON SO.ClientMembershipKey = CM.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
					ON CM.MembershipSSID = M.MembershipSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
					ON CM.CenterKey = C.CenterKey
				INNER JOIN #Centers
					ON C.ReportingCenterSSID = #Centers.CenterSSID
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership PREVCM
					ON SOD.PreviousClientMembershipSSID = PREVCM.ClientMembershipSSID
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership PREVM
					ON PREVCM.MembershipSSID = PREVM.MembershipSSID
	WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
				AND FST.NB_AppsCnt <> 0
				AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
				AND SOD.IsVoidedFlag = 0
				AND ( @EmployeeKey IS NULL OR E.EmployeeKey = @EmployeeKey )
END

IF @Type = 11 --EXT Count
BEGIN
	SELECT  C.CenterSSID AS 'Center'
		,       C.CenterDescriptionNumber AS 'CenterName'
		,       CASE WHEN SO.TicketNumber_Temp = 0
					 THEN CONVERT(VARCHAR, SO.InvoiceNumber)
					 ELSE CONVERT(VARCHAR, SO.TicketNumber_Temp)
				END AS 'ticket_no'
		,       CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'ClientName'
		,       CASE WHEN SO.IsGuaranteeFlag = 1 AND SC.SalesCodeDescriptionShort = 'CANCEL' THEN PREVM.MembershipDescription
					 ELSE M.MembershipDescription END AS 'Membership'
		,       DD.FullDate AS 'date'
		,       SC.SalesCodeDescriptionShort AS 'code'
		,       SC.SalesCodeDescription AS 'description'
		,       CASE WHEN SC.SalesCodeDescriptionShort = 'CANCEL' THEN -1
					 WHEN M.BusinessSegmentSSID = 3
						  AND SC.Salescodedepartmentssid = 1010 THEN 1
					 ELSE FST.Quantity
				END AS 'qty'
		,		CM.ClientMembershipContractPrice AS 'ContractPrice'
		,		ROUND(FST.ExtendedPrice,0) AS 'ExtendedPrice'
		,		ISNULL(E.EmployeeInitials, E2.EmployeeInitials) AS 'EmployeeInitials'

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
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
					ON SO.ClientMembershipKey = CM.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
					ON CM.MembershipSSID = M.MembershipSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
					ON CM.CenterKey = C.CenterKey
				INNER JOIN #Centers
					ON C.ReportingCenterSSID = #Centers.CenterSSID
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership PREVCM
					ON SOD.PreviousClientMembershipSSID = PREVCM.ClientMembershipSSID
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership PREVM
					ON PREVCM.MembershipSSID = PREVM.MembershipSSID
	WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
				AND FST.NB_ExtCnt <> 0
				AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
				AND SOD.IsVoidedFlag = 0
				AND ( @EmployeeKey IS NULL OR E.EmployeeKey = @EmployeeKey OR E2.EmployeeKey = @EmployeeKey )
END


IF @Type = 17 --Total NB1 Net #
BEGIN
	SELECT  C.CenterSSID AS 'Center'
		,       C.CenterDescriptionNumber AS 'CenterName'
		,       CASE WHEN SO.TicketNumber_Temp = 0
					 THEN CONVERT(VARCHAR, SO.InvoiceNumber)
					 ELSE CONVERT(VARCHAR, SO.TicketNumber_Temp)
				END AS 'ticket_no'
		,       CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'ClientName'
		,       CASE WHEN SO.IsGuaranteeFlag = 1 AND SC.SalesCodeDescriptionShort = 'CANCEL' THEN PREVM.MembershipDescription
					 ELSE M.MembershipDescription END AS 'Membership'
		,       DD.FullDate AS 'date'
		,       SC.SalesCodeDescriptionShort AS 'code'
		,       SC.SalesCodeDescription AS 'description'
		,       CASE WHEN SC.SalesCodeDescriptionShort = 'CANCEL' THEN -1
					 WHEN M.BusinessSegmentSSID = 3
						  AND SC.Salescodedepartmentssid = 1010 THEN 1
					 ELSE FST.Quantity
				END AS 'qty'
		,		CM.ClientMembershipContractPrice AS 'ContractPrice'
		,		ROUND(FST.ExtendedPrice,0) AS 'ExtendedPrice'
		,		ISNULL(E.EmployeeInitials, E2.EmployeeInitials) AS 'EmployeeInitials'
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
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
					ON SO.ClientMembershipKey = CM.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
					ON CM.MembershipSSID = M.MembershipSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
					ON CM.CenterKey = C.CenterKey
				INNER JOIN #Centers
					ON C.ReportingCenterSSID = #Centers.CenterSSID
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership PREVCM
					ON SOD.PreviousClientMembershipSSID = PREVCM.ClientMembershipSSID
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership PREVM
					ON PREVCM.MembershipSSID = PREVM.MembershipSSID
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
				AND (ISNULL(FST.NB_TradCnt, 0) <> 0
					OR ISNULL(FST.NB_GradCnt, 0) <> 0
					OR ISNULL(FST.NB_ExtCnt, 0) <> 0
					OR ISNULL(FST.NB_XtrCnt, 0) <> 0
					OR ISNULL(FST.S_SurCnt, 0) <> 0
					OR ISNULL(FST.S_PostExtCnt, 0) <> 0 )
				AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
				AND SOD.IsVoidedFlag = 0
				AND ( @EmployeeKey IS NULL OR E.EmployeeKey = @EmployeeKey  OR E2.EmployeeKey = @EmployeeKey )

END


IF @Type = 300 --Hair Sales #
BEGIN
	SELECT  C.CenterSSID AS 'Center'
		,       C.CenterDescriptionNumber AS 'CenterName'
		,       CASE WHEN SO.TicketNumber_Temp = 0
					 THEN CONVERT(VARCHAR, SO.InvoiceNumber)
					 ELSE CONVERT(VARCHAR, SO.TicketNumber_Temp)
				END AS 'ticket_no'
		,       CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'ClientName'
		,       CASE WHEN SO.IsGuaranteeFlag = 1 AND SC.SalesCodeDescriptionShort = 'CANCEL' THEN PREVM.MembershipDescription
					 ELSE M.MembershipDescription END AS 'Membership'
		,       DD.FullDate AS 'date'
		,       SC.SalesCodeDescriptionShort AS 'code'
		,       SC.SalesCodeDescription AS 'description'
		,       CASE WHEN SC.SalesCodeDescriptionShort = 'CANCEL' THEN -1
					 WHEN M.BusinessSegmentSSID = 3
						  AND SC.Salescodedepartmentssid = 1010 THEN 1
					 ELSE FST.Quantity
				END AS 'qty'
		,		CM.ClientMembershipContractPrice AS 'ContractPrice'
		,		ROUND(FST.ExtendedPrice,0) AS 'ExtendedPrice'
		,		ISNULL(E.EmployeeInitials, E2.EmployeeInitials) AS 'EmployeeInitials'
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
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
					ON SO.ClientMembershipKey = CM.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
					ON CM.MembershipSSID = M.MembershipSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
					ON CM.CenterKey = C.CenterKey
				INNER JOIN #Centers
					ON C.ReportingCenterSSID = #Centers.CenterSSID
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership PREVCM
					ON SOD.PreviousClientMembershipSSID = PREVCM.ClientMembershipSSID
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership PREVM
					ON PREVCM.MembershipSSID = PREVM.MembershipSSID
	WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
				AND ( FST.NB_TradCnt <> 0 OR FST.NB_GradCnt <> 0 )
				AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
				AND SOD.IsVoidedFlag = 0
				AND ( @EmployeeKey IS NULL OR E.EmployeeKey = @EmployeeKey  OR E2.EmployeeKey = @EmployeeKey )

END


IF @Type = 400 --EXT/Trad/Grad/Xtr/Sur/PostEXT #
BEGIN
	SELECT  C.CenterSSID AS 'Center'
		,       C.CenterDescriptionNumber AS 'CenterName'
		,       CASE WHEN SO.TicketNumber_Temp = 0
					 THEN CONVERT(VARCHAR, SO.InvoiceNumber)
					 ELSE CONVERT(VARCHAR, SO.TicketNumber_Temp)
				END AS 'ticket_no'
		,       CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'ClientName'
		,       CASE WHEN SO.IsGuaranteeFlag = 1 AND SC.SalesCodeDescriptionShort = 'CANCEL' THEN PREVM.MembershipDescription
					 ELSE M.MembershipDescription END AS 'Membership'
		,       DD.FullDate AS 'date'
		,       SC.SalesCodeDescriptionShort AS 'code'
		,       SC.SalesCodeDescription AS 'description'
		,       CASE WHEN SC.SalesCodeDescriptionShort = 'CANCEL' THEN -1
					 WHEN M.BusinessSegmentSSID = 3
						  AND SC.Salescodedepartmentssid = 1010 THEN 1
					 ELSE FST.Quantity
				END AS 'qty'
		,		CM.ClientMembershipContractPrice AS 'ContractPrice'
		,		ROUND(FST.ExtendedPrice,0) AS 'ExtendedPrice'
		,		ISNULL(E.EmployeeInitials, E2.EmployeeInitials) AS 'EmployeeInitials'
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
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
					ON SO.ClientMembershipKey = CM.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
					ON CM.MembershipSSID = M.MembershipSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
					ON CM.CenterKey = C.CenterKey
				INNER JOIN #Centers
					ON C.ReportingCenterSSID = #Centers.CenterSSID
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership PREVCM
					ON SOD.PreviousClientMembershipSSID = PREVCM.ClientMembershipSSID
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership PREVM
					ON PREVCM.MembershipSSID = PREVM.MembershipSSID
	WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
				AND ( FST.NB_TradCnt <> 0 OR FST.NB_GradCnt <> 0 OR FST.NB_ExtCnt <> 0 OR FST.NB_XtrCnt <> 0 OR FST.S_SurAmt <> 0 OR FST.S_PostExtAmt <> 0)
				AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
				AND SOD.IsVoidedFlag = 0
				AND ( @EmployeeKey IS NULL OR E.EmployeeKey = @EmployeeKey OR E2.EmployeeKey = @EmployeeKey )


END


IF @Type = 401 --EXT/Trad/Grad/Xtr/Sur/PostEXT # $
BEGIN
	SELECT  C.CenterSSID AS 'Center'
		,       C.CenterDescriptionNumber AS 'CenterName'
		,       CASE WHEN SO.TicketNumber_Temp = 0
					 THEN CONVERT(VARCHAR, SO.InvoiceNumber)
					 ELSE CONVERT(VARCHAR, SO.TicketNumber_Temp)
				END AS 'ticket_no'
		,       CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'ClientName'
		,       CASE WHEN SO.IsGuaranteeFlag = 1 AND SC.SalesCodeDescriptionShort = 'CANCEL' THEN PREVM.MembershipDescription
					 ELSE M.MembershipDescription END AS 'Membership'
		,       DD.FullDate AS 'date'
		,       SC.SalesCodeDescriptionShort AS 'code'
		,       SC.SalesCodeDescription AS 'description'
		,       CASE WHEN SC.SalesCodeDescriptionShort = 'CANCEL' THEN -1
					 WHEN M.BusinessSegmentSSID = 3
						  AND SC.Salescodedepartmentssid = 1010 THEN 1
					 ELSE FST.Quantity
				END AS 'qty'
		,		CM.ClientMembershipContractPrice AS 'ContractPrice'
		,		ROUND(FST.ExtendedPrice,0) AS 'ExtendedPrice'
		,		ISNULL(E.EmployeeInitials, E2.EmployeeInitials) AS 'EmployeeInitials'
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
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
					ON SO.ClientMembershipKey = CM.ClientMembershipKey
				INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
					ON CM.MembershipSSID = M.MembershipSSID
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
					ON CM.CenterKey = C.CenterKey
				INNER JOIN #Centers
					ON C.ReportingCenterSSID = #Centers.CenterSSID
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership PREVCM
					ON SOD.PreviousClientMembershipSSID = PREVCM.ClientMembershipSSID
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership PREVM
					ON PREVCM.MembershipSSID = PREVM.MembershipSSID
	WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
				AND ( FST.NB_TradAmt <> 0 OR FST.NB_GradAmt <> 0 OR FST.NB_ExtAmt <> 0 OR FST.NB_XtrAmt <> 0 OR FST.S_SurAmt <> 0 OR FST.S_PostExtAmt <> 0)
				AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668 )
				AND SOD.IsVoidedFlag = 0
				AND ( @EmployeeKey IS NULL OR E.EmployeeKey = @EmployeeKey  OR E2.EmployeeKey = @EmployeeKey )


END



END
GO
