/* CreateDate: 07/10/2017 15:54:57.623 , ModifyDate: 12/18/2017 11:17:38.940 */
GO
/***********************************************************************

PROCEDURE:				rptClientPhone
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				Rachelen Hut

--------------------------------------------------------------------------------------------------------
NOTES: 	This is a stored procedure that will be temporarily used to populate the Phone1 and Phone1TypeID in the datClient table
until the new BI world is set up.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

EXEC [rptClientPhone]

******************************************************************************************************/

CREATE PROCEDURE [dbo].[rptClientPhone]

AS
BEGIN

	SET NOCOUNT ON;

/*********** Create a temp table for the client phone number and type *********************************/

CREATE TABLE #ClientPhone(
	ClientGUID NVARCHAR(50)
,	Phone1 NVARCHAR(15)
,	Phone1TypeID INT
,	Phone2 NVARCHAR(15)
,	Phone2TypeID INT
,	Phone3 NVARCHAR(15)
,	Phone3TypeID INT
,	ClientPhone1SortOrder INT
,	ClientPhone2SortOrder INT
,	ClientPhone3SortOrder INT
,	CanConfirmAppointmentByTextPhone1 BIT
,	CanConfirmAppointmentByTextPhone2 BIT
,	CanConfirmAppointmentByTextPhone3 BIT
)

INSERT INTO #ClientPhone(
	ClientGUID
	,	Phone1
	,	Phone1TypeID
	,	ClientPhone1SortOrder
	,	CanConfirmAppointmentByTextPhone1)
SELECT ClientGUID
,	CP.PhoneNumber AS 'Phone1'
,	PhoneTypeID AS 'Phone1TypeID'
,	CP.ClientPhoneSortOrder AS 'ClientPhone1SortOrder'
,	CP.CanConfirmAppointmentByText
FROM dbo.datClientPhone CP
WHERE CP.ClientGUID IN(
	SELECT  CLT.[ClientGUID]
	FROM [dbo].[datClient] CLT
	INNER JOIN dbo.datClientMembership CM
		ON (CM.ClientMembershipGUID = CLT.CurrentBioMatrixClientMembershipGUID
		OR CM.ClientMembershipGUID = CLT.CurrentExtremeTherapyClientMembershipGUID
		OR CM.ClientMembershipGUID = CLT.CurrentSurgeryClientMembershipGUID
		OR CM.ClientMembershipGUID = CLT.CurrentXtrandsClientMembershipGUID)
	INNER JOIN dbo.cfgMembership M
		ON	M.MembershipID = CM.MembershipID
	WHERE M.RevenueGroupID = 1
	AND (CLT.Phone1 IS NULL OR CLT.Phone1 = '')
	AND CM.BeginDate >= '3/1/2017'  --Find new business clients since the beginning of March 2017
GROUP BY CLT.ClientGUID
       , CLT.ClientIdentifier
       , CLT.ClientFullNameAltCalc
       , CLT.LastName
       , CLT.FirstName
	   , CLT.Phone1
      )
AND CP.ClientPhoneSortOrder = 1

INSERT INTO #ClientPhone(
	ClientGUID
	,	Phone2
	,	Phone2TypeID
	,	ClientPhone2SortOrder
	,	CanConfirmAppointmentByTextPhone2)
SELECT ClientGUID
,	CP.PhoneNumber AS 'Phone2'
,	PhoneTypeID AS 'Phone2TypeID'
,	CP.ClientPhoneSortOrder AS 'ClientPhone2SortOrder'
,	CP.CanConfirmAppointmentByText
FROM dbo.datClientPhone CP
WHERE CP.ClientGUID IN(
	SELECT  CLT.[ClientGUID]
	FROM [dbo].[datClient] CLT
	INNER JOIN dbo.datClientMembership CM
		ON (CM.ClientMembershipGUID = CLT.CurrentBioMatrixClientMembershipGUID
		OR CM.ClientMembershipGUID = CLT.CurrentExtremeTherapyClientMembershipGUID
		OR CM.ClientMembershipGUID = CLT.CurrentSurgeryClientMembershipGUID
		OR CM.ClientMembershipGUID = CLT.CurrentXtrandsClientMembershipGUID)
	INNER JOIN dbo.cfgMembership M
		ON	M.MembershipID = CM.MembershipID
	WHERE M.RevenueGroupID = 1
		AND (CLT.Phone2 IS NULL OR CLT.Phone2 = '')
		AND CM.BeginDate >= '3/1/2017'  --Find new business clients since the beginning of March 2017
	GROUP BY CLT.ClientGUID
      )
AND CP.ClientPhoneSortOrder = 2


INSERT INTO #ClientPhone(
	ClientGUID
	,	Phone3
	,	Phone3TypeID
	,	ClientPhone3SortOrder
	,	CanConfirmAppointmentByTextPhone3)
SELECT ClientGUID
,	CP.PhoneNumber AS 'Phone3'
,	PhoneTypeID AS 'Phone3TypeID'
,	CP.ClientPhoneSortOrder AS 'ClientPhone3SortOrder'
,	CP.CanConfirmAppointmentByText
FROM dbo.datClientPhone CP
WHERE CP.ClientGUID IN(
	SELECT  CLT.[ClientGUID]
	FROM [dbo].[datClient] CLT
	INNER JOIN dbo.datClientMembership CM
		ON (CM.ClientMembershipGUID = CLT.CurrentBioMatrixClientMembershipGUID
		OR CM.ClientMembershipGUID = CLT.CurrentExtremeTherapyClientMembershipGUID
		OR CM.ClientMembershipGUID = CLT.CurrentSurgeryClientMembershipGUID
		OR CM.ClientMembershipGUID = CLT.CurrentXtrandsClientMembershipGUID)
	INNER JOIN dbo.cfgMembership M
		ON	M.MembershipID = CM.MembershipID
	WHERE M.RevenueGroupID = 1
	AND (CLT.Phone3 IS NULL OR CLT.Phone3 = '')
	AND CM.BeginDate >= '3/1/2017'  --Find new business clients since the beginning of March 2017
GROUP BY CLT.ClientGUID
      )
AND CP.ClientPhoneSortOrder = 3




/*********** Update the Phone1 and Phone1TypeID in the datClient table ************************************/

UPDATE CLT
SET CLT.Phone1 = CP.Phone1
,	CLT.IsAutoConfirmTextPhone1 = CP.CanConfirmAppointmentByTextPhone1
FROM dbo.datClient CLT
INNER JOIN #ClientPhone CP
ON CP.ClientGUID = CLT.ClientGUID
WHERE (CLT.Phone1 IS NULL OR CLT.Phone1 = '')


UPDATE CLT
SET CLT.Phone1TypeID = CP.Phone1TypeID
FROM dbo.datClient CLT
INNER JOIN #ClientPhone CP
ON CP.ClientGUID = CLT.ClientGUID
WHERE CLT.Phone1TypeID IS NULL


UPDATE CLT
SET CLT.Phone2 = CP.Phone2
,	CLT.IsAutoConfirmTextPhone2 = CP.CanConfirmAppointmentByTextPhone2
FROM dbo.datClient CLT
INNER JOIN #ClientPhone CP
ON CP.ClientGUID = CLT.ClientGUID
WHERE (CLT.Phone2 IS NULL OR CLT.Phone2 = '')


UPDATE CLT
SET CLT.Phone2TypeID = CP.Phone2TypeID
FROM dbo.datClient CLT
INNER JOIN #ClientPhone CP
ON CP.ClientGUID = CLT.ClientGUID
WHERE CLT.Phone2TypeID IS NULL



UPDATE CLT
SET CLT.Phone3 = CP.Phone3
,	CLT.IsAutoConfirmTextPhone3 = CP.CanConfirmAppointmentByTextPhone3
FROM dbo.datClient CLT
INNER JOIN #ClientPhone CP
ON CP.ClientGUID = CLT.ClientGUID
WHERE (CLT.Phone3 IS NULL OR CLT.Phone3 = '')


UPDATE CLT
SET CLT.Phone3TypeID = CP.Phone3TypeID
FROM dbo.datClient CLT
INNER JOIN #ClientPhone CP
ON CP.ClientGUID = CLT.ClientGUID
WHERE CLT.Phone3TypeID IS NULL


END
GO
