/* CreateDate: 06/19/2014 15:38:56.640 , ModifyDate: 08/20/2019 17:27:27.473 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					vw_Shows
DESTINATION SERVER:		SQL06
DESTINATION DATABASE: 	HC_BI_REPORTING
IMPLEMENTOR:			DL
------------------------------------------------------------------------
CHANGE HISTORY:
08/20/2019 - RH - Changed join on DimContactPhone to SFDC_LeadID and join on DimActivityDemographic to SFDC_TaskID
------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM dbo.vw_Shows WHERE ActivityDate BETWEEN '8/1/2019' AND '8/20/2019'
***********************************************************************/
CREATE VIEW [dbo].[vw_Shows]
AS
SELECT  CTR.CenterSSID AS 'CenterID'
,		CTR.CenterDescriptionNumber AS 'CenterName'
,       DC.SFDC_LeadID AS 'SFDC_LeadID'
,       DC.ContactFirstName AS 'FirstName'
,       DC.ContactLastName AS 'LastName'
,       ISNULL(DCP_Home.AreaCode + DCP_Home.PhoneNumber, '') AS 'HomePhone'
,       ISNULL(DCP_Work.AreaCode + DCP_Work.PhoneNumber, '') AS 'WorkPhone'
,       ISNULL(DCP_Cell.AreaCode + DCP_Cell.PhoneNumber, '') AS 'CellPhone'
,       ISNULL(DCE.Email, '') AS 'Email'
,       CONVERT(VARCHAR(11), ISNULL(DAG.Birthday, ''), 101) AS 'Birthdate'
,       ISNULL(DCA.ZipCode, '') AS 'Zip'
,       ISNULL(LEFT(DAG.GenderDescription, 1), '') AS 'Gender'
,       DD_ActivityDueDate.FullDate AS 'ActivityDate'
,		DA.ActionCodeSSID AS 'ActionCode'
,		DA.ResultCodeSSID AS 'ResultCode'
,       CASE WHEN ISNULL(DAG.SolutionOffered, '') = '' THEN DAR.SalesTypeDescription ELSE DAG.SolutionOffered END AS 'SolutionOffered'
,		ISNULL(DAG.PriceQuoted, 0) AS 'PriceQuoted'
,		DAG.EthnicityDescription AS 'Ethnicity'
,		DAG.Age
,		FAR.Sale
,		FAR.NoSale
FROM    HC_BI_MKTG_DDS.bi_mktg_dds.FactActivityResults FAR
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
            ON FAR.CenterKey = CTR.CenterKey
        INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.FactActivity FA
            ON FAR.ActivityKey = FA.ActivityKey
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD_ActivityDate
            ON FAR.ActivityDateKey = DD_ActivityDate.DateKey
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD_ActivityDueDate
            ON FAR.ActivityDueDateKey = DD_ActivityDueDate.DateKey
        INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact DC
            ON FAR.ContactKey = DC.ContactKey
        INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivityType DAT
            ON FA.ActivityTypeKey = DAT.ActivityTypeKey
        INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivityResult DAR
            ON FAR.ActivityResultKey = DAR.ActivityResultKey
        INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivityDemographic DAG
            ON DAR.SFDC_TaskID = DAG.SFDC_TaskID
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContactPhone DCP_Home
            ON DC.SFDC_LeadID = DCP_Home.SFDC_LeadID
               AND DCP_Home.PhoneTypeCode = 'HOME'
               AND DCP_Home.PrimaryFlag = 'Y'
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContactPhone DCP_Cell
            ON DC.SFDC_LeadID = DCP_Cell.SFDC_LeadID
               AND DCP_Cell.PhoneTypeCode = 'Cell'
               AND DCP_Cell.PrimaryFlag = 'Y'
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContactPhone DCP_Work
            ON DC.SFDC_LeadID = DCP_Work.SFDC_LeadID
               AND DCP_Work.PhoneTypeCode = 'BUSINESS'
               AND DCP_Work.PrimaryFlag = 'Y'
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContactEmail DCE
            ON DC.SFDC_LeadID = DCE.SFDC_LeadID
               AND DCE.EmailTypeCode = 'HOME'
               AND DCE.PrimaryFlag = 'Y'
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContactAddress DCA
            ON DC.SFDC_LeadID = DCA.SFDC_LeadID
               AND DCA.AddressTypeCode = 'HOME'
               AND DCA.PrimaryFlag = 'Y'
        INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity DA
            ON FA.ActivityKey = DA.ActivityKey
WHERE   FAR.Show = 1
		AND CONVERT(VARCHAR, CTR.CenterSSID) LIKE '[2]%'
		AND CTR.Active = 'Y'
        AND ( ISNULL(DCP_Home.AreaCode + DCP_Home.PhoneNumber, '') <> ''
              OR ISNULL(DCP_Work.AreaCode + DCP_Work.PhoneNumber, '') <> ''
              OR ISNULL(DCP_Cell.AreaCode + DCP_Cell.PhoneNumber, '') <> '' )
GO
