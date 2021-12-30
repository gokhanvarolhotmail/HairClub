/* CreateDate: 05/06/2013 18:26:37.957 , ModifyDate: 03/09/2020 15:10:50.617 */
GO
/*
==============================================================================
PROCEDURE:				extSiebelGetSurgerySaleDetail

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		 4/23/2013

LAST REVISION DATE: 	 4/23/2013

==============================================================================
DESCRIPTION:	Get Sales Order/Client Information for the Interface with Bosley
==============================================================================
NOTES:
	* 04/23/2013	MVT		Created
	* 05/08/2013	MVT		Updated to use Salutation Description instead of Salutation
							Description Short
	* 06/10/2013	MVT		Modified so that consultation date always returns a value
	* 08/15/2013	MVT		Modified to always return a Client Membership Identifier
							in order Surgery, EXT, BIO  (Should always have a surgery
							membership when executing this proc).
	* 11/06/2013	MLM		Fixed performance Issue with Getting data from SQL03
	* 02/04/2015	RMH		Added Xtrands as a possible ClientMembershipIdentifier
	* 03/02/2015	MVT		Updated order in which memberships are selected
	* 04/27/2017    PRM     Updated to reference new datClientPhone table
	* 09/10/2019	MVT		Remove dependency to OnContact. Modified to join to appointment by
							Salesforce Contact ID. Modified to pull Lead Create date cONEct.
							Modified to pull Consult note on appointment in cONEct for comments (TFS #13033).
	* 10/02/2019	SAL		Updated to removed commented out code that is referencing OnContact and synonyms
								being deleted (TFS #13144)
	* 10/04/2019	MVT		Modified to return HC Salesforce Lead ID and Bosley Salesforce Account ID
==============================================================================
SAMPLE EXECUTION:
EXEC extSiebelGetSurgerySaleDetail  'E37C19AF-84D6-42DC-B864-0000C3390525'
==============================================================================
*/
CREATE PROCEDURE [dbo].[extSiebelGetSurgerySaleDetail]
(
	@SalesOrderGUID uniqueidentifier
)
AS
	DECLARE @TenderTypeList as nvarchar(200)
	DECLARE @PostExtDescriptionShort nvarchar(10) = 'POSTEXT'
	DECLARE @PerformSurgeryDepartmentID int = 5060
	DECLARE @InitialAssigmentDepartments table
	(
		SalesCodeDepartmentID int
	)

	INSERT @InitialAssigmentDepartments (SalesCodeDepartmentID) VALUES (1010)
	INSERT @InitialAssigmentDepartments (SalesCodeDepartmentID) VALUES (1070)
	INSERT @InitialAssigmentDepartments (SalesCodeDepartmentID) VALUES (1075)
	INSERT @InitialAssigmentDepartments (SalesCodeDepartmentID) VALUES (1080)
	INSERT @InitialAssigmentDepartments (SalesCodeDepartmentID) VALUES (1090)

	DECLARE @ClientGUID char(36),
			@ConsultNoteTypeID int

	SELECT @ConsultNoteTypeID = nt.NoteTypeID FROM lkpNoteType nt WHERE nt.NoteTypeDescriptionShort = 'Consult'
	SELECT @ClientGUID = so.ClientGUID FROM datSalesOrder so WHERE so.SalesOrderGUID = @SalesOrderGUID


	DECLARE @PreviousSurgeries table
	(
	  ClientMembershipGuid uniqueidentifier,
	  GraftCount int,
	  ContractPrice money
	)

	DECLARE @Tenders table
	(
	  SalesOrderTenderGuid uniqueidentifier,
	  Amount money,
	  TenderTypeDescription nvarchar(100),
	  TenderTypeDescriptionShort nvarchar(10),
	  FinanceCompanyDescription nvarchar(100) NULL
	)

	-- Find all previous surgeries and insert into temp table.
	INSERT INTO @PreviousSurgeries
		SELECT cm.ClientMembershipGuid
				,a_sod.Quantity
				,a_sod.ExtendedPriceCalc
		FROM datSalesOrder so
			INNER JOIN datClient c ON c.ClientGuid = so.ClientGuid
			INNER JOIN datClientMembership cm ON cm.ClientGuid = c.ClientGuid
			INNER JOIN lkpClientMembershipStatus cmstat ON cmstat.ClientMembershipStatusId = cm.ClientMembershipStatusId
			INNER JOIN cfgMembership m ON m.MembershipId = cm.MembershipId
			INNER JOIN lkpBusinessSegment bseg ON bseg.BusinessSegmentId = m.BusinessSegmentId
			OUTER APPLY (
					SELECT TOP(1) sod.* FROM datSalesOrderDetail sod
						INNER JOIN datSalesOrder so ON so.SalesOrderGuid =sod.SalesOrderGuid
						INNER JOIN cfgSalesCode sc ON sc.SalesCodeID = sod.SalesCodeID
					WHERE so.ClientMembershipGuid = cm.ClientMembershipGuid
						AND sc.SalesCodeDepartmentID = @PerformSurgeryDepartmentID   -- OR sod.SalesCodeID = @BosleyRoomReservationSalesCodeID)
					ORDER BY sod.CreateDate desc) a_sod
		WHERE cm.ClientGUID = @ClientGUID
						AND cm.ClientMembershipGuid <> c.CurrentSurgeryClientMembershipGUID
						AND cmstat.ClientMembershipStatusDescriptionShort = 'SP'
						AND bseg.BusinessSegmentDescriptionShort = 'SUR'
		ORDER BY cm.BeginDate desc

	INSERT INTO @Tenders
		SELECT sot.SalesOrderTenderGuid
				,ISNULL(sot.Amount, 0)
				,tt.TenderTypeDescription
				,tt.TenderTypeDescriptionShort
				,fc.FinanceCompanyDescription
		FROM datSalesOrderTender sot
			INNER JOIN lkpTenderType tt ON tt.TenderTypeId = sot.TenderTypeId
			LEFT JOIN lkpFinanceCompany fc ON fc.FinanceCompanyId = sot.FinanceCompanyId
		WHERE sot.SalesOrderGuid = @SalesOrderGuid

	SELECT @TenderTypeList = COALESCE(@TenderTypeList +',' ,'') + TenderTypeDescriptionShort FROM @Tenders

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
		,ISNULL((SELECT SUM(Amount)
					FROM @Tenders), 0) as 'Amount'
		,@TenderTypeList as 'TenderType'
		,(SELECT TOP(1) FinanceCompanyDescription FROM @Tenders WHERE FinanceCompanyDescription IS NOT NULL) as 'FinanceCompany'
		,a_sod.Quantity as 'EstGraftCount'
		,a_sod.ExtendedPriceCalc as 'EstContractTotal'
		,(SELECT TOP(1) ps.GraftCount FROM @PreviousSurgeries ps) as 'PrevGraftCount'
		,(SELECT TOP(1) ps.GraftCount FROM @PreviousSurgeries ps) as 'PrevContractTotal'
		,ISNULL((SELECT COUNT(*) FROM @PreviousSurgeries), 0) as 'PrevNumOfProc'
		,CASE WHEN appt.StartDateTimeCalc IS NOT NULL
             THEN dbo.GetUTCFromLocal(appt.StartDateTimeCalc, tz.[UTCOffset], tz.[UsesDayLightSavingsFlag])
             ELSE GETUTCDATE()
        END AS 'ConsultDate'
		,CASE WHEN extMem.MembershipDescriptionShort = @PostExtDescriptionShort AND extcms.IsActiveMembershipFlag = 1 THEN 'YES'
					ELSE 'NO' END as 'IsPostExtremeClient'
		,c.SalesforceContactID as 'HCSalesforceLeadID'
		,c.BosleySalesforceAccountID
	FROM datSalesOrder sorder
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
