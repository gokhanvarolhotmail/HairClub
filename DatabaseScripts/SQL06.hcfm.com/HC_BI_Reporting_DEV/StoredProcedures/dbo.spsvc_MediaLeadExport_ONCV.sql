/* CreateDate: 09/26/2012 09:22:39.620 , ModifyDate: 03/14/2016 09:55:53.967 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				spsvc_IMSLeadExport_ONCV

VERSION:				v2.0

DESTINATION SERVER:		SQL05

DESTINATION DATABASE: 	HC_BI_MKTG_DDS

RELATED APPLICATION:  	SSIS WHSEXPIMSLeadExport

ORIGINAL AUTHOR:		Howard Abelow

IMPLEMENTOR: 			Kevin Murdoch

DATE IMPLEMENTED: 		10/04/2007

LAST REVISION DATE: 	08/15/2012

------------------------------------------------------------------------
NOTES: 		Gets the Lead Records for IMS Export
		11/2/09 MB Changed INNER JOIN to LEFT OUTER JOIN for the sources
			table in order to send ALL leads to IMS
		4/28/11 KM Removed reference to old recordID from previous version of Oncontact
		5/18/11 MB - Added function to replace any special characters from the Zip field (WO# 62793)
		06/21/11 MB - Changed procedure so that it did not reset the parameter values
						to NULL.  The procedure needs to either use the passed parameters
						or if none was passed, then use the default values
		08/03/12 KM - Modified Proc to run from new Server
		06/26/2013 KM - (#88063)Added Lead Status Code
------------------------------------------------------------------------

SAMPLE EXECUTION:
EXEC spsvc_MediaLeadExport_ONCV
EXEC spsvc_MediaLeadExport_ONCV '1/7/2013', '1/7/2013'
***********************************************************************/

CREATE PROCEDURE [dbo].[spsvc_MediaLeadExport_ONCV](
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
			SrcTbl.Level05Creative as 'Creative',
			ISNULL(c.contact_status_code, 'LEAD') AS 'LeadStatus'

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
		WHERE c.creation_date BETWEEN @BegDt AND @EndDt + ' 23:59:59'
	END
GO
