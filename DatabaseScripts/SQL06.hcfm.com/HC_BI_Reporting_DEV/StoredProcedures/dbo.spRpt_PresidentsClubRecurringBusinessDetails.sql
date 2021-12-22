/* CreateDate: 10/04/2013 09:03:14.693 , ModifyDate: 04/06/2016 08:42:51.317 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_PresidentsClubRecurringBusinessDetails
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			President's Club
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		10/04/2013
------------------------------------------------------------------------
CHANGE HISTORY:
04/03/2014	RH	Removed an additional SalesCodeKey = 468 for Center Transfer
06/03/2014	RH  Added NB_XtrCnt and NB_XtrAmt for Xtrands to the fields.
01/13/2015	RH  Added NB_XtrConvCnt and also added Xtrands to the sums of NB Count and NB Amount
06/04/2015  RH  (#111093) First of the month for StartDate and EndDate - to match the Summary
06/04/2015  RH  (#124015) Added 28 = EXT and Xtr Conversions; 29 = EXT and Xtr Sales
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_PresidentsClubRecurringBusinessDetails 10, '4/1/2016', '4/15/2016', 216

EXEC spRpt_PresidentsClubRecurringBusinessDetails 28, '3/1/2016', '4/1/2016', 216

***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_PresidentsClubRecurringBusinessDetails]
(
	@Type INT
,	@StartDate DATETIME
,	@EndDate DATETIME
,	@Center INT
)
AS
BEGIN


/*
@Type

7  = Xtr#
10 = Applications
25 = BIO Conversions (Excludes EXT Conversions and Xtrands Conversions)
26 = EXT Conversions
27 = Xtr Conversions
28 = EXT and Xtr Conversions
29 = EXT and Xtr Sales

*/


SET FMTONLY OFF;
SET NOCOUNT OFF;

DECLARE @PCPStartDate DATETIME  --Match the Summary report dates
		,	@PCPEndDate DATETIME

		SELECT @PCPStartDate = CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@StartDate)) + '/1/' + CONVERT(VARCHAR, YEAR(@StartDate)))
		,	@PCPEndDate = CONVERT(DATETIME, CONVERT(VARCHAR, MONTH(@EndDate)) + '/1/' + CONVERT(VARCHAR, YEAR(@EndDate)))


/********************************** Create temp table objects *************************************/
CREATE TABLE #Centers (
	CenterSSID INT
)

CREATE TABLE #Transactions (
    CenterSSID INT
,	CenterDescription VARCHAR(255)
,	RegionSSID INT
,	RegionDescription VARCHAR(255)
,	ClientDescription VARCHAR(255)
,	Tran_No VARCHAR(20)
,	Ticket_No VARCHAR(50)
,	Tran_Date SMALLDATETIME
,	SalesCode VARCHAR(50)
,	SalesCodeDescription VARCHAR(60)
,	Quantity INT
,	Price MONEY
,	Tax1 MONEY
,	Tax2 MONEY
,	Performer VARCHAR(50)
,	CancelReasonDescription VARCHAR(50)
,	Department VARCHAR(50)
,	Performer2 VARCHAR(50)
,	Voided VARCHAR(10)
,	Member1 VARCHAR(40)
,	NB_XtrCnt INT
,	NB_EXTCnt INT
,	NB_AppsCnt INT
,	NB_BIOConvCnt INT
,	NB_EXTConvCnt INT
,	NB_XtrConvCnt INT

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


/********************************** Get Transaction Data *************************************/
INSERT  INTO #Transactions
		SELECT  C.ReportingCenterSSID AS 'CenterSSID'
		,       C.CenterDescriptionNumber AS 'CenterDescription'
		,		R.RegionSSID
		,       R.RegionDescription AS 'RegionDescription'
		,       CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'ClientDescription'
		,       CASE WHEN SOD.TransactionNumber_Temp = -1
					 THEN CONVERT(VARCHAR, SOD.SalesOrderDetailKey)
					 ELSE CONVERT(VARCHAR, SOD.TransactionNumber_Temp)
				END AS 'Tran_No'
		,       CASE WHEN SO.TicketNumber_Temp = 0
					 THEN CONVERT(VARCHAR, SO.InvoiceNumber)
					 ELSE CONVERT(VARCHAR, SO.TicketNumber_Temp)
				END AS 'Ticket_No'
		,       DD.FullDate AS 'Tran_Date'
		,       SC.SalesCodeDescriptionShort AS 'SalesCode'
		,       SC.SalesCodeDescription AS 'SalesCodeDescription'
		,       CASE WHEN SC.SalesCodeDescriptionShort = 'CANCEL' THEN -1
					 WHEN M.BusinessSegmentSSID = 3
						  AND SC.Salescodedepartmentssid = 1010 THEN 1
					 ELSE FST.Quantity
				END AS 'Quantity'
		,       CASE WHEN @Type IN ( 1, 2, 4, 6, 17 )
					 THEN CM.ClientMembershipContractPrice
					 ELSE FST.ExtendedPrice
				END AS 'Price'
		,       FST.Tax1 AS 'Tax1'
		,       FST.Tax2 AS 'Tax2'
		,       E.EmployeeInitials AS 'Performer'
		,       CR.CancelReasonDescription AS 'CancelReasonDescription'
		,       SC.SalesCodeDepartmentSSID AS 'Department'
		,       E2.EmployeeInitials AS 'Performer2'
		,       CASE WHEN ISNULL(SO.IsVoidedFlag, 0) = 1 THEN 'v'
					 ELSE ''
				END AS 'Voided'
		,       CASE WHEN SO.IsGuaranteeFlag = 1
						  AND SC.SalesCodeDescriptionShort = 'CANCEL'
					 THEN PREVM.MembershipDescription
					 ELSE M.MembershipDescription
				END AS 'Member1'
		,       ISNULL(FST.NB_ExtCnt, 0) AS 'NB_ExtCnt'
		,       ISNULL(FST.NB_XtrCnt, 0) AS 'NB_XtrCnt'
		,       ISNULL(FST.NB_AppsCnt, 0) AS 'NB_AppsCnt'
		,       ISNULL(FST.NB_BIOConvCnt, 0) AS 'NB_BIOConvCnt'
		,       ISNULL(FST.NB_EXTConvCnt, 0) AS 'NB_EXTConvCnt'
		,       ISNULL(FST.NB_XtrConvCnt, 0) AS 'NB_XtrConvCnt'

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
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
					ON C.CenterTypeKey = CT.CenterTypeKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion R
					ON C.RegionKey = R.RegionKey
				INNER JOIN #Centers
					ON C.ReportingCenterSSID = #Centers.CenterSSID
				LEFT JOIN HC_BI_Reporting.dbo.DimCancelReason CR
					ON CR.CancelReasonID = SOD.CancelReasonID
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership PREVCM
					ON SOD.PreviousClientMembershipSSID = PREVCM.ClientMembershipSSID
				LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership PREVM
					ON PREVCM.MembershipSSID = PREVM.MembershipSSID
		WHERE   DD.FullDate BETWEEN @PCPStartDate AND @PCPEndDate
				AND SC.SalesCodeKey NOT IN ( 665, 654, 393, 668, 468 )
				AND SOD.IsVoidedFlag = 0


IF @Type = 7 --Xtr #
BEGIN
	SELECT  CenterSSID AS 'Center'
	,		CenterDescription AS 'CenterName'
	,       Ticket_No AS 'Ticket_No'
	,		Tran_No AS 'transact_no'
	,       ClientDescription AS 'ClientName'
	,		Member1 AS 'Membership'
	,       Tran_Date AS 'Date'
	,       SalesCode AS 'Code'
	,       SalesCodeDescription AS 'Description'
	,       Quantity AS 'Qty'
	,       Price AS 'Price'
	,		(Tax1 + Tax2) AS 'Tax'
	,		(Price + Tax1 + Tax2) AS 'Total'
	,       Performer AS 'Performer'
	,		Voided
	FROM	#Transactions
	WHERE	NB_XtrCnt <> 0
END


IF @Type = 10 --Applications
BEGIN
	SELECT  CenterSSID AS 'Center'
	,		CenterDescription AS 'CenterName'
	,       Ticket_No AS 'Ticket_No'
	,		Tran_No AS 'transact_no'
	,       ClientDescription AS 'ClientName'
	,		Member1 AS 'Membership'
	,       Tran_Date AS 'Date'
	,       SalesCode AS 'Code'
	,       SalesCodeDescription AS 'Description'
	,       Quantity AS 'Qty'
	,       Price AS 'Price'
	,		(Tax1 + Tax2) AS 'Tax'
	,		(Price + Tax1 + Tax2) AS 'Total'
	,       Performer AS 'Performer'
	,		Voided
	FROM	#Transactions
	WHERE	NB_AppsCnt <> 0
END


IF @Type = 25 --BIO Conversions
BEGIN
	SELECT  CenterSSID AS 'Center'
	,		CenterDescription AS 'CenterName'
	,       Ticket_No AS 'Ticket_No'
	,		Tran_No AS 'transact_no'
	,       ClientDescription AS 'ClientName'
	,		Member1 AS 'Membership'
	,       Tran_Date AS 'Date'
	,       SalesCode AS 'Code'
	,       SalesCodeDescription AS 'Description'
	,       Quantity AS 'Qty'
	,       Price AS 'Price'
	,		(Tax1 + Tax2) AS 'Tax'
	,		(Price + Tax1 + Tax2) AS 'Total'
	,       Performer AS 'Performer'
	,		Voided
	FROM	#Transactions
	WHERE	NB_BIOConvCnt <> 0
END


IF @Type = 26 --EXT Conversions
BEGIN
	SELECT  CenterSSID AS 'Center'
	,		CenterDescription AS 'CenterName'
	,       Ticket_No AS 'Ticket_No'
	,		Tran_No AS 'transact_no'
	,       ClientDescription AS 'ClientName'
	,		Member1 AS 'Membership'
	,       Tran_Date AS 'Date'
	,       SalesCode AS 'Code'
	,       SalesCodeDescription AS 'Description'
	,       Quantity AS 'Qty'
	,       Price AS 'Price'
	,		(Tax1 + Tax2) AS 'Tax'
	,		(Price + Tax1 + Tax2) AS 'Total'
	,       Performer AS 'Performer'
	,		Voided
	FROM	#Transactions
	WHERE	NB_EXTConvCnt <> 0
END

IF @Type = 27 --Xtr Conversions
BEGIN
	SELECT  CenterSSID AS 'Center'
	,		CenterDescription AS 'CenterName'
	,       Ticket_No AS 'Ticket_No'
	,		Tran_No AS 'transact_no'
	,       ClientDescription AS 'ClientName'
	,		Member1 AS 'Membership'
	,       Tran_Date AS 'Date'
	,       SalesCode AS 'Code'
	,       SalesCodeDescription AS 'Description'
	,       Quantity AS 'Qty'
	,       Price AS 'Price'
	,		(Tax1 + Tax2) AS 'Tax'
	,		(Price + Tax1 + Tax2) AS 'Total'
	,       Performer AS 'Performer'
	,		Voided
	FROM	#Transactions
	WHERE	NB_XtrConvCnt <> 0
END

IF @Type = 28 --EXT and Xtr Conversions
BEGIN
	SELECT  CenterSSID AS 'Center'
	,		CenterDescription AS 'CenterName'
	,       Ticket_No AS 'Ticket_No'
	,		Tran_No AS 'transact_no'
	,       ClientDescription AS 'ClientName'
	,		Member1 AS 'Membership'
	,       Tran_Date AS 'Date'
	,       SalesCode AS 'Code'
	,       SalesCodeDescription AS 'Description'
	,       Quantity AS 'Qty'
	,       Price AS 'Price'
	,		(Tax1 + Tax2) AS 'Tax'
	,		(Price + Tax1 + Tax2) AS 'Total'
	,       Performer AS 'Performer'
	,		Voided
	FROM	#Transactions
	WHERE	NB_EXTConvCnt <> 0
		OR NB_XtrConvCnt <> 0
END

IF @Type = 29 --EXT and Xtr Sales
BEGIN
	SELECT  CenterSSID AS 'Center'
	,		CenterDescription AS 'CenterName'
	,       Ticket_No AS 'Ticket_No'
	,		Tran_No AS 'transact_no'
	,       ClientDescription AS 'ClientName'
	,		Member1 AS 'Membership'
	,       Tran_Date AS 'Date'
	,       SalesCode AS 'Code'
	,       SalesCodeDescription AS 'Description'
	,       Quantity AS 'Qty'
	,       Price AS 'Price'
	,		(Tax1 + Tax2) AS 'Tax'
	,		(Price + Tax1 + Tax2) AS 'Total'
	,       Performer AS 'Performer'
	,		Voided
	FROM	#Transactions
	WHERE	(NB_ExtCnt <> 0
	 OR		NB_XtrCnt <> 0)
END

END
GO
