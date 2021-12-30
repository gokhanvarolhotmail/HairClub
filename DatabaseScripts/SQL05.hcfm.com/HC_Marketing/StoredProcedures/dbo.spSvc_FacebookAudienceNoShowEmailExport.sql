/* CreateDate: 08/21/2018 15:07:22.890 , ModifyDate: 08/21/2018 15:07:22.890 */
GO
/***********************************************************************
PROCEDURE:				spSvc_FacebookAudienceNoShowEmailExport
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

EXEC spSvc_FacebookAudienceNoShowEmailExport
***********************************************************************/
CREATE PROCEDURE spSvc_FacebookAudienceNoShowEmailExport
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME


SET @StartDate = DATEADD(dd, -30, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
SET @EndDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))


SELECT  DISTINCT
		ISNULL(LOWER(ec.Name), '') AS 'Email'
FROM    HC_BI_SFDC.dbo.Task t
		INNER JOIN HC_BI_SFDC.dbo.Lead l
			ON l.Id = t.WhoId
		INNER JOIN HC_BI_SFDC.dbo.Email__c ec
			ON ec.Lead__c = l.Id
WHERE   t.ActivityDate BETWEEN @StartDate AND  @EndDate + ' 23:59:59'
		AND t.Action__c IN ( 'Appointment', 'In House', 'Be Back' )
		AND ISNULL(t.Result__c, '') = 'No Show'
		AND t.IsDeleted = 0
		AND ( l.Status IN ( 'Lead', 'Client' ) AND l.IsDeleted = 0 )
		AND ISNULL(LOWER(ec.Name), '') <> ''

END
GO
