/* CreateDate: 01/10/2017 09:43:38.097 , ModifyDate: 07/13/2017 16:21:05.567 */
GO
/***********************************************************************
PROCEDURE:				spSvc_SilverpopClientLeadMergeExport
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

EXEC spSvc_SilverpopClientLeadMergeExport 2875
***********************************************************************/
CREATE PROCEDURE [dbo].[spSvc_SilverpopClientLeadMergeExport]
(
	@ExportHeaderID INT
)
AS
BEGIN


/********************************** Update Export Header Table *************************************/
UPDATE	datExportHeader
SET		IsCompletedFlag = 1
,		LastUpdate = GETUTCDATE()
,		LastUpdateUser = 'MD-Export'
WHERE	ExportHeaderID = @ExportHeaderID


-- Get Consultation & Appointment Reminders
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

DECLARE @AppointmentReminders AS TABLE (
	AppointmentGUID NVARCHAR(50)
,	CenterID INT
,	ClientIdentifier INT
,	SMSPhoneNumber NVARCHAR(15)
,	CanConfirmAppointmentByText BIT
,	EmailAddress NVARCHAR(100)
,	IsAutoConfirmEmail BIT
,	AppointmentDate VARCHAR(11)
,	AppointmentTime VARCHAR(15)
,	StylistFirstName NVARCHAR(50)
,	StylistLastName NVARCHAR(50)
)

DECLARE @ConsultationReminders AS TABLE (
	ActivityID NCHAR(10) NULL
,	LeadID NCHAR(10) NULL
,	SMSPhoneNumber NVARCHAR(15)
,	ActionCode NCHAR(10)
,	ResultCode NCHAR(10)
,	SourceCode NCHAR(20)
,	CenterID INT
,	DueDate VARCHAR(11)
,	StartTime VARCHAR(15)
,	CanConfirmConsultationByText NCHAR(10)
,	CreateDate VARCHAR(11)
,	DoNotEmail BIT
,	DoNotMail BIT
,	DoNotCall BIT
,	DoNotSolicit BIT
,	DoNotText BIT
)


/********************************** Get Center Data *************************************/
INSERT  INTO @Center
		SELECT  CTR.CenterID
		,       CTR.CenterDescription
		,       CT.CenterTypeDescriptionShort AS 'CenterType'
		,       ISNULL(LR.RegionID, 1) AS 'RegionID'
		,       ISNULL(LR.RegionDescription, 'Corporate') AS 'RegionName'
		,       CTR.Address1
		,       CTR.Address2
		,       CTR.City
		,       LS.StateDescriptionShort AS 'StateCode'
		,       CTR.PostalCode AS 'ZipCode'
		,       LC.CountryDescription AS 'Country'
		,       ISNULL(CTR.Phone1, '') AS 'PhoneNumber'
		,       ISNULL(o_MD.ManagingDirector, '') AS 'ManagingDirector'
		,       ISNULL(o_MD.ManagingDirectorEmail, '') AS 'ManagingDirectorEmail'
		FROM    HairClubCMS.dbo.cfgCenter CTR WITH ( NOLOCK )
				INNER JOIN HairClubCMS.dbo.lkpCenterType CT WITH ( NOLOCK )
					ON CT.CenterTypeID = CTR.CenterTypeID
				INNER JOIN HairClubCMS.dbo.lkpState LS WITH ( NOLOCK )
					ON LS.StateID = CTR.StateID
				INNER JOIN HairClubCMS.dbo.lkpCountry LC WITH ( NOLOCK )
					ON LC.CountryID = CTR.CountryID
				LEFT OUTER JOIN HairClubCMS.dbo.lkpRegion LR WITH ( NOLOCK )
					ON LR.RegionID = CTR.RegionID
				OUTER APPLY ( SELECT TOP 1
										DE.CenterID AS 'CenterSSID'
							  ,         DE.FirstName + ' ' + DE.LastName AS 'ManagingDirector'
							  ,         DE.UserLogin + '@hcfm.com' AS 'ManagingDirectorEmail'
							  FROM      HairClubCMS.dbo.datEmployee DE WITH ( NOLOCK )
										INNER JOIN HairClubCMS.dbo.cfgEmployeePositionJoin EPJ WITH ( NOLOCK )
											ON EPJ.EmployeeGUID = DE.EmployeeGUID
										INNER JOIN HairClubCMS.dbo.lkpEmployeePosition LEP WITH ( NOLOCK )
											ON LEP.EmployeePositionID = EPJ.EmployeePositionID
							  WHERE     LEP.EmployeePositionID = 6
										AND ISNULL(DE.CenterID, 100) <> 100
										AND DE.CenterID = CTR.CenterID
										AND DE.FirstName NOT IN ( 'EC', 'Test' )
										AND DE.IsActiveFlag = 1
							  ORDER BY  DE.CenterID
							  ,         DE.EmployeePayrollID DESC
							) o_MD
		WHERE   CONVERT(VARCHAR, CTR.CenterID) LIKE '[1278]%'
				AND CTR.IsActiveFlag = 1


DECLARE @TargetDate AS DATE


-- Get 72 Hour Client Appointment Reminders
SET @TargetDate = DATEADD(DD, 3, GETDATE())


INSERT	INTO @AppointmentReminders
		SELECT  CAST(da.AppointmentGUID AS NVARCHAR(50)) AS 'AppointmentGUID'
		,       da.CenterID
		,       clt.ClientIdentifier
		,       x_P.PhoneNumber AS 'SMSPhoneNumber'
		,		x_P.CanConfirmAppointmentByText
		,		clt.EMailAddress
		,		clt.IsAutoConfirmEmail
		,       CONVERT(VARCHAR(11), CAST(da.AppointmentDate AS DATE), 101) AS 'AppointmentDate'
		,       CONVERT(VARCHAR(15), CAST(da.StartTime AS TIME), 100) AS 'AppointmentTime'
		,       de.FirstName AS 'StylistFirstName'
		,       de.LastName AS 'StylistLastName'
		FROM    HairClubCMS.dbo.datAppointment da
				INNER JOIN HairClubCMS.dbo.datClient clt
					ON clt.ClientGUID = da.ClientGUID
				INNER JOIN HairClubCMS.dbo.cfgConfigurationCenter cc
					ON da.CenterID = cc.CenterID
				INNER JOIN HairClubCMS.dbo.datAppointmentEmployee ae
					ON ae.AppointmentGUID = da.AppointmentGUID
				INNER JOIN HairClubCMS.dbo.datEmployee de
					ON de.EmployeeGUID = ae.EmployeeGUID
				LEFT JOIN HairClubCMS.dbo.lkpAppointmentType lat
					ON lat.AppointmentTypeID = da.AppointmentTypeID
				OUTER APPLY ( SELECT TOP 1
										dcp.PhoneNumber
							  ,         pt.PhoneTypeDescription AS 'PhoneType'
							  ,         dcp.CanConfirmAppointmentByText
							  FROM      HairClubCMS.dbo.datClientPhone dcp WITH ( NOLOCK )
										INNER JOIN HairClubCMS.dbo.lkpPhoneType pt WITH ( NOLOCK )
											ON pt.PhoneTypeID = dcp.PhoneTypeID
							  WHERE     dcp.ClientGUID = clt.ClientGUID
										AND dcp.CanConfirmAppointmentByText = 1
							  ORDER BY  dcp.ClientPhoneSortOrder ASC
							) x_P
		WHERE   da.AppointmentDate = @TargetDate
				AND ISNULL(lat.AppointmentTypeDescriptionShort, '') <> 'BosleyAppt'
				AND cc.IsAutoConfirmEnabled = 1
				AND da.IsDeletedFlag = 0


-- Get 24 Hour Lead Consultation Reminders
SET @TargetDate = DATEADD(DD, 1, GETDATE())


INSERT  INTO @ConsultationReminders
		SELECT  OA.activity_id AS 'ActivityID'
		,		OC.contact_id AS 'LeadID'
		,       CASE WHEN ( LEN(LTRIM(RTRIM(CAST(MT.phone AS CHAR(15))))) = 10 ) THEN '1' + LTRIM(RTRIM(CAST(MT.phone AS CHAR(15))))
							 ELSE LTRIM(RTRIM(CAST(MT.phone AS CHAR(15))))
						END AS 'SMSPhoneNumber'
		,       OA.action_code AS 'ActionCode'
		,       OA.result_code AS 'ResultCode'
		,       OA.source_code AS 'SourceCode'
		,       CAST(ISNULL(C.cst_center_number, LC.cst_center_number) AS INT) AS 'CenterID'
		,       CONVERT(VARCHAR(11), CAST(OA.due_date AS DATE), 101) AS 'DueDate'
		,       CONVERT(VARCHAR(15), CAST(OA.start_time AS TIME), 100) AS 'StartTime'
		,       CASE WHEN MT.[action] = 'OPTIN' AND ( MT.[status] IS NULL OR LTRIM(RTRIM(ISNULL(MT.[status], ''))) = '' )
				AND LEN(LTRIM(RTRIM(CAST(MT.phone AS CHAR(15))))) IN ( 10, 11 ) THEN 'No' ELSE 'Yes' END AS 'CanConfirmConsultationByText'
		,		CONVERT(VARCHAR(11), CAST(OA.creation_date AS DATE), 101) AS 'CreateDate'
		,		CASE OC.cst_do_not_email WHEN 'Y' THEN 1 ELSE 0 END
		,		CASE OC.cst_do_not_mail WHEN 'Y' THEN 1 ELSE 0 END
		,		CASE OC.cst_do_not_call WHEN 'Y' THEN 1 ELSE 0 END
		,		CASE OC.do_not_solicit WHEN 'Y' THEN 1 ELSE 0 END
		,		CASE OC.cst_do_not_text WHEN 'Y' THEN 1 ELSE 0 END
		FROM    HCM.dbo.oncd_activity OA WITH ( NOLOCK )
				INNER JOIN HCM.dbo.oncd_activity_contact OAC WITH ( NOLOCK )
					ON OAC.activity_id = OA.activity_id
				INNER JOIN HCM.dbo.oncd_activity_company AC WITH ( NOLOCK ) -- Activity Center Join
					ON AC.activity_id = OA.activity_id
						AND AC.primary_flag = 'Y'
				INNER JOIN HCM.dbo.oncd_company C WITH ( NOLOCK ) -- Activity Center
					ON C.company_id = AC.company_id
				INNER JOIN HCM.dbo.oncd_contact OC WITH ( NOLOCK )
					ON OC.contact_id = OAC.contact_id
				INNER JOIN HCM.dbo.oncd_contact_company CC WITH ( NOLOCK ) -- Lead Center Join
					ON CC.contact_id = OC.contact_id
						AND CC.primary_flag = 'Y'
				INNER JOIN HCM.dbo.oncd_company LC WITH ( NOLOCK ) -- Lead Center
					ON LC.company_id = CC.company_id
				LEFT OUTER JOIN HCM.dbo.cstd_text_msg_temp MT WITH ( NOLOCK )
					ON MT.appointment_activity_id = OA.activity_id
		WHERE   LTRIM(RTRIM(OA.action_code)) IN ( 'APPOINT', 'BEBACK', 'INHOUSE' )
				AND LTRIM(RTRIM(ISNULL(OA.result_code, ''))) = ''
				AND OA.due_date = @TargetDate


UPDATE  CLM
SET     CLM.NextAppointmentGUID = x_A.NextAppointmentGUID
,       CLM.NextAppointmentCenterID = ISNULL(x_A.CenterID, '')
--,       CLM.CenterID = x_A.CenterID
--,       CLM.CenterName = x_A.CenterName
--,       CLM.CenterType = x_A.CenterType
--,       CLM.CenterAddress1 = x_A.Address1
--,       CLM.CenterAddress2 = x_A.Address2
--,       CLM.CenterCity = x_A.City
--,       CLM.CenterStateCode = x_A.StateCode
--,       CLM.CenterZipCode = x_A.ZipCode
--,       CLM.CenterCountry = x_A.Country
--,       CLM.CenterPhoneNumber = x_A.PhoneNumber
--,       CLM.CenterManagingDirector = x_A.ManagingDirector
--,       CLM.CenterManagingDirectorEmail = x_A.ManagingDirectorEmail
,       CLM.NextAppointmentDate = ISNULL(x_A.NextAppointmentDate, '')
,       CLM.NextAppointmentTime = ISNULL(x_A.NextAppointmentTime, '')
,       CLM.StylistFirstName = ISNULL(x_A.StylistFirstName, '')
,       CLM.StylistLastName = ISNULL(x_A.StylistLastName, '')
,		CLM.SMSPhoneNumber = ISNULL(x_A.SMSPhoneNumber, '')
,		CLM.Phone1 = ISNULL(x_A.SMSPhoneNumber, CLM.Phone1)
,		CLM.CanConfirmAppointmentByPhone1Text = ISNULL(x_A.CanConfirmAppointmentByText, CLM.CanConfirmAppointmentByPhone1Text)
,		CLM.EmailAddress = ISNULL(x_A.EmailAddress, CLM.EmailAddress)
,		CLM.IsAutoConfirmEmail = x_A.IsAutoConfirmEmail
,       CLM.ExportHeaderID = @ExportHeaderID
,       CLM.LastUpdate = CAST(GETDATE() AS DATE)
FROM    datClientLeadMerge CLM
        CROSS APPLY ( SELECT TOP 1
                                ar.AppointmentGUID AS 'NextAppointmentGUID'
                      ,         ar.CenterID
					  ,			c.CenterName
                      ,			c.CenterType
                      ,			c.RegionID
                      ,			c.RegionName
                      ,			c.Address1
                      ,			c.Address2
                      ,			c.City
                      ,			c.StateCode
                      ,			c.ZipCode
                      ,			c.Country
                      ,			c.PhoneNumber
                      ,			c.ManagingDirector
                      ,			c.ManagingDirectorEmail
                      ,         ar.AppointmentDate AS 'NextAppointmentDate'
                      ,         ar.AppointmentTime AS 'NextAppointmentTime'
                      ,         ar.StylistFirstName
                      ,         ar.StylistLastName
					  ,			ar.SMSPhoneNumber
					  ,			ar.CanConfirmAppointmentByText
					  ,			ar.EmailAddress
					  ,			ar.IsAutoConfirmEmail
                      FROM      @AppointmentReminders ar
								INNER JOIN @Center c
									ON c.CenterID = ar.CenterID
                      WHERE     ar.ClientIdentifier = CLM.ClientIdentifier
                      ORDER BY  CAST(ar.AppointmentDate AS DATE) ASC
                      ,         CONVERT(DATETIME, ar.AppointmentTime, 114) ASC
                    ) x_A
WHERE   CLM.RecordStatus = 'CLIENT'
        AND CLM.ClientIdentifier <> 0


UPDATE  CLM
SET     CLM.Phone1 = x_A.SMSPhoneNumber
,		CLM.SMSPhoneNumber = x_A.SMSPhoneNumber
,       CLM.CenterID = x_A.CenterID
,       CLM.CenterName = x_A.CenterName
,       CLM.CenterType = x_A.CenterType
,       CLM.CenterAddress1 = x_A.Address1
,       CLM.CenterAddress2 = x_A.Address2
,       CLM.CenterCity = x_A.City
,       CLM.CenterStateCode = x_A.StateCode
,       CLM.CenterZipCode = x_A.ZipCode
,       CLM.CenterCountry = x_A.Country
,       CLM.CenterPhoneNumber = x_A.PhoneNumber
,       CLM.CenterManagingDirector = x_A.ManagingDirector
,       CLM.CenterManagingDirectorEmail = x_A.ManagingDirectorEmail
,       CLM.ActivityActionCode = x_A.ActionCode
,       CLM.ActivityResultCode = x_A.ResultCode
,       CLM.ActivitySourceCode = x_A.SourceCode
,       CLM.ActivityDueDate = x_A.DueDate
,       CLM.ActivityStartTime = x_A.StartTime
,       CLM.CanConfirmConsultationByText = x_A.CanConfirmConsultationByText
,       CLM.ActivityCreationDate = x_A.CreateDate
,       CLM.DoNotEmail = x_A.DoNotEmail
,       CLM.DoNotMail = x_A.DoNotMail
,       CLM.DoNotCall = x_A.DoNotCall
,       CLM.DoNotSolicit = x_A.DoNotSolicit
,       CLM.DoNotText = x_A.DoNotText
,       CLM.LastUpdate = CAST(GETDATE() AS DATE)
,       CLM.ExportHeaderID = @ExportHeaderID
FROM    datClientLeadMerge CLM
        CROSS APPLY ( SELECT TOP 1
                                cr.SMSPhoneNumber
                      ,         c.CenterID
					  ,			c.CenterName
                      ,			c.CenterType
                      ,			c.RegionID
                      ,			c.RegionName
                      ,			c.Address1
                      ,			c.Address2
                      ,			c.City
                      ,			c.StateCode
                      ,			c.ZipCode
                      ,			c.Country
                      ,			c.PhoneNumber
                      ,			c.ManagingDirector
                      ,			c.ManagingDirectorEmail
                      ,         cr.ActionCode
                      ,         cr.ResultCode
                      ,         cr.SourceCode
                      ,         cr.DueDate
                      ,         cr.StartTime
                      ,         cr.CanConfirmConsultationByText
                      ,         cr.CreateDate
                      ,         cr.DoNotEmail
                      ,         cr.DoNotMail
                      ,         cr.DoNotCall
                      ,         cr.DoNotSolicit
                      ,         cr.DoNotText
                      FROM      @ConsultationReminders cr
								INNER JOIN @Center c
									ON c.CenterID = cr.CenterID
                      WHERE     cr.LeadID = CLM.LeadID
                      ORDER BY  CAST(cr.DueDate AS DATE) DESC
                      ,         CONVERT(DATETIME, cr.StartTime, 114) DESC
                    ) x_A
WHERE   CLM.RecordStatus = 'LEAD'
        AND CLM.ClientIdentifier = 0


-- Export Records
SELECT  CLM.ClientLeadMergeID AS 'RecordID'
,       CLM.RegionID
,       CLM.RegionName
,       CLM.CenterID
,       CLM.CenterName
,       CLM.CenterType
,       CLM.CenterAddress1
,       CLM.CenterAddress2
,       CLM.CenterCity
,       CLM.CenterStateCode
,       CLM.CenterZipCode
,       CASE WHEN CLM.CenterCountry IN ( 'CA', 'Canada' ) THEN 'Canada' ELSE 'United States' END AS 'CenterCountry'
,       CLM.CenterPhoneNumber
,       CLM.CenterManagingDirector
,       CLM.CenterManagingDirectorEmail
,       CLM.ClientIdentifier
,       CLM.LeadID
,       dbo.ProperCase(CLM.FirstName) AS 'FirstName'
,       dbo.ProperCase(CLM.LastName) AS 'LastName'
,		ISNULL(CLM.LeadAddressID, '') AS 'LeadAddressID'
,       CLM.Address1
,       CLM.Address2
,       CLM.City
,       CLM.StateCode
,       CLM.ZipCode
,		CASE WHEN CLM.Country IN ( 'CA', 'Canada' ) THEN 'Canada' ELSE 'United States' END AS 'Country'
,       CLM.Timezone
,		CASE WHEN PATINDEX('%[&'',":;!+=\/()<>]%', LTRIM(RTRIM(REPLACE(REPLACE(CLM.EmailAddress, ']', ''), '[', '')))) > 0  -- Invalid characters
			OR PATINDEX('[@.-_]%', LTRIM(RTRIM(REPLACE(REPLACE(CLM.EmailAddress, ']', ''), '[', '')))) > 0        -- Valid but cannot be starting character
			OR PATINDEX('%[@.-_]', LTRIM(RTRIM(REPLACE(REPLACE(CLM.EmailAddress, ']', ''), '[', '')))) > 0        -- Valid but cannot be ending character
			OR LTRIM(RTRIM(REPLACE(REPLACE(CLM.EmailAddress, ']', ''), '[', ''))) NOT LIKE '%@%.%'                 -- Must contain at least one @ and one .
			OR LTRIM(RTRIM(REPLACE(REPLACE(CLM.EmailAddress, ']', ''), '[', ''))) LIKE '%..%'                      -- Cannot have two periods in a row
			OR LTRIM(RTRIM(REPLACE(REPLACE(CLM.EmailAddress, ']', ''), '[', ''))) LIKE '%@%@%'                     -- Cannot have two @ anywhere
			OR LTRIM(RTRIM(REPLACE(REPLACE(CLM.EmailAddress, ']', ''), '[', ''))) LIKE '%.@%'
			OR LTRIM(RTRIM(REPLACE(REPLACE(CLM.EmailAddress, ']', ''), '[', ''))) LIKE '%@.%' -- Cannot have @ and . next to each other
			OR LTRIM(RTRIM(REPLACE(REPLACE(CLM.EmailAddress, ']', ''), '[', ''))) LIKE '%.cm'
			OR LTRIM(RTRIM(REPLACE(REPLACE(CLM.EmailAddress, ']', ''), '[', ''))) LIKE '%.co' -- Camaroon or Colombia? Unlikely. Probably typos
			OR LTRIM(RTRIM(REPLACE(REPLACE(CLM.EmailAddress, ']', ''), '[', ''))) LIKE '%.or'
			OR LTRIM(RTRIM(REPLACE(REPLACE(CLM.EmailAddress, ']', ''), '[', ''))) LIKE '%.ne' -- Missing last letter
			THEN ''
			ELSE LTRIM(RTRIM(REPLACE(REPLACE(CLM.EmailAddress, ']', ''), '[', '')))
			END AS 'Email'
,       CASE WHEN CLM.Gender = 'Female' THEN CLM.Gender ELSE 'Male' END AS 'Gender'
,		CASE WHEN CONVERT(VARCHAR(11), CLM.DateOfBirth, 101) = '01/01/1900' THEN '' ELSE CONVERT(VARCHAR(11), CLM.DateOfBirth, 101) END AS 'DateOfBirth'
,       CLM.Age
,       CLM.AgeRange
,       CLM.Language
,		ISNULL(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(CLM.SiebelID, CHAR(9), ''), CHAR(10), ''), CHAR(13), ''), '''', ''), '{', ''), '}', ''), ',', ''), '"', ''), '') AS 'SiebelID'
,		ISNULL(CASE WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CLM.Phone1)), '(', ''), ')', ''), '-', ''), ' ', '')) = 10
             THEN '1' + REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CLM.Phone1)), '(', ''), ')', ''), '-', ''), ' ', '')
             ELSE REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CLM.Phone1)), '(', ''), ')', ''), '-', ''), ' ', '')
        END, '') AS 'Phone1'
,       CLM.Phone1Type
,       CLM.Phone2
,       CLM.Phone2Type
,       CLM.Phone3
,       CLM.Phone3Type
,		ISNULL(CASE WHEN LEN(REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CLM.SMSPhoneNumber)), '(', ''), ')', ''), '-', ''), ' ', '')) = 10
             THEN '1' + REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CLM.SMSPhoneNumber)), '(', ''), ')', ''), '-', ''), ' ', '')
             ELSE REPLACE(REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(CLM.SMSPhoneNumber)), '(', ''), ')', ''), '-', ''), ' ', '')
        END, '') AS 'SMSPhoneNumber'
,       CLM.DNCDate
,       CLM.HairLossCode
,       CLM.HairLossExperienceCode
,       CLM.HairLossFamilyCode
,       CLM.HairLossInFamilyCode
,       CLM.HairLossProduct
,       CLM.HairLossSpotCode
,       CLM.PromotionCode
,       CLM.SourceCode
,       CLM.SourceMedia
,       CLM.SourceFormat
,       CLM.MarketingScore
,       CLM.DiscStyle
,       CLM.Ethnicity
,       CLM.LudwigCode
,       CLM.MaritalStatus
,       CLM.NoSaleReason
,       CLM.NorwoodCode
,       CLM.Occupation
,       CLM.PriceQuoted
,       CLM.SolutionOffered
,       CLM.Performer
,       CLM.PerformerName
,       CLM.PerformerEmail
,       CLM.SaleType
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.ActivityCreationDate AS DATE), 101), '') = '01/01/1900' THEN '' ELSE ISNULL(CONVERT(VARCHAR(11), CAST(CLM.ActivityCreationDate AS DATE), 101), '') END AS 'ActivityCreationDate'
,       CLM.ActivityActionCode
,       ISNULL(CLM.ActivityResultCode, '') AS 'ActivityResultCode'
,       ISNULL(CLM.ActivitySourceCode, '') AS 'ActivitySourceCode'
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.ActivityDueDate AS DATE), 101), '') = '01/01/1900' THEN '' ELSE ISNULL(CONVERT(VARCHAR(11), CAST(CLM.ActivityDueDate AS DATE), 101), '') END AS 'ActivityDueDate'
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.ActivityDueDate AS DATE), 101), '') = '01/01/1900' AND ISNULL(CONVERT(VARCHAR(15), CAST(CLM.ActivityStartTime AS TIME), 100), '') = '12:00AM' THEN '' ELSE ISNULL(CONVERT(VARCHAR(15), CAST(CLM.ActivityStartTime AS TIME), 100), '') END AS 'ActivityStartTime'
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.ActivityCompletionDate AS DATE), 101), '') = '01/01/1900' THEN '' ELSE ISNULL(CONVERT(VARCHAR(11), CAST(CLM.ActivityCompletionDate AS DATE), 101), '') END AS 'ActivityCompletionDate'
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.ActivityCompletionDate AS DATE), 101), '') = '01/01/1900' AND ISNULL(CONVERT(VARCHAR(15), CAST(CLM.ActivityCompletionTime AS TIME), 100), '') = '12:00AM' THEN '' ELSE ISNULL(CONVERT(VARCHAR(15), CAST(CLM.ActivityCompletionTime AS TIME), 100), '') END AS 'ActivityCompletionTime'
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.BrochureCreationDate AS DATE), 101), '') = '01/01/1900' THEN '' ELSE ISNULL(CONVERT(VARCHAR(11), CAST(CLM.BrochureCreationDate AS DATE), 101), '') END AS 'BrochureCreationDate'
,       CLM.BrochureActionCode
,       CLM.BrochureResultCode
,       CLM.BrochureSourceCode
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.BrochureDueDate AS DATE), 101), '') = '01/01/1900' THEN '' ELSE ISNULL(CONVERT(VARCHAR(11), CAST(CLM.BrochureDueDate AS DATE), 101), '') END AS 'BrochureDueDate'
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.BrochureDueDate AS DATE), 101), '') = '01/01/1900' AND ISNULL(CONVERT(VARCHAR(15), CAST(CLM.BrochureStartTime AS TIME), 100), '') = '12:00AM' THEN '' ELSE ISNULL(CONVERT(VARCHAR(15), CAST(CLM.BrochureStartTime AS TIME), 100), '') END AS 'BrochureStartTime'
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.BrochureCompletionDate AS DATE), 101), '') = '01/01/1900' THEN '' ELSE ISNULL(CONVERT(VARCHAR(11), CAST(CLM.BrochureCompletionDate AS DATE), 101), '') END AS 'BrochureCompletionDate'
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.BrochureCompletionDate AS DATE), 101), '') = '01/01/1900' AND ISNULL(CONVERT(VARCHAR(15), CAST(CLM.BrochureCompletionTime AS TIME), 100), '') = '12:00AM' THEN '' ELSE ISNULL(CONVERT(VARCHAR(15), CAST(CLM.BrochureCompletionTime AS TIME), 100), '') END AS 'BrochureCompletionTime'
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.InitialSaleDate AS DATE), 101), '') = '01/01/1900' THEN '' ELSE ISNULL(CONVERT(VARCHAR(11), CAST(CLM.InitialSaleDate AS DATE), 101), '') END AS 'InitialSaleDate'
,       CLM.NBConsultant
,       CLM.NBConsultantName
,       CLM.NBConsultantEmail
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.InitialApplicationDate AS DATE), 101), '') = '01/01/1900' THEN '' ELSE ISNULL(CONVERT(VARCHAR(11), CAST(CLM.InitialApplicationDate AS DATE), 101), '') END AS 'InitialApplicationDate'
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.ConversionDate AS DATE), 101), '') = '01/01/1900' THEN '' ELSE ISNULL(CONVERT(VARCHAR(11), CAST(CLM.ConversionDate AS DATE), 101), '') END AS 'ConversionDate'
,       CLM.MembershipAdvisor
,       CLM.MembershipAdvisorName
,       CLM.MembershipAdvisorEmail
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.FirstAppointmentDate AS DATE), 101), '') = '01/01/1900' THEN '' ELSE ISNULL(CONVERT(VARCHAR(11), CAST(CLM.FirstAppointmentDate AS DATE), 101), '') END AS 'FirstAppointmentDate'
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.LastAppointmentDate AS DATE), 101), '') = '01/01/1900' THEN '' ELSE ISNULL(CONVERT(VARCHAR(11), CAST(CLM.LastAppointmentDate AS DATE), 101), '') END AS 'LastAppointmentDate'
,       CASE WHEN CONVERT(VARCHAR(36), CLM.NextAppointmentGUID) IS NULL THEN '' ELSE CONVERT(VARCHAR(36), CLM.NextAppointmentGUID) END AS 'NextAppointmentGUID'
,		CASE WHEN ISNULL(CONVERT(VARCHAR, c.CenterID), '') = '' THEN '' ELSE CONVERT(VARCHAR, c.CenterID) END AS 'NextAppointmentCenterID'
,		ISNULL(c.CenterName, '') AS 'NextAppointmentCenterName'
,		ISNULL(c.Address1, '') AS 'NextAppointmentCenterAddress1'
,		ISNULL(c.Address2, '') AS 'NextAppointmentCenterAddress2'
,		ISNULL(c.City, '') AS 'NextAppointmentCenterCity'
,		ISNULL(c.StateCode, '') AS 'NextAppointmentCenterStateCode'
,		ISNULL(c.ZipCode, '') AS 'NextAppointmentCenterZipCode'
,		ISNULL(c.Country, '') AS 'NextAppointmentCenterCountry'
,		ISNULL(c.PhoneNumber, '') AS 'NextAppointmentCenterPhoneNumber'
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.NextAppointmentDate AS DATE), 101), '') = '01/01/1900' THEN '' ELSE ISNULL(CONVERT(VARCHAR(11), CAST(CLM.NextAppointmentDate AS DATE), 101), '') END AS 'NextAppointmentDate'
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.NextAppointmentDate AS DATE), 101), '') = '01/01/1900' AND ISNULL(CONVERT(VARCHAR(15), CAST(CLM.NextAppointmentTime AS TIME), 100), '') = '12:00AM' THEN '' ELSE ISNULL(CONVERT(VARCHAR(15), CAST(CLM.NextAppointmentTime AS TIME), 100), '') END AS 'NextAppointmentTime'
,		CASE WHEN CLM.StylistFirstName IS NULL THEN '' ELSE CLM.StylistFirstName END AS 'StylistFirstName'
,		CASE WHEN CLM.StylistLastName IS NULL THEN '' ELSE CLM.StylistLastName END AS 'StylistLastName'
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.FirstEXTServiceDate AS DATE), 101), '') = '01/01/1900' THEN '' ELSE ISNULL(CONVERT(VARCHAR(11), CAST(CLM.FirstEXTServiceDate AS DATE), 101), '') END AS 'FirstEXTServiceDate'
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.FirstXtrandServiceDate AS DATE), 101), '') = '01/01/1900' THEN '' ELSE ISNULL(CONVERT(VARCHAR(11), CAST(CLM.FirstXtrandServiceDate AS DATE), 101), '') END AS 'FirstXtrandServiceDate'
,       CLM.BIO_Membership
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.BIO_BeginDate AS DATE), 101), '') = '01/01/1900' THEN '' ELSE ISNULL(CONVERT(VARCHAR(11), CAST(CLM.BIO_BeginDate AS DATE), 101), '') END AS 'BIO_BeginDate'
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.BIO_EndDate AS DATE), 101), '') = '01/01/1900' THEN '' ELSE ISNULL(CONVERT(VARCHAR(11), CAST(CLM.BIO_EndDate AS DATE), 101), '') END AS 'BIO_EndDate'
,       CLM.BIO_MembershipStatus
,       CLM.BIO_MonthlyFee
,       CLM.BIO_ContractPrice
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.BIO_CancelDate AS DATE), 101), '') = '01/01/1900' THEN '' ELSE ISNULL(CONVERT(VARCHAR(11), CAST(CLM.BIO_CancelDate AS DATE), 101), '') END AS 'BIO_CancelDate'
,       CLM.BIO_CancelReasonDescription
,       CLM.EXT_Membership
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.EXT_BeginDate AS DATE), 101), '') = '01/01/1900' THEN '' ELSE ISNULL(CONVERT(VARCHAR(11), CAST(CLM.EXT_BeginDate AS DATE), 101), '') END AS 'EXT_BeginDate'
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.EXT_EndDate AS DATE), 101), '') = '01/01/1900' THEN '' ELSE ISNULL(CONVERT(VARCHAR(11), CAST(CLM.EXT_EndDate AS DATE), 101), '') END AS 'EXT_EndDate'
,       CLM.EXT_MembershipStatus
,       CLM.EXT_MonthlyFee
,       CLM.EXT_ContractPrice
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.EXT_CancelDate AS DATE), 101), '') = '01/01/1900' THEN '' ELSE ISNULL(CONVERT(VARCHAR(11), CAST(CLM.EXT_CancelDate AS DATE), 101), '') END AS 'EXT_CancelDate'
,       CLM.EXT_CancelReasonDescription
,       CLM.XTR_Membership
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.XTR_BeginDate AS DATE), 101), '') = '01/01/1900' THEN '' ELSE ISNULL(CONVERT(VARCHAR(11), CAST(CLM.XTR_BeginDate AS DATE), 101), '') END AS 'XTR_BeginDate'
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.XTR_EndDate AS DATE), 101), '') = '01/01/1900' THEN '' ELSE ISNULL(CONVERT(VARCHAR(11), CAST(CLM.XTR_EndDate AS DATE), 101), '') END AS 'XTR_EndDate'
,       CLM.XTR_MembershipStatus
,       CLM.XTR_MonthlyFee
,       CLM.XTR_ContractPrice
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.XTR_CancelDate AS DATE), 101), '') = '01/01/1900' THEN '' ELSE ISNULL(CONVERT(VARCHAR(11), CAST(CLM.XTR_CancelDate AS DATE), 101), '') END AS 'XTR_CancelDate'
,       CLM.XTR_CancelReasonDescription
,       CLM.SUR_Membership
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.SUR_BeginDate AS DATE), 101), '') = '01/01/1900' THEN '' ELSE ISNULL(CONVERT(VARCHAR(11), CAST(CLM.SUR_BeginDate AS DATE), 101), '') END AS 'SUR_BeginDate'
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.SUR_EndDate AS DATE), 101), '') = '01/01/1900' THEN '' ELSE ISNULL(CONVERT(VARCHAR(11), CAST(CLM.SUR_EndDate AS DATE), 101), '') END AS 'SUR_EndDate'
,       CLM.SUR_MembershipStatus
,       CLM.SUR_MonthlyFee
,       CLM.SUR_ContractPrice
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.SUR_CancelDate AS DATE), 101), '') = '01/01/1900' THEN '' ELSE ISNULL(CONVERT(VARCHAR(11), CAST(CLM.SUR_CancelDate AS DATE), 101), '') END AS 'SUR_CancelDate'
,       CLM.SUR_CancelReasonDescription
,       CLM.Mosaic_Household
,       CLM.Mosaic_Household_Group
,       CLM.Mosaic_Household_Type
,       CLM.Mosaic_Zip
,       CLM.Mosaic_Zip_Group
,       CLM.Mosaic_Zip_Type
,       CLM.Mosaic_Gender
,       CLM.Mosaic_Combined_Age
,       CLM.Mosaic_Education_Model
,       CLM.Mosaic_Marital_Status
,       CLM.Mosaic_Occupation_Group_V2
,       CLM.Mosaic_Latitude
,       CLM.Mosaic_Longitude
,       CLM.Mosaic_Match_Level_For_Geo_Data
,       CLM.Mosaic_Est_Household_Income_V5
,       CLM.Mosaic_NCOA_Move_Update_Code
,       CLM.Mosaic_Mail_Responder
,       CLM.Mosaic_MOR_Bank_Upscale_Merchandise_Buyer
,       CLM.Mosaic_MOR_Bank_Health_And_Fitness_Magazine
,       CLM.Mosaic_Cape_Ethnic_Pop_White_Only
,       CLM.Mosaic_Cape_Ethnic_Pop_Black_Only
,       CLM.Mosaic_Cape_Ethnic_Pop_Asian_Only
,       CLM.Mosaic_Cape_Ethnic_Pop_Hispanic
,       CLM.Mosaic_Cape_Lang_HH_Spanish_Speaking
,       CLM.Mosaic_Cape_INC_HH_Median_Family_Household_Income
,       CLM.Mosaic_MatchStatus
,       CLM.Mosaic_CE_Selected_Individual_Vendor_Ethnicity_Code
,       CLM.Mosaic_CE_Selected_Individual_Vendor_Ethnic_Group_Code
,       CLM.Mosaic_CE_Selected_Individual_Vendor_Spoken_Language_Code
,       CASE CLM.IsAutoConfirmEmail WHEN 1 THEN 'Yes' ELSE 'No' END AS 'IsAutoConfirmEmail'
,		ISNULL(CLM.CanConfirmConsultationByText, 'No') AS 'CanConfirmConsultationByText'
,       CASE CLM.CanConfirmAppointmentByPhone1Text WHEN 1 THEN 'Yes' ELSE 'No' END AS 'CanConfirmAppointmentByPhone1Text'
,       CASE CLM.CanContactForPromotionsByPhone1Text WHEN 1 THEN 'Yes' ELSE 'No' END AS 'CanContactForPromotionsByPhone1Text'
,       CASE CLM.CanConfirmAppointmentByPhone2Text WHEN 1 THEN 'Yes' ELSE 'No' END AS 'CanConfirmAppointmentByPhone2Text'
,       CASE CLM.CanContactForPromotionsByPhone2Text WHEN 1 THEN 'Yes' ELSE 'No' END AS 'CanContactForPromotionsByPhone2Text'
,       CASE CLM.CanConfirmAppointmentByPhone3Text WHEN 1 THEN 'Yes' ELSE 'No' END AS 'CanConfirmAppointmentByPhone3Text'
,       CASE CLM.CanContactForPromotionsByPhone3Text WHEN 1 THEN 'Yes' ELSE 'No' END AS 'CanContactForPromotionsByPhone3Text'
,       CASE CLM.DoNotContact WHEN 1 THEN 'Yes' ELSE 'No' END AS 'DoNotContact'
,       CASE CLM.DoNotCall WHEN 1 THEN 'Yes' ELSE 'No' END AS 'DoNotCall'
,       CASE CLM.DoNotText WHEN 1 THEN 'Yes' ELSE 'No' END AS 'DoNotText'
,       CASE CLM.DoNotEmail WHEN 1 THEN 'Yes' ELSE 'No' END AS 'DoNotEmail'
,       CASE CLM.DoNotMail WHEN 1 THEN 'Yes' ELSE 'No' END AS 'DoNotMail'
,       CASE CLM.DoNotSolicit WHEN 1 THEN 'Yes' ELSE 'No' END AS 'DoNotSolicit'
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.LeadCreateDate AS DATE), 101), '') = '01/01/1900' THEN '' ELSE ISNULL(CONVERT(VARCHAR(11), CAST(CLM.LeadCreateDate AS DATE), 101), '') END AS 'LeadCreateDate'
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.LeadLastUpdate AS DATE), 101), '') = '01/01/1900' THEN '' ELSE ISNULL(CONVERT(VARCHAR(11), CAST(CLM.LeadLastUpdate AS DATE), 101), '') END AS 'LeadLastUpdate'
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.ClientCreateDate AS DATE), 101), '') = '01/01/1900' THEN '' ELSE ISNULL(CONVERT(VARCHAR(11), CAST(CLM.ClientCreateDate AS DATE), 101), '') END AS 'ClientCreateDate'
,		CASE WHEN ISNULL(CONVERT(VARCHAR(11), CAST(CLM.ClientLastUpdate AS DATE), 101), '') = '01/01/1900' THEN '' ELSE ISNULL(CONVERT(VARCHAR(11), CAST(CLM.ClientLastUpdate AS DATE), 101), '') END AS 'ClientLastUpdate'
,       CLM.RecordStatus
FROM    datClientLeadMerge CLM
		LEFT OUTER JOIN @Center c
			ON clm.NextAppointmentCenterID = c.CenterID
WHERE   CLM.ExportHeaderID = @ExportHeaderID

END
GO
