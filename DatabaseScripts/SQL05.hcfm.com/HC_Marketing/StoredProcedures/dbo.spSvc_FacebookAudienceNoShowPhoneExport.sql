/* CreateDate: 08/21/2018 15:07:57.877 , ModifyDate: 08/21/2018 15:07:57.877 */
GO
/***********************************************************************
PROCEDURE:				spSvc_FacebookAudienceNoShowPhoneExport
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		8/21/2018
DESCRIPTION:			8/21/2018
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_FacebookAudienceNoShowPhoneExport
***********************************************************************/
CREATE PROCEDURE spSvc_FacebookAudienceNoShowPhoneExport
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME


SET @StartDate = DATEADD(dd, -30, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
SET @EndDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))


SELECT  DISTINCT
        CASE WHEN ( LEN(LTRIM(RTRIM(CAST(pc.PhoneAbr__c AS CHAR(15))))) = 10 ) THEN '1' + LTRIM(RTRIM(CAST(pc.PhoneAbr__c AS CHAR(15))))
				ELSE LTRIM(RTRIM(CAST(pc.PhoneAbr__c AS CHAR(15))))
		END AS 'Phone'
FROM    HC_BI_SFDC.dbo.Task t
		INNER JOIN HC_BI_SFDC.dbo.Lead l
			ON l.Id = t.WhoId
		INNER JOIN HC_BI_SFDC.dbo.Phone__c pc
			ON pc.Lead__c = l.Id
WHERE   t.ActivityDate BETWEEN @StartDate AND  @EndDate + ' 23:59:59'
		AND t.Action__c IN ( 'Appointment', 'In House', 'Be Back' )
		AND ISNULL(t.Result__c, '') = 'No Show'
		AND t.IsDeleted = 0
		AND ( l.Status IN ( 'Lead', 'Client' ) AND l.IsDeleted = 0 )
		AND LEN(pc.PhoneAbr__c) IN ( 10, 11 )
		AND pc.PhoneAbr__c NOT IN ( '1111111111', '2222222222', '3333333333', '4444444444', '5555555555', '6666666666', '7777777777', '8888888888', '9999999999', '0000000000', '1000000000', '9999999998' )

END
GO
