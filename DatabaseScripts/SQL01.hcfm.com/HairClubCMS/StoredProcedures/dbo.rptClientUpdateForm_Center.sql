/*
==============================================================================

PROCEDURE:				[rptClientUpdateForm_Center]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairclubCMS
IMPLEMENTOR: 			Rachelen Hut
DATE IMPLEMENTED:		05/24/2017

==============================================================================
DESCRIPTION:	This is a version to be used by the centers to print ALL clients.
==============================================================================
NOTES:	@NotPresent = 1 for Not Present; 2 for All
==============================================================================
CHANGE HISTORY:
04/27/2017 - PM - Updated to reference new datClientPhone table
05/17/2017 - RH - (#137876) Added Anniversary Date, OccupationID, OccupationDescription
08/31/2017 - RH - (#142588)(#141924) Added a parameter @NotPresent to select only forms that have not been uploaded OR missing Anniversary or Birth dates
12/19/2017 - RH - (#144864) Added EmergencyContact, MaritalStatusID INT, MaritalStatusDescription; Found 'Home', 'Mobile', 'Work'
==============================================================================
SAMPLE EXECUTION:

EXEC [rptClientUpdateForm_Center] 201, '12/19/2017', 1
==============================================================================
*/

CREATE PROCEDURE [dbo].[rptClientUpdateForm_Center] (
	@CenterID	INT
	,	@Date DATETIME
	,	@NotPresent INT
)

AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF



/*************** Create Temp Tables **********************************************************************/

CREATE TABLE #Client(
	AppointmentDate DATETIME
,	StartTime TIME
,	EmployeeFullNameCalc NVARCHAR(150)
,	ClientGUID NVARCHAR(50)
,	ClientIdentifier INT
,	ClientFullNameCalc NVARCHAR(150)
,	CenterID INT
,	CountryID INT
,	SalutationID INT
,	SalutationDescription NVARCHAR(50)
,	ContactID NVARCHAR(50)
,	FirstName NVARCHAR(50)
,	MiddleName NVARCHAR(20)
,	LastName NVARCHAR(50)
,	GenderID INT
,	GenderDescription  NVARCHAR(50)
,	DateOfBirth datetime
,	Address1 NVARCHAR(50)
,	Address2 NVARCHAR(50)
,	Address3 NVARCHAR(50)
,	City NVARCHAR(50)
,	StateID INT
,	StateDescriptionShort NVARCHAR(10)
,	PostalCode NVARCHAR(10)
,	DoNotCallFlag INT
,	DoNotContactFlag INT
,	EmailAddress  NVARCHAR(100)
,	TextMessageAddress NVARCHAR(100)
,	Phone1 NVARCHAR(15)
,	Phone1TypeDescription NVARCHAR(100)
,	IsAutoConfirmTextPhone1 NVARCHAR(3)
,	IsAutoConfirmTextPhone2 NVARCHAR(3)
,	IsAutoConfirmTextPhone3 NVARCHAR(3)
,	IsAutoConfirmEmail NVARCHAR(3)
,	Phone2 NVARCHAR(15)
,	Phone2TypeDescription NVARCHAR(100)
,	Phone3 NVARCHAR(15)
,	Phone3TypeDescription NVARCHAR(100)
,	Phone1TypeID INT
,	Phone2TypeID INT
,	Phone3TypeID INT
,	IsPhone1PrimaryFlag INT
,	IsPhone2PrimaryFlag INT
,	IsPhone3PrimaryFlag INT
,	EmergencyContactPhone NVARCHAR(15)
,	AnniversaryDate DATETIME
,	OccupationID INT
,	OccupationDescription NVARCHAR(100)
,	Uploaded INT
,	EmergencyContact NVARCHAR(255)
,	MaritalStatusID INT
,	MaritalStatusDescription NVARCHAR(50)
)


CREATE TABLE #Documents (CenterID INT
     , DocumentName NVARCHAR(150)
     , DocumentTypeID INT
     , [Description] NVARCHAR(150)
     , LastUpdate DATETIME
     , ClientIdentifier INT
     , ClientFullNameAltCalc NVARCHAR(150)
     , ClientGUID NVARCHAR(50)
     , MembershipDescription NVARCHAR(50)
     , DocumentTypeDescription NVARCHAR(150)
     , DocumentTypeDescriptionShort NVARCHAR(50)
     , Ranking INT
)

CREATE TABLE #Final(
	AppointmentDate DATETIME
,	StartTime TIME
,	EmployeeFullNameCalc NVARCHAR(150)
,	ClientGUID NVARCHAR(50)
,	ClientIdentifier INT
,	ClientFullNameCalc NVARCHAR(150)
,	CenterID INT
,	CountryID INT
,	SalutationID INT
,	SalutationDescription NVARCHAR(50)
,	ContactID NVARCHAR(50)
,	FirstName NVARCHAR(50)
,	MiddleName NVARCHAR(20)
,	LastName NVARCHAR(50)
,	GenderID INT
,	GenderDescription  NVARCHAR(50)
,	DateOfBirth datetime
,	Address1 NVARCHAR(50)
,	Address2 NVARCHAR(50)
,	Address3 NVARCHAR(50)
,	City NVARCHAR(50)
,	StateID INT
,	StateDescriptionShort NVARCHAR(10)
,	PostalCode NVARCHAR(10)
,	DoNotCallFlag INT
,	DoNotContactFlag INT
,	EmailAddress  NVARCHAR(100)
,	TextMessageAddress NVARCHAR(100)
,	Phone1 NVARCHAR(15)
,	Phone1TypeDescription NVARCHAR(100)
,	IsAutoConfirmTextPhone1 NVARCHAR(3)
,	IsAutoConfirmTextPhone2 NVARCHAR(3)
,	IsAutoConfirmTextPhone3 NVARCHAR(3)
,	IsAutoConfirmEmail NVARCHAR(3)
,	Phone2 NVARCHAR(15)
,	Phone2TypeDescription NVARCHAR(100)
,	Phone3 NVARCHAR(15)
,	Phone3TypeDescription NVARCHAR(100)
,	Phone1TypeID INT
,	Phone2TypeID INT
,	Phone3TypeID INT
,	IsPhone1PrimaryFlag INT
,	IsPhone2PrimaryFlag INT
,	IsPhone3PrimaryFlag INT
,	EmergencyContactPhone NVARCHAR(15)
,	AnniversaryDate DATETIME
,	OccupationID INT
,	OccupationDescription NVARCHAR(100)
,	Uploaded INT
,	EmergencyContact NVARCHAR(255)
,	MaritalStatusID INT
,	MaritalStatusDescription NVARCHAR(50)
,	Home NVARCHAR(15)
,	Mobile NVARCHAR(15)
,	Work NVARCHAR(15)
)

/*************** Populate #Clients *****************************************************************/

INSERT INTO #Client
SELECT  APPT.AppointmentDate
,	APPT.StartTime
,	STY.EmployeeFullNameCalc
,	CLT.ClientGUID
,	CLT.ClientIdentifier
,	CLT.ClientFullNameCalc
,	CLT.CenterID
,	CLT.CountryID
,	CLT.SalutationID
,	S.SalutationDescription
,	CLT.ContactID
,	CLT.FirstName
,	CLT.MiddleName
,	CLT.LastName
,	CLT.GenderID
,	G.GenderDescription
,	CLT.DateOfBirth
,	CLT.Address1
,	CLT.Address2
,	CLT.Address3
,	CLT.City
,	CLT.StateID
,	ST.StateDescriptionShort
,	CLT.PostalCode
,	CLT.DoNotCallFlag
,	CLT.DoNotContactFlag
,	LOWER(LEFT(CLT.EMailAddress,50)) AS 'EmailAddress'
,	CLT.TextMessageAddress
,	cp1.PhoneNumber AS 'Phone1'
,	cp1.PhoneTypeDescription AS 'Phone1TypeDescription'
,		ISNULL(cp1.CanConfirmAppointmentByText, '') AS 'IsAutoConfirmTextPhone1'
,		ISNULL(cp2.CanConfirmAppointmentByText, '')  AS 'IsAutoConfirmTextPhone2'
,		ISNULL(cp3.CanConfirmAppointmentByText, '')  AS 'IsAutoConfirmTextPhone3'
,		CASE WHEN clt.IsAutoConfirmEmail = 1 THEN 'Yes' ELSE '' END AS 'IsAutoConfirmEmail'
,	ISNULL(cp2.PhoneNumber, '') AS 'Phone2'
,	cp2.PhoneTypeDescription AS 'Phone2TypeDescription'
,	ISNULL(cp2.PhoneNumber, '') AS 'Phone3'
,	cp2.PhoneTypeDescription AS 'Phone3TypeDescription'
,	cp1.PhoneTypeID AS 'Phone1TypeID'
,	cp2.PhoneTypeID AS 'Phone2TypeID'
,	cp3.PhoneTypeID AS 'Phone3TypeID'
,	1 AS IsPhone1PrimaryFlag
,	0 AS IsPhone2PrimaryFlag
,	0 AS IsPhone3PrimaryFlag
,	LEFT(CLT.EmergencyContactPhone,3) + '-' + SUBSTRING(CLT.EmergencyContactPhone,4,3) + '-' + RIGHT(CLT.EmergencyContactPhone,4) AS 'EmergencyContactPhone'
,	CLT.AnniversaryDate
,	CD.OccupationID
,	O.OccupationDescription
,	NULL AS Uploaded
,	STY.EmergencyContact
,	CD.MaritalStatusID
,	MS.MaritalStatusDescription
FROM dbo.datClient CLT
	INNER JOIN datAppointment APPT
		ON CLT.ClientGUID = APPT.ClientGUID
	INNER JOIN dbo.datAppointmentEmployee AE
		ON AE.AppointmentGUID = APPT.AppointmentGUID
	INNER JOIN datEmployee STY
		ON STY.EmployeeGUID = AE.EmployeeGUID
	OUTER APPLY (SELECT LEFT(PhoneNumber,3) + '-' + SUBSTRING(PhoneNumber,4,3) + '-' + RIGHT(PhoneNumber,4) AS PhoneNumber, pt.PhoneTypeID, pt.PhoneTypeDescription,
						CASE WHEN CanConfirmAppointmentByText = 1 THEN 'Yes' ELSE 'No' END AS CanConfirmAppointmentByText
					FROM datClientPhone cp
						INNER JOIN lkpPhoneType pt ON cp.PhoneTypeID = pt.PhoneTypeID
					WHERE clt.ClientGUID = cp.ClientGUID AND ClientPhoneSortOrder = 1
				) cp1
	OUTER APPLY (SELECT LEFT(PhoneNumber,3) + '-' + SUBSTRING(PhoneNumber,4,3) + '-' + RIGHT(PhoneNumber,4) AS PhoneNumber, pt.PhoneTypeID, pt.PhoneTypeDescription,
						CASE WHEN CanConfirmAppointmentByText = 1 THEN 'Yes' ELSE 'No' END AS CanConfirmAppointmentByText
					FROM datClientPhone cp
						INNER JOIN lkpPhoneType pt ON cp.PhoneTypeID = pt.PhoneTypeID
					WHERE clt.ClientGUID = cp.ClientGUID AND ClientPhoneSortOrder = 2
				) cp2
	OUTER APPLY (SELECT LEFT(PhoneNumber,3) + '-' + SUBSTRING(PhoneNumber,4,3) + '-' + RIGHT(PhoneNumber,4) AS PhoneNumber, pt.PhoneTypeID, pt.PhoneTypeDescription,
						CASE WHEN CanConfirmAppointmentByText = 1 THEN 'Yes' ELSE 'No' END AS CanConfirmAppointmentByText
					FROM datClientPhone cp
						INNER JOIN lkpPhoneType pt ON cp.PhoneTypeID = pt.PhoneTypeID
					WHERE clt.ClientGUID = cp.ClientGUID AND ClientPhoneSortOrder = 3
					) cp3
	LEFT JOIN lkpSalutation S
		ON S.SalutationID = CLT.SalutationID
	LEFT JOIN dbo.lkpGender G
		ON G.GenderID = CLT.GenderID
	LEFT JOIN lkpState ST
		ON ST.StateID = CLT.StateID
	LEFT JOIN dbo.datClientDemographic CD
		ON CD.ClientIdentifier = CLT.ClientIdentifier
	LEFT JOIN dbo.lkpOccupation O
		ON O.OccupationID = CD.OccupationID
	LEFT JOIN dbo.lkpMaritalStatus MS
		ON MS.MaritalStatusID = CD.MaritalStatusID
WHERE APPT.CenterID = @CenterID
	AND APPT.AppointmentDate = @Date
	AND APPT.IsDeletedFlag = 0
GROUP BY LOWER(LEFT(CLT.EMailAddress ,50))
,	ISNULL(cp1.CanConfirmAppointmentByText ,'')
,	ISNULL(cp2.CanConfirmAppointmentByText ,'')
,	ISNULL(cp3.CanConfirmAppointmentByText ,'')
,	CASE WHEN CLT.IsAutoConfirmEmail = 1 THEN 'Yes' ELSE '' END
,	ISNULL(cp2.PhoneNumber ,'')
,	ISNULL(cp2.PhoneNumber ,'')
,	LEFT(CLT.EmergencyContactPhone ,3) + '-'
+	SUBSTRING(CLT.EmergencyContactPhone ,4 ,3) + '-'
+	RIGHT(CLT.EmergencyContactPhone ,4)
,	APPT.AppointmentDate
,	APPT.StartTime
,	STY.EmployeeFullNameCalc
,	CLT.ClientGUID
,	CLT.ClientIdentifier
,	CLT.ClientFullNameCalc
,	CLT.CenterID
,	CLT.CountryID
,	CLT.SalutationID
,	S.SalutationDescription
,	CLT.ContactID
,	CLT.FirstName
,	CLT.MiddleName
,	CLT.LastName
,	CLT.GenderID
,	G.GenderDescription
,	CLT.DateOfBirth
,	CLT.Address1
,	CLT.Address2
,	CLT.Address3
,	CLT.City
,	CLT.StateID
,	ST.StateDescriptionShort
,	CLT.PostalCode
,	CLT.DoNotCallFlag
,	CLT.DoNotContactFlag
,	CLT.TextMessageAddress
,	cp1.PhoneNumber
,	cp1.PhoneTypeDescription
,	cp2.PhoneTypeDescription
,	cp2.PhoneTypeDescription
,	cp1.PhoneTypeID
,	cp2.PhoneTypeID
,	cp3.PhoneTypeID
,	CLT.AnniversaryDate
,	CD.OccupationID
,	O.OccupationDescription
,	STY.EmergencyContact
,	CD.MaritalStatusID
,	MS.MaritalStatusDescription


/********************* Find uploaded documents *************************************************/

INSERT INTO #Documents
SELECT 	CLT.CenterID
,	DOC.DocumentName
,	DOC.DocumentTypeID
,	DOC.[Description]
,	DOC.LastUpdate
,	CLT.ClientIdentifier
,	CLT.ClientFullNameCalc
,	CLT.ClientGUID
,	M.MembershipDescription
,	DT.DocumentTypeDescription
,	DT.DocumentTypeDescriptionShort
,	ROW_NUMBER()OVER(PARTITION BY DOC.ClientGUID,DOC.DocumentTypeID ORDER BY DOC.LastUpdate DESC) AS 'Ranking'
FROM datClientMembershipDocument DOC
						INNER JOIN #Client CLT
							ON DOC.ClientGUID = CLT.ClientGUID
						INNER JOIN dbo.datClientMembership CM
							ON DOC.ClientMembershipGUID = CM.ClientMembershipGUID
						INNER JOIN dbo.cfgMembership M
							ON CM.MembershipID = M.MembershipID
						INNER JOIN lkpDocumentType DT ON DT.DocumentTypeId = DOC.DocumentTypeId
						WHERE DT.DocumentTypeDescriptionShort = 'FrmClntUpd'


/********** Update the records where the Client Update Form has been uploaded ***************************/

--Set Uploaded to 1 where the Client Update Form has been uploaded
UPDATE CLT
SET Uploaded = 1
FROM #Client CLT
LEFT JOIN #Documents DOC
 ON DOC.ClientIdentifier = CLT.ClientIdentifier AND Ranking = 1
WHERE CLT.Uploaded IS NULL

--Set the remaining records to 0
UPDATE CLT
SET Uploaded = 0
FROM #Client CLT
WHERE CLT.Uploaded IS NULL


/********** Select according to the parameter @NotPresent ***********************************************/

IF @NotPresent = 1  --SHOW ONLY Not Present and missing Anniversary or Birth dates
BEGIN
INSERT INTO #Final
SELECT AppointmentDate
,	StartTime
,	EmployeeFullNameCalc
,	ClientGUID
,	ClientIdentifier
,	ClientFullNameCalc
,	CenterID
,	CountryID
,	SalutationID
,	SalutationDescription
,	ContactID
,	FirstName
,	MiddleName
,	LastName
,	GenderID
,	GenderDescription
,	CASE WHEN DateOfBirth IS NULL THEN NULL
		WHEN  DateOfBirth = '1900-01-01 00:00:00.000' THEN NULL
		WHEN  DateOfBirth = '2000-01-01 00:00:00.000' THEN NULL ELSE DateOfBirth END AS 'DateOfBirth'
,	Address1
,	Address2
,	Address3
,	City
,	StateID
,	StateDescriptionShort
,	PostalCode
,	DoNotCallFlag
,	DoNotContactFlag
,	EmailAddress
,	TextMessageAddress
,	Phone1
,	Phone1TypeDescription
,	IsAutoConfirmTextPhone1
,	IsAutoConfirmTextPhone2
,	IsAutoConfirmTextPhone3
,	IsAutoConfirmEmail
,	Phone2
,	Phone2TypeDescription
,	Phone3
,	Phone3TypeDescription
,	Phone1TypeID
,	Phone2TypeID
,	Phone3TypeID
,	IsPhone1PrimaryFlag
,	IsPhone2PrimaryFlag
,	IsPhone3PrimaryFlag
,	EmergencyContactPhone
,	CASE WHEN AnniversaryDate IS NULL THEN NULL
		WHEN AnniversaryDate = '1900-01-01 00:00:00.000' THEN NULL
		WHEN AnniversaryDate = '2000-01-01 00:00:00.000' THEN NULL ELSE AnniversaryDate END AS 'AnniversaryDate'
,	OccupationID
,	OccupationDescription
,	Uploaded
,	EmergencyContact
,	MaritalStatusID
,	MaritalStatusDescription
,	CASE WHEN Phone1TypeID = 1 THEN #Client.Phone1
			WHEN Phone2TypeID = 1 THEN #Client.Phone2
			WHEN Phone3TypeID = 1 THEN #Client.Phone3
			ELSE '' END AS 'Home'
,	CASE WHEN Phone1TypeID = 3 THEN #Client.Phone1
			WHEN Phone2TypeID = 3 THEN #Client.Phone2
			WHEN Phone3TypeID = 3 THEN #Client.Phone3
			ELSE '' END AS 'Mobile'
,	CASE WHEN Phone1TypeID = 2 THEN #Client.Phone1
			WHEN Phone2TypeID = 2 THEN #Client.Phone2
			WHEN Phone3TypeID = 2 THEN #Client.Phone3
			ELSE '' END AS 'Work'
FROM #Client
WHERE Uploaded = 0
OR (AnniversaryDate IS NULL OR AnniversaryDate = '1900-01-01 00:00:00.000' OR AnniversaryDate = '2000-01-01 00:00:00.000'
	OR DateOfBirth IS NULL OR DateOfBirth = '1900-01-01 00:00:00.000' OR DateOfBirth = '2000-01-01 00:00:00.000'
	)
END
ELSE
IF @NotPresent = 2   -- ALL
BEGIN
INSERT INTO #Final
SELECT AppointmentDate
,	StartTime
,	EmployeeFullNameCalc
,	ClientGUID
,	ClientIdentifier
,	ClientFullNameCalc
,	CenterID
,	CountryID
,	SalutationID
,	SalutationDescription
,	ContactID
,	FirstName
,	MiddleName
,	LastName
,	GenderID
,	GenderDescription
,	CASE WHEN DateOfBirth IS NULL THEN NULL
		WHEN  DateOfBirth = '1900-01-01 00:00:00.000' THEN NULL
		WHEN  DateOfBirth = '2000-01-01 00:00:00.000' THEN NULL ELSE DateOfBirth END AS 'DateOfBirth'
,	Address1
,	Address2
,	Address3
,	City
,	StateID
,	StateDescriptionShort
,	PostalCode
,	DoNotCallFlag
,	DoNotContactFlag
,	EmailAddress
,	TextMessageAddress
,	Phone1
,	Phone1TypeDescription
,	IsAutoConfirmTextPhone1
,	IsAutoConfirmTextPhone2
,	IsAutoConfirmTextPhone3
,	IsAutoConfirmEmail
,	Phone2
,	Phone2TypeDescription
,	Phone3
,	Phone3TypeDescription
,	Phone1TypeID
,	Phone2TypeID
,	Phone3TypeID
,	IsPhone1PrimaryFlag
,	IsPhone2PrimaryFlag
,	IsPhone3PrimaryFlag
,	EmergencyContactPhone
,	CASE WHEN AnniversaryDate IS NULL THEN NULL
		WHEN AnniversaryDate = '1900-01-01 00:00:00.000' THEN NULL
		WHEN AnniversaryDate = '2000-01-01 00:00:00.000' THEN NULL ELSE AnniversaryDate END AS 'AnniversaryDate'
,	OccupationID
,	OccupationDescription
,	Uploaded
,	EmergencyContact
,	MaritalStatusID
,	MaritalStatusDescription
,	CASE WHEN Phone1TypeID = 1 THEN #Client.Phone1
			WHEN Phone2TypeID = 1 THEN #Client.Phone2
			WHEN Phone3TypeID = 1 THEN #Client.Phone3
			ELSE '' END AS 'Home'
,	CASE WHEN Phone1TypeID = 3 THEN #Client.Phone1
			WHEN Phone2TypeID = 3 THEN #Client.Phone2
			WHEN Phone3TypeID = 3 THEN #Client.Phone3
			ELSE '' END AS 'Mobile'
,	CASE WHEN Phone1TypeID = 2 THEN #Client.Phone1
			WHEN Phone2TypeID = 2 THEN #Client.Phone2
			WHEN Phone3TypeID = 2 THEN #Client.Phone3
			ELSE '' END AS 'Work'
FROM #Client
END

SELECT * FROM #Final


END
