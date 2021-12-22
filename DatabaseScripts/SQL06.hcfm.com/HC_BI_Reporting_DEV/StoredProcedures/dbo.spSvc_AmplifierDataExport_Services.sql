/* CreateDate: 06/16/2014 11:39:00.510 , ModifyDate: 11/14/2014 09:44:59.567 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSvc_AmplifierDataExport_Services
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

EXEC spSvc_AmplifierDataExport_Services
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_AmplifierDataExport_Services]
AS
BEGIN

DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME


SET @StartDate = DATEADD(dd, -2, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
SET @EndDate = DATEADD(dd, -2, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))


SELECT  46 AS 'ClientBrandID'
,       1203 AS 'SurveyType'
,       CTR.CenterSSID AS 'Location'
,       CLT.ClientIdentifier AS 'ClientContactID'
,       CLT.ClientFirstName AS 'FirstName'
,       CLT.ClientLastName AS 'LastName'
,       CASE WHEN CLT.Phone1TypeSSID = 1 THEN ISNULL(CLT.ClientPhone1, '')
             ELSE ''
        END AS 'HomePhone'
,       CASE WHEN CLT.Phone1TypeSSID = 2 THEN ISNULL(CLT.ClientPhone2, '')
             ELSE ''
        END AS 'WorkPhone'
,       CASE WHEN CLT.Phone1TypeSSID = 3 THEN ISNULL(CLT.ClientPhone3, '')
             ELSE ''
        END AS 'CellPhone'
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
,       CASE WHEN DM.MembershipDescription LIKE 'EXT%' THEN 'EXT 1st Service'
             ELSE 'Xtrands 1st Service'
        END AS 'ServiceType'
,       CONVERT(VARCHAR(11), MIN(DD.FullDate), 101) AS 'ServiceDate'
,       ISNULL(STY.EmployeeFirstName + ' ' + STY.EmployeeLastName, '') AS 'ServiceProviderName'
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
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
            ON FST.CenterKey = CTR.CenterKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
            ON FST.ClientKey = CLT.ClientKey
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
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
            ON DCM.CenterKey = DC.CenterKey
        INNER JOIN ( SELECT FST.ClientKey
                     ,      MIN(DD.FullDate) AS 'DatePurchased'
                     FROM   HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                            INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                                ON FST.OrderDateKey = DD.DateKey
                            INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
                                ON FST.SalesCodeKey = DSC.SalesCodeKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
								ON FST.SalesOrderKey = DSO.SalesOrderKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
								ON DSO.ClientMembershipSSID = DCM.ClientMembershipSSID
                     WHERE  DSC.SalesCodeDepartmentSSID = 1010
                     GROUP BY FST.ClientKey
                   ) Sales
            ON CLT.ClientKey = Sales.ClientKey
        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee STY
            ON FST.Employee2Key = STY.EmployeeKey
WHERE   ( DSC.SalesCodeDepartmentSSID IN ( 5035 )
          OR DSC.SalesCodeSSID IN ( 773 ) )
        AND DM.MembershipSSID NOT IN ( 13, 40, 41 )
        AND CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
        AND DC.Active = 'Y'
GROUP BY CTR.CenterSSID
,       CLT.ClientIdentifier
,       CLT.ClientFirstName
,       CLT.ClientLastName
,       CASE WHEN CLT.Phone1TypeSSID = 1 THEN ISNULL(CLT.ClientPhone1, '')
             ELSE ''
        END
,       CASE WHEN CLT.Phone1TypeSSID = 2 THEN ISNULL(CLT.ClientPhone2, '')
             ELSE ''
        END
,       CASE WHEN CLT.Phone1TypeSSID = 3 THEN ISNULL(CLT.ClientPhone3, '')
             ELSE ''
        END
,       ISNULL(CLT.ClientEMailAddress, '')
,       ISNULL(CLT.ClientDateOfBirth, '')
,       ISNULL(CLT.PostalCode, '')
,       ISNULL(LEFT(CLT.ClientGenderDescriptionShort, 1), '')
,       DM.MembershipDescription
,       ISNULL(STY.EmployeeFirstName + ' ' + STY.EmployeeLastName, '')
,       CLT.ClientEthinicityDescription
,       Sales.DatePurchased
HAVING  MIN(DD.FullDate) BETWEEN @StartDate AND @EndDate
UNION
SELECT  46 AS 'ClientBrandID'
,       1203 AS 'SurveyType'
,       CTR.CenterSSID AS 'Location'
,       CLT.ClientIdentifier AS 'ClientContactID'
,       CLT.ClientFirstName AS 'FirstName'
,       CLT.ClientLastName AS 'LastName'
,       CASE WHEN CLT.Phone1TypeSSID = 1 THEN ISNULL(CLT.ClientPhone1, '')
             ELSE ''
        END AS 'HomePhone'
,       CASE WHEN CLT.Phone1TypeSSID = 2 THEN ISNULL(CLT.ClientPhone2, '')
             ELSE ''
        END AS 'WorkPhone'
,       CASE WHEN CLT.Phone1TypeSSID = 3 THEN ISNULL(CLT.ClientPhone3, '')
             ELSE ''
        END AS 'CellPhone'
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
,       'New Style Day' AS 'ServiceType'
,       CONVERT(VARCHAR(11), DD.FullDate, 101) AS 'ServiceDate'
,       ISNULL(STY.EmployeeFirstName + ' ' + STY.EmployeeLastName, '') AS 'ServiceProviderName'
,       FST.ExtendedPrice AS 'ServiceRevenue'
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
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
            ON FST.CenterKey = CTR.CenterKey
        INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
            ON FST.ClientKey = CLT.ClientKey
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
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
            ON DCM.CenterKey = DC.CenterKey
        INNER JOIN ( SELECT FST.ClientKey
                     ,      MIN(DD.FullDate) AS 'DatePurchased'
                     FROM   HC_BI_CMS_DDS.bi_cms_dds.FactSalesTransaction FST
                            INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
                                ON FST.OrderDateKey = DD.DateKey
                            INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesCode DSC
                                ON FST.SalesCodeKey = DSC.SalesCodeKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder DSO
								ON FST.SalesOrderKey = DSO.SalesOrderKey
							INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
								ON DSO.ClientMembershipSSID = DCM.ClientMembershipSSID
                     WHERE  DSC.SalesCodeDepartmentSSID = 1010
                     GROUP BY FST.ClientKey
                   ) Sales
            ON CLT.ClientKey = Sales.ClientKey
        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee STY
            ON FST.Employee2Key = STY.EmployeeKey
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
        AND DSC.SalesCodeSSID IN ( 648 )
        AND CONVERT(VARCHAR, DC.CenterSSID) LIKE '[2]%'
        AND DC.Active = 'Y'
        AND ISNULL(CLT.DoNotCallFlag, 0) = 0
        AND ISNULL(CLT.DoNotContactFlag, 0) = 0

END
GO
