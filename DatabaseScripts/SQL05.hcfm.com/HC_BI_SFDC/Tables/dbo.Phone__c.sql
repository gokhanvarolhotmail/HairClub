/* CreateDate: 04/18/2018 11:34:10.077 , ModifyDate: 03/21/2022 16:35:30.373 */
GO
CREATE TABLE [dbo].[Phone__c](
	[Id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Lead__c] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactPhoneID__c] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OncContactID__c] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Name] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PhoneAbr__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DoNotCall__c] [bit] NULL,
	[DoNotText__c] [bit] NULL,
	[DNCFlag__c] [bit] NULL,
	[EBRDNC__c] [bit] NULL,
	[EBRDNCDate__c] [datetime] NULL,
	[Wireless__c] [bit] NULL,
	[Primary__c] [bit] NULL,
	[SortOrder__c] [int] NULL,
	[Status__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ValidFlag__c] [bit] NULL,
	[Type__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsDeleted] [bit] NOT NULL,
	[CreatedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Phone__c] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_Phone__c_IsDeleted_INCL] ON [dbo].[Phone__c]
(
	[PhoneAbr__c] ASC,
	[IsDeleted] ASC
)
INCLUDE([Lead__c],[Primary__c],[ValidFlag__c],[CreatedDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Phone__c_IsDeleted_INL] ON [dbo].[Phone__c]
(
	[IsDeleted] ASC
)
INCLUDE([Lead__c],[PhoneAbr__c],[Primary__c],[ValidFlag__c],[CreatedDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_Phone__c_Lead] ON [dbo].[Phone__c]
(
	[Lead__c] ASC
)
INCLUDE([Primary__c]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Phone__c_Primary] ON [dbo].[Phone__c]
(
	[Primary__c] ASC
)
INCLUDE([Lead__c],[PhoneAbr__c],[LastModifiedDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Phone__c] ADD  CONSTRAINT [DF_Phone__c_IsDeleted]  DEFAULT ((0)) FOR [IsDeleted]
GO
