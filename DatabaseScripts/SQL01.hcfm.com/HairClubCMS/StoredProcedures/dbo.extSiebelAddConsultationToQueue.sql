/***********************************************************************

PROCEDURE:				extSiebelAddConsultationToQueue

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		5/15/13

LAST REVISION DATE: 	5/15/13

--------------------------------------------------------------------------------------------------------
NOTES: 	Adds a Consultation for the specified client to the Queue
	* 05/15/2013 MVT - Created
	* 10/04/2019 MVT - Modified to Add HC Salesforce Lead ID and Bosley Salesforce Account ID to Request Queue

--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

exec [extSiebelAddConsultationToQueue] '4B9BEC3E-B6BA-41D5-B00C-3EAE529BF11F'

***********************************************************************/

CREATE PROCEDURE [dbo].[extSiebelAddConsultationToQueue]
	  @ClientGUID uniqueidentifier
AS
BEGIN

	SET NOCOUNT ON;

	-- Insert Record Into datRequestQueue
	DECLARE  @TempQueue TABLE (
				SiebelID nvarchar(50) NULL,
				OnContactID NVARCHAR(50) NULL,
				SalutationDescriptionShort nvarchar(10) NULL,
				LastName nvarchar(50) NULL,
				Firstname nvarchar(50) NULL,
				MiddleInitial nvarchar(1) NULL,
				GenderDescriptionShort nvarchar(10) NULL,
				Address1 nvarchar(50) NULL,
				Address2 nvarchar(50) NULL,
				City nvarchar(50) NULL,
				ProvinceDescriptionShort nvarchar(10) NULL,
				StateDescriptionShort nvarchar(10) NULL,
				PostalCode nvarchar(10) NULL,
				CountryDescriptionShort nvarchar(10) NULL,
				HomePhone nvarchar(15) NULL,
				WorkPhone nvarchar(15) NULL,
				MobilePhone nvarchar(15) NULL,
				EmailAddress nvarchar(100) NULL,
				Comment nvarchar(2000) NULL,
				HomePhoneAuth DateTime NULL,
				WorkPhoneAuth DateTime NULL,
				MobilePhoneAuth DateTime NULL,
				LeadCreateDate DateTime NULL,
				ClientIdentifier INT NULL,
				ClientMembershipIdentifier nvarchar(50) NULL,
				ConsultOffice nvarchar(50) NULL,
				ConsultantUsername nvarchar(50) NULL,
				ConsultDate DateTime NULL,
				IsPostExtremeClientFlag nvarchar(3) NULL,
				HCSalesforceLeadID nvarchar(50) NULL,
				BosleySalesforceAccountID nvarchar(50) NULL
			);

	INSERT INTO @TempQueue(SiebelID, OnContactID, SalutationDescriptionShort, LastName, FirstName, MiddleInitial, GenderDescriptionShort, Address1, Address2, City, ProvinceDescriptionShort,
								StateDescriptionShort, PostalCode, CountryDescriptionShort, HomePhone, WorkPhone, MobilePhone, EmailAddress, Comment, HomePhoneAuth, WorkPhoneAuth, MobilePhoneAuth,
								LeadCreateDate, ClientIdentifier, ClientMembershipIdentifier, ConsultOffice, ConsultantUserName, ConsultDate, IsPostExtremeClientFlag, HCSalesforceLeadID, BosleySalesforceAccountID)
	EXEC [dbo].[extSiebelGetConsultationDetail] @ClientGUID

	INSERT INTO datRequestQueue(SiebelID, OnContactID, SalutationDescriptionShort, LastName, FirstName, MiddleInitial, GenderDescriptionShort, Address1, Address2, City, ProvinceDescriptionShort,
								StateDescriptionShort, PostalCode, CountryDescriptionShort, HomePhone, WorkPhone, MobilePhone, EmailAddress, ConsultationNotes, HomePhoneAuth, WorkPhoneAuth, MobilePhoneAuth,
								LeadCreateDate, ClientIdentifier, ClientMembershipIdentifier, ConsultOffice, ConsultantUserName, ConsultDate, IsPostExtremeClientFlag, ProcessName, CreateDate, CreateUser, LastUpdate,
								LastUpdateUser, HCSalesforceLeadID, BosleySalesforceAccountID)
	SELECT SiebelID, OnContactID, SalutationDescriptionShort, LastName, FirstName, MiddleInitial, GenderDescriptionShort, Address1, Address2, City, ProvinceDescriptionShort,
								StateDescriptionShort, PostalCode, CountryDescriptionShort, HomePhone, WorkPhone, MobilePhone, EmailAddress, Comment, HomePhoneAuth, WorkPhoneAuth, MobilePhoneAuth, LeadCreateDate,
								ClientIdentifier, ClientMembershipIdentifier, ConsultOffice, ConsultantUserName, ConsultDate,
								IsPostExtremeClientFlag, 'Consultation', GETUTCDATE(), 'sa', GETUTCDATE(), 'sa', HCSalesforceLeadID, BosleySalesforceAccountID
	FROM @TempQueue

END
