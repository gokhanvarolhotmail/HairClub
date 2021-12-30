/* CreateDate: 04/24/2018 16:09:21.460 , ModifyDate: 06/13/2021 19:12:07.563 */
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
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_HCDeletionTracker__c_ObjectName__c_MasterRecordId__c_INCL] ON [dbo].[HCDeletionTracker__c]
(
	[ObjectName__c] ASC,
	[MasterRecordId__c] ASC
)
INCLUDE([Id],[DeletedId__c],[ToBeProcessed__c],[IsProcessed],[IsError]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_HCDeletionTracker__c_SessionID] ON [dbo].[HCDeletionTracker__c]
(
	[SessionID] ASC
)
INCLUDE([ToBeProcessed__c],[IsProcessed],[IsError]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_HCDeletionTracker__c_ToBeProcessed__c_IsProcessed_MasterRecordId__c] ON [dbo].[HCDeletionTracker__c]
(
	[ToBeProcessed__c] ASC,
	[IsProcessed] ASC,
	[MasterRecordId__c] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HCDeletionTracker__c] ADD  CONSTRAINT [DF_HCDeletionTracker__c_IsProcessed]  DEFAULT ((0)) FOR [IsProcessed]
GO
ALTER TABLE [dbo].[HCDeletionTracker__c] ADD  CONSTRAINT [DF_HCDeletionTracker__c_IsError]  DEFAULT ((0)) FOR [IsError]
GO
