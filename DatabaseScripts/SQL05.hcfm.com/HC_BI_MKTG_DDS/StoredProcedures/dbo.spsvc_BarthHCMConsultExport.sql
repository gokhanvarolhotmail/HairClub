/* CreateDate: 06/25/2013 14:34:02.103 , ModifyDate: 06/25/2013 14:34:02.103 */
GO
/***********************************************************************

PROCEDURE:				[spsvc_BarthHCMConsultExport]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE:	HC_BI_Reporting

RELATED APPLICATION:	Barth CMS Export

AUTHOR:					Kevin Murdoch

IMPLEMENTOR:			Kevin Murdoch

DATE IMPLEMENTED:		06/25/2013

LAST REVISION DATE:		06/25/2013

------------------------------------------------------------------------
This procedure exports the days Consultations
------------------------------------------------------------------------

SAMPLE EXEC:
exec [spsvc_BarthHCMConsultExport]

***********************************************************************/
create PROCEDURE [dbo].[spsvc_BarthHCMConsultExport] AS
BEGIN

	SET NOCOUNT ON
	SET XACT_ABORT ON


	DECLARE @Startdate DATETIME
    DECLARE @Enddate DATETIME

	SET @startdate = CAST(GETDATE() AS DATE)
	SET @Enddate = '06/25/2013 23:59'

	SELECT
		LTRIM(RTRIM(co.cst_center_number)) + ' - '  + co.company_name_1 AS Center,
		a.activity_id AS 'Activity_ID',
		c.contact_id AS 'Contact_ID',
		dbo.[pCase](LTRIM(RTRIM(c.last_name))) AS 'Last_Name',
		dbo.[pCase](LTRIM(RTRIM(c.first_name))) As 'First_Name',
		a.due_date AS 'Appt_Date',
		a.start_time AS 'ApptStartTime',
		cs.source_code AS 'Source',
		pc.promotion_code As 'Promo',
		dbo.[pCase](c.cst_language_code) As 'Language',
		LTRIM(RTRIM(a.action_code)) AS 'action_code',
		LTRIM(RTRIM(a.result_code)) AS 'result_code'


	FROM SQL05.HCM.DBO.oncd_company co WITH(NOLOCK)
		INNER JOIN SQL05.HCM.DBO.oncd_contact_company cc WITH(NOLOCK)
			on cc.company_id = co.company_id
				AND cc.primary_flag = 'y'
		INNER JOIN SQL05.HCM.DBO.oncd_contact c WITH(NOLOCK)
			on cc.contact_id = c.contact_id
		INNER JOIN SQL05.HCM.DBO.oncd_activity_contact acon WITH(NOLOCK)
			on c.contact_id = acon.contact_id
		INNER JOIN SQL05.HCM.DBO.oncd_activity a WITH(NOLOCK)
			on acon.activity_id = a.activity_id AND a.due_date = @StartDate
					AND a.action_code IN ('APPOint', 'INHOUSE', 'BEBACK')
		LEFT JOIN SQL05.HCM.DBO.oncd_contact_company cp WITH(NOLOCK)
			ON cp.contact_id = c.contact_id
				AND cp.primary_flag = 'Y'
		LEFT JOIN SQL05.HCM.DBO.oncd_contact_source cs WITH(NOLOCK)
			ON cs.contact_id = c.contact_id
				AND cs.primary_flag = 'Y'
		LEFT JOIN SQL05.HCM.DBO.csta_promotion_code pc
			ON pc.promotion_code = c.cst_promotion_code
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter ctr
			ON co.cst_center_number = ctr.centerssid
		INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion reg
			ON ctr.RegionKey = reg.RegionKey
	WHERE reg.RegionDescriptionShort = 'BARTH'
	ORDER BY co.cst_center_number, a.start_time
END
GO
