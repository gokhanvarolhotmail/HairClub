/* CreateDate: 06/16/2014 11:39:15.970 , ModifyDate: 11/14/2014 09:44:41.180 */
GO
/***********************************************************************
PROCEDURE:				spSvc_AmplifierDataExport_ActivePCP
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		06/16/2014
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_AmplifierDataExport_ActivePCP
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_AmplifierDataExport_ActivePCP]
AS
BEGIN

DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME


SET @StartDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
SET @EndDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))


SELECT  46 AS 'ClientBrandID'
,       1204 AS 'SurveyType'
,       CTR.CenterSSID AS 'Location'
,       CLT.ClientIdentifier AS 'ClientContactID'
,       CLT.ClientFirstName AS 'FirstName'
,       CLT.ClientLastName AS 'LastName'
,		CASE WHEN CLT.Phone1TypeSSID = 1 THEN ISNULL(CLT.ClientPhone1, '') ELSE '' END AS 'HomePhone'
,		CASE WHEN CLT.Phone1TypeSSID = 2 THEN ISNULL(CLT.ClientPhone2, '') ELSE '' END AS 'WorkPhone'
,		CASE WHEN CLT.Phone1TypeSSID = 3 THEN ISNULL(CLT.ClientPhone3, '') ELSE '' END AS 'CellPhone'
,       ISNULL(CLT.ClientEMailAddress, '') AS 'Email'
,       CASE WHEN ISNULL(CLT.ClientDateOfBirth, '') = '1/1/1900' THEN '' ELSE CONVERT(VARCHAR(11), ISNULL(CLT.ClientDateOfBirth, ''), 101) END AS 'Birthdate'
,       ISNULL(CLT.PostalCode, '') AS 'Zip'
,       ISNULL(LEFT(CLT.ClientGenderDescriptionShort, 1), '') AS 'Gender'
,       '' AS 'InquiryDate'
,       '' AS 'ScheduledBy'
,       '' AS 'ConsultServiceType'
,       '' AS 'ConsultDate'
,       '' AS 'ConsultantName'
,       '' AS 'ConsultCancellationDate'
,       DM.MembershipDescription AS 'ServiceType'
,       '' AS 'ServiceDate'
,       '' AS 'ServiceProviderName'
,       '' AS 'ServiceRevenue'
,       '' AS 'LeadSource'
,       '' AS 'uservarchar1'
,       '' AS 'uservarchar2'
,       CLT.ClientEthinicityDescription AS 'uservarchar3'
,       '' AS 'uservarchar4'
,       CONVERT(VARCHAR(11), DCM.ClientMembershipEndDate, 101) AS 'userdate1'
,       Sales.DatePurchased AS 'userdate2'
,       '' AS 'userdate3'
,       '' AS 'userdate4'
,       '' AS 'userreal1'
,       '' AS 'userreal2'
,       '' AS 'userreal3'
,       '' AS 'userreal4'
FROM    HC_Accounting.dbo.FactPCPDetail FPD
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FPD.DateKey = DD.DateKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
            ON FPD.CenterKey = CTR.CenterKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
            ON FPD.ClientKey = CLT.ClientKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
            ON FPD.MembershipKey = DM.MembershipKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
			ON DCM.ClientKey = CLT.ClientKey
				AND DCM.MembershipKey = DM.MembershipKey
        INNER JOIN ( SELECT FST.ClientKey
                     ,      MIN(DD.FullDate) AS 'DatePurchased'
                     FROM   HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                            INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                                ON FST.OrderDateKey = DD.DateKey
                            INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
                                ON FST.SalesCodeKey = DSC.SalesCodeKey
                     WHERE  DSC.SalesCodeDepartmentSSID = 1010
                     GROUP BY FST.ClientKey
                   ) Sales
            ON CLT.ClientKey = Sales.ClientKey
WHERE   MONTH(DD.FullDate) = MONTH(GETDATE())
        AND YEAR(DD.FullDate) = YEAR(GETDATE())
        AND FPD.PCP - FPD.EXT = 1
		AND CONVERT(VARCHAR, CTR.CenterSSID) LIKE '[2]%'
        AND CTR.Active = 'Y'
		AND DM.MembershipSSID NOT IN ( 43, 44 )
		AND DCM.ClientMembershipEndDate BETWEEN @StartDate AND @EndDate
		AND ISNULL(CLT.DoNotCallFlag, 0) = 0
		AND ISNULL(CLT.DoNotContactFlag, 0) = 0

END
GO
