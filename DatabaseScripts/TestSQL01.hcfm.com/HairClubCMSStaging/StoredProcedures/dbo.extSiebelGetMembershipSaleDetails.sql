/* CreateDate: 04/24/2017 15:54:06.850 , ModifyDate: 03/09/2020 15:10:50.557 */
GO
/*
==============================================================================
PROCEDURE:				extSiebelGetMembershipSaleDetails

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Paul Madary

IMPLEMENTOR: 			Paul Madary

DATE IMPLEMENTED: 		 4/3/2017

LAST REVISION DATE: 	 4/3/2017

==============================================================================
DESCRIPTION:	Get Membership Sales Order Details/Client Information for the Interface with Bosley
==============================================================================
NOTES:
	* 04/03/2017	PRM		Created
	* 04/26/2017    PRM     Updated to reference new datClientPhone table
	* 09/10/2019	MVT		Remove dependency to OnContact. Modified to join to appointment by
							Salesforce Contact ID. Modified to pull Lead Create date cONEct.
							Modified to pull Consult note on appointment in cONEct for comments (TFS #13033).
	* 10/02/2019	SAL		Updated to removed commented out code that is referencing OnContact and synonyms
								being deleted (TFS #13144)
	* 10/04/2019	MVT		Modified to return HC Salesforce Lead ID and Bosley Salesforce Account ID
	* 10/22/2019	MVT		Updated for SMP and 4PRP (TFS #13277)
==============================================================================
SAMPLE EXECUTION:
EXEC extSiebelGetMembershipSaleDetails  'E37C19AF-84D6-42DC-B864-0000C3390525'
==============================================================================
*/
CREATE PROCEDURE [dbo].[extSiebelGetMembershipSaleDetails]
(
	@SalesOrderGUID uniqueidentifier
)
AS

	DECLARE @ClientGUID char(36),
			@ConsultNoteTypeID int

	SELECT @ConsultNoteTypeID = nt.NoteTypeID FROM lkpNoteType nt WHERE nt.NoteTypeDescriptionShort = 'Consult'
	SELECT @ClientGUID = so.ClientGUID FROM datSalesOrder so WHERE so.SalesOrderGUID = @SalesOrderGUID

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
		,ISNULL(c.LeadCreateDate,c.CreateDate) as 'LeadCreateDate'
		,c.ClientIdentifier as 'ClientIdentifier'
		,CASE WHEN cmSur.ClientMembershipIdentifier IS NOT NULL THEN cmSur.ClientMembershipIdentifier
			WHEN cmExt.ClientMembershipIdentifier IS NOT NULL THEN cmExt.ClientMembershipIdentifier
			WHEN cmXtr.ClientMembershipIdentifier IS NOT NULL THEN cmXtr.ClientMembershipIdentifier
			ELSE cmBio.ClientMembershipIdentifier END as 'ClientMembershipIdentifier'
		,cent.[CenterDescription] + '_HAIRCLUB' as 'ConsultOffice'
		,UPPER(e.UserLogin) + '_HAIRCLUB' as 'ConsultantUserName'

		,sorder.InvoiceNumber as 'InvoiceNumber'
		,0 as 'Amount'
		,'' as 'TenderType'
		,'' as 'FinanceCompany'
		,CASE WHEN ao.AddOnDescriptionShort = '4TGE' THEN 4 ELSE sorderdet.Quantity END as 'EstGraftCount'
		,sorderdet.ExtendedPriceCalc as 'EstContractTotal'
		,0 as 'PrevGraftCount'
		,0 as 'PrevContractTotal'
		,0 as 'PrevNumOfProc'
		,CASE WHEN appt.StartDateTimeCalc IS NOT NULL
             THEN dbo.GetUTCFromLocal(appt.StartDateTimeCalc, tz.[UTCOffset], tz.[UsesDayLightSavingsFlag])
             ELSE GETUTCDATE()
        END AS 'ConsultDate'
		,'NO' as 'IsPostExtremeClient'
		, CASE WHEN ao.AddOnDescriptionShort = 'CS' THEN 'ProcedureCS'
			WHEN ao.AddOnDescriptionShort = 'TGE' THEN 'ProcedureTriGenEnh'
			WHEN ao.AddOnDescriptionShort = '4TGE' THEN 'ProcedureTriGenEnh'
			WHEN ao.AddOnDescriptionShort = 'TGE9BPS' THEN 'ProcedureTriGenEnhBPS'
			WHEN ao.AddOnDescriptionShort like 'SMP%' THEN 'ProcedureSMP'
			ELSE 'ProcedureAddOnUnknown' END as ProcessName
		,c.SalesforceContactID as 'HCSalesforceLeadID'
		,c.BosleySalesforceAccountID
	FROM datSalesOrder sorder
		INNER JOIN datSalesOrderDetail sorderdet ON sorder.SalesOrderGuid = sorderdet.SalesOrderGuid
		INNER JOIN datClientMembershipAddOn cmao ON sorderdet.ClientMembershipAddOnID = cmao.ClientMembershipAddOnID --This will only return details with an Add-On attached to it
		INNER JOIN cfgAddOn ao ON cmao.AddOnID = ao.AddOnID
		INNER JOIN datClient c ON c.ClientGuid = sorder.ClientGuid
		INNER JOIN cfgCenter cent ON c.CenterID = cent.CenterID
		LEFT JOIN datClientMembership cmSur ON cmSur.ClientMembershipGuid = c.CurrentSurgeryClientMembershipGUID
		LEFT JOIN datClientMembership cmExt ON cmExt.ClientMembershipGuid = c.CurrentExtremeTherapyClientMembershipGUID
		LEFT JOIN datClientMembership cmBio ON cmBio.ClientMembershipGuid = c.CurrentBioMatrixClientMembershipGUID
		LEFT JOIN datClientMembership cmXtr ON cmXtr.ClientMembershipGuid = c.CurrentXtrandsClientMembershipGUID
		LEFT JOIN lkpClientMembershipStatus extcms ON extcms.ClientMembershipStatusId = cmExt.ClientMembershipStatusId
		LEFT JOIN cfgMembership extMem ON extMem.MembershipId = cmExt.MembershipId
		OUTER APPLY (
						SELECT TOP(1) so.EmployeeGuid, sod.* FROM datSalesOrderDetail sod
							INNER JOIN datSalesOrder so ON so.SalesOrderGuid =sod.SalesOrderGuid
							INNER JOIN cfgSalesCode sc ON sc.SalesCodeID = sod.SalesCodeID
						WHERE so.ClientMembershipGuid = c.CurrentSurgeryClientMembershipGUID
							AND sc.SalesCodeDepartmentID IN (SELECT * FROM @InitialAssigmentDepartments)
						ORDER BY sod.CreateDate desc) a_sod
		LEFT JOIN datEmployee e ON e.EmployeeGuid = a_sod.Employee1GUID
		LEFT JOIN lkpSalutation s on c.SalutationID = s.SalutationID
		LEFT JOIN lkpGender g on c.GenderID = g.GenderID
		LEFT JOIN lkpState st ON c.StateID = st.StateID
		LEFT JOIN lkpCountry ctry on c.CountryID = ctry.CountryID
		OUTER APPLY (
			SELECT TOP(1)
					nc.NotesClient As Note,
					a.*
			FROM datAppointment a
				LEFT JOIN datNotesClient nc ON nc.AppointmentGUID = a.AppointmentGUID AND nc.NoteTypeID = @ConsultNoteTypeID
			WHERE a.SalesforceContactID IS NOT NULL
				AND a.SalesforceContactID = c.SalesforceContactID
			ORDER BY a.CreateDate DESC) appt
		LEFT JOIN cfgCenter cntr ON cntr.CenterID = appt.CenterID
		LEFT JOIN lkpTimeZone tz ON cntr.TimeZoneID = tz.TimeZoneID
	WHERE sorder.SalesOrderGuid = @SalesOrderGUID
GO
