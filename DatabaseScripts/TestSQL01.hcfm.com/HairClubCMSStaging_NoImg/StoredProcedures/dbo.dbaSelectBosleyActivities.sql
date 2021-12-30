/* CreateDate: 05/20/2013 22:23:15.710 , ModifyDate: 02/16/2018 10:56:45.127 */
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
	* 6/03/13 MVT - Added Incoming Log Processing Warning Message.
	* 8/15/13 MB  - Added code to allow for only ClientIdentifer being passed to procedure
--------------------------------------------------------------------------------------------------------

SAMPLE EXECUTION:

exec [dbaSelectBosleyActivities] '1/1/18', '2/16/18', NULL
exec [dbaSelectBosleyActivities] NULL, NULL, 411785

***********************************************************************/

CREATE PROCEDURE [dbo].[dbaSelectBosleyActivities]
	  @StartDate DateTime,
	  @EndDate DateTime,
	  @ClientIdentifier int

AS
BEGIN

	SET NOCOUNT ON;

	--DECLARE @StartDate datetime = '5/20/13'
	--DECLARE @EndDate datetime = '5/25/13'
	--
	-- Select clients that have had incoming or outgoing trx between date range
	--
	DECLARE  @Clients TABLE
			(
			[ClientIdentifier] [nvarchar] (30)
			)

	SET @EndDate = @EndDate + ' 23:59:59'

	INSERT INTO @Clients (
		ClientIdentifier
		)
		SELECT clientidentifier
		FROM dbo.datOutgoingRequestLog
		WHERE createdate BETWEEN @startdate AND @endDate
		GROUP BY clientidentifier

	INSERT INTO @Clients (
		ClientIdentifier
		)
		SELECT CONECTID
		FROM dbo.datIncomingRequestLog
		WHERE createdate BETWEEN @startdate AND @endDate
			AND ConectID NOT IN (SELECT ClientIdentifier FROM @CLIENTS)
		GROUP BY ConectID


	INSERT INTO @Clients (ClientIdentifier)
	SELECT ISNULL(@ClientIdentifier, NULL)


	DECLARE  @FullLog TABLE (
				[EntryType] [nvarchar] (30),
				[ConsultantUsername] [nvarchar](200) NULL,
				[ProcessName] [nvarchar](40) NULL,
				[SiebelID] [nvarchar](50) NULL,
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
				[ProcedureStatus] [nvarchar](50) NULL,
				[ProcedureDate] [datetime] NULL,
				[ProcedureGraftCount] [int] NULL,
				[ProcedureAmount] [decimal](14, 4) NULL,
				[PaymentDate] [datetime] NULL,
				[PaymentAmount] [decimal](14, 4) NULL,
				[PaymentType] [nvarchar](200) NULL,
				[IsProcessedFlag] [bit] NULL,
				[ConsultationStatus] [nvarchar](50) NULL,
				[ConsultationStatusDate] [datetime] NULL,
				[ProcessingErrorMessage] [nvarchar](4000) NULL,
				[ProcessingWarningMessage] [nvarchar](4000) NULL,

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
		  ,rl.[ClientIdentifier]
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
			INNER JOIN @CLIENTS cl
				ON rl.ClientIdentifier = cl.Clientidentifier
	  --WHERE (@StartDate IS NOT NULL
			--	AND @EndDate IS NOT NULL
			--	AND rl.CreateDate >= @StartDate
			--	AND rl.CreateDate < DATEADD(day,1,@EndDate))
			--OR (@ClientIdentifier IS NOT NULL
			--	AND ClientIdentifier = @ClientIdentifier)

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
				[ProcessingWarningMessage],
				[ConsultantUserName],
				[ConsultationStatus],
				[ConsultationStatusDate],
				[CreateDate],
				[CreateUser],
				[LastUpdate],
				[LastUpdateUser],
				[ConsultOffice])
	SELECT 'INCOMING'
		  ,[IsProcessedFlag]
		  ,[IncomingRequestID]
		  ,[ProcessName]
		  ,irl.[SiebelID]
		  ,irl.[ConectID]
		  ,irl.[ClientMembershipID]
		  ,mem.MembershipDescription
		  ,irl.[BosleyRequestID]
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
		  ,[WarningMessage]
		  ,[ConsultantUserName]
		  ,[ConsultationStatus]
		  ,[ConsultationStatusDate]
		  ,irl.[CreateDate]
		  ,irl.[CreateUser]
		  ,irl.[LastUpdate]
		  ,irl.[LastUpdateUser]
		  ,cent.CenterDescription + '_HAIRCLUB'
	  FROM [dbo].[datIncomingRequestLog] irl
			LEFT OUTER JOIN datClientMembership cm ON irl.ClientMembershipID = cm.ClientMembershipIdentifier
			LEFT OUTER JOIN cfgMembership mem ON mem.MembershipID = cm.MembershipID
			LEFT OUTER JOIN datClient c ON irl.ConectID = c.ClientIdentifier
			LEFT OUTER JOIN cfgCenter cent ON c.CenterID = cent.CenterID
			INNER JOIN @clients cl
				ON irl.ConectID = cl.Clientidentifier
	  --WHERE (@StartDate IS NOT NULL
			--	AND @EndDate IS NOT NULL
			--	AND irl.CreateDate >= @StartDate
			--	AND irl.CreateDate < DATEADD(day,1,@EndDate))
			--OR (@ClientIdentifier IS NOT NULL
			--	AND ConectID = @ClientIdentifier)


	-- Select Back
	SELECT l.EntryType
		,l.IsSuccessfull
		,l.CreateDate
		,l.ProcessName
		,CASE WHEN ProcessName = 'ConsultUpdate' THEN
			CASE	WHEN ConsultationStatus = 'MDConsultSched' THEN
						'No Impact'
					WHEN ConsultationStatus = 'NoSale' THEN
						'No Impact'
					WHEN ConsultationStatus = 'NoShow' THEN
						'No Impact'
					ELSE 'UNKNOWN' END
			WHEN ProcessName = 'ProcedureDone' THEN
			CASE	WHEN ProcedureStatus = 'Done' THEN
						'Verify Surgery Revenue & Commissions'
					ELSE 'UNKNOWN' END
			WHEN ProcessName = 'Payment' THEN
			CASE	WHEN PaymentType = 'Payment' THEN
						'Verify Surgery Revenue '
					WHEN PaymentType = 'HCPayment' THEN
						'Verify No Impact on Surgery Revenue'
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
			WHEN ProcessName = 'PatientSlipClosed' THEN
			CASE	WHEN ProcedureStatus = 'Closed'  THEN
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
						'BOS Sales Consultation Scheduled for '
						+ CAST(CONVERT(DATETIME,ConsultationStatusDate,0) AS VARCHAR(30))
					WHEN ConsultationStatus = 'NoSale' THEN
						'BOS NoSale - Sales Consult Occurred ' + CAST(CONVERT(DATETIME,ConsultationStatusDate,100) AS VARCHAR(30))
					WHEN ConsultationStatus = 'NoShow' THEN
						'BOS NoShow - Sales Consult Scheduled ' + CAST(CONVERT(DATETIME,ConsultationStatusDate,100) AS VARCHAR(30))
					ELSE 'UNKNOWN' END
			WHEN ProcessName IN ('PatientSlipClosed', 'ProcedureDone') THEN
			CASE	WHEN ProcedureStatus = 'Done' THEN
						'BOS MO/SO created-AuditComplete- '
						+ CASE WHEN dbo.fxDivideDecimal(CONVERT(money, l.ProcedureAmount), CONVERT(DECIMAL(10,0), l.ProcedureGraftCount)) <=4.25 THEN
							' $/GRAFT<$4.25 ' ELSE '' end
						+ CAST(CONVERT(DATETIME,ProcedureDate,0) AS VARCHAR(30))
						+ ' Audit Complete ' + CAST(CONVERT(DATETIME,l.Createdate-1,110) AS VARCHAR(12))
						+ CAST(CONVERT(DECIMAL(10,0),l.ProcedureGraftCount) AS VARCHAR(10))
						+ '/'
						+ CAST(CONVERT(money,l.ProcedureAmount) AS VARCHAR(10))
						+ CASE WHEN l.PostExtremeFlag = 'YES' THEN ' +PEXT ' ELSE '' END
						--+ ' $/Graft='
						--+ CAST(CONVERT(money,l.ProcedureAmount) / CONVERT(DECIMAL(10,2),l.ProcedureGraftCount) AS VARCHAR(10))
					ELSE 'UNKNOWN' END
			WHEN ProcessName = 'Payment' THEN
			CASE	WHEN PaymentType = 'Payment' THEN
						'HC SO created PAYMENT made at Bosley for '
						+ CAST(CONVERT(MONEY,l.PaymentAmount,1) AS VARCHAR(10))
						+ CASE WHEN l.PostExtremeFlag = 'YES' THEN ' +PEXT ' ELSE '' END
					WHEN PaymentType = 'HCPayment' THEN
						'BOS HC Payment recorded at Bosley for '
						+ CAST(CONVERT(MONEY,l.PaymentAmount,1) AS VARCHAR(10))
						+ CASE WHEN l.PostExtremeFlag = 'YES' THEN ' +PEXT ' ELSE '' END
					WHEN PaymentType = 'Refund' THEN
						'HC SO created REFUND made at Bosley for '
						+ CAST(CONVERT(MONEY,l.PaymentAmount,1) AS VARCHAR(10))
					ELSE 'UNKNOWN' END
			WHEN ProcessName = 'TreatmentPlan' THEN
			CASE	WHEN ProcedureStatus = 'Scheduled' AND clm.membershipid <> 58 THEN
						'BOS TreatmentPlanRcvd for ' + mem.membershipdescription + ' '
						+ CAST(CONVERT(DECIMAL(10,0),l.TreatmentPlanGraftCount) AS VARCHAR(10))
						+ '/'
						+ CAST(CONVERT(money,l.TreatmentPlanContractAmount) AS VARCHAR(10))
						+ CASE WHEN l.PostExtremeFlag = 'YES' THEN ' +PEXT ' ELSE '' END
					WHEN ProcedureStatus = 'Scheduled' AND clm.membershipid = 58 THEN
						'HC MO created - First Surgery for '
						+ CAST(CONVERT(DECIMAL(10,0),l.TreatmentPlanGraftCount) AS VARCHAR(10))
						+ '/'
						+ CAST(CONVERT(money,l.TreatmentPlanContractAmount) AS VARCHAR(10))
						+ CASE WHEN l.PostExtremeFlag = 'YES' THEN ' +PEXT ' ELSE '' END
					WHEN ProcedureStatus = 'Scheduled' AND clm.membershipid IS null THEN
						'Client membershipship Identifier unknown'
					ELSE 'UNKNOWN' END
			WHEN ProcessName = 'PatientSlipClosed' THEN
			CASE	WHEN ProcedureStatus = 'Closed'  THEN
						'BOS Surgery Audited- '
						+ CASE WHEN dbo.fxDivideDecimal(CONVERT(money, l.ProcedureAmount), CONVERT(DECIMAL(10,0), l.ProcedureGraftCount)) <=4.25 THEN
							' $/GRAFT<$4.25 ' ELSE '' end
						+ CAST(CONVERT(DATETIME,l.ProcedureDate-1,110) AS VARCHAR(12))
						+ '-' + CAST(CONVERT(DECIMAL(10,0),l.ProcedureGraftCount) AS VARCHAR(10))
						+ '/'
						+ CAST(CONVERT(money,l.ProcedureAmount) AS VARCHAR(10))
						+ CASE WHEN l.PostExtremeFlag = 'YES' THEN ' +PEXT ' ELSE '' END
						--+ ' $/Graft='
						--+ CAST(CONVERT(money,ISNULL(l.ProcedureAmount,0)) / CONVERT(DECIMAL(10,2),ISNULL(l.ProcedureGraftCount,0)) AS VARCHAR(10))
					ELSE 'UNKNOWN' END
			WHEN ProcessName = 'ProcedureUpdate' THEN
			CASE	WHEN ProcedureStatus = 'Rescheduled'  THEN
						'NA-Surgery Rescheduled for '
						+ CAST(CONVERT(DATETIME,l.ProcedureDate-1,110) AS VARCHAR(12))
						+ '-' + CAST(CONVERT(DECIMAL(10,0),l.ProcedureGraftCount) AS VARCHAR(10))
						+ '/'
						+ CAST(CONVERT(money,l.ProcedureAmount) AS VARCHAR(10))
						+ CASE WHEN l.PostExtremeFlag = 'YES' THEN ' +PEXT ' ELSE '' END
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
						'HC Mbr Assign: '
						+ ISNULL(mem.MembershipDescriptionshort, '') +
						' (InitReq)-SiebelID = '
						+ CAST(l.ResultSiebelID AS VARCHAR(10))
						+ ' Gr/Cont: ' + CAST(CONVERT(DECIMAL(10,0),l.EstGraftCount) AS VARCHAR(10))
						+ '/'
						+ CAST(CONVERT(money,l.EstContractTotal) AS VARCHAR(10))
						+ CASE WHEN l.PostExtremeFlag = 'YES' THEN ' +PEXT ' ELSE '' END
						+ ' InitPmt: '
						+ CAST(CONVERT(money,l.Amount) AS VARCHAR(10))
						+ ' Tender: '
						+ l.TenderTypeDescriptionShort
						+ ' '
						+ isnull(l.FinanceCompany,'')

					WHEN l.SiebelID = l.ResultSiebelID THEN
						'HC SO Payment Taken for '
						+ CAST(CONVERT(money,l.Amount) AS VARCHAR(10))
						+ ' Tender -'
						+ l.TenderTypeDescriptionShort
						+ ' '
						+ isnull(l.FinanceCompany,'')
						+ CASE WHEN l.PostExtremeFlag = 'YES' THEN ' +PEXT ' ELSE '' END

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
		,CAST(l.ClientIdentifier as nvarchar(15)) + ' ' + ISNULL(l.LastName, c.LastName) as 'cONEct Number Last Name'
		,ISNULL(l.LastName, c.LastName) as 'Last Name'
		,ISNULL(l.MiddleInitial, c.MiddleName) as 'Middle Initial'
		,l.ClientIdentifier
		,l.OnContactID as 'OnContact Identifier'
		,l.SiebelID
		,l.ClientMembershipIdentifier
		,l.MembershipDescription
		,l.ConsultOffice as 'Consultation Office'
		,l.ConsultantUsername as 'Consultant'
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
		,l.ProcessingWarningMessage as 'I-Incoming Request Processing Warning'
	FROM @FullLog l
		INNER JOIN datClient c ON c.ClientIdentifier = l.ClientIdentifier
		LEFT outer JOIN datClientmembership clm ON clm.ClientMembershipIdentifier = l.ClientMembershipIdentifier
		LEFT outer JOIN dbo.cfgMembership mem ON clm.MembershipID = mem.MembershipID
	ORDER BY l.clientidentifier,CreateDate

END
GO
