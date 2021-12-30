/* CreateDate: 12/14/2015 11:55:07.573 , ModifyDate: 08/23/2018 09:56:23.903 */
GO
/***********************************************************************
PROCEDURE:				spSvc_BosleyReferralActivitiesExport
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HCM
RELATED APPLICATION:	Bosley Referrals Export
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		12/14/2015
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_BosleyReferralActivitiesExport NULL, NULL
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_BosleyReferralActivitiesExport]
(
	@StartDate DATETIME = NULL,
	@EndDate DATETIME = NULL
)
AS
BEGIN

SET NOCOUNT ON;
SET XACT_ABORT ON;


/********************************** Set Dates If Parameters are NULL *************************************/
IF ( @StartDate IS NULL OR @EndDate IS NULL )
   BEGIN
		SET @StartDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
		SET @EndDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
   END


SELECT  OCS.source_code AS 'ReferralPurpose'
,       ISNULL(OC.cst_siebel_id, '') AS 'SiebelID'
,       CASE WHEN CONVERT(VARCHAR, CLT.ClientIdentifier) IS NULL THEN ''
             ELSE CONVERT(VARCHAR, CLT.ClientIdentifier)
        END AS 'ConectID'
,       OC.contact_id AS 'OnContactID'
,       OC.first_name AS 'FirstName'
,       OC.last_name AS 'LastName'
,       'OnContact' AS 'HCSystem'
,       OA.activity_id AS 'HCSystemActivityID'
,       OA.due_date AS 'ActivityDateTime'
,       OA.creation_date AS 'CreatedDate'
,       'Consultation' AS 'ActivityClass'
,       'Consultation' AS 'ActivityType'
,       OA.action_code AS 'ActivityAction'
,       ISNULL(OA.result_code, '') AS 'ActivityResolution'
,       CASE ISNULL(OA.result_code, '')
          WHEN 'SHOWNOSALE' THEN 'Done'
          WHEN 'SHOWSALE' THEN 'Done'
          WHEN 'NOSHOW' THEN 'Cancelled'
          WHEN 'CANCEL' THEN 'Cancelled'
          WHEN 'RESCHEDULE' THEN 'Rescheduled'
          WHEN '' THEN 'Scheduled'
          ELSE ''
        END AS 'ActivityStatus'
,       ISNULL(CCC.contract_amount, 0) AS 'SaleAmount'
,       CASE WHEN ISNULL(OA.result_code, '') <> 'SHOWSALE' THEN ''
             ELSE CCC.sale_type_description
        END AS 'ProductSold'
,       CC.CenterDescription AS 'HCCenterName'
,       CC.CenterID AS 'HCCenterNumber'
,       ISNULL(CAD.performer, '') AS 'ConsultantSalesPerson'
,       '' AS 'MembershipID'
,       ISNULL(OCA.address_line_1, '') AS 'Address1'
,       ISNULL(OCA.address_line_2, '') AS 'Address2'
,       ISNULL(OCA.city, '') AS 'City'
,       ISNULL(OCA.state_code, '') AS 'State'
,       ISNULL(OCA.zip_code, '') AS 'Zip'
,       ISNULL(RTRIM(home_ph.area_code) + home_ph.phone_number, '') AS 'HomePhone'
,       ISNULL(RTRIM(cell_ph.area_code) + cell_ph.phone_number, '') AS 'CellPhone'
,       ISNULL(RTRIM(business_ph.area_code) + business_ph.phone_number, '') AS 'BusinessPhone'
,       ISNULL(OCE.email, '') AS 'Email'
FROM    HCM.dbo.oncd_activity OA
        INNER JOIN HCM.dbo.oncd_activity_contact OAC
            ON OAC.activity_id = OA.activity_id
        INNER JOIN HCM.dbo.oncd_contact OC
            ON OC.contact_id = OAC.contact_id
        INNER JOIN HCM.dbo.oncd_contact_company OCC
            ON OCC.contact_id = OC.contact_id
               AND OCC.primary_flag = 'Y'
        INNER JOIN HCM.dbo.oncd_company COM
            ON COM.company_id = OCC.company_id
		INNER JOIN HairClubCMS.dbo.cfgCenter CC
			ON CC.CenterID = COM.cst_center_number
        INNER JOIN HCM.dbo.oncd_contact_source OCS
            ON OCS.contact_id = OC.contact_id
               AND OCS.primary_flag = 'Y'
        LEFT OUTER JOIN HairClubCMS.dbo.datClient CLT
            ON CLT.ContactID = OC.contact_id
        LEFT OUTER JOIN HCM.dbo.oncd_contact_address OCA
            ON OCA.contact_id = OC.contact_id
               AND OCA.primary_flag = 'Y'
        LEFT OUTER JOIN HCM.dbo.cstd_contact_completion CCC
            ON CCC.contact_id = OC.contact_id
               AND CCC.activity_id = OA.activity_id
        LEFT OUTER JOIN HCM.dbo.cstd_activity_demographic CAD
            ON CAD.activity_id = OA.activity_id
        LEFT OUTER JOIN HCM.dbo.oncd_contact_email OCE
            ON OCE.contact_id = OC.contact_id
               AND OCE.primary_flag = 'Y'
        LEFT OUTER JOIN HCM.dbo.oncd_contact_phone home_ph
            ON home_ph.contact_id = OC.contact_id
               AND home_ph.phone_type_code = 'HOME'
               AND home_ph.primary_flag = 'Y'
        LEFT OUTER JOIN HCM.dbo.oncd_contact_phone cell_ph
            ON cell_ph.contact_id = OC.contact_id
               AND cell_ph.phone_type_code = 'CELL'
               AND cell_ph.primary_flag = 'Y'
        LEFT OUTER JOIN HCM.dbo.oncd_contact_phone business_ph
            ON business_ph.contact_id = OC.contact_id
               AND business_ph.phone_type_code = 'BUSINESS'
               AND business_ph.primary_flag = 'Y'
WHERE   OA.source_code LIKE 'BOS%'
		AND OC.last_name NOT LIKE '%(DUP)%'
        AND OA.completion_date BETWEEN @StartDate AND @EndDate + ' 23:59:59'
ORDER BY OC.contact_id
,		OA.due_date
,		OA.start_time

END
GO
