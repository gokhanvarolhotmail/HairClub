/* CreateDate: 08/21/2018 14:47:29.113 , ModifyDate: 08/21/2018 14:52:03.683 */
GO
/***********************************************************************
PROCEDURE:				spSvc_FacebookAudienceLeadPhoneExport
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

EXEC spSvc_FacebookAudienceLeadPhoneExport
***********************************************************************/
CREATE PROCEDURE spSvc_FacebookAudienceLeadPhoneExport
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT ON;


DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME


SET @StartDate = DATEADD(dd, -30, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))
SET @EndDate = DATEADD(dd, -1, CAST(CONVERT(VARCHAR, GETDATE(), 10) AS DATETIME))


CREATE TABLE #DistinctLead (
	Id NVARCHAR(18)
)

CREATE TABLE #Phone (
	Lead__c NVARCHAR(18)
,	PhoneAbr__c NVARCHAR(50)
)


/********************************** Create temp table indexes *************************************/
CREATE NONCLUSTERED INDEX IDX_DistinctLead_Id ON #DistinctLead ( Id )
CREATE NONCLUSTERED INDEX IDX_Phone_Lead__c ON #Phone ( Lead__c )


-- Get Created/Updated Leads
INSERT	INTO #DistinctLead
		SELECT DISTINCT
				l.Id
		FROM    HC_BI_SFDC.dbo.Lead l
		WHERE   l.ReportCreateDate__c BETWEEN @StartDate AND @EndDate + ' 23:59:59'
				OR l.LastModifiedDate BETWEEN @StartDate AND @EndDate + ' 23:59:59'
				AND l.IsDeleted = 0
		UNION
		SELECT DISTINCT
				pc.Lead__c
		FROM    HC_BI_SFDC.dbo.Phone__c pc
		WHERE   pc.LastModifiedDate BETWEEN @StartDate AND @EndDate + ' 23:59:59'
				AND pc.IsDeleted = 0
		UNION
		SELECT DISTINCT
				ec.Lead__c
		FROM    HC_BI_SFDC.dbo.Email__c ec
		WHERE   ec.LastModifiedDate BETWEEN @StartDate AND @EndDate + ' 23:59:59'
				AND ec.IsDeleted = 0


-- Get Lead Phone Data
INSERT	INTO #Phone
		SELECT  dl.Id
		,		o_P.PhoneAbr__c
		FROM    #DistinctLead dl
				OUTER APPLY ( SELECT TOP 1
										pc.PhoneAbr__c
							  FROM      HC_BI_SFDC.dbo.Phone__c pc
							  WHERE     pc.Lead__c = dl.Id
										AND pc.Primary__c = 1
										AND pc.IsDeleted = 0
							  ORDER BY  pc.CreatedDate
							) o_P


-- Return Lead Phone Data
SELECT  DISTINCT
        CASE WHEN ( LEN(LTRIM(RTRIM(CAST(p.PhoneAbr__c AS CHAR(15))))) = 10 ) THEN '1' + LTRIM(RTRIM(CAST(p.PhoneAbr__c AS CHAR(15))))
				ELSE LTRIM(RTRIM(CAST(p.PhoneAbr__c AS CHAR(15))))
		END AS 'Phone'
FROM    #DistinctLead dl
		INNER JOIN HC_BI_SFDC.dbo.Lead l
			ON l.Id = dl.Id
		LEFT OUTER JOIN #Phone p
			ON p.Lead__c = dl.Id
WHERE	l.Status IN ( 'Lead', 'Client' )
		AND LEN(p.PhoneAbr__c) IN ( 10, 11 )
		AND p.PhoneAbr__c NOT IN ( '1111111111', '2222222222', '3333333333', '4444444444', '5555555555', '6666666666', '7777777777', '8888888888', '9999999999', '0000000000', '1000000000', '9999999998' )
		AND l.IsDeleted = 0

END
GO
