/***********************************************************************

PROCEDURE:				extSiebelAddUpdateToQueue

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		5/19/13

LAST REVISION DATE: 	5/19/13

--------------------------------------------------------------------------------------------------------
NOTES: 	Adds an Update for the specified client to the Queue
	* 05/19/2013	MVT		Created
	* 10/04/2019	MVT		Modified to include HC Salesforce Lead ID and Bosley Salesforce Account ID
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

exec [extSiebelAddUpdateToQueue] '064DB407-6CCC-42B3-B877-014A48A07F7E'

***********************************************************************/

CREATE PROCEDURE [dbo].[extSiebelAddUpdateToQueue]
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
				HomePhoneAuth DateTime NULL,
				WorkPhoneAuth DateTime NULL,
				MobilePhoneAuth DateTime NULL,
				ClientIdentifier INT NULL,
				ClientMembershipIdentifier nvarchar(50) NULL,
				IsPostExtremeClientFlag nvarchar(3) NULL,
				LeadCreateDate DateTime NULL,
				ConsultDate DateTime NULL,
				ConsultOffice nvarchar(50) NULL,
				ConsultantUserName nvarchar(50) NULL,
				InvoiceNumber nvarchar(20) NULL,
				HCSalesforceLeadID nvarchar(50) NULL,
				BosleySalesforceAccountID nvarchar(50) NULL
			);

	INSERT INTO @TempQueue(SiebelID, OnContactID, SalutationDescriptionShort, LastName, FirstName, MiddleInitial, GenderDescriptionShort, Address1, Address2, City, ProvinceDescriptionShort,
								StateDescriptionShort, PostalCode, CountryDescriptionShort, HomePhone, WorkPhone, MobilePhone, EmailAddress, HomePhoneAuth, WorkPhoneAuth, MobilePhoneAuth,
								ClientIdentifier, ClientMembershipIdentifier, IsPostExtremeClientFlag, LeadCreateDate, ConsultDate, ConsultOffice, ConsultantUserName, InvoiceNumber,
								HCSalesforceLeadID, BosleySalesforceAccountID)
	EXEC [dbo].[extSiebelUpdate] @ClientGUID

	INSERT INTO datRequestQueue(SiebelID, OnContactID, SalutationDescriptionShort, LastName, FirstName, MiddleInitial, GenderDescriptionShort, Address1, Address2, City, ProvinceDescriptionShort,
								StateDescriptionShort, PostalCode, CountryDescriptionShort, HomePhone, WorkPhone, MobilePhone, EmailAddress, HomePhoneAuth, WorkPhoneAuth, MobilePhoneAuth,
								LeadCreateDate, ClientIdentifier, ClientMembershipIdentifier, ConsultOffice, ConsultantUserName, ConsultDate, IsPostExtremeClientFlag,
								InvoiceNumber, ProcessName, CreateDate, CreateUser, LastUpdate, LastUpdateUser, HCSalesforceLeadID, BosleySalesforceAccountID)
	SELECT SiebelID, OnContactID, SalutationDescriptionShort, LastName, FirstName, MiddleInitial, GenderDescriptionShort, Address1, Address2, City, ProvinceDescriptionShort,
								StateDescriptionShort, PostalCode, CountryDescriptionShort, HomePhone, WorkPhone, MobilePhone, EmailAddress, HomePhoneAuth, WorkPhoneAuth, MobilePhoneAuth, LeadCreateDate,
								ClientIdentifier, ClientMembershipIdentifier, ConsultOffice, ConsultantUserName, ConsultDate,
								IsPostExtremeClientFlag, InvoiceNumber, 'Update', GETUTCDATE(), 'sa', GETUTCDATE(), 'sa', HCSalesforceLeadID, BosleySalesforceAccountID
	FROM @TempQueue

END
