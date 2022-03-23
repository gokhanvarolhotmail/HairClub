/* CreateDate: 03/22/2022 08:26:03.700 , ModifyDate: 03/22/2022 08:26:03.700 */
GO
CREATE TABLE [dbo].[PhoneScrub__c](
	[Id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Name] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Batch__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Status__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ExportDatetime__c] [datetime] NOT NULL,
	[ImportDatetime__c] [datetime] NULL,
	[ProcessDate__c] [datetime] NULL,
	[DoNotCall__c] [bit] NULL,
	[Wireless__c] [bit] NULL,
	[EBRDate__c] [datetime] NULL,
	[DoNotCodes__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WirelessCodes__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsDeleted] [bit] NULL,
	[CreatedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreatedDate] [datetime] NOT NULL,
	[LastModifiedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastModifiedDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
