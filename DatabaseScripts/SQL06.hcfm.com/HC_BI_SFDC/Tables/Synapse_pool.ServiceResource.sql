/* CreateDate: 03/21/2022 13:00:04.157 , ModifyDate: 03/21/2022 13:00:07.793 */
GO
CREATE TABLE [Synapse_pool].[ServiceResource](
	[Id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OwnerId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Name] [nvarchar](765) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyIsoCode] [nvarchar](765) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime2](0) NULL,
	[CreatedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](0) NULL,
	[LastModifiedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](0) NULL,
	[LastViewedDate] [datetime2](0) NULL,
	[LastReferencedDate] [datetime2](0) NULL,
	[RelatedRecordId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ResourceType] [nvarchar](765) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Description] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsActive] [bit] NULL,
	[LocationId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccountId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[External_Id__c] [nvarchar](765) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
