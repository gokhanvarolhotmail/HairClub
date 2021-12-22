/***********************************************************************

PROCEDURE:				spsvc_IMSActivityExport_ONCV

VERSION:				v2.0

DESTINATION SERVER:		SQL05

DESTINATION DATABASE: 	HC_BI_MKTG_DDS

RELATED APPLICATION:  	SSIS WHSEXPIMSActivityExport

ORIGINAL AUTHOR: 		Howard Abelow

IMPLEMENTOR: 			Kevin Murdoch

DATE IMPLEMENTED: 		10/04/2007

LAST REVISION DATE: 	08/03/12

------------------------------------------------------------------------
NOTES: 		Gets the Activity Records for IMS Export
REVISIONS:	WJB 03/11/08 Added Sale Type to export
			KRM 11/02/09 Added to select statement - include specific
					result codes.
			KRM	4/28/11 Removed join to Xref file from previous version of Oncontact
			KRM 08/03/12 Moved over to SQL05
			KRM 03/15/16 Commented out > 04/01/2005
------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [spsvc_MediaActivityExport_ONCV]
EXEC spsvc_MediaActivityExport_ONCV  '1/12/2016', '1/12/2016'
***********************************************************************/

CREATE PROCEDURE [dbo].[spsvc_MediaActivityExport_ONCV]
    (
      @BegDt DATETIME = NULL
    , @EndDt DATETIME = NULL

    )
AS
    BEGIN
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
        SET NOCOUNT ON ;
--If you need to manually regenerate the export file, make the begDt and EndDt null
--This will allow you to temporarilly change the begdt and enddt to be more than -1
--days ago.
--set @BegDt = Null
--set @EndDt = null
--Check number of days back...
--SELECT DATEADD(dd, -2024,CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
        IF ( @BegDt IS NULL
             OR @EndDt IS NULL
           )
            BEGIN
                SET @BegDt = DATEADD(dd, -3, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
                SET @EndDt = DATEADD(dd, -3, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
            END


			SELECT
				CAST(dc.ContactSSID AS VARCHAR(10)) as 'RecordID',
				far.Appointments AS 'Appointment',
				CASE WHEN far.appointments >= 1 THEN dd.FullDate END AS 'Appointment_Date',
				far.Show as 'Show',
				CASE WHEN far.Show = 1 THEN dd.FullDate END AS 'Show_Date',
				far.Sale as 'Sale',
				CASE WHEN far.Sale = 1 THEN dd.fulldate END AS 'Sale_Date',
				ctr.CenterSSID AS 'Center',
				CAST(dc.ContactSSID AS VARCHAR(10)) as 'OldRecordID',
				src.SourceSSID AS 'ActivitySource',
				CASE WHEN st.SalesTypeSSID > 0 THEN st.SalesTypeSSID else null end AS 'SaleTypeID',
				gen.GenderDescription AS 'Gender',
				ms.MaritalStatusDescription AS 'MaritalStatus',
				et.EthnicityDescription AS 'Ethnicity',
				oc.OccupationDescription AS 'Occupation',
				age.AgeRangeDescription AS 'Age',
				SrcTbl.Media AS 'MediaType',
				SrcTbl.Level02Location AS 'Location',
				SrcTbl.Level03Language AS 'Language',
				SrcTbl.Level04Format AS 'Format',
				SrcTbl.Level05Creative AS 'Creative',
				CASE WHEN LTRIM(RTRIM(dbo.FormatPhoneForMediaExport(SrcTbl.Number))) = '' THEN NULL ELSE
					 LTRIM(RTRIM(dbo.FormatPhoneForMediaExport(SrcTbl.Number))) END AS '800 Number'
			 ,res.ResultCodeSSID
			 --,*
			FROM HC_BI_MKTG_DDS.bi_mktg_dds.FactActivityResults far
				--inner join HC_BI_MKTG_DDS.bi_mktg_dds.DimActivityResult dar
				--	on far.ActivityResultKey = dar.ActivityResultKey
				INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContact dc
					on far.ContactKey = dc.ContactKey
				INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.FactLead fl
					on far.ContactKey = fl.ContactKey
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
					on far.CenterKey = ctr.CenterKey
				INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource src
					on far.SourceKey = src.SourceKey
				INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
					on far.activityduedatekey = dd.datekey
				INNER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimResultCode res
					on far.ResultCodeKey = res.ResultCodeKey
				LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSalesType st
					on far.SalesTypeKey = st.SalesTypeKey
				LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimGender gen
					on far.GenderKey = gen.GenderKey
				LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimMaritalStatus ms
					on far.MaritalStatusKey = ms.MaritalStatusKey
				LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimEthnicity et
					on far.EthnicityKey = et.EthnicityKey
				LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimOccupation oc
					on far.OccupationKey = oc.OccupationKey
				LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimAgeRange age
					on far.AgeRangeKey = age.AgeRangeKey
				LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource SrcTbl
					on UPPER(LTRIM(RTRIM(src.SourceSSID))) = UPPER(LTRIM(RTRIM(SrcTbl.[SourceSSID])))
			WHERE dd.FullDate BETWEEN @BegDt AND @EndDt
					and (far.Show = 1 or far.Sale = 1 or far.Appointments = 1)
					and res.ResultCodeSSID in ('-2','NOSHOW','SHOWNOSALE','SHOWSALE','PRANK')
					--and fl.LeadCreationDateKey > 20050401

		END
