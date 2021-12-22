/* CreateDate: 10/12/2016 11:45:15.130 , ModifyDate: 10/12/2016 11:51:43.097 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSvc_GetFacebookAudienceNoSaleData
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_GetFacebookAudienceNoSaleData
***********************************************************************/
CREATE PROCEDURE spSvc_GetFacebookAudienceNoSaleData
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


TRUNCATE TABLE tmpFacebookAudienceNoSales


INSERT  INTO tmpFacebookAudienceNoSales (
			ContactID
        ,	EmailAddress
        ,	PhoneNumber
		)
		-- No Sales
		SELECT	OC.contact_id AS 'ContactID'
		,		ISNULL(LOWER(OCE.email), '') AS 'EmailAddress'
		,		ISNULL(LTRIM(RTRIM(OCP.area_code)) + LTRIM(RTRIM(OCP.phone_number)), '') AS 'PhoneNumber'
		FROM    SQL05.HCM.dbo.oncd_activity OA WITH (NOLOCK)
				INNER JOIN SQL05.HCM.dbo.oncd_activity_contact OAC WITH (NOLOCK)
					ON OAC.activity_id = OA.activity_id
				INNER JOIN SQL05.HCM.dbo.oncd_contact OC WITH (NOLOCK)
					ON OC.contact_id = OAC.contact_id
				LEFT OUTER JOIN SQL05.HCM.dbo.oncd_contact_phone OCP WITH (NOLOCK)
					ON OCP.contact_id = OC.contact_id
						AND OCP.primary_flag = 'Y'
				LEFT OUTER JOIN SQL05.HCM.dbo.oncd_contact_email OCE WITH (NOLOCK)
					ON OCE.contact_id = OC.contact_id
						AND OCE.primary_flag = 'Y'
		WHERE   OA.action_code IN ( 'APPOINT', 'BEBACK', 'INHOUSE' )
				AND OA.result_code  IN ( 'SHOWNOSALE' )
				AND ( OA.due_date >= DATEADD(DAY, -30, CONVERT(VARCHAR(11), GETDATE(), 101))
						AND OA.due_date < DATEADD(DAY, -0, CONVERT(VARCHAR(11), GETDATE(), 101))  )

END
GO
