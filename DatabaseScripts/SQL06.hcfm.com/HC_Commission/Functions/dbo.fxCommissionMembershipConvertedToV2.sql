--SELECT dbo.fxCommissionMembershipConvertedToV2(111)
CREATE FUNCTION [dbo].[fxCommissionMembershipConvertedToV2]
(
	@SalesOrderKey INT
)
RETURNS INT
AS
BEGIN

DECLARE @ConvertedTo INT


SELECT	@ConvertedTo = DM.MembershipKey
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON FST.SalesCodeKey = DSC.SalesCodeKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
			ON FST.SalesOrderKey = DSO.SalesOrderKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail DSOD
			ON FST.SalesOrderDetailKey = DSOD.SalesOrderDetailKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
			ON DSO.ClientMembershipKey = DCM.ClientMembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
			ON DCM.MembershipSSID = DM.MembershipSSID
WHERE   FST.SalesOrderKey = @SalesOrderKey
		AND FST.NB_BIOConvCnt >= 1


RETURN ISNULL(@ConvertedTo, 0)

END
