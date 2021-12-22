/* CreateDate: 06/16/2014 11:38:51.440 , ModifyDate: 08/04/2014 09:43:21.317 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSvc_AmplifierDataExport_Shows
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

EXEC spSvc_AmplifierDataExport_Shows
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_AmplifierDataExport_Shows]
AS
BEGIN

DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME


SET @StartDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
SET @EndDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))


SELECT  46 AS 'ClientBrandID'
,       801 AS 'SurveyType'
,       CTR.CenterSSID AS 'Location'
,       ISNULL(CLT.ClientIdentifier, DC.ContactKey) AS 'ClientContactID'
,       DC.ContactFirstName AS 'FirstName'
,       DC.ContactLastName AS 'LastName'
,       ISNULL(DCP_Home.AreaCode + DCP_Home.PhoneNumber, '') AS 'HomePhone'
,       ISNULL(DCP_Work.AreaCode + DCP_Work.PhoneNumber, '') AS 'WorkPhone'
,       ISNULL(DCP_Cell.AreaCode + DCP_Cell.PhoneNumber, '') AS 'CellPhone'
,       ISNULL(DCE.Email, '') AS 'Email'
,       CONVERT(VARCHAR(11), ISNULL(DAG.Birthday, ''), 101) AS 'Birthdate'
,       ISNULL(DCA.ZipCode, '') AS 'Zip'
,       ISNULL(LEFT(DAG.GenderDescription, 1), '') AS 'Gender'
,       CONVERT(VARCHAR(11), DD_ActivityDate.FullDate, 101) AS 'InquiryDate'
,       ISNULL(DE_ScheduledBy.EmployeeFirstName + ' ' + DE_ScheduledBy.EmployeeLastName, '') AS 'ScheduledBy'
,       CASE WHEN ISNULL(DAG.SolutionOffered, '') = '' THEN DAR.SalesTypeDescription ELSE DAG.SolutionOffered END AS 'ConsultServiceType'
,       CONVERT(VARCHAR(11), DD_ActivityDueDate.FullDate, 101) AS 'ConsultDate'
,       ISNULL(CMS_EMP.EmployeeFirstName + ' ' + CMS_EMP.EmployeeLastName, '') AS 'ConsultantName'
,       '' AS 'ConsultCancellationDate'
,       '' AS 'ServiceType'
,       '' AS 'ServiceDate'
,       '' AS 'ServiceProviderName'
,       '' AS 'ServiceRevenue'
,       DS.SourceName AS 'LeadSource'
,       '' AS 'uservarchar1'
,       '' AS 'uservarchar2'
,       '' AS 'uservarchar3'
,       '' AS 'uservarchar4'
,       '' AS 'userdate1'
,       '' AS 'userdate2'
,       '' AS 'userdate3'
,       '' AS 'userdate4'
,       '' AS 'userreal1'
,       '' AS 'userreal2'
,       '' AS 'userreal3'
,       '' AS 'userreal4'
FROM    HC_BI_MKTG_DDS.bi_mktg_dds.FactActivityResults FAR
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
            ON FAR.CenterKey = CTR.CenterKey
        INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.FactActivity FA
            ON FAR.ActivityKey = FA.ActivityKey
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD_ActivityDate
            ON FAR.ActivityDateKey = DD_ActivityDate.DateKey
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD_ActivityDueDate
            ON FAR.ActivityDueDateKey = DD_ActivityDueDate.DateKey
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimEmployee DE_ScheduledBy
            ON FAR.ActivityEmployeeKey = DE_ScheduledBy.EmployeeKey
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimEmployee DE_CompletedBy
            ON FAR.CompletedByEmployeeKey = DE_CompletedBy.EmployeeKey
        INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact DC
            ON FAR.ContactKey = DC.ContactKey
        INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivityType DAT
            ON FA.ActivityTypeKey = DAT.ActivityTypeKey
        INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivityResult DAR
            ON FAR.ActivityResultKey = DAR.ActivityResultKey
        INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivityDemographic DAG
            ON DAR.ActivitySSID = DAG.ActivitySSID
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource DS
            ON FAR.SourceKey = DS.SourceKey
        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
            ON DC.ContactKey = CLT.contactkey
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContactPhone DCP_Home
            ON DC.ContactSSID = DCP_Home.ContactSSID
               AND DCP_Home.PhoneTypeCode = 'HOME'
               AND DCP_Home.PrimaryFlag = 'Y'
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContactPhone DCP_Cell
            ON DC.ContactSSID = DCP_Cell.ContactSSID
               AND DCP_Cell.PhoneTypeCode = 'Cell'
               AND DCP_Cell.PrimaryFlag = 'Y'
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContactPhone DCP_Work
            ON DC.ContactSSID = DCP_Work.ContactSSID
               AND DCP_Work.PhoneTypeCode = 'BUSINESS'
               AND DCP_Work.PrimaryFlag = 'Y'
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContactEmail DCE
            ON DC.ContactSSID = DCE.ContactSSID
               AND DCE.EmailTypeCode = 'HOME'
               AND DCE.PrimaryFlag = 'Y'
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContactAddress DCA
            ON DC.ContactSSID = DCA.ContactSSID
               AND DCA.AddressTypeCode = 'HOME'
               AND DCA.PrimaryFlag = 'Y'
        INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity DA
            ON FA.ActivityKey = DA.ActivityKey
        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimAppointment APPT
            ON DA.ActivitySSID = APPT.OnContactActivitySSID
        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactAppointmentEmployee FAE
            ON APPT.AppointmentKey = FAE.AppointmentKey
        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee CMS_EMP
            ON FAE.EmployeeKey = CMS_EMP.EmployeeKey
WHERE   DD_ActivityDueDate.FullDate BETWEEN @StartDate AND @EndDate
        AND FAR.Show = 1
		AND FAR.Sale = 1
		AND CONVERT(VARCHAR, CTR.CenterSSID) LIKE '[2]%'
		AND CTR.Active = 'Y'
        AND ( ISNULL(DCP_Home.AreaCode + DCP_Home.PhoneNumber, '') <> ''
              OR ISNULL(DCP_Work.AreaCode + DCP_Work.PhoneNumber, '') <> ''
              OR ISNULL(DCP_Cell.AreaCode + DCP_Cell.PhoneNumber, '') <> '' )
UNION
SELECT  46 AS 'ClientBrandID'
,       801 AS 'SurveyType'
,       CTR.CenterSSID AS 'Location'
,       ISNULL(CLT.ClientIdentifier, DC.ContactKey) AS 'ClientContactID'
,       DC.ContactFirstName AS 'FirstName'
,       DC.ContactLastName AS 'LastName'
,       ISNULL(DCP_Home.AreaCode + DCP_Home.PhoneNumber, '') AS 'HomePhone'
,       ISNULL(DCP_Work.AreaCode + DCP_Work.PhoneNumber, '') AS 'WorkPhone'
,       ISNULL(DCP_Cell.AreaCode + DCP_Cell.PhoneNumber, '') AS 'CellPhone'
,       ISNULL(DCE.Email, '') AS 'Email'
,       CONVERT(VARCHAR(11), ISNULL(DAG.Birthday, ''), 101) AS 'Birthdate'
,       ISNULL(DCA.ZipCode, '') AS 'Zip'
,       ISNULL(LEFT(DAG.GenderDescription, 1), '') AS 'Gender'
,       CONVERT(VARCHAR(11), DD_ActivityDate.FullDate, 101) AS 'InquiryDate'
,       ISNULL(DE_ScheduledBy.EmployeeFirstName + ' ' + DE_ScheduledBy.EmployeeLastName, '') AS 'ScheduledBy'
,       CASE WHEN ISNULL(DAG.SolutionOffered, '') = '' THEN DAR.SalesTypeDescription ELSE DAG.SolutionOffered END AS 'ConsultServiceType'
,       CONVERT(VARCHAR(11), DD_ActivityDueDate.FullDate, 101) AS 'ConsultDate'
,       ISNULL(CMS_EMP.EmployeeFirstName + ' ' + CMS_EMP.EmployeeLastName, '') AS 'ConsultantName'
,       '' AS 'ConsultCancellationDate'
,       '' AS 'ServiceType'
,       '' AS 'ServiceDate'
,       '' AS 'ServiceProviderName'
,       '' AS 'ServiceRevenue'
,       DS.SourceName AS 'LeadSource'
,       '' AS 'uservarchar1'
,       '' AS 'uservarchar2'
,       '' AS 'uservarchar3'
,       '' AS 'uservarchar4'
,       '' AS 'userdate1'
,       '' AS 'userdate2'
,       '' AS 'userdate3'
,       '' AS 'userdate4'
,       '' AS 'userreal1'
,       '' AS 'userreal2'
,       '' AS 'userreal3'
,       '' AS 'userreal4'
FROM    HC_BI_MKTG_DDS.bi_mktg_dds.FactActivityResults FAR
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
            ON FAR.CenterKey = CTR.CenterKey
        INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.FactActivity FA
            ON FAR.ActivityKey = FA.ActivityKey
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD_ActivityDate
            ON FAR.ActivityDateKey = DD_ActivityDate.DateKey
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD_ActivityDueDate
            ON FAR.ActivityDueDateKey = DD_ActivityDueDate.DateKey
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimEmployee DE_ScheduledBy
            ON FAR.ActivityEmployeeKey = DE_ScheduledBy.EmployeeKey
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimEmployee DE_CompletedBy
            ON FAR.CompletedByEmployeeKey = DE_CompletedBy.EmployeeKey
        INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact DC
            ON FAR.ContactKey = DC.ContactKey
        INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivityType DAT
            ON FA.ActivityTypeKey = DAT.ActivityTypeKey
        INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivityResult DAR
            ON FAR.ActivityResultKey = DAR.ActivityResultKey
        INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivityDemographic DAG
            ON DAR.ActivitySSID = DAG.ActivitySSID
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource DS
            ON FAR.SourceKey = DS.SourceKey
        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
            ON DC.ContactKey = CLT.contactkey
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContactPhone DCP_Home
            ON DC.ContactSSID = DCP_Home.ContactSSID
               AND DCP_Home.PhoneTypeCode = 'HOME'
               AND DCP_Home.PrimaryFlag = 'Y'
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContactPhone DCP_Cell
            ON DC.ContactSSID = DCP_Cell.ContactSSID
               AND DCP_Cell.PhoneTypeCode = 'Cell'
               AND DCP_Cell.PrimaryFlag = 'Y'
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContactPhone DCP_Work
            ON DC.ContactSSID = DCP_Work.ContactSSID
               AND DCP_Work.PhoneTypeCode = 'BUSINESS'
               AND DCP_Work.PrimaryFlag = 'Y'
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContactEmail DCE
            ON DC.ContactSSID = DCE.ContactSSID
               AND DCE.EmailTypeCode = 'HOME'
               AND DCE.PrimaryFlag = 'Y'
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContactAddress DCA
            ON DC.ContactSSID = DCA.ContactSSID
               AND DCA.AddressTypeCode = 'HOME'
               AND DCA.PrimaryFlag = 'Y'
        INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity DA
            ON FA.ActivityKey = DA.ActivityKey
        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimAppointment APPT
            ON DA.ActivitySSID = APPT.OnContactActivitySSID
        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.FactAppointmentEmployee FAE
            ON APPT.AppointmentKey = FAE.AppointmentKey
        LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee CMS_EMP
            ON FAE.EmployeeKey = CMS_EMP.EmployeeKey
WHERE   DD_ActivityDueDate.FullDate BETWEEN @StartDate AND @EndDate
        AND FAR.Show = 1
		AND FAR.NoSale = 1
		AND CONVERT(VARCHAR, CTR.CenterSSID) LIKE '[278]%'
		AND CTR.Active = 'Y'
        AND ( ISNULL(DCP_Home.AreaCode + DCP_Home.PhoneNumber, '') <> ''
              OR ISNULL(DCP_Work.AreaCode + DCP_Work.PhoneNumber, '') <> ''
              OR ISNULL(DCP_Cell.AreaCode + DCP_Cell.PhoneNumber, '') <> '' )
		AND DC.DoNotCallFlag = 'N'
		AND DC.DoNotEmailFlag = 'N'
		AND DC.DoNotSolicitFlag = 'N'

END
GO
