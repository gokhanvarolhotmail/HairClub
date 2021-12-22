/* CreateDate: 11/12/2013 11:26:24.507 , ModifyDate: 11/12/2013 11:26:24.507 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************

PROCEDURE:				dbaSelectBosleyActivities

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Mike Tovbin

IMPLEMENTOR: 			Mike Tovbin

DATE IMPLEMENTED: 		5/16/13

LAST REVISION DATE: 	5/16/13

--------------------------------------------------------------------------------------------------------
NOTES: 	Selects all Bosley activity for specified date range.
	* 5/15/13 MVT - Created
	* 5/21/13 MVT - Updated to include "I" for Incoming, "RES" for Result, and "O" for Outgoing
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

exec [dbaSelectBosleyActivitiesEnhanced] '5/01/13', '5/30/13', NULL
exec [dbaSelectBosleyActivitiesEnhanced] NULL, NULL, 417844

***********************************************************************/

CREATE PROCEDURE [dbo].[dbaSelectBosleyActivitiesEnhanced]
	  @StartDate DateTime,
	  @EndDate DateTime,
	  @ClientIdentifier int

AS
BEGIN

	SET NOCOUNT ON;

	--DECLARE @StartDate datetime = '5/1/13'
	--DECLARE @EndDate datetime = '5/16/13'

	DECLARE  @FullLog TABLE (
				[EntryType] [nvarchar] (30),
				[ConsultantUsername] [nvarchar](200) NULL,
				[ProcessName] [nvarchar](40) NULL,
				[SiebelID] [nvarchar](50) NULL,
				[InitialOutgoing] [int] NULL,
				[ClientIdentifier] [int] NULL,
				[ClientMembershipIdentifier] [nvarchar](50) NULL,
				[MembershipDescription] [nvarchar](100) NULL,
				[IsSuccessfull] bit NOT NULL,

				[ResultSiebelID] [nvarchar] (50) NULL,
				[OutgoingRequestID] [int] NULL,
				[OnContactID] [nvarchar](50) NULL,
				[SalutationDescriptionShort] [nvarchar](10) NULL,
				[LastName] [nvarchar](50) NULL,
				[Firstname] [nvarchar](50) NULL,
				[MiddleInitial] [nvarchar](1) NULL,
				[GenderDescriptionShort] [nvarchar](10) NULL,
				[Address1] [nvarchar](100) NULL,
				[Address2] [nvarchar](50) NULL,
				[City] [nvarchar](100) NULL,
				[ProvinceDecriptionShort] [nvarchar](10) NULL,
				[StateDescriptionShort] [nvarchar](10) NULL,
				[PostalCode] [nvarchar](10) NULL,
				[CountryDescriptionShort] [nvarchar](10) NULL,
				[HomePhone] [nvarchar](15) NULL,
				[WorkPhone] [nvarchar](15) NULL,
				[MobilePhone] [nvarchar](15) NULL,
				[EmailAddress] [nvarchar](100) NULL,
				[HomePhoneAuth] [datetime] NULL,
				[WorkPhoneAuth] [datetime] NULL,
				[CellPhoneAuth] [datetime] NULL,
				[ConsultationNotes] [varchar](5000) NULL,
				[ConsultOffice] [nvarchar](50) NULL,
				[LeadCreatedDate] [datetime] NULL,
				[InvoiceNumber] [nvarchar](50) NULL,
				[Amount] [Money] NULL,
				[TenderTypeDescriptionShort] [nvarchar](200) NULL,
				[FinanceCompany] [nvarchar](100) NULL,
				[EstGraftCount] [int] NULL,
				[EstContractTotal] [Money] NULL,
				[PrevGraftCount] [int] NULL,
				[PrevContractTotal] [Money] NULL,
				[PrevNumOfProcedures] [int] NULL,
				[PostExtremeFlag] [nvarchar](3) NULL,
				[RequestQueueID] [int] NULL,
				[ConsultDate] [datetime] NULL,


				[IncomingRequestID] [int] NULL,
				[BosleyRequestID] [int] NULL,
				[PatientSlipNo] [nvarchar](50) NULL,
				[TreatmentPlanDate] [datetime] NULL,
				[TreatmentPlanNo] [nvarchar](50) NULL,
				[TreatmentPlanGraftCount] [int] NULL,
				[TreatmentPlanContractAmount] [Money] NULL,
				[ProcedureStatus] [nvarchar](30) NULL,
				[ProcedureDate] [datetime] NULL,
				[ProcedureGraftCount] [int] NULL,
				[ProcedureAmount] [decimal](14, 4) NULL,
				[PaymentDate] [datetime] NULL,
				[PaymentAmount] [decimal](14, 4) NULL,
				[PaymentType] [nvarchar](30) NULL,
				[IsProcessedFlag] [bit] NULL,
				[ConsultationStatus] [nvarchar](50) NULL,
				[ConsultationStatusDate] [datetime] NULL,
				[ProcessingErrorMessage] [nvarchar](4000) NULL,

				[CreateDate] [datetime] NOT NULL,
				[CreateUser] [nvarchar](25) NOT NULL,
				[LastUpdate] [datetime] NOT NULL,
				[LastUpdateUser] [nvarchar](25) NOT NULL
			);

	INSERT INTO @FullLog (
				[EntryType],
				[IsSuccessfull],
				[OutgoingRequestID],
				[OnContactID],
				[SalutationDescriptionShort],
				[LastName],
				[Firstname],
				[MiddleInitial],
				[GenderDescriptionShort],
				[Address1],
				[Address2],
				[City],
				[ProvinceDecriptionShort],
				[StateDescriptionShort],
				[PostalCode],
				[CountryDescriptionShort],
				[HomePhone],
				[WorkPhone],
				[MobilePhone],
				[EmailAddress],
				[HomePhoneAuth],
				[WorkPhoneAuth],
				[CellPhoneAuth],
				[ConsultationNotes],
				[ConsultOffice],
				[ConsultantUsername],
				[LeadCreatedDate],
				[ProcessName],
				[SiebelID],
				[InitialOutgoing],
				[ClientIdentifier],
				[ClientMembershipIdentifier],
				[MembershipDescription],
				[InvoiceNumber],
				[Amount],
				[TenderTypeDescriptionShort],
				[FinanceCompany],
				[EstGraftCount],
				[EstContractTotal],
				[PrevGraftCount],
				[PrevContractTotal],
				[PrevNumOfProcedures],
				[PostExtremeFlag],
				[RequestQueueID],
				[ConsultDate],
				[CreateDate],
				[CreateUser],
				[LastUpdate],
				[LastUpdateUser],
				[ResultSiebelID])
	SELECT 'OUTGOING'
		  ,CASE WHEN res.OutgoingResponseID IS NULL OR res.ErrorMessage IS NOT NULL OR res.ExceptionMessage IS NOT NULL THEN 0 ELSE 1 END
		  ,rl.[OutgoingRequestID]
		  ,[OnContactID]
		  ,[SalutationDescriptionShort]
		  ,[LastName]
		  ,[Firstname]
		  ,[MiddleInitial]
		  ,[GenderDescriptionShort]
		  ,[Address1]
		  ,[Address2]
		  ,[City]
		  ,[ProvinceDecriptionShort]
		  ,[StateDescriptionShort]
		  ,[PostalCode]
		  ,[CountryDescriptionShort]
		  ,[HomePhone]
		  ,[WorkPhone]
		  ,[MobilePhone]
		  ,[EmailAddress]
		  ,[HomePhoneAuth]
		  ,[WorkPhoneAuth]
		  ,[CellPhoneAuth]
		  ,[ConsultationNotes]
		  ,[ConsultOffice]
		  ,[ConsultantUsername]
		  ,[LeadCreatedDate]
		  ,[ProcessName]
		  ,[SiebelID]
		  ,CASE WHEN rl.SiebelID ='' THEN 1 ELSE 0 END AS [InitialOutgoing]
		  ,[ClientIdentifier]
		  ,rl.[ClientMembershipIdentifier]
		  ,mem.MembershipDescription
		  ,[InvoiceNumber]
		  ,[Amount]
		  ,[TenderTypeDescriptionShort]
		  ,[FinanceCompany]
		  ,[EstGraftCount]
		  ,[EstContractTotal]
		  ,[PrevGraftCount]
		  ,[PrevContractTotal]
		  ,[PrevNumOfProcedures]
		  ,[PostExtremeFlag]
		  ,[RequestQueueID]
		  ,[ConsultDate]
		  ,rl.[CreateDate]
		  ,rl.[CreateUser]
		  ,rl.[LastUpdate]
		  ,rl.[LastUpdateUser]
		  ,res.[SeibelID]
	  FROM [dbo].[datOutgoingRequestLog] rl
			LEFT OUTER JOIN datClientMembership cm ON rl.ClientMembershipIdentifier = cm.ClientMembershipIdentifier
			LEFT OUTER JOIN cfgMembership mem ON mem.MembershipID = cm.MembershipID
			LEFT OUTER JOIN datOutgoingResponseLog res ON rl.OutgoingRequestID = res.OutgoingRequestID
	  WHERE (@StartDate IS NOT NULL
				AND @EndDate IS NOT NULL
				AND rl.CreateDate >= @StartDate
				AND rl.CreateDate < DATEADD(day,1,@EndDate))
			OR (@ClientIdentifier IS NOT NULL
				AND ClientIdentifier = @ClientIdentifier)

	INSERT INTO @FullLog (
				[EntryType],
				[IsSuccessfull],
				[IncomingRequestID],
				[ProcessName],
				[SiebelID],
				[ClientIdentifier],
				[ClientMembershipIdentifier],
				[MembershipDescription],
				[BosleyRequestID],
				[PatientSlipNo],
				[TreatmentPlanDate],
				[TreatmentPlanNo],
				[TreatmentPlanGraftCount],
				[TreatmentPlanContractAmount],
				[ProcedureStatus],
				[ProcedureDate],
				[ProcedureGraftCount],
				[ProcedureAmount],
				[PaymentDate],
				[PaymentAmount],
				[PaymentType],
				[IsProcessedFlag],
				[ProcessingErrorMessage],
				[ConsultantUserName],
				[ConsultationStatus],
				[ConsultationStatusDate],
				[CreateDate],
				[CreateUser],
				[LastUpdate],
				[LastUpdateUser])
	SELECT 'INCOMING'
		  ,[IsProcessedFlag]
		  ,[IncomingRequestID]
		  ,[ProcessName]
		  ,[SiebelID]
		  ,[ConectID]
		  ,irl.[ClientMembershipID]
		  ,mem.MembershipDescription
		  ,[BosleyRequestID]
		  ,[PatientSlipNo]
		  ,[TreatmentPlanDate]
		  ,[TreatmentPlanNo]
		  ,[TreatmentPlanGraftCount]
		  ,[TreatmentPlanContractAmount]
		  ,[ProcedureStatus]
		  ,[ProcedureDate]
		  ,[ProcedureGraftCount]
		  ,[ProcedureAmount]
		  ,[PaymentDate]
		  ,[PaymentAmount]
		  ,[PaymentType]
		  ,[IsProcessedFlag]
		  ,[ErrorMessage]
		  ,[ConsultantUserName]
		  ,[ConsultationStatus]
		  ,[ConsultationStatusDate]
		  ,irl.[CreateDate]
		  ,irl.[CreateUser]
		  ,irl.[LastUpdate]
		  ,irl.[LastUpdateUser]
	  FROM [dbo].[datIncomingRequestLog] irl
			LEFT OUTER JOIN datClientMembership cm ON irl.ClientMembershipID = cm.ClientMembershipIdentifier
			LEFT OUTER JOIN cfgMembership mem ON mem.MembershipID = cm.MembershipID
	  WHERE (@StartDate IS NOT NULL
				AND @EndDate IS NOT NULL
				AND irl.CreateDate >= @StartDate
				AND irl.CreateDate < DATEADD(day,1,@EndDate))
			OR (@ClientIdentifier IS NOT NULL
				AND ConectID = @ClientIdentifier)

	-- Select Back
	SELECT l.EntryType
		,l.IsSuccessfull
		,l.ProcessName
		,l.[InitialOutgoing]


		,CASE WHEN ProcessName = 'ConsultUpdate' THEN
			CASE	WHEN ConsultationStatus = 'MDConsultSched' THEN
						'No Impact'
					WHEN ConsultationStatus = 'NoSale' THEN
						'No Impact'
					WHEN ConsultationStatus = 'NoShow' THEN
						'No Impact'
					ELSE 'UNKNOWN' END
			WHEN ProcessName = 'PatientSlipClosed' THEN
			CASE	WHEN ProcedureStatus = 'Closed' THEN
						'Verify Surgery Revenue'
					ELSE 'UNKNOWN' END
			WHEN ProcessName = 'Payment' THEN
			CASE	WHEN PaymentType = 'Payment' THEN
						'Verify Surgery Revenue '
					WHEN PaymentType = 'HCPayment' THEN
						'Verify Surgery Revenue'
					WHEN PaymentType = 'Refund' THEN
						'Verify Surgery Revenue'
					ELSE 'UNKNOWN' END
			WHEN ProcessName = 'TreatmentPlan' THEN
			CASE	WHEN ProcedureStatus = 'Scheduled' AND clm.membershipid <> 58 THEN
						'No Impact'
					WHEN ProcedureStatus = 'Scheduled' AND clm.membershipid = 58 THEN
						'Verify Surgery Count'
					WHEN ProcedureStatus = 'Scheduled' AND clm.membershipid IS null THEN
						'No Impact'
					ELSE 'UNKNOWN' END
			WHEN ProcessName = 'ProcedureDone' THEN
			CASE	WHEN ProcedureStatus = 'Done'  THEN
						'No Impact'
					ELSE 'UNKNOWN' END
			WHEN ProcessName = 'ProcedureUpdate' THEN
			CASE	WHEN ProcedureStatus = 'Rescheduled'  THEN
						'No Impact'
			 		WHEN ProcedureStatus = 'Cancelled'  THEN
						'No Impact'
					ELSE 'UNKNOWN' END
			WHEN ProcessName = 'PostExtSold' THEN
			CASE	WHEN ProcessName = 'PostEXTSold'  THEN
						'Verify PostEXT Sale & Revenue'
					ELSE 'UNKNOWN' END
	---
	--- OUTGOING
	---
			WHEN ProcessName = 'Procedure' THEN
			CASE	WHEN l.IsSuccessfull = 0 THEN
						'UNSUCCESSFUL Outgoing Procedure Trx'
					WHEN l.SiebelID = '' THEN
						'Verify Surgery Count'
					WHEN l.SiebelID = l.ResultSiebelID THEN
						'Verify Surgery Revenue'
					ELSE 'UNKNOWN' END
			WHEN ProcessName = 'Consultation' THEN
			CASE	WHEN l.IsSuccessfull = 0 THEN
						'No Impact'
					WHEN l.SiebelID = '' THEN
						'Verify Consultation'

					ELSE 'UNKNOWN' END
			WHEN ProcessName IN ( 'PostEXTAdd') THEN
			CASE	WHEN l.IsSuccessfull = 0 THEN
						'No Impact'
					WHEN PostExtremeFlag = 'YES' THEN
						'Verify PostEXT Sale & Revenue'
					ELSE 'UNKNOWN' END

			WHEN ProcessName IN ( 'Update' ) THEN
			CASE	WHEN l.IsSuccessfull = 0 THEN
						'No Impact'
					WHEN PostExtremeFlag = 'YES' THEN
						'Verify PostEXT Sale & Revenue'
					WHEN isnull(PostExtremeFlag,'NO') = 'NO' THEN
						'No Impact'


					ELSE 'UNKNOWN' END

			ELSE
				'UNKNOWN' END  AS 'FlashImpact'


		,CASE WHEN ProcessName = 'ConsultUpdate' THEN
			CASE	WHEN ConsultationStatus = 'MDConsultSched' THEN
						'NA-Sales Consultation Scheduled - '
						+ CAST(CONVERT(DATETIME,ConsultationStatusDate,0) AS VARCHAR(30))
					WHEN ConsultationStatus = 'NoSale' THEN
						'NA-NoSale - Sales Consult Occurred ' + CAST(CONVERT(DATETIME,ConsultationStatusDate,100) AS VARCHAR(30))
					WHEN ConsultationStatus = 'NoShow' THEN
						'NA-NoShow - Sales Consult Scheduled ' + CAST(CONVERT(DATETIME,ConsultationStatusDate,100) AS VARCHAR(30))
					ELSE 'UNKNOWN' END
			WHEN ProcessName = 'PatientSlipClosed' THEN
			CASE	WHEN ProcedureStatus = 'Closed' THEN
						'MO/SO created - Surgery Audited - '
						+ CAST(CONVERT(DATETIME,ProcedureDate,0) AS VARCHAR(30))
						+ ' Audit Complete ' + CAST(CONVERT(DATETIME,l.Createdate-1,110) AS VARCHAR(12))
					ELSE 'UNKNOWN' END
			WHEN ProcessName = 'Payment' THEN
			CASE	WHEN PaymentType = 'Payment' THEN
						'SO created-PAYMENT made at Bosley for '
						+ CAST(CONVERT(MONEY,l.PaymentAmount,1) AS VARCHAR(10))
					WHEN PaymentType = 'HCPayment' THEN
						'SO-HC Payment recorded at Bosley for '
						+ CAST(CONVERT(MONEY,l.PaymentAmount,1) AS VARCHAR(10))
					WHEN PaymentType = 'Refund' THEN
						'SO created-REFUND made at Bosley for '
						+ CAST(CONVERT(MONEY,l.PaymentAmount,1) AS VARCHAR(10))
					ELSE 'UNKNOWN' END
			WHEN ProcessName = 'TreatmentPlan' THEN
			CASE	WHEN ProcedureStatus = 'Scheduled' AND clm.membershipid <> 58 THEN
						'NA-TreatmentPlanRcvd for ' + mem.membershipdescription + ' '
						+ CAST(CONVERT(DECIMAL(10,0),l.TreatmentPlanGraftCount) AS VARCHAR(10))
						+ ' Grafts for '
						+ CAST(CONVERT(money,l.TreatmentPlanContractAmount) AS VARCHAR(10))
					WHEN ProcedureStatus = 'Scheduled' AND clm.membershipid = 58 THEN
						'MO created - First Surgery for '
						+ CAST(CONVERT(DECIMAL(10,0),l.TreatmentPlanGraftCount) AS VARCHAR(10))
						+ ' Grafts for '
						+ CAST(CONVERT(money,l.TreatmentPlanContractAmount) AS VARCHAR(10))
					WHEN ProcedureStatus = 'Scheduled' AND clm.membershipid IS null THEN
						'Client membershipship Identifier unknown'
					ELSE 'UNKNOWN' END
			WHEN ProcessName = 'ProcedureDone' THEN
			CASE	WHEN ProcedureStatus = 'Done'  THEN
						'NA-Surgery completed - '
						+ CAST(CONVERT(DATETIME,l.ProcedureDate-1,110) AS VARCHAR(12))
						+ '-' + CAST(CONVERT(DECIMAL(10,0),l.ProcedureGraftCount) AS VARCHAR(10))
						+ ' Grafts for '
						+ CAST(CONVERT(money,l.ProcedureAmount) AS VARCHAR(10))
					ELSE 'UNKNOWN' END
			WHEN ProcessName = 'ProcedureUpdate' THEN
			CASE	WHEN ProcedureStatus = 'Rescheduled'  THEN
						'NA-Surgery Rescheduled for '
						+ CAST(CONVERT(DATETIME,l.ProcedureDate-1,110) AS VARCHAR(12))
						--+ '-' + CAST(CONVERT(DECIMAL(10,0),l.ProcedureGraftCount) AS VARCHAR(10))
						--+ ' Grafts for '
						--+ CAST(CONVERT(money,l.ProcedureAmount) AS VARCHAR(10))
			 		WHEN ProcedureStatus = 'Cancelled'  THEN
						'NA-Surgery Cancelled for '
						+ CAST(CONVERT(DATETIME,l.ProcedureDate-1,110) AS VARCHAR(12))
					ELSE 'UNKNOWN' END
			WHEN ProcessName = 'PostExtSold' THEN
			CASE	WHEN ProcessName = 'PostEXTSold'  THEN
						'CONTACT CTR-POSTEXT Sold at Bosley on '
						+ CAST(CONVERT(DATETIME,l.Createdate-1,110) AS VARCHAR(12))
						+ 'for '
						+ CAST(CONVERT(money,l.PaymentAmount) AS VARCHAR(10))
					ELSE 'UNKNOWN' END
	---
	--- OUTGOING
	---
			WHEN ProcessName = 'Procedure' THEN
			CASE	WHEN l.IsSuccessfull = 0 THEN
						'UNSUCCESSFUL Outgoing Procedure Trx'
					WHEN l.SiebelID = '' THEN
						'HC MO Membership Assign for '
						+ ISNULL(l.MembershipDescription, '') +
						' Sold (Initial Request) - SiebelID = '
						+ CAST(l.ResultSiebelID AS VARCHAR(10))
					WHEN l.SiebelID = l.ResultSiebelID THEN
						'HC SO Payment Taken for '
						+ CAST(CONVERT(money,l.Amount) AS VARCHAR(10))
						+ ' Tender -'
						+ l.TenderTypeDescriptionShort
						+ ' '
						+ isnull(l.FinanceCompany,'')

					ELSE 'UNKNOWN' END
			WHEN ProcessName = 'Consultation' THEN
			CASE	WHEN l.IsSuccessfull = 0 THEN
						'UNSUCCESSFUL Outgoing Consultation Trx'
					WHEN l.SiebelID = '' THEN
						'SHOWNOSALE-Surgery Consult=Y - SiebelID = '
						+ CAST(l.ResultSiebelID AS VARCHAR(10))
					ELSE 'UNKNOWN' END
			WHEN ProcessName IN ( 'PostEXTAdd') THEN
			CASE	WHEN l.IsSuccessfull = 0 THEN
						'UNSUCCESSFUL Outgoing PostEXTAdd Trx'
					WHEN PostExtremeFlag = 'YES' THEN
						'PostEXT was added for '
						+ ISNULL(l.LastName, c.LastName) + ',' + ISNULL(l.FirstName, c.FirstName) + '(' + CAST(l.clientidentifier AS VARCHAR(10)) + ') Siebel ID='
						+ CAST(l.ResultSiebelID AS VARCHAR(10))
					ELSE 'UNKNOWN' END

			WHEN ProcessName IN ( 'Update' ) THEN
			CASE	WHEN l.IsSuccessfull = 0 THEN
						'UNSUCCESSFUL Outgoing Update Trx'
					WHEN PostExtremeFlag = 'YES' THEN
						'PostEXT was added for '
						+ ISNULL(l.LastName, c.LastName) + ',' + ISNULL(l.FirstName, c.FirstName) + '(' + CAST(l.clientidentifier AS VARCHAR(10)) + ') Siebel ID='
						+ CAST(l.ResultSiebelID AS VARCHAR(10))
					WHEN isnull(PostExtremeFlag,'NO') = 'NO' THEN
						'UPDATE of Client information at Bosley - ClientIdentifier'


					ELSE 'UNKNOWN' END

			ELSE
				'UNKNOWN' END
AS 'Explanation'



		,ISNULL(l.FirstName, c.FirstName) as 'First Name'
		,ISNULL(l.LastName, c.LastName) as 'Last Name'
		,ISNULL(l.MiddleInitial, c.MiddleName) as 'Middle Initial'
		,l.ClientIdentifier
		,l.OnContactID as 'OnContact Identifier'
		,l.SiebelID
		,l.ClientMembershipIdentifier
		,l.MembershipDescription
		,l.ConsultOffice as 'Consultation Office'
		,l.ConsultantUsername as 'Consultant'
		,l.CreateDate
		,l.CreateUser

		,l.ResultSiebelID as 'RES-Siebel ID'
		,l.OutgoingRequestID as 'O-OutgoingRequestID'
		,l.ConsultDate as 'O-ConsultDate'
		,l.SalutationDescriptionShort as 'O-Salutation'
		,l.GenderDescriptionShort as 'O-Gender'
		,l.Address1 as 'O-Address1'
		,l.Address2 as 'O-Address2'
		,l.City as 'O-City'
		,l.StateDescriptionShort as 'O-State'
		,l.ProvinceDecriptionShort as 'O-Province'
		,l.PostalCode  as 'O-PostalCode'
		,l.CountryDescriptionShort as 'O-Country'
		,l.HomePhone as 'O-HomePhone'
		,l.WorkPhone as 'O-WorkPhone'
		,l.MobilePhone as 'O-MobilePhone'
		,l.HomePhoneAuth as 'O-Home Phone Auth'
		,l.WorkPhoneAuth as 'O-Work Phone Auth'
		,l.CellPhoneAuth as 'O-Cell Phone Auth'
		,l.ConsultationNotes as 'O-ConsultationNotes'
		,l.LeadCreatedDate as 'O-LeadCreatedDate'
		,l.InvoiceNumber as 'O-InvoiceNumber'
		,l.Amount as 'O-Amount'
		,l.TenderTypeDescriptionShort as 'O-Tenders'
		,l.FinanceCompany as 'O-FinanceCompany'
		,l.EstGraftCount as 'O-Est. Graft Count'
		,l.EstContractTotal as 'O-Est. Contract Total'
		,l.PrevGraftCount as 'O-Prev. Graft Count'
		,l.PrevContractTotal as 'O-Prev. Contract Total'
		,l.PrevNumOfProcedures as 'O-Number of Prev. Procedures'
		,l.PostExtremeFlag as 'O-Post EXT. Sold'
		,l.RequestQueueID as 'O-RequestQueueID'

		,l.IncomingRequestID as 'I-IncomingRequestID'
		,l.BosleyRequestID as 'I-BosleyRequestID'
		,l.PatientSlipNo as 'I-PatientSlipNo'
		,l.TreatmentPlanDate as 'I-TreatmentPlanDate'
		,l.TreatmentPlanNo as 'I-TreatmentPlanNo'
		,l.TreatmentPlanGraftCount as 'I-TreatmentPlanGraftCount'
		,l.TreatmentPlanContractAmount as 'I-TreatmentPlanContractAmount'
		,l.ProcedureStatus as 'I-ProcedureStatus'
		,l.ProcedureDate as 'I-ProcedureDate'
		,l.ProcedureGraftCount as 'I-ProcedureGraftCount'
		,l.ProcedureAmount as 'I-ProcedureAmount'
		,l.PaymentDate as 'I-PaymentDate'
		,l.PaymentAmount as 'I-PaymentAmount'
		,l.PaymentType as 'I-PaymentType'
		,l.IsProcessedFlag as 'I-Is Incoming Request Processed'
		,l.ConsultationStatus as 'I-ConsultationStatus'
		,l.ConsultationStatusDate as 'I-ConsultationStatusDate'
		,l.ProcessingErrorMessage as 'I-Incoming Request Processing Error'
	FROM @FullLog l
		LEFT outer JOIN datClient c ON c.ClientIdentifier = l.ClientIdentifier
		LEFT outer JOIN datClientmembership clm ON clm.ClientMembershipIdentifier = l.ClientMembershipIdentifier
		LEFT outer JOIN dbo.cfgMembership mem ON clm.MembershipID = mem.MembershipID
	--AND clm.MembershipID = 58
	ORDER BY ClientIdentifier, CreateDate

END
GO
