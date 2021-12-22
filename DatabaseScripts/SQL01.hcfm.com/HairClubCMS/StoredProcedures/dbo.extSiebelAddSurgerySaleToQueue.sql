/***********************************************************************

PROCEDURE:				extSiebelAddSurgerySaleToQueue

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		5/23/13

LAST REVISION DATE: 	5/23/13

--------------------------------------------------------------------------------------------------------
NOTES: 	Adds a Surgery Sale for the specified client to the Queue
	* 05/23/2013	MVT		Created
	* 10/04/2019	MVT		Modified to include HC Salesforce Lead ID and Bosley Salesforce Account ID
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

exec [extSiebelAddSurgerySaleToQueue] '4B9BEC3E-B6BA-41D5-B00C-3EAE529BF11F'

***********************************************************************/

CREATE PROCEDURE [dbo].[extSiebelAddSurgerySaleToQueue]
	  @SalesOrderGuid uniqueidentifier
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

				InvoiceNumber nvarchar(50) NULL,
				Amount money NULL,
				TenderTypeDescriptionShort nvarchar(500) NULL,
				FinanceCompany nvarchar(50) NULL,
				EstGraftCount int NULL,
				EstContractTotal money NULL,
				PrevGraftCount int NULL,
				PrevContractTotal money NULL,
				PrevNumOfProc int NULL,

				ConsultDate DateTime NULL,
				IsPostExtremeClientFlag nvarchar(3) NULL,
				HCSalesforceLeadID nvarchar(50) NULL,
				BosleySalesforceAccountID nvarchar(50) NULL
			);

	INSERT INTO @TempQueue(SiebelID, OnContactID, SalutationDescriptionShort, LastName, FirstName, MiddleInitial, GenderDescriptionShort, Address1, Address2, City, ProvinceDescriptionShort,
								StateDescriptionShort, PostalCode, CountryDescriptionShort, HomePhone, WorkPhone, MobilePhone, EmailAddress, Comment, HomePhoneAuth, WorkPhoneAuth, MobilePhoneAuth,
								LeadCreateDate, ClientIdentifier, ClientMembershipIdentifier, ConsultOffice, ConsultantUserName,
								InvoiceNumber, Amount, TenderTypeDescriptionShort, FinanceCompany, EstGraftCount, EstContractTotal, PrevGraftCount, PrevContractTotal, PrevNumOfProc,
								 ConsultDate, IsPostExtremeClientFlag, HCSalesforceLeadID, BosleySalesforceAccountID)
	EXEC [dbo].[extSiebelGetSurgerySaleDetail] @SalesOrderGuid

	INSERT INTO datRequestQueue(SiebelID, OnContactID, SalutationDescriptionShort, LastName, FirstName, MiddleInitial, GenderDescriptionShort, Address1, Address2, City, ProvinceDescriptionShort,
								StateDescriptionShort, PostalCode, CountryDescriptionShort, HomePhone, WorkPhone, MobilePhone, EmailAddress, ConsultationNotes, HomePhoneAuth, WorkPhoneAuth, MobilePhoneAuth,
								LeadCreateDate, ClientIdentifier, ClientMembershipIdentifier, ConsultOffice, ConsultantUserName,
								InvoiceNumber, Amount, TenderTypeDescriptionShort, FinanceCompany, EstGraftCount, EstContractTotal, PrevGraftCount, PrevContractTotal, PrevNumOfProcedures,
								ConsultDate, IsPostExtremeClientFlag, ProcessName, CreateDate, CreateUser, LastUpdate, LastUpdateUser, HCSalesforceLeadID, BosleySalesforceAccountID)
	SELECT SiebelID, OnContactID, SalutationDescriptionShort, LastName, FirstName, MiddleInitial, GenderDescriptionShort, Address1, Address2, City, ProvinceDescriptionShort,
								StateDescriptionShort, PostalCode, CountryDescriptionShort, HomePhone, WorkPhone, MobilePhone, EmailAddress, Comment, HomePhoneAuth, WorkPhoneAuth, MobilePhoneAuth, LeadCreateDate,
								ClientIdentifier, ClientMembershipIdentifier, ConsultOffice, ConsultantUserName,
								InvoiceNumber, Amount, TenderTypeDescriptionShort, FinanceCompany, EstGraftCount, EstContractTotal, PrevGraftCount, PrevContractTotal, PrevNumOfProc,
								ConsultDate, IsPostExtremeClientFlag, 'Procedure', GETUTCDATE(), 'sa', GETUTCDATE(), 'sa', HCSalesforceLeadID, BosleySalesforceAccountID
	FROM @TempQueue

END
