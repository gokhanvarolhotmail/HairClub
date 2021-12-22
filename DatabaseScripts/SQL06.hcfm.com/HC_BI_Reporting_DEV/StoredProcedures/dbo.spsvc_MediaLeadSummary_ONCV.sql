/* CreateDate: 09/26/2012 09:22:24.780 , ModifyDate: 06/11/2013 08:24:18.983 */
GO
/***********************************************************************

PROCEDURE:				spsvc_IMSLeadSummary_ONCV

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
------------------------------------------------------------------------

SAMPLE EXECUTION: EXEC spsvc_MediaLeadSummary_ONCV
							EXEC spsvc_MediaLeadSummary_ONCV '8/2/2012', '8/2/2012'

***********************************************************************/

CREATE PROCEDURE [dbo].[spsvc_MediaLeadSummary_ONCV]
    (
      --@BegDt DATETIME = NULL,
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
        IF ( @EndDt IS NULL
           )
            BEGIN
                SET @EndDt = DATEADD(dd, -1,
                                     CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
            END


		SELECT
			COUNT(c.contact_id) as 'Leads',
			CONVERT(datetime, CONVERT(char(10),c.creation_date, 101)) as 'Date',
			so.source_code as 'Source',
			CASE WHEN LTRIM(RTRIM(dbo.FormatPhoneForMediaExport(SrcTbl.Number))) = ''
				THEN NULL ELSE
					LTRIM(RTRIM(dbo.FormatPhoneForMediaExport(SrcTbl.Number)))
						END as '800 Number'
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

			CONVERT(datetime, CONVERT(char(10),c.creation_date, 101)) = @EndDt

		GROUP BY
			CONVERT(datetime, CONVERT(char(10),c.creation_date, 101)),
			so.source_code,
			LTRIM(RTRIM(dbo.FormatPhoneForMediaExport(SrcTbl.Number)))

			UNION

		SELECT
			COUNT(c.contact_id) as Leads
		,	@EndDt
		,	'zzz: TOTAL LEADS'
		,	'n/a'
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

		WHERE CONVERT(datetime, CONVERT(char(10),c.creation_date, 101)) = @EndDt
		ORDER BY so.source_code

		--order by c.contact_id
	END
GO
