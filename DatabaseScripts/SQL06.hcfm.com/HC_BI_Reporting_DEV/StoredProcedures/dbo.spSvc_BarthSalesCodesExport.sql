/* CreateDate: 04/10/2014 12:16:22.730 , ModifyDate: 04/10/2014 12:16:22.730 */
GO
/***********************************************************************
PROCEDURE:				spSvc_BarthSalesCodesExport
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		04/10/2014
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_BarthSalesCodesExport
***********************************************************************/
CREATE PROCEDURE spSvc_BarthSalesCodesExport
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


/********************************** Get SalesCode Data *************************************/
SELECT  DSC.SalesCodeKey
,       DSC.SalesCodeSSID
,       DSC.SalesCodeDescription
,       DSC.SalesCodeDescriptionShort
,       DSC.SalesCodeTypeSSID
,       DSC.SalesCodeTypeDescription
,       DSC.SalesCodeTypeDescriptionShort
,       DSC.SalesCodeDepartmentKey
,       DSC.SalesCodeDepartmentSSID
,       DSC.PriceDefault
,       DSC.ServiceDuration
FROM    HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
ORDER BY DSC.SalesCodeKey

END
GO
