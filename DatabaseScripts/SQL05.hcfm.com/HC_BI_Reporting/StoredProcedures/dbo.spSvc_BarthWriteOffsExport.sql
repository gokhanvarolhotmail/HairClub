/* CreateDate: 04/10/2014 12:18:37.497 , ModifyDate: 08/07/2018 23:15:44.343 */
GO
/***********************************************************************
PROCEDURE:				spSvc_BarthWriteOffsExport
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		04/10/2014
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_BarthWriteOffsExport
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_BarthWriteOffsExport]
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


/********************************** Get WriteOff Data *************************************/
DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME


SET @StartDate = DATEADD(dd, -21, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
SET @EndDate = DATEADD(dd, 0, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))


SELECT	DR.RegionSSID AS 'RegionSSID'
,		DR.RegionDescription AS 'RegionDescription'
,		DC.CenterSSID AS 'CenterSSID'
,		DC.CenterDescriptionNumber AS 'CenterDescription'
,		CASE WHEN DSOD.TransactionNumber_Temp = -1 THEN CONVERT(VARCHAR, DSOD.SalesOrderDetailKey) ELSE CONVERT(VARCHAR, DSOD.TransactionNumber_Temp) END AS 'TransactionNumber'
,		CASE WHEN DSO.TicketNumber_Temp = 0 THEN CONVERT(VARCHAR, DSO.InvoiceNumber) ELSE CONVERT(VARCHAR, DSO.TicketNumber_Temp) END AS 'TicketNumber'
,		CLT.ClientIdentifier
,		CLT.ClientNumber_Temp AS 'ClientIdentifierCMS'
,		REPLACE(CLT.ClientFirstName, ',', '') AS 'FirstName'
,		REPLACE(CLT.ClientLastName, ',', '') AS 'LastName'
,		DD.FullDate AS 'Date'
,		DSC.SalesCodeSSID
,		DSC.SalesCodeDescriptionShort AS 'Code'
,		DSC.SalesCodeDescription AS 'Description'
,		FST.ExtendedPrice AS 'Price'
,		FST.Tax1 AS 'Tax1'
,		FST.Tax2 AS 'Tax2'
,		FST.ExtendedPricePlusTax AS 'TotalPrice'
,		DE1.EmployeeInitials AS 'Performer'
,		ISNULL(DMOR.MembershipOrderReasonID, -1) AS 'WriteOffReasonID'
,		ISNULL(DMOR.MembershipOrderReasonDescription, 'Unknown') AS 'WriteOffReason'
,		ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(so.WriteOffReasonDescription, CHAR(9), ''), CHAR(10), ''), CHAR(13), ''), '''', ''), '{', ''), '}', ''), ',', '') , '') AS 'WriteOffReasonManual'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FST.OrderDateKey = DD.DateKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
            ON FST.SalesCodeKey = DSC.SalesCodeKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
            ON FST.ClientMembershipKey = DCM.ClientMembershipKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
            ON DCM.MembershipSSID = DM.MembershipSSID
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
            ON DCM.CenterKey = DC.CenterKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType DCT
            ON DC.CenterTypeKey = DCT.CenterTypeKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
            ON DC.RegionKey = DR.RegionKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD
            ON FST.SalesOrderDetailKey = DSOD.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
            ON DSOD.SalesOrderKey = DSO.SalesOrderKey
		INNER JOIN SQL05.HairClubCMS.dbo.datSalesOrder so
			ON so.SalesOrderGUID = DSO.SalesOrderSSID
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderType DSOT
			ON DSO.SalesOrderTypeKey = DSOT.SalesOrderTypeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
			ON FST.ClientKey = CLT.ClientKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDepartment DSCD
			ON DSC.SalesCodeDepartmentKey = DSCD.SalesCodeDepartmentKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCodeDivision DSCD2
			ON DSCD.SalesCodeDivisionKey = DSCD2.SalesCodeDivisionKey
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE1
			ON FST.Employee1Key = DE1.EmployeeKey
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee DE2
			ON FST.Employee2Key = DE2.EmployeeKey
		LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembershipOrderReason DMOR
            ON DSOD.MembershipOrderReasonID = DMOR.MembershipOrderReasonID
WHERE   DC.CenterSSID IN ( 807, 804, 821, 745, 748, 806, 811, 805, 817, 746, 814, 747, 820, 822 )
		AND DD.FullDate BETWEEN @StartDate AND @EndDate
		AND ( DSC.SalesCodeSSID IN ( 646, 694, 675, 685, 715, 708 )
				OR FST.SalesOrderTypeKey = 5 )
		AND DSO.IsVoidedFlag = 0

END
GO
