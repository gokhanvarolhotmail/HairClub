/* CreateDate: 06/30/2014 11:15:14.727 , ModifyDate: 11/14/2014 09:43:44.590 */
GO
/***********************************************************************
PROCEDURE:				spSvc_AmplifierDataExport_RecurringBusinessCancels
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

EXEC spSvc_AmplifierDataExport_RecurringBusinessCancels
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_AmplifierDataExport_RecurringBusinessCancels]
AS
BEGIN

DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME


SET @StartDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
SET @EndDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))


SELECT  46 AS 'ClientBrandID'
,       1205 AS 'SurveyType'
,       CTR.CenterSSID AS 'Location'
,       CLT.ClientIdentifier AS 'ClientContactID'
,       CLT.ClientFirstName AS 'FirstName'
,       CLT.ClientLastName AS 'LastName'
,       ISNULL(Phone.HomePhone, '') AS 'HomePhone'
,       ISNULL(Phone.WorkPhone, '') AS 'WorkPhone'
,       ISNULL(Phone.CellPhone, '') AS 'CellPhone'
,       ISNULL(CLT.ClientEMailAddress, '') AS 'Email'
,       CONVERT(VARCHAR(11), ISNULL(CLT.ClientDateOfBirth, ''), 101) AS 'Birthdate'
,       ISNULL(CLT.PostalCode, '') AS 'Zip'
,       ISNULL(LEFT(CLT.ClientGenderDescriptionShort, 1), '') AS 'Gender'
,       '' AS 'InquiryDate'
,       '' AS 'ScheduledBy'
,       '' AS 'ConsultServiceType'
,       '' AS 'ConsultDate'
,       '' AS 'ConsultantName'
,       '' AS 'ConsultCancellationDate'
,       M.MembershipDescription AS 'ServiceType'
,       CONVERT(VARCHAR(11), DD.FullDate, 101) AS 'ServiceDate'
,       ISNULL(EMP.EmployeeFirstName + ' ' + EMP.EmployeeLastName, '') AS 'ServiceProviderName'
,       '' AS 'ServiceRevenue'
,       '' AS 'LeadSource'
,       '' AS 'uservarchar1'
,       '' AS 'uservarchar2'
,       CLT.ClientEthinicityDescription AS 'uservarchar3'
,       '' AS 'uservarchar4'
,       '' AS 'userdate1'
,       Sales.DatePurchased AS 'userdate2'
,       '' AS 'userdate3'
,       '' AS 'userdate4'
,       '' AS 'userreal1'
,       '' AS 'userreal2'
,       '' AS 'userreal3'
,       '' AS 'userreal4'
FROM    HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FST.OrderDateKey = DD.DateKey
		INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
			ON FST.SalesCodeKey = DSC.SalesCodeKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
            ON FST.SalesOrderKey = SO.SalesOrderKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
            ON SO.ClientMembershipKey = CM.ClientMembershipKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
            ON CM.CenterKey = CTR.CenterKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
            ON FST.ClientKey = CLT.ClientKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
            ON CM.MembershipKey = M.MembershipKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee EMP
            ON FST.Employee1Key = EMP.EmployeeKey
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
        LEFT OUTER JOIN ( SELECT    ClientKey
                          ,         CASE WHEN ClientPhone1TypeDescriptionShort = 'Home' THEN ClientPhone1
                                         WHEN ClientPhone2TypeDescriptionShort = 'Home' THEN ClientPhone2
                                         WHEN ClientPhone3TypeDescriptionShort = 'Home' THEN ClientPhone3
                                    END AS 'HomePhone'
                          ,         CASE WHEN ClientPhone1TypeDescriptionShort = 'Work' THEN ClientPhone1
                                         WHEN ClientPhone2TypeDescriptionShort = 'Work' THEN ClientPhone2
                                         WHEN ClientPhone3TypeDescriptionShort = 'Work' THEN ClientPhone3
                                    END AS 'WorkPhone'
                          ,         CASE WHEN ClientPhone1TypeDescriptionShort = 'Mobile' THEN ClientPhone1
                                         WHEN ClientPhone2TypeDescriptionShort = 'Mobile' THEN ClientPhone2
                                         WHEN ClientPhone3TypeDescriptionShort = 'Mobile' THEN ClientPhone3
                                    END AS 'CellPhone'
                          FROM      HC_BI_CMS_DDS.bi_cms_dds.DimClient
                          WHERE     ClientPhone1 <> ''
                                    OR ClientPhone2 <> ''
                                    OR clientphone3 <> ''
                        ) Phone
            ON FST.ClientKey = Phone.ClientKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
        AND DSC.SalesCodeDepartmentSSID IN ( 1099 )
		AND M.RevenueGroupSSID = 2
        AND ( ISNULL(Phone.WorkPhone, '') <> ''
              OR ISNULL(Phone.HomePhone, '') <> ''
              OR ISNULL(Phone.CellPhone, '') <> '' )
		AND CONVERT(VARCHAR, CTR.CenterSSID) LIKE '[2]%'
        AND CTR.Active = 'Y'
		AND ISNULL(CLT.DoNotCallFlag, 0) = 0
		AND ISNULL(CLT.DoNotContactFlag, 0) = 0

END
GO
