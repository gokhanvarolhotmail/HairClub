/*
==============================================================================

PROCEDURE:				rptClientUpdateForm
DESTINATION SERVER:		SQL06
DESTINATION DATABASE: 	HairclubCMS
IMPLEMENTOR: 			Rachelen Hut
DATE IMPLEMENTED:		10/2/2014

==============================================================================
DESCRIPTION:	This is a form that may be updated by hand by the centers.
==============================================================================
CHANGE HISTORY:
04/27/2017 - PM - Updated to reference new datClientPhone table
05/17/2017 - RH - (#137876) Added Anniversary Date, OccupationID, OccupationDescription
12/19/2017 - RH - (#144864) Added MaritalStatusID, MaritalStatusDescription; Found 'Home', 'Mobile', 'Work'
==============================================================================

SAMPLE EXECUTION:

EXEC [rptClientUpdateForm] 354607

==============================================================================
*/
CREATE PROCEDURE [dbo].[rptClientUpdateForm] (
	@ClientIdentifier	INT
)

AS
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT OFF


/*************** Create Temp Tables **********************************************************************/
IF OBJECT_ID('tempdb..#Client') IS NOT NULL
BEGIN
	DROP TABLE #Client
END
CREATE TABLE #Client(
	ClientGUID NVARCHAR(50)
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
,	MaritalStatusID INT
,	MaritalStatusDescription NVARCHAR(50)
)


IF OBJECT_ID('tempdb..#Final') IS NOT NULL
BEGIN
	DROP TABLE #Final
END
CREATE TABLE #Final(
	ClientGUID NVARCHAR(50)
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
,	MaritalStatusID INT
,	MaritalStatusDescription NVARCHAR(50)
,	Home NVARCHAR(15)
,	Mobile NVARCHAR(15)
,	Work NVARCHAR(15)
)

/********************Insert into #Client **********************************************/

INSERT INTO #Client
SELECT  CLT.ClientGUID
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
,	CD.MaritalStatusID
,	MS.MaritalStatusDescription
FROM dbo.datClient CLT
	LEFT JOIN lkpSalutation S
		ON S.SalutationID = CLT.SalutationID
	LEFT JOIN dbo.lkpGender G
		ON G.GenderID = CLT.GenderID
	LEFT JOIN lkpState ST
		ON ST.StateID = CLT.StateID
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
	LEFT JOIN dbo.datClientDemographic CD
		ON CD.ClientIdentifier = CLT.ClientIdentifier
	LEFT JOIN dbo.lkpOccupation O
		ON O.OccupationID = CD.OccupationID
	LEFT JOIN dbo.lkpMaritalStatus MS
		ON MS.MaritalStatusID = CD.MaritalStatusID

WHERE CLT.ClientIdentifier = @ClientIdentifier


/********************Insert into #Final **********************************************/

INSERT INTO #Final
SELECT 	ClientGUID
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


SELECT * FROM #Final


END
