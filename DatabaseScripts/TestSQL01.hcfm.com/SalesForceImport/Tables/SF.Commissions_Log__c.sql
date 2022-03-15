/* CreateDate: 03/03/2022 13:53:55.673 , ModifyDate: 03/03/2022 22:19:11.810 */
GO
CREATE TABLE [SF].[Commissions_Log__c](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsDeleted] [bit] NULL,
	[Name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[LastActivityDate] [date] NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[Service_Appointment__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ACE_Approved__c] [bit] NULL,
	[Comments__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Commission_To_Proposed_Change__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Commission_To__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Commissions_Logic_Details__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[My_Commission_Log__c] [bit] NULL,
	[Related_Lead__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Related_Person_Account__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[System_Generated__c] [bit] NULL,
	[Commission_To_Manager__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Commission_To_Company__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_Commissions_Log__c] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreatedDate] ON [SF].[Commissions_Log__c]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LastModifiedDate] ON [SF].[Commissions_Log__c]
(
	[LastModifiedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
