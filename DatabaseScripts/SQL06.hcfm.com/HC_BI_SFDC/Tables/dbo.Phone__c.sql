/* CreateDate: 03/22/2022 08:10:59.313 , ModifyDate: 03/22/2022 08:10:59.313 */
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
	[LastModifiedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
