/* CreateDate: 05/06/2013 18:26:37.853 , ModifyDate: 03/09/2020 15:10:50.350 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================
PROCEDURE:				extSiebelGetConsultationDetail

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Michael Maass

IMPLEMENTOR: 			Michael Maass

DATE IMPLEMENTED: 		 4/18/2013

LAST REVISION DATE: 	 4/18/2013

==============================================================================
DESCRIPTION:	Get Client consultation Information for the Interface with Bosley
==============================================================================
NOTES:
	* 05/08/2013	MVT		Updated to use Salutation Description instead of Salutation
							Description Short
	* 06/10/2013	MVT		Modified so that consultation date and lead create date always return a value
	* 06/18/2013	MVT		Modified to also take a Consultant Guid.
	* 08/15/2013	MVT		Modified to always return a Client Membership Identifier
							in order Surgery, EXT, BIO
	* 01/03/2014	MVT		Updated to no longer use lead_info OnContact View.
	* 03/02/2015	MVT		Updated proc for Xtrands Business Segment
	* 04/26/2017    PRM     Updated to reference new datClientPhone table
	* 09/11/2019	MVT		Modified to pull consultation Note and Lead Create Date from cONEct.  Removed
							OnContact dependency (TFS #13033).
	* 10/02/2019	SAL		Updated to removed commented out code that is referencing OnContact and synonyms
							being deleted (TFS #13144)
	* 10/04/2019	MVT		Modified to return HC Salesforce Lead ID and Bosley Salesforce Account ID
==============================================================================
SAMPLE EXECUTION:
EXEC extSiebelGetConsultationDetail  'ADFA47B0-C15F-4A2F-98BF-387DD2D18F40', '394A5A0F-80DB-4ACA-BF9F-015E9B2B6A3C'
==============================================================================
*/
CREATE PROCEDURE [dbo].[extSiebelGetConsultationDetail]
(
	@ClientGUID uniqueidentifier,
	@ConsultantGUID uniqueidentifier = NULL
)
AS

	DECLARE @InitialAssignmentSalesCodeID int
	DECLARE @PostExtDescriptionShort nvarchar(10) = 'POSTEXT'
	--SELECT @InitialAssignmentSalesCodeID = SalesCodeID FROM cfgSalesCode WHERE SalesCodeDescriptionShort = 'INITASG' --New Membership

	DECLARE @InitialAssigmentDepartments table
	(
		SalesCodeDepartmentID int
	)

	DECLARE @ConsultNoteTypeID int
	SELECT @ConsultNoteTypeID = nt.NoteTypeID FROM lkpNoteType nt WHERE nt.NoteTypeDescriptionShort = 'Consult'

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
		ISNULL(c.SiebelID, '') as 'SiebelID'
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
		,appt.Note as 'Comment'
		,CONVERT(DATE, CONVERT(VARCHAR(10),GETUTCDATE(),101)) as 'HomePhoneAuth'
		,CONVERT(DATE, CONVERT(VARCHAR(10),GETUTCDATE(),101)) as 'WorkPhoneAuth'
		,CONVERT(DATE, CONVERT(VARCHAR(10),GETUTCDATE(),101)) as 'MobilePhoneAuth'
		,ISNULL(c.LeadCreateDate, c.CreateDate)  as 'LeadCreateDate'
		,c.ClientIdentifier as 'ClientIdentifier'
		,CASE WHEN cmSur.ClientMembershipIdentifier IS NOT NULL THEN cmSur.ClientMembershipIdentifier
			WHEN cmExt.ClientMembershipIdentifier IS NOT NULL THEN cmExt.ClientMembershipIdentifier
			WHEN cmXtr.ClientMembershipIdentifier IS NOT NULL THEN cmXtr.ClientMembershipIdentifier
			ELSE cmBio.ClientMembershipIdentifier END as 'ClientMembershipIdentifier'
		,cent.[CenterDescription] + '_HAIRCLUB' as 'ConsultOffice'
		,UPPER(ISNULL(consult_e.UserLogin, e.UserLogin)) + '_HAIRCLUB' as 'ConsultantUserName'
		,CASE WHEN appt.StartDateTimeCalc IS NOT NULL
             THEN dbo.GetUTCFromLocal(appt.StartDateTimeCalc, tz.[UTCOffset], tz.[UsesDayLightSavingsFlag])
             ELSE GETUTCDATE()
        END AS 'ConsultDate'
		,CASE WHEN extMem.MembershipDescriptionShort = @PostExtDescriptionShort AND extcms.IsActiveMembershipFlag = 1 THEN 'YES'
					ELSE 'NO' END as 'IsPostExtremeClient'
		,c.SalesforceContactID as 'HCSalesforceLeadID'
		,c.BosleySalesforceAccountID
	FROM datClient c
		INNER JOIN cfgCenter cent WITH (NOLOCK) on c.CenterID = cent.CenterID
		LEFT JOIN datClientMembership cmSur WITH (NOLOCK) ON cmSur.ClientMembershipGuid = c.CurrentSurgeryClientMembershipGUID
		LEFT JOIN datClientMembership cmExt WITH (NOLOCK) ON cmExt.ClientMembershipGuid = c.CurrentExtremeTherapyClientMembershipGUID
		LEFT JOIN datClientMembership cmBio WITH (NOLOCK) ON cmBio.ClientMembershipGuid = c.CurrentBioMatrixClientMembershipGUID
		LEFT JOIN datClientMembership cmXtr WITH (NOLOCK) ON cmXtr.ClientMembershipGuid = c.CurrentXtrandsClientMembershipGUID
		LEFT JOIN lkpClientMembershipStatus extcms WITH (NOLOCK) ON extcms.ClientMembershipStatusId = cmExt.ClientMembershipStatusId
		LEFT JOIN cfgMembership extMem WITH (NOLOCK) ON extMem.MembershipId = cmExt.MembershipId
		OUTER APPLY (
						SELECT TOP(1) so.EmployeeGuid, sod.* FROM datSalesOrderDetail sod
							INNER JOIN datSalesOrder so ON so.SalesOrderGuid =sod.SalesOrderGuid
							INNER JOIN cfgSalesCode sc ON sc.SalesCodeID = sod.SalesCodeID
						WHERE so.ClientMembershipGuid = c.CurrentSurgeryClientMembershipGUID
							AND sc.SalesCodeDepartmentID IN (SELECT * FROM @InitialAssigmentDepartments)
						ORDER BY sod.CreateDate desc) a_sod
		LEFT JOIN datEmployee e WITH (NOLOCK) ON e.EmployeeGuid = a_sod.Employee1Guid
		LEFT JOIN datEmployee consult_e WITH (NOLOCK) ON consult_e.EmployeeGuid = @ConsultantGUID
		LEFT JOIN lkpSalutation s WITH (NOLOCK) on c.SalutationID = s.SalutationID
		LEFT JOIN lkpGender g WITH (NOLOCK) on c.GenderID = g.GenderID
		LEFT JOIN lkpState st WITH (NOLOCK) ON c.StateID = st.StateID
		LEFT JOIN lkpCountry ctry WITH (NOLOCK) on c.CountryID = ctry.CountryID
		OUTER APPLY (
			SELECT TOP(1)
					nc.NotesClient As Note,
					a.*
			FROM datAppointment a
				LEFT JOIN datNotesClient nc ON nc.AppointmentGUID = a.AppointmentGUID AND nc.NoteTypeID = @ConsultNoteTypeID
			WHERE a.SalesforceContactID IS NOT NULL
				AND a.SalesforceContactID = c.SalesforceContactID
			ORDER BY a.CreateDate DESC) appt
		LEFT JOIN cfgCenter cntr WITH (NOLOCK) ON cntr.CenterID = appt.CenterID
		LEFT JOIN lkpTimeZone tz WITH (NOLOCK) ON cntr.TimeZoneID = tz.TimeZoneID
	WHERE c.ClientGUID = @ClientGUID
GO
