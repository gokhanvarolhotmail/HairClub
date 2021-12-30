/* CreateDate: 10/04/2019 14:09:30.190 , ModifyDate: 10/04/2019 15:15:28.227 */
GO
CREATE TABLE [dbo].[Address__c](
	[Id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Lead__c] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OncContactAddressID__c] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OncContactID__c] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Street__c] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Street2__c] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Street3__c] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Street4__c] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Zip__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Country__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DoNotMail__c] [bit] NULL,
	[Primary__c] [bit] NULL,
	[Status__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsDeleted] [bit] NOT NULL,
	[CreatedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL,
 CONSTRAINT [PK_Address__c] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_Address__c_Lead] ON [dbo].[Address__c]
(
	[Lead__c] ASC,
	[Primary__c] ASC
)
INCLUDE([Zip__c]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_Address__c_Primary] ON [dbo].[Address__c]
(
	[Primary__c] ASC
)
INCLUDE([Lead__c],[Zip__c],[LastModifiedDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
