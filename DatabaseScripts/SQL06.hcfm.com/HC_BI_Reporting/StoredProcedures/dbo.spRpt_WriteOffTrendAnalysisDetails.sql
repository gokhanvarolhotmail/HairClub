/* CreateDate: 12/05/2013 09:45:20.470 , ModifyDate: 08/04/2015 14:14:05.170 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_WriteOffTrendAnalysisDetails
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			WriteOff Trend Analysis Details
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		12/05/2013
------------------------------------------------------------------------
NOTES:

12/05/2013 - DL - (#94709) Converted Stored Procedure
08/03/2015 - RH - (#116696) Removed Write-Offs for New Business (675,685) - added DM.RevenueGroupDescription = 'Recurring Business' AND FST.ExtendedPrice <> '0.00'

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_WriteOffTrendAnalysisDetails 235, 7, 2015
***********************************************************************/
CREATE PROCEDURE [dbo].[spRpt_WriteOffTrendAnalysisDetails]
(
	@Center INT,
	@Month INT,
	@Year INT
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME

SET @StartDate = CONVERT(VARCHAR, @Month) + '/1/' + CONVERT(VARCHAR, @Year)
SET @EndDate = DATEADD(s, -1, DATEADD(mm, DATEDIFF(m, 0, @StartDate) + 1, 0))
SET @EndDate = CONVERT(VARCHAR(11), @EndDate, 101)


SELECT	@StartDate AS 'StartDate'
,		@EndDate AS 'EndDate'
,		DR.RegionSSID AS 'RegionID'
,		DR.RegionDescription AS 'Region'
,		DC.CenterDescriptionNumber AS 'Center'
,		CASE WHEN DSOD.TransactionNumber_Temp = -1 THEN CONVERT(VARCHAR, DSOD.SalesOrderDetailKey) ELSE CONVERT(VARCHAR, DSOD.TransactionNumber_Temp) END AS 'transact_no'
,		CASE WHEN DSO.TicketNumber_Temp = 0 THEN CONVERT(VARCHAR, DSO.InvoiceNumber) ELSE CONVERT(VARCHAR, DSO.TicketNumber_Temp) END AS 'ticket_no'
,		CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'Client'
,		DD.FullDate AS 'Date'
,		DSC.SalesCodeDescriptionShort AS 'Code'
,		DSC.SalesCodeDescription AS 'Description'
,		ABS(FST.ExtendedPrice) AS 'Price'
,		FST.Tax1 AS 'Tax_1'
,		FST.ExtendedPricePlusTax AS 'Total'
,		DE1.EmployeeInitials AS 'Performer'
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
WHERE   DC.CenterSSID = @Center
		AND DD.FullDate BETWEEN @StartDate AND @EndDate
		AND (DSC.SalesCodeSSID IN ( 646, 694, 715, 708 )
			OR FST.SalesOrderTypeKey = 5 )--NSF/Chargeback Order
		AND DM.RevenueGroupDescription = 'Recurring Business'
		AND FST.ExtendedPrice <> '0.00'
ORDER BY DD.FullDate
,		DSO.InvoiceNumber

END


/*Removed New Business
SalesCodeSSID	SalesCodeDescription
675	Write-Off - New Business (EXT)
685	Write-Off - New Business (BIO)*/
GO
