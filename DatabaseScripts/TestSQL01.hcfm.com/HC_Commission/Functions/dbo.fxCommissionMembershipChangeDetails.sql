/* CreateDate: 11/26/2012 14:08:50.830 , ModifyDate: 11/26/2012 14:34:44.080 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
--select dbo.[fxCommissionMembershipChangeDetails](25091220)
CREATE FUNCTION [dbo].[fxCommissionMembershipChangeDetails] (
	@SalesOrderKey INT
)
RETURNS VARCHAR(100) AS
BEGIN
	RETURN(
		SELECT m2.MembershipDescription + ' to ' + m.MembershipDescription as 'MembershipChange'
		FROM HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FST.OrderDateKey = dd.DateKey
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
				ON FST.CenterKey = c.CenterKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode SC
				ON fst.SalesCodeKey = sc.SalesCodeKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
				ON FST.SalesOrderKey = SO.SalesOrderKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm
				ON SO.ClientMembershipKey = cm.ClientMembershipKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m
				ON cm.MembershipSSID = m.MembershipSSID
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
				ON FST.SalesOrderDetailKey = SOD.SalesOrderDetailKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership cm2
				ON SOD.PreviousClientMembershipSSID = cm2.ClientMembershipSSID
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership m2
				ON cm2.MembershipSSID = m2.MembershipSSID
		WHERE FST.SalesOrderKey=@SalesOrderKey
			AND SC.SalesCodeDepartmentSSID IN (1070, 1080, 1090, 1095, 1099, 1075)
	)
END
GO
