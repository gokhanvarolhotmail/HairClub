/* CreateDate: 04/04/2017 09:42:38.440 , ModifyDate: 06/10/2017 17:13:44.573 */
GO
/***********************************************************************
PROCEDURE:				spSvc_SilverpopClientLeadSMSConsentDailyExport
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
RELATED APPLICATION:	Silverpop Export
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		11/16/2016
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_SilverpopClientLeadSMSConsentDailyExport
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_SilverpopClientLeadSMSConsentDailyExport]
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME


SET @StartDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
SET @EndDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
SET @EndDate = @EndDate + ' 23:59:59'


/********************************** Create temp table objects *************************************/
CREATE TABLE #SMSPhone ( Phone1 NVARCHAR(15) )


CREATE TABLE #SMSConsent (
	Phone1 NVARCHAR(15)
,	[SMS Consent Status] NVARCHAR(50)
,   [SMS Consent Date] DATE
)


CREATE CLUSTERED INDEX IDX_SMSPhone_Phone1 ON #SMSPhone ( Phone1 )

CREATE CLUSTERED INDEX IDX_SMSConsent_Phone1 ON #SMSConsent ( Phone1 )


INSERT	INTO #SMSPhone
		SELECT  DISTINCT
				CASE WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CLM.Phone1)), '(', ''), ')', ''), '-', ''), ' ', ''), '.', '')) = 10
					 THEN '1' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CLM.Phone1)), '(', ''), ')', ''), '-', ''), ' ', ''), '.', '')
					 ELSE REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CLM.Phone1)), '(', ''), ')', ''), '-', ''), ' ', ''), '.', '')
				END AS 'Phone1'
		FROM    datClientLeadMerge CLM
		WHERE   REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CLM.Phone1)), '(', ''), ')', ''), '-', ''), ' ', ''), '.', '') <> ''
				AND ( CLM.CreateDate BETWEEN @StartDate AND @EndDate
						OR CLM.LastUpdate BETWEEN @StartDate AND @EndDate )


INSERT	INTO #SMSConsent
		SELECT	CASE WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CLM.Phone1)), '(', ''), ')', ''), '-', ''), ' ', ''), '.', '')) = 10
					 THEN '1' + REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CLM.Phone1)), '(', ''), ')', ''), '-', ''), ' ', ''), '.', '')
					 ELSE REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CLM.Phone1)), '(', ''), ')', ''), '-', ''), ' ', ''), '.', '')
				END AS 'Phone1'
		,       CASE WHEN ( CLM.DoNotContact = 1
							OR CLM.DoNotText = 1 ) THEN 'OPTED-OUT'
					 ELSE 'OPTED-IN'
				END AS 'SMS Consent Status'
		,       CASE WHEN CLM.RecordStatus = 'LEAD' THEN CLM.LeadCreateDate
					 ELSE CLM.ClientCreateDate
				END AS 'SMS Consent Date'
		FROM    datClientLeadMerge CLM
		WHERE   REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CLM.Phone1)), '(', ''), ')', ''), '-', ''), ' ', ''), '.', '') <> ''
				AND ( CLM.CreateDate BETWEEN @StartDate AND @EndDate
						OR CLM.LastUpdate BETWEEN @StartDate AND @EndDate )


SELECT  SP.Phone1
,       x_C.[SMS Consent Status]
,       CONVERT(VARCHAR(11), CAST(x_C.[SMS Consent Date] AS DATE), 101) AS 'SMS Consent Date'
FROM    #SMSPhone SP
        CROSS APPLY ( SELECT TOP 1
                                SC.Phone1
                      ,         SC.[SMS Consent Status]
                      ,         SC.[SMS Consent Date]
                      FROM      #SMSConsent SC
                      WHERE     SC.Phone1 = SP.Phone1
                      ORDER BY  SC.[SMS Consent Date] DESC
                    ) x_C
WHERE	ISNUMERIC(SP.Phone1) = 1
		AND LEN(SP.Phone1) = 11

END
GO
