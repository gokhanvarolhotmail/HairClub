/* CreateDate: 12/04/2017 15:19:59.033 , ModifyDate: 06/16/2020 13:24:06.173 */
GO
/***********************************************************************
PROCEDURE:				spSvc_GetClientEmailMessageReminders
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

EXEC spSvc_GetClientEmailMessageReminders ''
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_GetClientEmailMessageReminders]
(
	@SessionID NVARCHAR(100)
)
AS
BEGIN

SET FMTONLY OFF;
SET NOCOUNT OFF;


DECLARE @CurrentDate DATE
,		@TargetDate AS DATE;


DECLARE @Center AS TABLE (
	CenterID INT
,	CenterName NVARCHAR(50)
,	CenterType NVARCHAR(10)
,	RegionID INT
,	RegionName NVARCHAR(100)
,	Address1 NVARCHAR(50)
,   Address2 NVARCHAR(50)
,   City NVARCHAR(50)
,   StateCode NVARCHAR(10)
,   ZipCode NVARCHAR(15)
,   Country NVARCHAR(100)
,	PhoneNumber NVARCHAR(15)
,	ManagingDirector NVARCHAR(102)
,	ManagingDirectorEmail NVARCHAR(100)
)

DECLARE @tmpRecords AS TABLE (
	Appointment_Guid [NVARCHAR](50) NULL
,	Appointment_Date [DATE] NULL
,	Appointment_Time [TIME] NULL
,	Client_ID INT NULL
,	Client_First [NVARCHAR](50) NULL
,	Client_Last [NVARCHAR](50) NULL
,	Client_Email [NVARCHAR](100) NOT NULL
,	Client_Gender [NVARCHAR](10) NOT NULL
,	Client_Phone [NVARCHAR](15) NULL
,	Center_ID [INT] NULL
,	Center_Number [INT] NULL
,	Center_Address_1 [NVARCHAR](50) NULL
,	Center_Address_2 [NVARCHAR](50) NULL
,	Center_City [NVARCHAR](50) NULL
,	Center_State [NVARCHAR](10) NULL
,	Center_Zip [NVARCHAR](10) NULL
,	Center_Phone [NVARCHAR](15) NULL
,	Center_Time_Zone [NVARCHAR](10) NULL
,	Employee_1_First_Name [NVARCHAR](50) NULL
,	Employee_1_Last_Name [NVARCHAR](50) NULL
,	Employee_1_Position [NVARCHAR](10) NULL
,	Employee_2_First_Name [NVARCHAR](50) NULL
,	Employee_2_Last_Name [NVARCHAR](50) NULL
,	Employee_2_Position [NVARCHAR](10) NULL
,	Stylist_First_Name [NVARCHAR](50) NULL
,	Stylist_Last_Name [NVARCHAR](50) NULL
,	ClientLanguage [NVARCHAR](10) NULL
,	LanguageID [INT] NULL
);


-- Get Center Data
INSERT  INTO @Center
		SELECT  ctr.CenterID
		,       ctr.CenterDescription
		,       dct.CenterTypeDescriptionShort AS 'CenterType'
		,       ISNULL(lr.RegionID, 1) AS 'RegionID'
		,       ISNULL(lr.RegionDescription, 'Corporate') AS 'RegionName'
		,       ctr.Address1
		,       ctr.Address2
		,       ctr.City
		,       ls.StateDescriptionShort AS 'StateCode'
		,       ctr.PostalCode AS 'ZipCode'
		,       lc.CountryDescription AS 'Country'
		,       ctr.Phone1
		,       CASE ctr.CenterID
				  WHEN 201 THEN 'Susan Greenspan'
				  WHEN 205 THEN ''
				  WHEN 212 THEN ''
				  WHEN 213 THEN ''
				  WHEN 228 THEN 'Simon D''Souza'
				  WHEN 229 THEN 'Chris Terkalas'
				  WHEN 250 THEN ''
				  WHEN 239 THEN 'Tarrah-Lee Lawrence'
				  WHEN 255 THEN 'Kadisha Esperanto'
				  WHEN 260 THEN 'Jim Loar'
				  WHEN 283 THEN 'Ashley Zielke'
				  ELSE ISNULL(o_MD.ManagingDirector, '')
				END AS 'ManagingDirector'
		,       CASE ctr.CenterID
				  WHEN 201 THEN 'Sgreenspan@hcfm.com'
				  WHEN 205 THEN ''
				  WHEN 212 THEN ''
				  WHEN 213 THEN ''
				  WHEN 228 THEN 'sdsouza@hcfm.com'
				  WHEN 229 THEN 'Cterkalas@hcfm.com'
				  WHEN 250 THEN ''
				  WHEN 239 THEN 'Tlawrence@hcfm.com'
				  WHEN 255 THEN 'Kesperanto@hcfm.com'
				  WHEN 260 THEN 'Jloar@hcfm.com'
				  WHEN 283 THEN 'azielke@hcfm.com'
				  ELSE ISNULL(o_MD.ManagingDirectorEmail, '')
				END AS 'ManagingDirectorEmail'
		FROM    HairClubCMS.dbo.cfgCenter ctr
				INNER JOIN HairClubCMS.dbo.lkpCenterType dct
					ON dct.CenterTypeID = ctr.CenterTypeID
				INNER JOIN HairClubCMS.dbo.lkpRegion lr
					ON lr.RegionID = ctr.RegionID
				INNER JOIN HairClubCMS.dbo.lkpState ls
					ON ls.StateID = ctr.StateID
				INNER JOIN HairClubCMS.dbo.lkpCountry lc
					ON lc.CountryID = ctr.CountryID
				OUTER APPLY ( SELECT TOP 1
										ec.CenterID
							  ,         e.FirstName + ' ' + e.LastName AS 'ManagingDirector'
							  ,         e.UserLogin + '@hcfm.com' AS 'ManagingDirectorEmail'
							  FROM      HairClubCMS.dbo.datEmployee e
										LEFT JOIN HairClubCMS.dbo.datEmployeeCenter ec
											ON ec.EmployeeGUID = e.EmployeeGUID
										LEFT JOIN HairClubCMS.dbo.cfgEmployeePositionJoin ep
											ON ep.EmployeeGUID = e.EmployeeGUID
										LEFT JOIN HairClubCMS.dbo.lkpEmployeePosition epl
											ON epl.EmployeePositionID = ep.EmployeePositionID
							  WHERE     e.CenterID = ctr.CenterID
										AND e.CenterID = ec.CenterID
										AND e.FirstName NOT IN ( 'EC', 'Test' )
										AND e.IsActiveFlag = 1
										AND epl.ActiveDirectoryGroup = 'Role_Ops Managing Director'
										AND epl.IsActiveFlag = 1
										AND ec.IsActiveFlag = 1
										AND ep.IsActiveFlag = 1
							  ORDER BY  ec.CenterID
							  ,         e.EmployeePayrollID DESC
							) o_MD
		WHERE   ( dct.CenterTypeDescriptionShort IN ( 'C' )
					OR ctr.CenterNumber IN ( 818, 819, 891 ) )
				AND ctr.CenterID NOT IN ( 1001, 896 )
				AND ctr.IsActiveFlag = 1


-- Get 24 Hour Reminders
SET @CurrentDate = GETDATE()
SET @TargetDate = DATEADD(DD, 1, @CurrentDate)


;WITH    CenterEmployees
          AS ( SELECT   ec.CenterID
               ,        e.FirstName
               ,        e.LastName
               ,        epl.EmployeePositionDescription
               ,        epl.EmployeePositionDescriptionShort AS Title
               ,        ROW_NUMBER() OVER ( PARTITION BY ec.CenterID ORDER BY CASE epl.EmployeePositionDescriptionShort
                                                                                WHEN 'Manager' THEN 1
                                                                                WHEN 'Consultant' THEN 2
                                                                                WHEN 'RegDir' THEN 3
                                                                                ELSE 99
                                                                              END, LastName, FirstName ) AS [Priority]
               FROM     HairClubCMS.dbo.datEmployee e
                        LEFT JOIN HairClubCMS.dbo.datEmployeeCenter ec
                            ON ec.EmployeeGUID = e.EmployeeGUID
                        LEFT JOIN HairClubCMS.dbo.cfgEmployeePositionJoin ep
                            ON ep.EmployeeGUID = e.EmployeeGUID
                        LEFT JOIN HairClubCMS.dbo.lkpEmployeePosition epl
                            ON epl.EmployeePositionID = ep.EmployeePositionID
               WHERE    1 = 1
                        AND e.IsActiveFlag = 1
                        AND ec.IsActiveFlag = 1
                        AND ep.IsActiveFlag = 1
                        AND epl.IsActiveFlag = 1
             )
     INSERT INTO @tmpRecords
            SELECT  CAST(a.AppointmentGUID AS NVARCHAR(50)) AS [Appointment_Guid]
            ,       a.AppointmentDate AS [Appointment_Date]
            ,       FORMAT(CAST(a.StartTime AS DATETIME), 't') AS [Appointment_Time]
            ,		c.ClientIdentifier AS [Client_ID]
			,       c.FirstName AS [Client_First]
			,       c.LastName AS [Client_Last]
			,       c.EMailAddress AS [Client_Email]
            ,       ISNULL(g.GenderDescriptionShort, 'M') AS [Client_Gender]
			,		CASE WHEN c.IsAutoConfirmTextPhone1 = 1 THEN c.Phone1 ELSE CASE WHEN c.IsAutoConfirmTextPhone2 = 1 THEN c.Phone2 ELSE CASE WHEN c.IsAutoConfirmTextPhone3 = 1 THEN c.Phone3 END END END AS [Client_Phone]
            ,       cntr.CenterID AS [Center_ID]
			,		cntr.CenterNumber
            ,       cntr.Address1 AS [Center_Address_1]
            ,       cntr.Address2 AS [Center_Address_2]
            ,       cntr.City AS [Center_City]
            ,       st.StateDescriptionShort AS [Center_State]
            ,       cntr.PostalCode AS [Center_Zip]
            ,       CASE WHEN cntr.IsPhone1PrimaryFlag = 1 THEN cntr.Phone1
                         WHEN cntr.IsPhone2PrimaryFlag = 2 THEN cntr.Phone2
                         WHEN cntr.IsPhone3PrimaryFlag = 3 THEN cntr.Phone3
                         ELSE cntr.Phone1
                    END AS [Center_Phone]
			,       tz.TimeZoneDescriptionShort AS [Center_Time_Zone]
            ,       e1.FirstName AS [Employee_1_First_Name]
            ,       e1.LastName AS [Employee_1_Last_Name]
            ,       e1.Title AS [Employee_1_Position]
            ,       e2.FirstName AS [Employee_2_First_Name]
            ,       e2.LastName AS [Employee_2_Last_Name]
            ,       e2.Title AS [Employee_2_Position]
			,		de.FirstName AS [Stylist_First_Name]
			,		de.LastName AS [Stylist_Last_Name]
            ,       CAST(NULL AS NVARCHAR(10)) AS [ClientLanguage]
            ,       c.LanguageID
            FROM    HairClubCMS.dbo.datAppointment a
					LEFT JOIN HairClubCMS.dbo.datAppointmentEmployee ae
						ON ae.AppointmentGUID = a.AppointmentGUID
					LEFT JOIN HairClubCMS.dbo.datEmployee de
						ON de.EmployeeGUID = ae.EmployeeGUID
                    LEFT JOIN HairClubCMS.dbo.datClient c
                        ON a.ClientGUID = c.ClientGUID
                    LEFT JOIN HairClubCMS.dbo.lkpGender g
                        ON c.GenderID = g.GenderID
                    LEFT JOIN HairClubCMS.dbo.cfgCenter cntr
                        ON cntr.CenterID = a.CenterID
                    LEFT JOIN HairClubCMS.dbo.cfgConfigurationCenter cc
                        ON cc.CenterID = c.CenterID
                    LEFT JOIN HairClubCMS.dbo.lkpTimeZone tz
                        ON tz.TimeZoneID = cntr.TimeZoneID
                    LEFT JOIN CenterEmployees e1
                        ON e1.CenterID = c.CenterID
                           AND e1.[Priority] = 1
                    LEFT JOIN CenterEmployees e2
                        ON e2.CenterID = c.CenterID
                           AND e2.[Priority] = 2
                    LEFT JOIN HairClubCMS.dbo.lkpState st
                        ON st.StateID = cntr.StateID
                    LEFT JOIN HairClubCMS.dbo.lkpAppointmentType at
                        ON at.AppointmentTypeID = a.AppointmentTypeID
            WHERE   1 = 1
					AND ISNULL(c.CanConfirmAppointmentByEmail, 0) = 1
					AND ISNULL(c.DoNotContactFlag, 0) = 0
					AND c.EMailAddress IS NOT NULL
					AND LEN(RTRIM(LTRIM(c.EMailAddress))) > 0
					AND cc.IsAutoConfirmEnabled = 1
                    AND a.IsDeletedFlag = 0
                    AND a.AppointmentDate = @TargetDate
                    AND ISNULL(at.AppointmentTypeDescriptionShort, '') <> 'BosleyAppt'
					AND cntr.CenterID NOT IN ( 1001, 896 );


DELETE	tr
FROM	@tmpRecords tr
		INNER JOIN datCenterClosure cc
			ON cc.CenterNumber = tr.Center_Number
WHERE	( cc.ReopenDate IS NULL
			OR tr.Appointment_Date < cc.ReopenDate )


----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-- Update Client Language when LanguageID set on Client.
UPDATE  r
SET     ClientLanguage = l.LanguageDescriptionShort
FROM    @tmpRecords r
        LEFT JOIN HairClubCMS.dbo.lkpLanguage l
            ON l.LanguageID = r.LanguageID
               AND l.IsActiveFlag = 1
WHERE   r.ClientLanguage IS NULL;


----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-- Update Client Language when LanguageID set on Center (cfgConfigurationCenter).
UPDATE  r
SET     ClientLanguage = l.LanguageDescriptionShort
FROM    @tmpRecords r
        LEFT JOIN HairClubCMS.dbo.cfgConfigurationCenter ct
            ON ct.CenterID = r.Center_ID
        LEFT JOIN HairClubCMS.dbo.lkpLanguage l
            ON l.LanguageID = ct.LanguageID
               AND l.IsActiveFlag = 1
WHERE   r.ClientLanguage IS NULL;


----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
-- Default any missing languages to English
UPDATE  r
SET     ClientLanguage = l.LanguageDescriptionShort
FROM    @tmpRecords r
        LEFT JOIN HairClubCMS.dbo.lkpLanguage l
            ON l.LanguageDescription = 'English'
               AND l.IsActiveFlag = 1
WHERE   r.ClientLanguage IS NULL;


----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------
INSERT  INTO datClientMessageLog (
			TextMessageProcessID
        ,	SessionGUID
        ,	BatchID
        ,	ClientIdentifier
        ,	FirstName
        ,	LastName
        ,	EmailAddress
        ,	Gender
        ,	ClientPhoneNumber
        ,	LanguageID
        ,	LanguageCode
        ,	AppointmentGUID
        ,	AppointmentDate
        ,	AppointmentTime
        ,	CenterID
        ,	CenterName
        ,	CenterAddressLine1
        ,	CenterAddressLine2
        ,	CenterCity
        ,	CenterStateCode
        ,	CenterCountryCode
        ,	CenterTimeZone
        ,	CenterPhoneNumber
        ,	Employee1First_Name
        ,	Employee1Last_Name
        ,	Employee1Position
        ,	Employee2First_Name
        ,	Employee2Last_Name
        ,	Employee2Position
		,	Stylist_First_Name
		,	Stylist_Last_Name
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
        ,       -1 AS 'BatchID'
        ,       TR.Client_ID AS 'ClientIdentifier'
        ,       TR.Client_First AS 'FirstName'
        ,       TR.Client_Last AS 'LastName'
        ,       TR.Client_Email AS 'EmailAddress'
        ,       TR.Client_Gender
        ,       TR.Client_Phone
        ,       LL.LanguageID
        ,       LL.LanguageDescriptionShort AS 'LanguageCode'
        ,       TR.Appointment_GUID
        ,       TR.Appointment_Date
        ,       TR.Appointment_Time
        ,       CTR.CenterID
        ,       CTR.CenterDescription AS 'CenterName'
        ,       CTR.Address1 AS 'CenterAddressLine1'
        ,       CTR.Address2 AS 'CenterAddressLine2'
        ,       CTR.City AS 'CenterCity'
        ,       LS.StateDescriptionShort AS 'CenterStateCode'
        ,       LC.CountryDescriptionShort AS 'CenterCountryCode'
        ,       TZ.TimeZoneDescriptionShort AS 'CenterTimeZone'
        ,       TR.Center_Phone AS 'CenterPhoneNumber'
        ,       TR.Employee_1_First_Name
        ,       TR.Employee_1_Last_Name
        ,       TR.Employee_1_Position
        ,       TR.Employee_2_First_Name
        ,       TR.Employee_2_Last_Name
        ,       TR.Employee_2_Position
		,		TR.Stylist_First_Name
		,		TR.Stylist_Last_Name
        ,       NULL AS 'TextMessage'
        ,       TMS.TextMessageStatusID
        ,       NULL AS 'ErrorCode'
        ,       NULL AS 'ErrorVerbiage'
        ,       0 AS 'IsReprocessFlag'
        ,       GETDATE() AS 'CreateDate'
        ,       'CLText-HC' AS 'CreateUser'
        ,       GETDATE() AS 'LastUpdate'
        ,       'CLText-HC' AS 'LastUpdateUser'
        FROM    @tmpRecords TR
                INNER JOIN HC_Marketing.dbo.lkpTextMessageProcess TMP
                    ON TMP.TextMessageProcessDescriptionShort = '72HRCLEML'
                INNER JOIN HC_Marketing.dbo.lkpTextMessageStatus TMS
                    ON TMS.TextMessageStatusDescriptionShort = 'PENDING'
                LEFT OUTER JOIN HairClubCMS.dbo.lkpLanguage LL
                    ON LL.LanguageDescriptionShort = TR.ClientLanguage
                INNER JOIN HairClubCMS.dbo.cfgCenter CTR
                    ON CTR.CenterID = TR.Center_ID
                INNER JOIN HairClubCMS.dbo.lkpState LS
                    ON LS.StateID = CTR.StateID
                INNER JOIN HairClubCMS.dbo.lkpCountry LC
                    ON LC.CountryID = CTR.CountryID
                INNER JOIN HairClubCMS.dbo.lkpTimeZone TZ
                    ON TZ.TimeZoneID = CTR.TimeZoneID
                OUTER APPLY ( SELECT TOP 1
                                        CML.ClientMessageLogID
                              ,         CML.AppointmentGUID
                              ,         CML.ClientIdentifier
                              ,         CML.ClientPhoneNumber
                              ,         CML.IsReprocessFlag
                              FROM      HC_Marketing.dbo.datClientMessageLog CML
                              WHERE     CML.TextMessageProcessID = TMP.TextMessageProcessID
                                        AND CML.AppointmentGUID = TR.Appointment_GUID
                                        AND CML.ClientIdentifier = TR.Client_ID
                              ORDER BY  CML.CreateDate DESC
                            ) o_ML
        WHERE   ( o_ML.ClientMessageLogID IS NULL OR o_ML.IsReprocessFlag = 1 )


-- Update Batch ID
DECLARE @batchID int = 1;
DECLARE @rowCount int = 1;


WHILE @rowCount > 0
      BEGIN
            WITH    NextBatch
                      AS ( SELECT TOP 100
                                    *
                           FROM     datClientMessageLog
                           WHERE    SessionGUID = @SessionID
                                    AND BatchID = -1
                         )
                 UPDATE datClientMessageLog
                 SET    BatchID = @batchID
                 FROM   NextBatch
                        JOIN datClientMessageLog
                            ON NextBatch.ClientMessageLogID = datClientMessageLog.ClientMessageLogID;

            SET @rowCount = @@ROWCOUNT;
            SET @batchID = @batchID + 1;
      END


-- Return All Pending records for specific Session ID
SELECT  CML.ClientIdentifier
,       CML.FirstName
,       CML.LastName
,       CML.Gender
,       CML.EmailAddress
,       CML.LanguageCode
,       CML.AppointmentDate
,       CML.AppointmentTime
,       CML.CenterID
,       CML.CenterName
,		c.Address1 AS 'CenterAddress1'
,		c.Address2 AS 'CenterAddress2'
,		c.City AS 'CenterCity'
,		c.StateCode AS 'CenterStateCode'
,		c.ZipCode AS 'CenterZipCode'
,		c.Country AS 'CenterCountry'
,		c.PhoneNumber AS 'CenterPhoneNumber'
,		c.ManagingDirector
,		c.ManagingDirectorEmail
,       CML.CenterTimeZone
,		CML.Stylist_First_Name
,		CML.Stylist_Last_Name
FROM    datClientMessageLog CML
        INNER JOIN lkpTextMessageStatus TMS
            ON TMS.TextMessageStatusID = CML.TextMessageStatusID
		INNER JOIN @Center c
			ON c.CenterID = CML.CenterID
WHERE   CML.SessionGUID = @SessionID
        AND TMS.TextMessageStatusDescriptionShort = 'PENDING'
ORDER BY CML.ClientMessageLogID

END
GO
