/*
==============================================================================
PROCEDURE:				extSiebelUpdate

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Michael Tovbin

IMPLEMENTOR: 			Michael Tovbin

DATE IMPLEMENTED: 		 4/24/2013

LAST REVISION DATE: 	 4/24/2013

==============================================================================
DESCRIPTION:	Updates Information for the Interface with Bosley
==============================================================================
NOTES:
	* 05/08/2013	MVT		Updated to use Salutation Description instead of Salutation
							Description Short
	* 06/18/2013	MVT		Modified to return consultant.
	* 08/15/2013	MVT		Modified to always return a Client Membership Identifier
							in order Surgery, EXT, BIO
	* 03/02/2015	MVT		Updated proc for Xtrands Business Segment
	* 04/27/2017    PRM     Updated to reference new datClientPhone table
	* 10/04/2019	MVT		Modified to return HC Salesforce Lead ID and Bosley Salesforce Account ID

==============================================================================
SAMPLE EXECUTION:
EXEC extSiebelUpdate  'E37C19AF-84D6-42DC-B864-0000C3390525'
==============================================================================
*/
CREATE PROCEDURE [dbo].[extSiebelUpdate]
(
	@ClientGUID uniqueidentifier
)
AS

	DECLARE @PostExtDescriptionShort nvarchar(10) = 'POSTEXT'
		DECLARE @InitialAssigmentDepartments table
	(
		SalesCodeDepartmentID int
	)

	INSERT @InitialAssigmentDepartments (SalesCodeDepartmentID) VALUES (1010)
	INSERT @InitialAssigmentDepartments (SalesCodeDepartmentID) VALUES (1070)
	INSERT @InitialAssigmentDepartments (SalesCodeDepartmentID) VALUES (1075)
	INSERT @InitialAssigmentDepartments (SalesCodeDepartmentID) VALUES (1080)
	INSERT @InitialAssigmentDepartments (SalesCodeDepartmentID) VALUES (1090)

	DECLARE @MR AS VARCHAR(3) = 'Mr.'
	DECLARE @USA as VARCHAR(2) = 'US'
	DECLARE @PhoneTypeID_Work int
			,@PhoneTypeID_Home int
			,@PhoneTypeID_Mobile int

	SELECT @PhoneTypeID_Work = PhoneTypeID FROM lkpPhoneType WHERE PhoneTypeDescriptionShort = 'Work'
	SELECT @PhoneTypeID_Home = PhoneTypeID FROM lkpPhoneType WHERE PhoneTypeDescriptionShort = 'Home'
	SELECT @PhoneTypeID_Mobile = PhoneTypeID FROM lkpPhoneType WHERE PhoneTypeDescriptionShort = 'Mobile'

	SELECT
		c.SiebelID as 'SiebelID'
		,c.ContactID as 'OnContactID'
		,ISNULL(s.SalutationDescription,@MR) as 'SalutationDescriptionShort'
		,c.LastName as 'LastName'
		,c.FirstName as 'FirstName'
		,LEFT(c.MiddleName,1) as 'MiddleInitial'
		,g.GenderDescriptionShort as 'GenderDescriptionShort'
		,c.Address1 as 'Address1'
		,c.Address2 as 'Address2'
		,c.City as 'City'
		,IIF(ctry.CountryDescriptionShort = @USA,NULL,st.StateDescriptionShort) as 'ProvinceDescriptionShort'
		,IIF(ctry.CountryDescriptionShort = @USA,st.StateDescriptionShort,NULL) as 'StateDescriptionShort'
		,c.PostalCode as 'PostalCode'
		,ctry.CountryDescriptionShort as 'CountryDescriptionShort'
		,(SELECT TOP 1 PhoneNumber FROM datClientPhone WHERE ClientGUID = @ClientGUID AND PhoneTypeID = @PhoneTypeID_Home) as 'HomePhone'
		,(SELECT TOP 1 PhoneNumber FROM datClientPhone WHERE ClientGUID = @ClientGUID AND PhoneTypeID = @PhoneTypeID_Work) as 'WorkPhone'
		,(SELECT TOP 1 PhoneNumber FROM datClientPhone WHERE ClientGUID = @ClientGUID AND PhoneTypeID = @PhoneTypeID_Mobile) as 'MobilePhone'
		,c.EmailAddress as 'EmailAddress'
		,CONVERT(DATE, CONVERT(VARCHAR(10),GETUTCDATE(),101)) as 'HomePhoneAuth'
		,CONVERT(DATE, CONVERT(VARCHAR(10),GETUTCDATE(),101)) as 'WorkPhoneAuth'
		,CONVERT(DATE, CONVERT(VARCHAR(10),GETUTCDATE(),101)) as 'MobilePhoneAuth'
		,c.ClientIdentifier as 'ClientIdentifier'
		,CASE WHEN cmSur.ClientMembershipIdentifier IS NOT NULL THEN cmSur.ClientMembershipIdentifier
			WHEN cmExt.ClientMembershipIdentifier IS NOT NULL THEN cmExt.ClientMembershipIdentifier
			WHEN cmXtr.ClientMembershipIdentifier IS NOT NULL THEN cmXtr.ClientMembershipIdentifier
			ELSE cmBio.ClientMembershipIdentifier END as 'ClientMembershipIdentifier'
		,CASE WHEN extMem.MembershipDescriptionShort = @PostExtDescriptionShort AND extcms.IsActiveMembershipFlag = 1 THEN 'YES'
					ELSE 'NO' END as 'IsPostExtremeClient'
		,CAST('1900-01-01' as Date) as 'LeadCreateDate'
		,CAST('1900-01-01' as Date) as 'ConsultDate'
		,cent.[CenterDescription] + '_HAIRCLUB' as 'ConsultOffice'
		,CASE WHEN e.UserLogin IS NOT NULL THEN UPPER(e.UserLogin) + '_HAIRCLUB'
			ELSE ' ' END as 'ConsultantUserName'
		,ISNULL(a_sod.InvoiceNumber, ' ') as 'InvoiceNumber'
		,c.SalesforceContactID as 'HCSalesforceLeadID'
		,c.BosleySalesforceAccountID
	FROM datClient c
		INNER JOIN cfgCenter cent on c.CenterID = cent.CenterID
		LEFT JOIN datClientMembership cmSur ON cmSur.ClientMembershipGuid = c.CurrentSurgeryClientMembershipGUID
		LEFT JOIN datClientMembership cmExt ON cmExt.ClientMembershipGuid = c.CurrentExtremeTherapyClientMembershipGUID
		LEFT JOIN datClientMembership cmBio ON cmBio.ClientMembershipGuid = c.CurrentBioMatrixClientMembershipGUID
		LEFT JOIN datClientMembership cmXtr ON cmXtr.ClientMembershipGuid = c.CurrentXtrandsClientMembershipGUID
		LEFT JOIN lkpClientMembershipStatus extcms ON extcms.ClientMembershipStatusId = cmExt.ClientMembershipStatusId
		OUTER APPLY (
						SELECT TOP(1) so.EmployeeGuid, so.InvoiceNumber, sod.* FROM datSalesOrderDetail sod
							INNER JOIN datSalesOrder so ON so.SalesOrderGuid =sod.SalesOrderGuid
							INNER JOIN cfgSalesCode sc ON sc.SalesCodeID = sod.SalesCodeID
						WHERE so.ClientMembershipGuid = c.CurrentSurgeryClientMembershipGUID
							AND sc.SalesCodeDepartmentID IN (SELECT * FROM @InitialAssigmentDepartments)
						ORDER BY so.OrderDate desc) a_sod
		LEFT JOIN datEmployee e ON e.EmployeeGuid = a_sod.Employee1GUID
		LEFT JOIN cfgMembership extMem ON extMem.MembershipId = cmExt.MembershipId
		LEFT JOIN lkpSalutation s on c.SalutationID = s.SalutationID
		LEFT JOIN lkpGender g on c.GenderID = g.GenderID
		LEFT JOIN lkpState st ON c.StateID = st.StateID
		LEFT JOIN lkpCountry ctry on c.CountryID = ctry.CountryID
	WHERE c.ClientGUID = @ClientGUID
