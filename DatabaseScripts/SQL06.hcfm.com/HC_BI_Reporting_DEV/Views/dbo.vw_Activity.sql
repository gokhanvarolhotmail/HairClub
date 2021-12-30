/* CreateDate: 09/06/2011 14:52:19.953 , ModifyDate: 08/20/2019 17:18:14.997 */
GO
/***********************************************************************
VIEW:					vw_Activity
DESTINATION SERVER:		SQL06
DESTINATION DATABASE: 	HC_BI_REPORTING
IMPLEMENTOR:			HDu
------------------------------------------------------------------------
NOTES:

09/01/2011 - HD - Initial Rewrite to SQL06.
03/28/2013 - KM - Added in restrictions to primary flag for email, address, phone.
01/11/2016 - RH - Changed to pull consultations from vwFactActivityResults (#122061)
08/20/2019 - RH - Changed joins to SFDC_LeadID; changed recordid to SFDC_LeadID
------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT top 10 * FROM dbo.vw_Activity WHERE recordid = '00Qf4000003uBGTEA2'
***********************************************************************/
CREATE VIEW [dbo].[vw_Activity]
AS


WITH Consult AS (SELECT FAR.ContactKey
		,	FAR.ActivityKey
		,	CASE WHEN FAR.Consultation = 1 THEN 1 ELSE 0 END AS 'IsConsultation'  --These values have been set in the view vwFactActivityResults - referrals have already been removed.
	FROM    HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				ON FAR.CenterKey = DC.CenterKey
			INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON FAR.ActivityDueDateKey = DD.DateKey
	WHERE   FAR.BeBack <> 1
		AND FAR.Show=1
	GROUP BY FAR.ContactKey
	,	FAR.ActivityKey
	,	FAR.Consultation)

SELECT  Center.CenterSSID 'Center'
,       DA.ActivitySSID 'act_key'
,       Contact.SFDC_LeadID 'recordid'
,       CONVERT(DATETIME, DA.ActivityDueDate) 'Date'
,       Employee.EmployeeFullName 'SalesPerson'
,       Employee.EmployeeSSID 'SalesPersonID'
,       Source.SourceSSID 'Source'
,       NULL 'SourceID'
,       ActionCode.ActionCodeSSID 'act_code'
,       ResultCode.ResultCodeSSID 'result_code'
,       Gender.GenderDescription 'Gender'
,       NULL 'GenderID'
,       Occupation.OccupationDescription 'Occupation'
,       NULL 'OccupationID'
,       Ethnicity.EthnicityDescription 'Ethnicity'
,       NULL 'EthnicityID'
,       MaritalStatus.MaritalStatusDescription 'MaritalStatus'
,       NULL 'MaritalStatusID'
,       AgeRange.AgeRangeDescription 'Age'
,       NULL 'AgeID'
,       ActivityType.ActivityTypeSSID 'Action'
,       NULL 'ActionID'
,       DA.IsAppointment 'IsAppointment'
,       DA.IsShow 'IsShow'
,       DA.IsSale 'IsSale'
,       ISNULL(Consult.IsConsultation,0) 'IsConsultation'
,       DA.IsBeBack 'IsBeBack'
,       NULL 'Timestamp'
,       NULL 'DateID'
,       NULL 'TimeID'
,       ActivityTime.Hour24 'Time'
,       Source.SourceSSID 'ActivitySource'
,       DA.PromotionCodeSSID 'cst_promotion_code'
		--Additional fields for the ActivityLead view
,       Activity.ActivityCompletedDateKey
,       Activity.ActivityCompletedTimeKey
FROM    HC_BI_MKTG_DDS.bi_mktg_dds.FactActivity Activity
		LEFT OUTER JOIN Consult
			ON Activity.ContactKey = Consult.ContactKey AND Activity.ActivityKey = Consult.ActivityKey
        INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwDimContact Contact
            ON Activity.ContactKey = Contact.ContactKey
		--May have multiple rows check later, maybe use PrimaryFlag to filter
        INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwDimContactPhone DCP
            ON Contact.SFDC_LeadID = DCP.SFDC_LeadID
               AND DCP.PrimaryFlag = 'Y'
		--May have multiple rows check later, maybe use PrimaryFlag to filter
        INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwDimContactAddress DCA
            ON Contact.SFDC_LeadID = DCA.SFDC_LeadID
               AND DCA.PrimaryFlag = 'Y'
		--May have multiple rows check later, maybe use PrimaryFlag to filter
        INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwDimContactEmail ContactEmail
            ON Contact.SFDC_LeadID = ContactEmail.SFDC_LeadID
               AND ContactEmail.PrimaryFlag = 'Y'
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity DA
            ON Activity.ActivityKey = DA.ActivityKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimCenter Center
            ON Activity.CenterKey = Center.CenterKey
        INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwDimEmployee Employee
            ON Activity.ActivityEmployeeKey = Employee.EmployeeKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimGender Gender
            ON Activity.GenderKey = Gender.GenderKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimEthnicity Ethnicity
            ON Activity.EthnicityKey = Ethnicity.EthnicityKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimOccupation Occupation
            ON Activity.OccupationKey = Occupation.OccupationKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimMaritalStatus MaritalStatus
            ON Activity.MaritalStatusKey = MaritalStatus.MaritalStatusKey
        INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.vwDimSource Source
            ON Activity.SourceKey = Source.SourceKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimAgeRange AgeRange
            ON Activity.AgeRangeKey = AgeRange.AgeRangeKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimDate ActivityDate
            ON Activity.ActivityDateKey = ActivityDate.DateKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.vwDimTimeOfDay ActivityTime
            ON Activity.ActivityTimeKey = ActivityTime.TimeOfDayKey
        LEFT OUTER JOIN [HC_BI_MKTG_DDS].bi_mktg_dds.DimActionCode ActionCode
            ON Activity.ActionCodeKey = ActionCode.ActionCodeKey
        LEFT OUTER JOIN [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimResultCode] ResultCode
            ON Activity.ResultCodeKey = ResultCode.ResultCodeKey
        LEFT OUTER JOIN [HC_BI_MKTG_DDS].[bi_mktg_dds].[DimActivityType] ActivityType
            ON Activity.ActivityTypeKey = ActivityType.ActivityTypeKey
GO
