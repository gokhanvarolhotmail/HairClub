/* CreateDate: 10/24/2017 12:57:01.650 , ModifyDate: 10/26/2017 14:00:46.610 */
GO
/***********************************************************************

PROCEDURE:				spsvc_MediaLeadUpdate_BI

VERSION:				v3.0

DESTINATION SERVER:		SQL05

DESTINATION DATABASE: 	HC_BI_MKTG_DDS

RELATED APPLICATION:  	SSIS WHSEXPIMSLeadExport

ORIGINAL AUTHOR:		Howard Abelow

IMPLEMENTOR: 			Kevin Murdoch

DATE IMPLEMENTED: 		10/05/2012

LAST REVISION DATE: 	10/24/2017

------------------------------------------------------------------------
NOTES:
10/05/2012	KM	Initial Implementation
03/20/2013  KM  Added in selection of update for Child tables as well as oncd_contact
10/31/2013	MB	Added LeadStatus to output and also lead status update date to the
				query clause (WO# 91631)
------------------------------------------------------------------------

SAMPLE EXECUTION:
EXEC spsvc_MediaLeadUpdate_ONCV
spsvc_MediaLeadUpdate_BI '03/20/2017', '03/20/2017'
***********************************************************************/

CREATE PROCEDURE [dbo].[spsvc_MediaLeadUpdate_BI](
@BegDt DATETIME = NULL,
@EndDt DATETIME = NULL
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
        IF ( @BegDt IS NULL
             OR @EndDt IS NULL
           )
            BEGIN
                SET @BegDt = DATEADD(dd, -1,CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
                SET @EndDt = DATEADD(dd, -1,CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
            END


		SELECT
			CAST(c.ContactSSID AS VARCHAR(10)) as 'RecordID',
			CONVERT(datetime, CONVERT(char(10),dd.FullDate, 101)) as 'Date',
			CONVERT(char(5),CONVERT(varchar,dt.Time24,108)) as 'Time',
			a.ZipCode as 'Zip',
			c.ContactGender as 'Gender',
			ISNULL(CAST(p.AreaCode AS VARCHAR(3)) + CAST(p.PhoneNumber AS VARCHAR(7)),9999999999) AS 'Phone',
			CASE WHEN ((LTRIM(RTRIM(c.ContactAlternateCenter))) IS NULL or (LTRIM(RTRIM(c.ContactAlternateCenter)))  = '' or (LTRIM(RTRIM(c.ContactAlternateCenter))) = 0)
				THEN CAST (dc.CenterSSID as char(10)) ELSE CAST (c.ContactAlternateCenter as char(10)) END AS 'Territory_Original',
			NULL AS 'Territory_Alternate',
			--CASE WHEN ((LTRIM(RTRIM(c.ContactAlternateCenter))) IS NOT NULL or (LTRIM(RTRIM(c.ContactAlternateCenter)))  <> ' ' or (LTRIM(RTRIM(c.ContactAlternateCenter)))  <> 0)
			--	THEN CAST (c.ContactAlternateCenter as char(10)) ELSE NULL END AS 'Territory_Alternate',
			so.SourceSSID as 'Source',
			LTRIM(RTRIM(dbo.FormatPhoneForMediaExport(SrcTbl.Number))) as '800 Number',
			CAST(c.ContactSSID AS VARCHAR(10))  as 'OldRecordID',
			--c.cst_sessionid as 'SessionID',
			c.ContactAffiliateID as 'AffiliateID',
			SrcTbl.Media as 'Media Type',
			SrcTbl.Level02Location as 'Location',
			SrcTbl.Level03Language as 'Language',
			SrcTbl.Level04Format as 'Format',
			SrcTbl.Level05Creative as 'Creative',
			ISNULL(c.ContactStatusSSID, 'LEAD') AS 'LeadStatus'
		FROM HC_BI_MKTG_DDS.bi_mktg_dds.DimContact c
			LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContactAddress a
				ON c.ContactSSID = a.ContactSSID AND a.PrimaryFlag = 'Y'
			LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimContactPhone p
				ON c.ContactSSID= p.ContactSSID AND p.PrimaryFlag = 'Y'
			LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.FactLead fl
				ON c.ContactKey = fl.ContactKey
			LEFT OUTER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter dc
				ON fl.CenterKey = dc.CenterKey
			LEFT OUTER JOIN HC_BI_ENT_DDS.bief_dds.DimDate dd
				ON fl.LeadCreationDateKey = dd.DateKey
			LEFT OUTER JOIN HC_BI_ENT_DDS.bief_dds.DimTimeOfDay dt
				ON fl.LeadCreationTimeKey = dt.TimeOfDayKey
			--LEFT OUTER JOIN [SQL05].HCM.dbo.oncd_company coa
			--	ON coa.company_id = cca.company_id
			LEFT OUTER JOIN HC_BI_MKTG_DDS.bi_mktg_dds.DimSource so
				ON fl.SourceKey = so.SourceKey
			LEFT OUTER JOIN [SQL05].[HC_BI_MKTG_DDS].bi_mktg_dds.DimSource SrcTbl
				ON UPPER(LTRIM(RTRIM(so.SourceSSID))) = UPPER(LTRIM(RTRIM(SrcTbl.[SourceSSID])))
		WHERE
		dd.FullDate BETWEEN @BegDt AND @EndDt + ' 23:59:59'
			--(
			--c.updated_date BETWEEN @BegDt AND @EndDt + ' 23:59:59'
			--or so.updated_date BETWEEN @BegDt AND @EndDt + ' 23:59:59'
			--or cca.updated_date BETWEEN @BegDt AND @EndDt + ' 23:59:59'
			--or cc.updated_date BETWEEN @BegDt AND @EndDt + ' 23:59:59'
			--or p.updated_date BETWEEN @BegDt AND @EndDt + ' 23:59:59'
			--OR c.status_updated_date BETWEEN @BegDt AND @EndDt + ' 23:59:59'
			--)
			--AND c.creation_date < @BegDt
		ORDER BY c.ContactSSID
	END
GO
