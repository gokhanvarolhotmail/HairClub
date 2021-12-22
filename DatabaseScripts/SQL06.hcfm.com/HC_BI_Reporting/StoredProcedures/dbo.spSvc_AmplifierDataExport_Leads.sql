/* CreateDate: 06/16/2014 11:39:13.363 , ModifyDate: 08/04/2014 09:41:21.583 */
GO
/***********************************************************************
PROCEDURE:				spSvc_AmplifierDataExport_Leads
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

EXEC spSvc_AmplifierDataExport_Leads
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_AmplifierDataExport_Leads]
AS
BEGIN

DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME


SET @StartDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
SET @EndDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))


SELECT  46 AS 'ClientBrandID'
,       1201 AS 'SurveyType'
,       CTR.CenterSSID AS 'Location'
,       ISNULL(CLT.ClientIdentifier, DC.ContactKey) AS 'ClientContactID'
,       REPLACE(DC.ContactFirstName, ',', ' ') AS 'FirstName'
,       REPLACE(DC.ContactLastName, ',', ' ') AS 'LastName'
,       ISNULL(DCP_Home.AreaCode + DCP_Home.PhoneNumber, '') AS 'HomePhone'
,       ISNULL(DCP_Work.AreaCode + DCP_Work.PhoneNumber, '') AS 'WorkPhone'
,       ISNULL(DCP_Cell.AreaCode + DCP_Cell.PhoneNumber, '') AS 'CellPhone'
,       ISNULL(DCE.Email, '') AS 'Email'
,       '' AS 'Birthdate'
,       ISNULL(DCA.ZipCode, '') AS 'Zip'
,       ISNULL(LEFT(DG.GenderDescription, 1), '') AS 'Gender'
,       CONVERT(VARCHAR(11), DD.FullDate, 101) AS 'InquiryDate'
,       '' AS 'ScheduledBy'
,       '' AS 'ConsultServiceType'
,       '' AS 'ConsultDate'
,       '' AS 'ConsultantName'
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
FROM    HC_BI_MKTG_DDS.bi_mktg_dds.FactLead FL
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FL.LeadCreationDateKey = DD.DateKey
        INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact DC
            ON FL.ContactKey = DC.ContactKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
            ON FL.CenterKey = CTR.CenterKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
			ON CTR.RegionKey = DR.RegionKey
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimTimeOfDay DTOD
            ON FL.LeadCreationTimeKey = DTOD.TimeOfDayKey
		LEFT OUTER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
            ON DC.ContactKey = CLT.contactkey
        LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimGender DG
            ON FL.GenderKey = DG.GenderKey
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource DS
            ON FL.SourceKey = DS.SourceKey
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
WHERE   DD.FullDate BETWEEN @StartDate AND @EndDate
        AND DC.ContactSSID NOT IN ( '0CBO1J3ITX', '0ZSGQ9WITX', '4GKD9USITX', 'ASO0GUZITX', 'E5568BCVP1', 'I094226ITX', 'N5H9LFXITX', 'WRA09ABITX' )
		AND CONVERT(VARCHAR, CTR.CenterSSID) LIKE '[2]%'
		AND CTR.Active = 'Y'
		AND DC.DoNotCallFlag = 'N'
		AND DC.DoNotEmailFlag = 'N'
		AND DC.DoNotSolicitFlag = 'N'

END
GO
