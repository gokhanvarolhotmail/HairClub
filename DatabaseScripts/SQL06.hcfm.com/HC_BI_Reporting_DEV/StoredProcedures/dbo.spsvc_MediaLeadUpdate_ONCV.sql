/* CreateDate: 10/05/2012 09:30:43.010 , ModifyDate: 10/31/2013 13:29:22.250 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				spsvc_MediaLeadUpdate_ONCV

VERSION:				v2.0

DESTINATION SERVER:		SQL05

DESTINATION DATABASE: 	HC_BI_MKTG_DDS

RELATED APPLICATION:  	SSIS WHSEXPIMSLeadExport

ORIGINAL AUTHOR:		Howard Abelow

IMPLEMENTOR: 			Kevin Murdoch

DATE IMPLEMENTED: 		10/05/2012

LAST REVISION DATE: 	10/05/2012

------------------------------------------------------------------------
NOTES:
10/05/2012	KM	Initial Implementation
03/20/2013  KM  Added in selection of update for Child tables as well as oncd_contact
10/31/2013	MB	Added LeadStatus to output and also lead status update date to the
				query clause (WO# 91631)
------------------------------------------------------------------------

SAMPLE EXECUTION:
EXEC spsvc_MediaLeadUpdate_ONCV
EXEC spsvc_MediaLeadUpdate_ONCV '03/20/2013', '03/20/2013'
***********************************************************************/

CREATE PROCEDURE [dbo].[spsvc_MediaLeadUpdate_ONCV](
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
			CAST(c.contact_id AS VARCHAR(10)) as 'RecordID',
			CONVERT(datetime, CONVERT(char(10),c.creation_date, 101)) as 'Date',
			CONVERT(char(5),CONVERT(varchar,c.creation_date,108)) as 'Time',
			a.zip_code as 'Zip',
			c.cst_gender_code as 'Gender',
			ISNULL(CAST(p.area_code AS VARCHAR(3)) + CAST(p.phone_number AS VARCHAR(7)),9999999999) AS 'Phone',
			CASE WHEN co.cst_center_number IS NULL THEN CAST (coa.cst_center_number as char(10)) ELSE CAST (co.cst_center_number as char(10)) END AS 'Territory_Original',
			CASE WHEN co.cst_center_number IS NOT NULL THEN CAST (coa.cst_center_number as char(10)) ELSE NULL END AS 'Territory_Alternate',
			so.source_code as 'Source',
			LTRIM(RTRIM(dbo.FormatPhoneForMediaExport(SrcTbl.Number))) as '800 Number',
			c.contact_id as 'OldRecordID',
			c.cst_sessionid as 'SessionID',
			c.cst_affiliateid as 'AffiliateID',
			SrcTbl.Media as 'Media Type',
			SrcTbl.Level02Location as 'Location',
			SrcTbl.Level03Language as 'Language',
			SrcTbl.Level04Format as 'Format',
			SrcTbl.Level05Creative as 'Creative'
			,	ISNULL(c.contact_status_code, 'LEAD') AS 'LeadStatus'
		FROM [SQL05].HCM.dbo.oncd_contact c
			LEFT OUTER JOIN [SQL05].HCM.dbo.oncd_contact_address a
				ON c.contact_id = a.contact_id and a.primary_flag = 'Y'
			LEFT OUTER JOIN [SQL05].HCM.dbo.oncd_contact_phone p
				ON c.contact_id = p.contact_id and p.primary_flag = 'Y'
			LEFT OUTER JOIN [SQL05].HCM.dbo.oncd_contact_company cc
				ON c.contact_id = cc.contact_id
					AND cc.primary_flag <> 'Y'
			LEFT OUTER JOIN [SQL05].HCM.dbo.oncd_contact_company cca
				ON c.contact_id = cca.contact_id
					AND cca.primary_flag = 'Y'
			LEFT OUTER JOIN [SQL05].HCM.dbo.oncd_company co
				ON co.company_id = cc.company_id
			LEFT OUTER JOIN [SQL05].HCM.dbo.oncd_company coa
				ON coa.company_id = cca.company_id
			LEFT OUTER JOIN [SQL05].HCM.dbo.oncd_contact_source so
				ON c.contact_id = so.contact_id
					AND so.primary_flag = 'Y'
			LEFT OUTER JOIN [SQL05].[HC_BI_MKTG_DDS].bi_mktg_dds.DimSource SrcTbl
				ON UPPER(LTRIM(RTRIM(so.source_code))) = UPPER(LTRIM(RTRIM(SrcTbl.[SourceSSID])))
		WHERE
			(
			c.updated_date BETWEEN @BegDt AND @EndDt + ' 23:59:59'
			or so.updated_date BETWEEN @BegDt AND @EndDt + ' 23:59:59'
			or cca.updated_date BETWEEN @BegDt AND @EndDt + ' 23:59:59'
			or cc.updated_date BETWEEN @BegDt AND @EndDt + ' 23:59:59'
			or p.updated_date BETWEEN @BegDt AND @EndDt + ' 23:59:59'
			OR c.status_updated_date BETWEEN @BegDt AND @EndDt + ' 23:59:59'
			)
			AND c.creation_date < @BegDt
	END
GO
