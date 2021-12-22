/* CreateDate: 10/12/2016 11:42:34.053 , ModifyDate: 10/12/2016 11:52:55.390 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spSvc_GetFacebookAudienceLeadData
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

EXEC spSvc_GetFacebookAudienceLeadData
***********************************************************************/
CREATE PROCEDURE spSvc_GetFacebookAudienceLeadData
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


TRUNCATE TABLE tmpFacebookAudienceLeads


INSERT  INTO tmpFacebookAudienceLeads (
			ContactID
        ,	EmailAddress
        ,	PhoneNumber
		)
		-- Leads
		SELECT  VL.RecordID AS 'ContactID'
		,		ISNULL(LOWER(VL.Email), '') AS 'EmailAddress'
		,		ISNULL(VL.Phone, '') AS 'PhoneNumber'
		FROM    HC_BI_Reporting.dbo.vw_Lead VL
		WHERE   VL.contact_status_code = 'LEAD'
				AND ( VL.Phone NOT IN ( '1111111111', '2222222222', '3333333333', '4444444444', '5555555555', '6666666666', '7777777777', '8888888888', '9999999999', '0000000000', '1000000000', '9999999998' )
						OR VL.Email LIKE '%@%' )
				AND ( VL.Sale = 0 OR VL.Sale IS NULL )
				AND ( VL.Appointment_Date < DATEADD(dd, 7, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME)) OR VL.Appointment_Date IS NULL )

END
GO
