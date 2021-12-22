/* CreateDate: 05/23/2013 14:02:54.617 , ModifyDate: 03/09/2020 15:10:50.327 */
GO
CREATE TABLE [dbo].[datRequestQueue](
	[RequestQueueID] [int] IDENTITY(1,1) NOT NULL,
	[SiebelID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OnContactID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalutationDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Firstname] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MiddleInitial] [nvarchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GenderDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address1] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address2] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ProvinceDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PostalCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HomePhone] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WorkPhone] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MobilePhone] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EmailAddress] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HomePhoneAuth] [datetime] NULL,
	[WorkPhoneAuth] [datetime] NULL,
	[MobilePhoneAuth] [datetime] NULL,
	[ConsultantUsername] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ConsultDate] [datetime] NULL,
	[ConsultOffice] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadCreateDate] [datetime] NULL,
	[ClientIdentifier] [int] NULL,
	[ClientMembershipIdentifier] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsPostExtremeClientFlag] [nvarchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InvoiceNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsProcessedFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[ProcessName] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TenderTypeDescriptionShort] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EstGraftCount] [int] NULL,
	[EstContractTotal] [decimal](21, 6) NULL,
	[PrevGraftCount] [int] NULL,
	[PrevContractTotal] [decimal](21, 6) NULL,
	[PrevNumOfProcedures] [int] NULL,
	[ConsultationNotes] [varchar](5000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Amount] [decimal](33, 6) NULL,
	[FinanceCompany] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReferenceOutgoingRequestID] [int] NULL,
	[IsOutDatedFlag] [bit] NULL,
	[HCSalesforceLeadID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BosleySalesforceAccountID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_datRequestQueue] PRIMARY KEY CLUSTERED
(
	[RequestQueueID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datRequestQueue_ClientIdenitifier] ON [dbo].[datRequestQueue]
(
	[ClientIdentifier] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datRequestQueue_IsProcessedFlag_IsOutDatedFlat] ON [dbo].[datRequestQueue]
(
	[IsProcessedFlag] ASC,
	[IsOutDatedFlag] ASC
)
INCLUDE([RequestQueueID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datRequestQueue] ADD  CONSTRAINT [DF_datRequestQueue_IsProcessedFlag]  DEFAULT ((0)) FOR [IsProcessedFlag]
GO
ALTER TABLE [dbo].[datRequestQueue] ADD  CONSTRAINT [DF_datRequestQueue_IsOutDatedFlag]  DEFAULT ((0)) FOR [IsOutDatedFlag]
GO
