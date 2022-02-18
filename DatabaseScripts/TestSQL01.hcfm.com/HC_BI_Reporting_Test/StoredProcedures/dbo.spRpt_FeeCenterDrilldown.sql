/* CreateDate: 08/24/2012 08:42:24.373 , ModifyDate: 08/24/2012 08:42:24.373 */
GO
/*===============================================================================================
-- Procedure Name:			spRpt_FeeCenterDrilldown
-- Created By:             HDu
-- Implemented By:         HDu
-- Last Modified By:       HDu
--
-- Date Created:           8/23/2012
-- Date Implemented:       8/23/2012
-- Date Last Modified:     8/23/2012
--
-- Destination Server:		SQL06
-- Destination Database:	HC_BI_Reporting
-- Related Application:
================================================================================================
**NOTES**
================================================================================================
Sample Execution:
EXEC spRpt_FeeCenterDrilldown 263, '01/01/2011'
================================================================================================*/
CREATE PROCEDURE [dbo].[spRpt_FeeCenterDrilldown]
	@Center		INT
,	@StartDate	SMALLDATETIME
AS
BEGIN
	SELECT ce.CenterSSID AS Center_No
	,	ce.CenterDescriptionNumber AS Center
	,	so.TicketNumber_Temp [ticket_no]
	,	sod.TransactionNumber_Temp [transact_no]
	,	cl.ClientNumber_Temp [client_no]
	,	cl.ClientFirstName [First_Name]
	,	cl.ClientLastName [Last_Name]
	,	so.OrderDate [Date]
	,	sc.SalesCodeDescriptionShort [Code]
	,	sc.SalesCodeDescription [Description]
	,	t.[Price]
	,	cm.Member1_ID_Temp [Member1]
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction t
INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ce ON ce.CenterKey = t.CenterKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion re ON re.RegionKey = ce.RegionKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType ct ON ct.CenterTypeKey = ce.CenterTypeKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode sc ON sc.SalesCodeKey = t.SalesCodeKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder so ON so.SalesOrderKey = t.SalesOrderKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail sod ON sod.SalesOrderDetailKey = t.SalesOrderDetailKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient cl ON t.ClientKey = cl.ClientKey
INNER JOIN [HC_BI_CMS_DDS].[bi_cms_dds].[DimMembership] m ON m.MembershipKey = t.MembershipKey
INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm ON cm.ClientMembershipKey = t.ClientMembershipKey
	WHERE (so.OrderDate BETWEEN @startDate AND (DateADD(DD, -1, DateADD(m,1,@startDate))+ ' 23:59:59'))
		AND ce.CenterSSID = @Center
		AND sc.SalesCodeDescriptionShort NOT IN ('PCPPMT','PCPRFD','PCPREVWO', 'EXTMEMPT')
		AND sc.SalesCodeDepartmentSSID IN (2020)
		AND m.RevenueGroupDescriptionShort = 'PCP'
		AND t.price <> 0
	ORDER BY [Date], Last_Name, [First_Name]
END
GO
