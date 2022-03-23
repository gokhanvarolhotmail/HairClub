/* CreateDate: 03/21/2022 16:48:09.593 , ModifyDate: 03/21/2022 16:48:09.703 */
GO
CREATE TABLE [dbo].[HCDeletionTracker__c](
	[Id] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SessionID] [uniqueidentifier] NOT NULL,
	[OwnerId] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsDeleted] [bit] NOT NULL,
	[Name] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime] NULL,
	[CreatedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime] NULL,
	[LastModifiedById] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ObjectName__c] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DeletedId__c] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DeletedById__c] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MasterRecordId__c] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ToBeProcessed__c] [bit] NOT NULL,
	[IsProcessed] [bit] NOT NULL,
	[IsError] [bit] NULL,
	[ErrorMessage] [nvarchar](2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastProcessedDate__c] [datetime] NULL,
 CONSTRAINT [PK_HCDeletionTracker__c] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HCDeletionTracker__c] ADD  CONSTRAINT [DF_HCDeletionTracker__c_IsProcessed]  DEFAULT ((0)) FOR [IsProcessed]
GO
ALTER TABLE [dbo].[HCDeletionTracker__c] ADD  CONSTRAINT [DF_HCDeletionTracker__c_IsError]  DEFAULT ((0)) FOR [IsError]
GO
