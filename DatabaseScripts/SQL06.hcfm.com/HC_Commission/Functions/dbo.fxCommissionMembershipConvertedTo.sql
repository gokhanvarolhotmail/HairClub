--select dbo.[fxCommissionMembershipConvertedTo](25909048)
CREATE FUNCTION [dbo].[fxCommissionMembershipConvertedTo] (
	@SalesOrderKey INT
)
RETURNS VARCHAR(100) AS
BEGIN
	RETURN(
		SELECT m.MembershipKey AS 'ConvertedTo'
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
