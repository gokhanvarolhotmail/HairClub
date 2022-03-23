/* CreateDate: 03/22/2022 08:10:58.973 , ModifyDate: 03/22/2022 08:10:58.973 */
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
	[LastModifiedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
