/***********************************************************************
PROCEDURE:				spSvc_BarthActivitiesExport
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		04/10/2014
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_BarthActivitiesExport
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_BarthActivitiesExport]
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


/********************************** Get Activity Data *************************************/
SELECT  CTR.CenterSSID
,		CTR.CenterDescriptionNumber AS 'CenterDescription'
,		CAST(DC.ContactSSID AS VARCHAR(10)) AS 'LeadID'
,       REPLACE(DC.ContactFirstName, ',', ' ') AS 'FirstName'
,       REPLACE(DC.ContactLastName, ',', ' ') AS 'LastName'
,		DA.ActivitySSID AS 'ActivityID'
,		CONVERT(DATETIME, DA.ActivityDueDate, ( 108 )) + CONVERT(DATETIME, DA.ActivityStartTime, 114) AS 'ActivityDate'
,		DA.ActionCodeSSID
,		DA.ResultCodeSSID
,		DA.ActivityTypeSSID
,		DA.ActivityCompletionDate
,		DA.ActivityCompletionTime
,       CASE WHEN DST.SalesTypeSSID > 0 THEN DST.SalesTypeSSID
             ELSE NULL
        END AS 'SaleTypeID'
,       CASE WHEN DST.SalesTypeSSID > 0 THEN DST.SalesTypeDescription
             ELSE NULL
        END AS 'SalesTypeDescription'
,       DG.GenderKey
,       DG.GenderSSID
,       DG.GenderDescription AS 'Gender'
,       DMS.MaritalStatusKey
,       DMS.MaritalStatusSSID
,       DMS.MaritalStatusDescription AS 'MaritalStatus'
,       DE.EthnicityKey
,       DE.EthnicitySSID
,       DE.EthnicityDescription AS 'Ethnicity'
,       DO.OccupationKey
,       DO.OccupationSSID
,       DO.OccupationDescription AS 'Occupation'
,       DAR.AgeRangeKey
,       DAR.AgeRangeSSID
,       DAR.AgeRangeDescription AS 'Age'
,       DS.SourceKey
,       DS.SourceSSID AS 'Source'
,		DPC.PromotionCodeKey
,		DPC.PromotionCodeSSID AS 'PromotionCode'
,       DS.Media AS 'MediaType'
,       DS.Level02Location AS 'Location'
,       DS.Level03Language AS 'Language'
,       DS.Level04Format AS 'Format'
,       DS.Level05Creative AS 'Creative'
,       CASE WHEN LTRIM(RTRIM(dbo.FormatPhoneForMediaExport(DS.Number))) = '' THEN NULL
             ELSE LTRIM(RTRIM(dbo.FormatPhoneForMediaExport(DS.Number)))
        END AS '800 Number'
,		REPLACE(CONVERT(NVARCHAR(50), DAD.Performer), ',', '') AS 'Performer'
,       FAR.Appointments AS 'IsAppointment'
,		FAR.Consultation AS 'IsConsultation'
,		FAR.BeBack AS 'IsBeBack'
,       FAR.Show AS 'IsShow'
,       FAR.NoShow AS 'IsNoShow'
,       FAR.Sale AS 'IsSale'
,       FAR.NoSale AS 'IsNoSale'
FROM    HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity DA
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
			ON CTR.CenterSSID = DA.CenterSSID
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact DC
            ON DC.ContactSSID = DA.ContactSSID
		INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.FactLead FL
            ON FL.ContactKey = DC.ContactKey
		LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.FactActivityResults FAR
			ON FAR.ActivityKey = DA.ActivityKey
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSalesType DST
            ON FAR.SalesTypeKey = DST.SalesTypeKey
        LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimGender DG
            ON FAR.GenderKey = DG.GenderKey
        LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimMaritalStatus DMS
            ON FAR.MaritalStatusKey = DMS.MaritalStatusKey
        LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimEthnicity DE
            ON FAR.EthnicityKey = DE.EthnicityKey
        LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimOccupation DO
            ON FAR.OccupationKey = DO.OccupationKey
        LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAgeRange DAR
            ON FAR.AgeRangeKey = DAR.AgeRangeKey
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource DS
            ON FAR.SourceKey = DS.SourceKey
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimPromotionCode DPC
            ON FL.PromotionCodeKey = DPC.PromotionCodeKey
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivityDemographic DAD
            ON DA.ActivitySSID = DAD.ActivitySSID
WHERE	( DA.ActivityDueDate > DATEADD(DAY, -21, GETDATE())
			OR DA.ActivityCompletionDate > DATEADD(DAY, -21, GETDATE()) )
		AND DA.ActionCodeSSID IN ( 'APPOINT', 'BEBACK', 'INHOUSE', 'CONFIRM' )
		AND DA.ResultCodeSSID NOT IN ( 'PRANK' )
		AND CTR.CenterSSID IN ( 807, 804, 821, 745, 748, 806, 811, 805, 817, 746, 814, 747, 820, 822 )
ORDER BY CTR.CenterSSID
,		DA.ActivityDueDate
,		DA.ActivityStartTime

END
