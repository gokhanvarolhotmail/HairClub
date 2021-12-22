/****** Script Changes***************************************************************
CHANGE HISTORY:
01/08/2016 - RH - Changed FactActivityResult to vwFactActivityResult for Consultations
08/20/2019 - RH - Changed join on DimContact to SFDC_LeadID and join on DimActivityDemographic to SFDC_TaskID

SAMPLE EXECUTION:
select * from vwActivity where centerSSID = 234 and ActivityDate between '08/9/2019' and '08/20/2019' and ResultCode IN('SHOWSALE','SHOWNOSALE')

************************************************************************************/



CREATE VIEW [dbo].[vwActivity]
AS
SELECT  CTR.CenterSSID
,		CTR.CenterDescriptionNumber AS 'CenterDescription'
,		DC.SFDC_LeadID AS 'SFDC_LeadID'
,       REPLACE(DC.ContactFirstName, ',', ' ') AS 'FirstName'
,       REPLACE(DC.ContactLastName, ',', ' ') AS 'LastName'
,		ISNULL(DCA.ZipCode, '') AS 'ZipCode'
,		ISNULL(DCE.Email, '') AS 'EmailAddress'
,		'(' + DCP.AreaCode + ')' + ' ' + LEFT(DCP.PhoneNumber, 3) + '-' + RIGHT(DCP.PhoneNumber, 4) AS 'PhoneNumber'
,		DA.ActivitySSID AS 'RecordID'
,       CONVERT(DATETIME, DD.FullDate, ( 108 )) + CONVERT(DATETIME, DA.ActivityStartTime, 114) AS 'ActivityDate'
,       DA.ActionCodeSSID AS 'ActionCode'
,       CASE WHEN DRC.ResultCodeSSID = '-2' THEN NULL
             ELSE DRC.ResultCodeSSID
        END AS 'ResultCode'
,       CASE WHEN DST.SalesTypeSSID > 0 THEN DST.SalesTypeSSID
             ELSE NULL
        END AS 'SaleTypeID'
,       CASE WHEN DST.SalesTypeSSID > 0 THEN DST.SalesTypeDescription
             ELSE NULL
        END AS 'SalesTypeDescription'
,		ISNULL(DAD.PriceQuoted, 0) AS 'PriceQuoted'
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
,       DS.SourceSSID AS 'ActivitySource'
,       DS.Media AS 'MediaType'
,       DS.Level02Location AS 'Location'
,       DS.Level03Language AS 'Language'
,       DS.Level04Format AS 'Format'
,       DS.Level05Creative AS 'Creative'
,       CASE WHEN LTRIM(RTRIM(DS.Number)) = '' THEN NULL
             ELSE LTRIM(RTRIM(DS.Number))
        END AS 'TollFreeNumber'
,       FAR.Appointments AS 'IsAppointment'
,		FAR.Consultation AS 'IsConsultation'
,		FAR.BeBack AS 'IsBeBack'
,       FAR.Show AS 'IsShow'
,       FAR.NoShow AS 'IsNoShow'
,       FAR.Sale AS 'IsSale'
,       FAR.NoSale AS 'IsNoSale'
FROM    HC_BI_MKTG_DDS.bi_mktg_dds.vwFactActivityResults FAR
        INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate DD
            ON FAR.ActivityDueDateKey = DD.DateKey
        INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact DC
            ON FAR.ContactKey = dc.ContactKey
        INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.FactLead FL
            ON FAR.ContactKey = FL.ContactKey
        INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
            ON FAR.CenterKey = CTR.CenterKey
        INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimResultCode DRC
            ON FAR.ResultCodeKey = DRC.ResultCodeKey
        INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivity DA
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
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimActivityDemographic DAD
            ON DA.SFDC_TaskID = DAD.SFDC_TaskID
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContactAddress DCA
            ON DC.SFDC_LeadID = DCA.SFDC_LeadID
				AND DCA.PrimaryFlag = 'Y'
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContactEmail DCE
            ON DC.SFDC_LeadID = DCE.SFDC_LeadID
				AND DCE.PrimaryFlag = 'Y'
        LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContactPhone DCP
            ON DC.SFDC_LeadID = DCP.SFDC_LeadID
				AND DCP.PrimaryFlag = 'Y'
WHERE   DRC.ResultCodeSSID NOT IN ( 'PRANK' )
		AND CTR.CenterTypeSSID = 1
		AND CTR.Active = 'Y'
