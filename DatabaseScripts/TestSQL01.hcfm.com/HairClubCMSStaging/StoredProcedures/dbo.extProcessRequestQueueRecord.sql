/* CreateDate: 05/15/2013 13:59:08.290 , ModifyDate: 03/09/2020 15:10:50.637 */
GO
/***********************************************************************

PROCEDURE:				extProcessRequestQueueRecord

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Maass

IMPLEMENTOR: 			Mike Maass

DATE IMPLEMENTED: 		05/14/2013

LAST REVISION DATE: 	05/14/2013

--------------------------------------------------------------------------------------------------------
NOTES: 	Return RequestQueue Records to be processed

		05/14/13 - MLM	: Initial Creation
		10/04/19 - MVT	: Updated to write HC Salesforce Lead ID and Bosley Account ID to the Outgoing Request Log.
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

extProcessRequestQueueRecord 1

***********************************************************************/
CREATE PROCEDURE [dbo].[extProcessRequestQueueRecord]
	@RequestQueueID int
AS
BEGIN

	SET NOCOUNT ON;

	BEGIN TRANSACTION
	BEGIN Try

		--Add RequestQueue Record to the OutgoingRequestLog Table
		INSERT INTO datOutgoingRequestLog(RequestQueueID, OnContactID, SalutationDescriptionShort, LastName, FirstName, MiddleInitial, GenderDescriptionShort, Address1, Address2, City, ProvinceDecriptionShort, StateDescriptionShort,
					PostalCode, CountryDescriptionShort, HomePhone, WorkPhone, MobilePhone, EmailAddress, HomePhoneAuth, WorkPhoneAuth, CellPhoneAuth, ConsultationNotes, ConsultOffice, ConsultantUserName, ConsultDate,
					LeadCreatedDate, ProcessName, SiebelID, ClientIdentifier, ClientMembershipIdentifier, InvoiceNumber, Amount, TenderTypeDescriptionShort, FinanceCompany, EstGraftCount, EstContractTotal,
					PrevGraftCount, PrevContractTotal, PrevNumOfProcedures, PostExtremeFlag, CreateDate, CreateUser,LastUpdate, LastUpdateUser, HCSalesforceLeadID, BosleySalesforceAccountID)
			SELECT rq.RequestQueueID, rq.OnContactID, rq.SalutationDescriptionShort, rq.LastName, rq.FirstName, rq.MiddleInitial, rq.GenderDescriptionShort, rq.Address1, rq.Address2, rq.City, rq.ProvinceDescriptionShort, rq.StateDescriptionShort,
					rq.PostalCode, rq.CountryDescriptionShort, rq.HomePhone, rq.WorkPhone, rq.MobilePhone, rq.EmailAddress, rq.HomePhoneAuth, rq.WorkPhoneAuth, rq.MobilePhoneAuth, rq.ConsultationNotes, rq.ConsultOffice, rq.ConsultantUserName, rq.ConsultDate,
					rq.LeadCreateDate, rq.ProcessName, IIF(ISNULL(rq.SiebelID,'') = '',c.SiebelID, rq.SiebelID), rq.ClientIdentifier, rq.ClientMembershipIdentifier, rq.InvoiceNumber, rq.Amount, rq.TenderTypeDescriptionShort, rq.FinanceCompany, rq.EstGraftCount, rq.EstContractTotal,
					rq.PrevGraftCount, rq.PrevContractTotal, rq.PrevNumOfProcedures, rq.IsPostExtremeClientFlag, GETUTCDATE(), 'sa', GETUTCDATE(), 'sa', rq.HCSalesforceLeadID, rq.BosleySalesforceAccountID
			FROM datRequestQueue rq
			INNER JOIN datClient c on rq.ClientIdentifier = c.ClientIdentifier
			WHERE rq.RequestQueueID = @RequestQueueID

		--Fetch the Record From the datOutgoingRequestLog
		SELECT *
		FROM datOutgoingRequestLog
		WHERE RequestQueueID = @RequestQueueID

		COMMIT TRANSACTION
	END Try

	BEGIN Catch

		RAISERROR(N'Failed to Retrieve RequestQueue Record', 16, 1)
		ROLLBACK TRANSACTION
	END Catch

END
GO
