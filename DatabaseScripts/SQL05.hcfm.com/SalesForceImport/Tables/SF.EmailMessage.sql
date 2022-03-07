/* CreateDate: 03/04/2022 08:17:51.197 , ModifyDate: 03/07/2022 12:17:33.887 */
GO
CREATE TABLE [SF].[EmailMessage](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ParentId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivityId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[TextBody] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HtmlBody] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Headers] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Subject] [varchar](3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FromName] [varchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FromAddress] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ValidatedFromAddress] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ToAddress] [varchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CcAddress] [varchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BccAddress] [varchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Incoming] [bit] NULL,
	[HasAttachment] [bit] NULL,
	[Status] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MessageDate] [datetime2](7) NULL,
	[IsDeleted] [bit] NULL,
	[ReplyToEmailMessageId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsExternallyVisible] [bit] NULL,
	[MessageIdentifier] [varchar](765) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ThreadIdentifier] [varchar](765) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsClientManaged] [bit] NULL,
	[RelatedToId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsTracked] [bit] NULL,
	[IsOpened] [bit] NULL,
	[FirstOpenedDate] [datetime2](7) NULL,
	[LastOpenedDate] [datetime2](7) NULL,
	[IsBounced] [bit] NULL,
	[EmailTemplateId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContentDocumentIds] [varchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BccIds] [varchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CcIds] [varchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ToIds] [varchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_EmailMessage] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreatedDate] ON [SF].[EmailMessage]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LastModifiedDate] ON [SF].[EmailMessage]
(
	[LastModifiedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [SF].[EmailMessage]  WITH NOCHECK ADD  CONSTRAINT [fk_EmailMessage_Account_RelatedToId] FOREIGN KEY([RelatedToId])
REFERENCES [SF].[Account] ([Id])
GO
ALTER TABLE [SF].[EmailMessage] NOCHECK CONSTRAINT [fk_EmailMessage_Account_RelatedToId]
GO
ALTER TABLE [SF].[EmailMessage]  WITH NOCHECK ADD  CONSTRAINT [fk_EmailMessage_AssignedResource_RelatedToId] FOREIGN KEY([RelatedToId])
REFERENCES [SF].[AssignedResource] ([Id])
GO
ALTER TABLE [SF].[EmailMessage] NOCHECK CONSTRAINT [fk_EmailMessage_AssignedResource_RelatedToId]
GO
ALTER TABLE [SF].[EmailMessage]  WITH NOCHECK ADD  CONSTRAINT [fk_EmailMessage_Campaign_RelatedToId] FOREIGN KEY([RelatedToId])
REFERENCES [SF].[Campaign] ([Id])
GO
ALTER TABLE [SF].[EmailMessage] NOCHECK CONSTRAINT [fk_EmailMessage_Campaign_RelatedToId]
GO
ALTER TABLE [SF].[EmailMessage]  WITH NOCHECK ADD  CONSTRAINT [fk_EmailMessage_Case_ParentId] FOREIGN KEY([ParentId])
REFERENCES [SF].[Case] ([Id])
GO
ALTER TABLE [SF].[EmailMessage] NOCHECK CONSTRAINT [fk_EmailMessage_Case_ParentId]
GO
ALTER TABLE [SF].[EmailMessage]  WITH NOCHECK ADD  CONSTRAINT [fk_EmailMessage_Case_RelatedToId] FOREIGN KEY([RelatedToId])
REFERENCES [SF].[Case] ([Id])
GO
ALTER TABLE [SF].[EmailMessage] NOCHECK CONSTRAINT [fk_EmailMessage_Case_RelatedToId]
GO
ALTER TABLE [SF].[EmailMessage]  WITH NOCHECK ADD  CONSTRAINT [fk_EmailMessage_Commissions_Log__c_RelatedToId] FOREIGN KEY([RelatedToId])
REFERENCES [SF].[Commissions_Log__c] ([Id])
GO
ALTER TABLE [SF].[EmailMessage] NOCHECK CONSTRAINT [fk_EmailMessage_Commissions_Log__c_RelatedToId]
GO
ALTER TABLE [SF].[EmailMessage]  WITH NOCHECK ADD  CONSTRAINT [fk_EmailMessage_Contract_RelatedToId] FOREIGN KEY([RelatedToId])
REFERENCES [SF].[Contract] ([Id])
GO
ALTER TABLE [SF].[EmailMessage] NOCHECK CONSTRAINT [fk_EmailMessage_Contract_RelatedToId]
GO
ALTER TABLE [SF].[EmailMessage]  WITH NOCHECK ADD  CONSTRAINT [fk_EmailMessage_ContractLineItem_RelatedToId] FOREIGN KEY([RelatedToId])
REFERENCES [SF].[ContractLineItem] ([Id])
GO
ALTER TABLE [SF].[EmailMessage] NOCHECK CONSTRAINT [fk_EmailMessage_ContractLineItem_RelatedToId]
GO
ALTER TABLE [SF].[EmailMessage]  WITH NOCHECK ADD  CONSTRAINT [fk_EmailMessage_EmailMessage_ReplyToEmailMessageId] FOREIGN KEY([ReplyToEmailMessageId])
REFERENCES [SF].[EmailMessage] ([Id])
GO
ALTER TABLE [SF].[EmailMessage] NOCHECK CONSTRAINT [fk_EmailMessage_EmailMessage_ReplyToEmailMessageId]
GO
ALTER TABLE [SF].[EmailMessage]  WITH NOCHECK ADD  CONSTRAINT [fk_EmailMessage_Location_RelatedToId] FOREIGN KEY([RelatedToId])
REFERENCES [SF].[Location] ([Id])
GO
ALTER TABLE [SF].[EmailMessage] NOCHECK CONSTRAINT [fk_EmailMessage_Location_RelatedToId]
GO
ALTER TABLE [SF].[EmailMessage]  WITH NOCHECK ADD  CONSTRAINT [fk_EmailMessage_Opportunity_RelatedToId] FOREIGN KEY([RelatedToId])
REFERENCES [SF].[Opportunity] ([Id])
GO
ALTER TABLE [SF].[EmailMessage] NOCHECK CONSTRAINT [fk_EmailMessage_Opportunity_RelatedToId]
GO
ALTER TABLE [SF].[EmailMessage]  WITH NOCHECK ADD  CONSTRAINT [fk_EmailMessage_Order_RelatedToId] FOREIGN KEY([RelatedToId])
REFERENCES [SF].[Order] ([Id])
GO
ALTER TABLE [SF].[EmailMessage] NOCHECK CONSTRAINT [fk_EmailMessage_Order_RelatedToId]
GO
ALTER TABLE [SF].[EmailMessage]  WITH NOCHECK ADD  CONSTRAINT [fk_EmailMessage_PromoCode__c_RelatedToId] FOREIGN KEY([RelatedToId])
REFERENCES [SF].[PromoCode__c] ([Id])
GO
ALTER TABLE [SF].[EmailMessage] NOCHECK CONSTRAINT [fk_EmailMessage_PromoCode__c_RelatedToId]
GO
ALTER TABLE [SF].[EmailMessage]  WITH NOCHECK ADD  CONSTRAINT [fk_EmailMessage_Quote_RelatedToId] FOREIGN KEY([RelatedToId])
REFERENCES [SF].[Quote] ([Id])
GO
ALTER TABLE [SF].[EmailMessage] NOCHECK CONSTRAINT [fk_EmailMessage_Quote_RelatedToId]
GO
ALTER TABLE [SF].[EmailMessage]  WITH NOCHECK ADD  CONSTRAINT [fk_EmailMessage_ServiceAppointment_RelatedToId] FOREIGN KEY([RelatedToId])
REFERENCES [SF].[ServiceAppointment] ([Id])
GO
ALTER TABLE [SF].[EmailMessage] NOCHECK CONSTRAINT [fk_EmailMessage_ServiceAppointment_RelatedToId]
GO
ALTER TABLE [SF].[EmailMessage]  WITH NOCHECK ADD  CONSTRAINT [fk_EmailMessage_ServiceContract_RelatedToId] FOREIGN KEY([RelatedToId])
REFERENCES [SF].[ServiceContract] ([Id])
GO
ALTER TABLE [SF].[EmailMessage] NOCHECK CONSTRAINT [fk_EmailMessage_ServiceContract_RelatedToId]
GO
ALTER TABLE [SF].[EmailMessage]  WITH NOCHECK ADD  CONSTRAINT [fk_EmailMessage_ServiceResource_RelatedToId] FOREIGN KEY([RelatedToId])
REFERENCES [SF].[ServiceResource] ([Id])
GO
ALTER TABLE [SF].[EmailMessage] NOCHECK CONSTRAINT [fk_EmailMessage_ServiceResource_RelatedToId]
GO
ALTER TABLE [SF].[EmailMessage]  WITH NOCHECK ADD  CONSTRAINT [fk_EmailMessage_Task_ActivityId] FOREIGN KEY([ActivityId])
REFERENCES [SF].[Task] ([Id])
GO
ALTER TABLE [SF].[EmailMessage] NOCHECK CONSTRAINT [fk_EmailMessage_Task_ActivityId]
GO
ALTER TABLE [SF].[EmailMessage]  WITH NOCHECK ADD  CONSTRAINT [fk_EmailMessage_User_CreatedById] FOREIGN KEY([CreatedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[EmailMessage] NOCHECK CONSTRAINT [fk_EmailMessage_User_CreatedById]
GO
ALTER TABLE [SF].[EmailMessage]  WITH NOCHECK ADD  CONSTRAINT [fk_EmailMessage_User_LastModifiedById] FOREIGN KEY([LastModifiedById])
REFERENCES [SF].[User] ([Id])
GO
ALTER TABLE [SF].[EmailMessage] NOCHECK CONSTRAINT [fk_EmailMessage_User_LastModifiedById]
GO
ALTER TABLE [SF].[EmailMessage]  WITH NOCHECK ADD  CONSTRAINT [fk_EmailMessage_WorkOrder_RelatedToId] FOREIGN KEY([RelatedToId])
REFERENCES [SF].[WorkOrder] ([Id])
GO
ALTER TABLE [SF].[EmailMessage] NOCHECK CONSTRAINT [fk_EmailMessage_WorkOrder_RelatedToId]
GO
ALTER TABLE [SF].[EmailMessage]  WITH NOCHECK ADD  CONSTRAINT [fk_EmailMessage_WorkOrderLineItem_RelatedToId] FOREIGN KEY([RelatedToId])
REFERENCES [SF].[WorkOrderLineItem] ([Id])
GO
ALTER TABLE [SF].[EmailMessage] NOCHECK CONSTRAINT [fk_EmailMessage_WorkOrderLineItem_RelatedToId]
GO
ALTER TABLE [SF].[EmailMessage]  WITH NOCHECK ADD  CONSTRAINT [fk_EmailMessage_ZipCode__c_RelatedToId] FOREIGN KEY([RelatedToId])
REFERENCES [SF].[ZipCode__c] ([Id])
GO
ALTER TABLE [SF].[EmailMessage] NOCHECK CONSTRAINT [fk_EmailMessage_ZipCode__c_RelatedToId]
GO
