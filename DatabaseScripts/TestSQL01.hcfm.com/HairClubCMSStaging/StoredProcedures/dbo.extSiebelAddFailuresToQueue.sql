/* CreateDate: 05/15/2013 14:02:29.240 , ModifyDate: 03/09/2020 15:10:50.647 */
GO
/***********************************************************************

PROCEDURE:				extSiebelAddFailuresToQueue

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		5/15/13

LAST REVISION DATE: 	5/15/13

--------------------------------------------------------------------------------------------------------
NOTES: 	Adds failed requests to the Queue.
	* 5/15/13 MVT - Created
	* 5/21/13 MVT - Removed logic to populate consultation date since new version of cONEct will handle that.
	* 10/02/2019 SAL - Updated to removed commented out code that is referencing OnContact and synonyms
						being deleted (TFS #13144)
	* 10/04/2019	MVT		Modified to include HC Salesforce Lead ID and Bosley Salesforce Account ID
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

exec [extSiebelAddFailuresToQueue]

***********************************************************************/

CREATE PROCEDURE [dbo].[extSiebelAddFailuresToQueue]

AS
BEGIN

	SET NOCOUNT ON;

	INSERT INTO [dbo].[datRequestQueue]
			   (
			   [ReferenceOutgoingRequestID]
			   ,[SiebelID]
			   ,[OnContactID]
			   ,[SalutationDescriptionShort]
			   ,[LastName]
			   ,[Firstname]
			   ,[MiddleInitial]
			   ,[GenderDescriptionShort]
			   ,[Address1]
			   ,[Address2]
			   ,[City]
			   ,[ProvinceDescriptionShort]
			   ,[StateDescriptionShort]
			   ,[PostalCode]
			   ,[CountryDescriptionShort]
			   ,[HomePhone]
			   ,[WorkPhone]
			   ,[MobilePhone]
			   ,[EmailAddress]
			   ,[HomePhoneAuth]
			   ,[WorkPhoneAuth]
			   ,[MobilePhoneAuth]
			   ,[ConsultantUsername]
			   ,[ConsultDate]
			   ,[ConsultOffice]
			   ,[LeadCreateDate]
			   ,[ClientIdentifier]
			   ,[ClientMembershipIdentifier]
			   ,[IsPostExtremeClientFlag]
			   ,[InvoiceNumber]
			   ,[IsProcessedFlag]
			   ,[CreateDate]
			   ,[CreateUser]
			   ,[LastUpdate]
			   ,[LastUpdateUser]
			   ,[ProcessName]
			   ,[TenderTypeDescriptionShort]
			   ,[EstGraftCount]
			   ,[EstContractTotal]
			   ,[PrevGraftCount]
			   ,[PrevContractTotal]
			   ,[PrevNumOfProcedures]
			   ,[ConsultationNotes]
			   ,[Amount]
			   ,[FinanceCompany]
			   ,[IsOutDatedFlag]
			   ,[HCSalesforceLeadID]
			   ,[BosleySalesforceAccountID])
	SELECT		req.[OutgoingRequestID]
			   ,req.[SiebelID]
			   ,req.[OnContactID]
			   ,req.[SalutationDescriptionShort]
			   ,req.[LastName]
			   ,req.[Firstname]
			   ,req.[MiddleInitial]
			   ,req.[GenderDescriptionShort]
			   ,req.[Address1]
			   ,req.[Address2]
			   ,req.[City]
			   ,req.[ProvinceDecriptionShort]
			   ,req.[StateDescriptionShort]
			   ,req.[PostalCode]
			   ,req.[CountryDescriptionShort]
			   ,req.[HomePhone]
			   ,req.[WorkPhone]
			   ,req.[MobilePhone]
			   ,req.[EmailAddress]
			   ,req.[HomePhoneAuth]
			   ,req.[WorkPhoneAuth]
			   ,req.[CellPhoneAuth]
			   ,req.[ConsultantUsername]
			   ,req.[ConsultDate]
			   ,req.[ConsultOffice]
			   ,req.[LeadCreatedDate]
			   ,req.[ClientIdentifier]
			   ,req.[ClientMembershipIdentifier]
			   ,req.PostExtremeFlag
			   ,req.[InvoiceNumber]
			   ,0 -- IsProcessed Flag
			   ,GETUTCDATE()
			   ,'sa-Reprocess'
			   ,GETUTCDATE()
			   ,'sa-Reprocess'
			   ,req.[ProcessName]
			   ,req.[TenderTypeDescriptionShort]
			   ,req.[EstGraftCount]
			   ,req.[EstContractTotal]
			   ,req.[PrevGraftCount]
			   ,req.[PrevContractTotal]
			   ,req.[PrevNumOfProcedures]
			   ,req.[ConsultationNotes]
			   ,req.[Amount]
			   ,req.[FinanceCompany]
			   ,0 --IsOutdated flag
			   ,req.[HCSalesforceLeadID]
			   ,req.[BosleySalesforceAccountID]
	FROM datOutgoingRequestLog req
		   LEFT JOIN datOutgoingResponseLog res ON req.OutgoingRequestID = res.OutgoingRequestID
		   LEFT JOIN datRequestQueue rq ON rq.[ReferenceOutgoingRequestID] = req.OutgoingRequestID
	WHERE (res.OutgoingResponseID IS NULL  -- response is missing
			OR res.[ExceptionMessage] IS NOT NULL
			OR res.[ErrorMessage] IS NOT NULL)
			AND req.RequestQueueID IS NULL
			AND rq.[RequestQueueID] IS NULL  -- Not in the Queue already
			AND req.CreateDate > '10/27/2017'
	ORDER BY req.CreateDate
END
GO
