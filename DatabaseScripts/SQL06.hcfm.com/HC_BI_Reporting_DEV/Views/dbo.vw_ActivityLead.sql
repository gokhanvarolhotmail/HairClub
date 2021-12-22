/* CreateDate: 09/06/2011 15:17:40.610 , ModifyDate: 05/20/2014 09:50:09.307 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					vw_ActivityLead
DESTINATION SERVER:		SQL06
DESTINATION DATABASE: 	HC_BI_REPORTING
IMPLEMENTOR:			HDu
------------------------------------------------------------------------
NOTES:

09/06/2011 - HD - Initial Rewrite to SQL06.
------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM dbo.vw_ActivityLead WHERE ActRecordID = '000QFTKITX'
***********************************************************************/
CREATE VIEW [dbo].[vw_ActivityLead]
AS
SELECT  Activity.Center AS 'ActCenter'
,       Activity.act_key AS 'ActKey'
,       Activity.recordid AS 'ActRecordID'
,       CONVERT(DATETIME, Activity.Date) AS 'ActDate'
,       Activity.Time AS 'ActTime'
,       Activity.SalesPerson AS 'ActSalesPerson'
,       Activity.ActivitySource AS 'ActSource'
,       Activity.act_code AS 'ActionCode'
,       Activity.result_code AS 'Result'
,       Activity.Action AS 'ActionType'
,       Activity.IsAppointment AS 'ActIsAppt'
,       Activity.IsShow AS 'ActIsShow'
,       Activity.IsSale AS 'ActIsSale'
,       Activity.IsBeBack AS 'ActIsBeback'
,       Activity.IsConsultation AS 'ActIsConsult'
,       Activity.[Date] AS 'ActCreateDate'
,       Activity.SalesPersonID AS 'ActCreateBy'
,       CompletedDate.FullDate AS 'ActCompletionDate'
,       CompletedTime.[Time24] AS 'ActCompletionTime'
,       Activity.[Action] AS 'ActCstActivityType'
,       Lead.Center AS 'LeadCenter'
,       Lead.RecordID AS 'LeadRecordID'
,       Lead.FirstName
,       Lead.LastName
,       Lead.Address1
,       Lead.Address2
,       Lead.City
,       Lead.State
,       Lead.Zip
,       Lead.Phone
,       Lead.Territory_Original AS 'LeadPrimaryCtr'
,       Lead.Territory_Alternate AS 'LeadAltCtr'
,       Lead.SalesPerson AS 'LeadSalesPerson'
,       Lead.Gender AS 'ActGender'
,       Lead.Occupation
,       Lead.Ethnicity
,       Lead.Norwood
,       Lead.Ludwig
,       Lead.Source AS 'LeadSource'
,       Lead.Age
,       Lead.Date AS 'LeadCreateDate'
,       Lead.Time AS 'LeadCreateTime'
,       Lead.Appointment AS 'LeadIsAppt'
,       Lead.Appointment_Date AS 'LeadApptDate'
,       Lead.Show AS 'LeadIsShow'
,       Lead.Show_Date AS 'LeadShowDate'
,       Lead.Sale AS 'LeadIsSale'
,       Lead.Sale_Date AS 'LeadSaleDate'
,       Lead.adi_flag AS 'AdiFlag'
,       Lead.contact_status_code AS 'LeadStatusCode'
,       Lead.cst_affiliateid AS 'AffiliateId'
,       Lead.cst_sessionid AS 'SessionId'
,       Lead.Email
,       Lead.cst_language_code AS 'Language'
,       Activity.cst_promotion_code AS 'PromotionCode'
FROM    dbo.vw_Activity Activity
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimDate CompletedDate
            ON Activity.ActivityCompletedDateKey = CompletedDate.DateKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimTimeOfDay CompletedTime
            ON Activity.ActivityCompletedTimeKey = CompletedTime.TimeOfDayKey
        LEFT OUTER JOIN dbo.vw_Lead Lead
            ON Activity.recordid = Lead.RecordID
GO
