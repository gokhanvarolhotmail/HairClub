/* CreateDate: 09/06/2016 11:17:19.610 , ModifyDate: 03/28/2017 09:54:09.913 */
GO
/***********************************************************************
PROCEDURE:				spSvc_GetLeadTextMessageReminders
DESTINATION SERVER:		SQL05
DESTINATION DATABASE:	HC_Marketing
RELATED APP:			Message Media Text Message SSIS
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		09/06/2016
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spSvc_GetLeadTextMessageReminders ''
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_GetLeadTextMessageReminders]
(
	@SessionID NVARCHAR(100)
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


DECLARE @CurrentDate DATETIME
DECLARE @DateMin DATETIME
DECLARE @DateMax DATETIME


SET @CurrentDate = GETUTCDATE()


-- Get 24 Hour Reminders
SET @DateMin = DATEADD(HOUR, 25, DATEADD(HOUR, DATEDIFF(HOUR, 0, @CurrentDate), 0))
SET @DateMax = DATEADD(HOUR, 1, @DateMin)


INSERT  INTO datLeadMessageLog (
			TextMessageProcessID
        ,	SessionGUID
		,	BatchID
        ,	ContactID
		,	FirstName
		,	LastName
		,	ActivityID
        ,	ActivityDate
		,	ActivityDateUTC
        ,	PhoneNumber
        ,	LanguageCode
		,	CenterID
		,	CenterName
		,	AddressLine1
		,	AddressLine2
		,	City
		,	StateCode
		,	CountryCode
        ,	TextMessage
        ,	TextMessageStatusID
        ,	ErrorCode
        ,	ErrorVerbiage
        ,	IsReprocessFlag
        ,	CreateDate
        ,	CreateUser
        ,	LastUpdate
        ,	LastUpdateUser
		)
		SELECT  TMP.TextMessageProcessID
		,       @SessionID AS 'SessionID'
		,		-1 AS 'BatchID'
		,       OC.contact_id AS 'ContactID'
		,       LTRIM(RTRIM(OC.first_name)) AS 'FirstName'
		,       LTRIM(RTRIM(OC.last_name)) AS 'LastName'
		,       OA.activity_id AS 'ActivityID'
		,       ( OA.due_date + ' ' + OA.start_time ) AS 'ActivityDate'
		,       DATEADD(HOUR, -1 * ( CASE WHEN tz.[UsesDayLightSavingsFlag] = 0 THEN ( tz.[UTCOffset] )
										  WHEN DATEPART(WK, ( OA.due_date + ' ' + OA.start_time )) <= 10
											   OR DATEPART(WK, ( OA.due_date + ' ' + OA.start_time )) >= 45 THEN ( tz.[UTCOffset] )
										  ELSE ( ( tz.[UTCOffset] ) + 1 )
									 END ), ( OA.due_date + ' ' + OA.start_time )) AS 'ActivityDateUTC'
		,       CASE WHEN ( LEN(LTRIM(RTRIM(CAST(MT.phone AS CHAR(15))))) = 10 ) THEN '1' + LTRIM(RTRIM(CAST(MT.phone AS CHAR(15))))
					 ELSE LTRIM(RTRIM(CAST(MT.phone AS CHAR(15))))
				END AS 'PhoneNumber'
		,       CASE WHEN OA.cst_language_code IS NULL
						  OR LTRIM(RTRIM(OA.cst_language_code)) = '' THEN 'en-US'
					 ELSE LL.LanguageDescriptionShort
				END AS 'LanguageCode'
		,       CO.cst_center_number AS 'CenterID'
		,       LTRIM(RTRIM(CO.company_name_1)) AS 'CenterName'
		,       LTRIM(RTRIM(CA.address_line_1)) AS 'AddressLine1'
		,       LTRIM(RTRIM(CA.address_line_2)) AS 'AddressLine2'
		,       LTRIM(RTRIM(CA.city)) AS 'City'
		,       LTRIM(RTRIM(CA.state_code)) AS 'StateCode'
		,       CASE WHEN CA.country_code IS NULL
						  OR LTRIM(RTRIM(CA.country_code)) = '' THEN 'US'
					 ELSE LTRIM(RTRIM(CA.country_code))
				END AS 'CountryCode'
		,       FORMATMESSAGE(TM.TextMessage, FORMAT(OA.due_date, 'd', TM.LanguageCode), FORMAT(OA.start_time, 't', TM.LanguageCode), LTRIM(RTRIM(CA.city))) AS 'TextMessage'
		,       TMS.TextMessageStatusID
		,       NULL AS 'ErrorCode'
		,       NULL AS 'ErrorVerbiage'
		,       0 AS 'IsReprocessFlag'
		,       GETDATE() AS 'CreateDate'
		,       'LDText-HCM' AS 'CreateUser'
		,       GETDATE() AS 'LastUpdate'
		,       'LDText-HCM' AS 'LastUpdateUser'
		FROM    HCM.dbo.cstd_text_msg_temp MT WITH ( NOLOCK )
				INNER JOIN HCM.dbo.oncd_activity OA WITH ( NOLOCK )
					ON OA.activity_id = MT.appointment_activity_id
				INNER JOIN HCM.dbo.oncd_contact OC WITH ( NOLOCK )
					ON OC.contact_id = MT.contact_id
				INNER JOIN HCM.dbo.oncd_activity_company AC WITH ( NOLOCK )
					ON AC.activity_id = OA.activity_id
					   AND AC.primary_flag = 'Y'
				INNER JOIN HCM.dbo.oncd_company CO WITH ( NOLOCK )
					ON CO.company_id = AC.company_id
				INNER JOIN HCM.dbo.oncd_company_address CA ( NOLOCK )
					ON CA.company_id = CO.company_id
					   AND CA.primary_flag = 'Y'
				INNER JOIN HC_Marketing.dbo.lkpTextMessageProcess TMP
					ON TMP.TextMessageProcessDescriptionShort = '24HRLDTEXT'
						AND TMP.IsActiveFlag = 1
				INNER JOIN HC_Marketing.dbo.lkpTextMessageStatus TMS
					ON TMS.TextMessageStatusDescriptionShort = 'PENDING'
				LEFT OUTER JOIN HairClubCMS.dbo.lkpLanguage LL
					ON LL.OnContactLanguageCode = OA.cst_language_code
				INNER JOIN HC_Marketing.dbo.lkpTextMessage TM
					ON TM.TextMessageProcessID = TMP.TextMessageProcessID
					   AND TM.LanguageCode = ISNULL(LL.LanguageDescriptionShort, 'en-US')
					   AND TM.IsActiveFlag = 1
				INNER JOIN HairClubCMS.dbo.cfgCenter c
					ON c.CenterID = CAST(CO.cst_center_number AS INT)
				INNER JOIN HairClubCMS.dbo.lkpTimeZone tz
					ON tz.TimeZoneID = c.TimeZoneID
				OUTER APPLY ( SELECT TOP 1
										LML.LeadMessageLogID
							  ,         LML.ActivityID
							  ,         LML.ContactID
							  ,         LML.PhoneNumber
							  ,         LML.IsReprocessFlag
							  FROM      HC_Marketing.dbo.datLeadMessageLog LML
							  WHERE     LML.TextMessageProcessID = TMP.TextMessageProcessID
										AND LML.ActivityID = MT.appointment_activity_id
										AND LML.ContactID = MT.contact_id
							  ORDER BY  LML.CreateDate DESC
							) o_ML
		WHERE   MT.[action] = 'OPTIN'
				AND ( MT.[status] IS NULL OR LTRIM(RTRIM(ISNULL(MT.[status], ''))) = '' )
				AND LEN(LTRIM(RTRIM(CAST(MT.phone AS CHAR(15))))) IN ( 10, 11 )
				AND ( OC.do_not_solicit <> 'Y' OR OC.do_not_solicit IS NULL )
				AND ( OC.cst_dnc_flag <> 'Y' OR OC.cst_dnc_flag IS NULL )
				AND ( OC.cst_do_not_call <> 'Y' OR OC.cst_do_not_call IS NULL )
				AND ( OC.cst_do_not_text <> 'Y' OR OC.cst_do_not_text IS NULL )
				AND LTRIM(RTRIM(OA.action_code)) IN ( 'APPOINT', 'BEBACK', 'INHOUSE' )
				AND LTRIM(RTRIM(ISNULL(OA.result_code, ''))) = ''
				AND DATEADD(HOUR, -1 * ( CASE WHEN tz.[UsesDayLightSavingsFlag] = 0 THEN ( tz.[UTCOffset] )
										  WHEN DATEPART(WK, ( OA.due_date + ' ' + OA.start_time )) <= 10
											   OR DATEPART(WK, ( OA.due_date + ' ' + OA.start_time )) >= 45 THEN ( tz.[UTCOffset] )
										  ELSE ( ( tz.[UTCOffset] ) + 1 )
									 END ), ( OA.due_date + ' ' + OA.start_time )) >= @DateMin
				AND DATEADD(HOUR, -1 * ( CASE WHEN tz.[UsesDayLightSavingsFlag] = 0 THEN ( tz.[UTCOffset] )
										  WHEN DATEPART(WK, ( OA.due_date + ' ' + OA.start_time )) <= 10
											   OR DATEPART(WK, ( OA.due_date + ' ' + OA.start_time )) >= 45 THEN ( tz.[UTCOffset] )
										  ELSE ( ( tz.[UTCOffset] ) + 1 )
									 END ), ( OA.due_date + ' ' + OA.start_time )) < @DateMax
				AND ( o_ML.LeadMessageLogID IS NULL OR o_ML.IsReprocessFlag = 1 )


-- Get 2 Hour Reminders
SET @DateMin = DATEADD(HOUR, 2, DATEADD(HOUR, DATEDIFF(HOUR, 0, @CurrentDate), 0))
SET @DateMax = DATEADD(HOUR, 2, @DateMin)


INSERT  INTO datLeadMessageLog (
			TextMessageProcessID
        ,	SessionGUID
		,	BatchID
        ,	ContactID
		,	FirstName
		,	LastName
		,	ActivityID
        ,	ActivityDate
		,	ActivityDateUTC
        ,	PhoneNumber
        ,	LanguageCode
		,	CenterID
		,	CenterName
		,	AddressLine1
		,	AddressLine2
		,	City
		,	StateCode
		,	CountryCode
        ,	TextMessage
        ,	TextMessageStatusID
        ,	ErrorCode
        ,	ErrorVerbiage
        ,	IsReprocessFlag
        ,	CreateDate
        ,	CreateUser
        ,	LastUpdate
        ,	LastUpdateUser
		)
		SELECT  TMP.TextMessageProcessID
		,       @SessionID AS 'SessionID'
		,		-1 AS 'BatchID'
		,       OC.contact_id AS 'ContactID'
		,       LTRIM(RTRIM(OC.first_name)) AS 'FirstName'
		,       LTRIM(RTRIM(OC.last_name)) AS 'LastName'
		,       OA.activity_id AS 'ActivityID'
		,       OA.due_date + ' ' + OA.start_time AS 'ActivityDate'
		,       DATEADD(HOUR, -1 * ( CASE WHEN tz.[UsesDayLightSavingsFlag] = 0 THEN ( tz.[UTCOffset] )
										  WHEN DATEPART(WK, ( OA.due_date + ' ' + OA.start_time )) <= 10
											   OR DATEPART(WK, ( OA.due_date + ' ' + OA.start_time )) >= 45 THEN ( tz.[UTCOffset] )
										  ELSE ( ( tz.[UTCOffset] ) + 1 )
									 END ), ( OA.due_date + ' ' + OA.start_time )) AS 'ActivityDateUTC'
		,       CASE WHEN ( LEN(LTRIM(RTRIM(CAST(MT.phone AS CHAR(15))))) = 10 ) THEN '1' + LTRIM(RTRIM(CAST(MT.phone AS CHAR(15))))
					 ELSE LTRIM(RTRIM(CAST(MT.phone AS CHAR(15))))
				END AS 'PhoneNumber'
		,       CASE WHEN OA.cst_language_code IS NULL
						  OR LTRIM(RTRIM(OA.cst_language_code)) = '' THEN 'en-US'
					 ELSE LL.LanguageDescriptionShort
				END AS 'LanguageCode'
		,       CO.cst_center_number AS 'CenterID'
		,       LTRIM(RTRIM(CO.company_name_1)) AS 'CenterName'
		,       LTRIM(RTRIM(CA.address_line_1)) AS 'AddressLine1'
		,       LTRIM(RTRIM(CA.address_line_2)) AS 'AddressLine2'
		,       LTRIM(RTRIM(CA.city)) AS 'City'
		,       LTRIM(RTRIM(CA.state_code)) AS 'StateCode'
		,       CASE WHEN CA.country_code IS NULL
						  OR LTRIM(RTRIM(CA.country_code)) = '' THEN 'US'
					 ELSE LTRIM(RTRIM(CA.country_code))
				END AS 'CountryCode'
		,       FORMATMESSAGE(TM.TextMessage, FORMAT(OA.due_date, 'd', TM.LanguageCode), FORMAT(OA.start_time, 't', TM.LanguageCode), LTRIM(RTRIM(CA.city))) AS 'TextMessage'
		,       TMS.TextMessageStatusID
		,       NULL AS 'ErrorCode'
		,       NULL AS 'ErrorVerbiage'
		,       0 AS 'IsReprocessFlag'
		,       GETDATE() AS 'CreateDate'
		,       'LDText-HCM' AS 'CreateUser'
		,       GETDATE() AS 'LastUpdate'
		,       'LDText-HCM' AS 'LastUpdateUser'
		FROM    HCM.dbo.cstd_text_msg_temp MT WITH ( NOLOCK )
				INNER JOIN HCM.dbo.oncd_activity OA WITH ( NOLOCK )
					ON OA.activity_id = MT.appointment_activity_id
				INNER JOIN HCM.dbo.oncd_contact OC WITH ( NOLOCK )
					ON OC.contact_id = MT.contact_id
				INNER JOIN HCM.dbo.oncd_activity_company AC WITH ( NOLOCK )
					ON AC.activity_id = OA.activity_id
					   AND AC.primary_flag = 'Y'
				INNER JOIN HCM.dbo.oncd_company CO WITH ( NOLOCK )
					ON CO.company_id = AC.company_id
				INNER JOIN HCM.dbo.oncd_company_address CA ( NOLOCK )
					ON CA.company_id = CO.company_id
					   AND CA.primary_flag = 'Y'
				INNER JOIN HC_Marketing.dbo.lkpTextMessageProcess TMP
					ON TMP.TextMessageProcessDescriptionShort = '2HRLDTEXT'
						AND TMP.IsActiveFlag = 1
				INNER JOIN HC_Marketing.dbo.lkpTextMessageStatus TMS
					ON TMS.TextMessageStatusDescriptionShort = 'PENDING'
				LEFT OUTER JOIN HairClubCMS.dbo.lkpLanguage LL
					ON LL.OnContactLanguageCode = OA.cst_language_code
				INNER JOIN HC_Marketing.dbo.lkpTextMessage TM
					ON TM.TextMessageProcessID = TMP.TextMessageProcessID
					   AND TM.LanguageCode = ISNULL(LL.LanguageDescriptionShort, 'en-US')
					   AND TM.IsActiveFlag = 1
				INNER JOIN HairClubCMS.dbo.cfgCenter c
					ON c.CenterID = CAST(CO.cst_center_number AS INT)
				INNER JOIN HairClubCMS.dbo.lkpTimeZone tz
					ON tz.TimeZoneID = c.TimeZoneID
				OUTER APPLY ( SELECT TOP 1
										LML.LeadMessageLogID
							  ,         LML.ActivityID
							  ,         LML.ContactID
							  ,         LML.PhoneNumber
							  ,         LML.IsReprocessFlag
							  FROM      HC_Marketing.dbo.datLeadMessageLog LML
							  WHERE     LML.TextMessageProcessID = TMP.TextMessageProcessID
										AND LML.ActivityID = MT.appointment_activity_id
										AND LML.ContactID = MT.contact_id
							  ORDER BY  LML.CreateDate DESC
							) o_ML
		WHERE   MT.[action] = 'OPTIN'
				AND ( MT.[status] IS NULL OR LTRIM(RTRIM(ISNULL(MT.[status], ''))) = '' )
				AND LEN(LTRIM(RTRIM(CAST(MT.phone AS CHAR(15))))) IN ( 10, 11 )
				AND ( OC.do_not_solicit <> 'Y' OR OC.do_not_solicit IS NULL )
				AND ( OC.cst_dnc_flag <> 'Y' OR OC.cst_dnc_flag IS NULL )
				AND ( OC.cst_do_not_call <> 'Y' OR OC.cst_do_not_call IS NULL )
				AND ( OC.cst_do_not_text <> 'Y' OR OC.cst_do_not_text IS NULL )
				AND LTRIM(RTRIM(OA.action_code)) IN ( 'APPOINT', 'BEBACK', 'INHOUSE' )
				AND LTRIM(RTRIM(ISNULL(OA.result_code, ''))) = ''
				AND DATEADD(HOUR, -1 * ( CASE WHEN tz.[UsesDayLightSavingsFlag] = 0 THEN ( tz.[UTCOffset] )
										  WHEN DATEPART(WK, ( OA.due_date + ' ' + OA.start_time )) <= 10
											   OR DATEPART(WK, ( OA.due_date + ' ' + OA.start_time )) >= 45 THEN ( tz.[UTCOffset] )
										  ELSE ( ( tz.[UTCOffset] ) + 1 )
									 END ), ( OA.due_date + ' ' + OA.start_time )) >= @DateMin
				AND DATEADD(HOUR, -1 * ( CASE WHEN tz.[UsesDayLightSavingsFlag] = 0 THEN ( tz.[UTCOffset] )
										  WHEN DATEPART(WK, ( OA.due_date + ' ' + OA.start_time )) <= 10
											   OR DATEPART(WK, ( OA.due_date + ' ' + OA.start_time )) >= 45 THEN ( tz.[UTCOffset] )
										  ELSE ( ( tz.[UTCOffset] ) + 1 )
									 END ), ( OA.due_date + ' ' + OA.start_time )) < @DateMax
				AND ( o_ML.LeadMessageLogID IS NULL OR o_ML.IsReprocessFlag = 1 )


-- Update Batch ID
DECLARE @batchID int = 1;
DECLARE @rowCount int = 1;


WHILE @rowCount > 0
      BEGIN
            WITH    NextBatch
                      AS ( SELECT TOP 100
                                    *
                           FROM     datLeadMessageLog
                           WHERE    SessionGUID = @SessionID
                                    AND BatchID = -1
                         )
                 UPDATE datLeadMessageLog
                 SET    BatchID = @batchID
                 FROM   NextBatch
                        JOIN datLeadMessageLog
                            ON NextBatch.LeadMessageLogID = datLeadMessageLog.LeadMessageLogID;

            SET @rowCount = @@ROWCOUNT;
            SET @batchID = @batchID + 1;
      END


-- Return All Pending records for specific Session ID
SELECT  LML.LeadMessageLogID
,		LML.ActivityID
,		LML.PhoneNumber
,       LML.TextMessage
FROM    datLeadMessageLog LML
		INNER JOIN lkpTextMessageStatus TMS
			ON TMS.TextMessageStatusID = LML.TextMessageStatusID
WHERE   LML.SessionGUID = @SessionID
		AND TMS.TextMessageStatusDescriptionShort = 'PENDING'
ORDER BY LML.LeadMessageLogID

END
GO
