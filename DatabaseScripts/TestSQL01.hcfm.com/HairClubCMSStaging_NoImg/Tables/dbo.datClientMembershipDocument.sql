/* CreateDate: 01/21/2014 23:48:16.530 , ModifyDate: 03/03/2022 07:29:29.553 */
GO
CREATE TABLE [dbo].[datClientMembershipDocument](
	[ClientMembershipDocumentGUID] [uniqueidentifier] ROWGUIDCOL  NOT NULL,
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[ClientMembershipGUID] [uniqueidentifier] NOT NULL,
	[DocumentName] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Document] [varbinary](max) FILESTREAM  NULL,
	[DocumentTypeID] [int] NOT NULL,
	[Description] [nvarchar](400) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[DocumentStatusID] [int] NOT NULL,
	[OptOutDate] [datetime] NULL,
 CONSTRAINT [PK_ClientMembershipDocument] PRIMARY KEY CLUSTERED
(
	[ClientMembershipDocumentGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY] FILESTREAM_ON [HCCMSFileStreamClientDocs]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY] FILESTREAM_ON [HCCMSFileStreamClientDocs]
GO
CREATE NONCLUSTERED INDEX [IX_datClientMembershipDocument_ClientMembershipGUID] ON [dbo].[datClientMembershipDocument]
(
	[ClientMembershipGUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_datClientMembershipDocument_DocumentTypeID] ON [dbo].[datClientMembershipDocument]
(
	[DocumentTypeID] ASC
)
INCLUDE([ClientMembershipDocumentGUID],[ClientMembershipGUID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datClientMembershipDocument]  WITH CHECK ADD  CONSTRAINT [FK_datClientMembershipDocument_datClient] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datClientMembershipDocument] CHECK CONSTRAINT [FK_datClientMembershipDocument_datClient]
GO
ALTER TABLE [dbo].[datClientMembershipDocument]  WITH CHECK ADD  CONSTRAINT [FK_datClientMembershipDocument_datClientMembership] FOREIGN KEY([ClientMembershipGUID])
REFERENCES [dbo].[datClientMembership] ([ClientMembershipGUID])
GO
ALTER TABLE [dbo].[datClientMembershipDocument] CHECK CONSTRAINT [FK_datClientMembershipDocument_datClientMembership]
GO
ALTER TABLE [dbo].[datClientMembershipDocument]  WITH CHECK ADD  CONSTRAINT [FK_datClientMembershipDocument_lkpDocumentStatus] FOREIGN KEY([DocumentStatusID])
REFERENCES [dbo].[lkpDocumentStatus] ([DocumentStatusID])
GO
ALTER TABLE [dbo].[datClientMembershipDocument] CHECK CONSTRAINT [FK_datClientMembershipDocument_lkpDocumentStatus]
GO
ALTER TABLE [dbo].[datClientMembershipDocument]  WITH CHECK ADD  CONSTRAINT [FK_datClientMembershipDocument_lkpDocumentType] FOREIGN KEY([DocumentTypeID])
REFERENCES [dbo].[lkpDocumentType] ([DocumentTypeID])
GO
ALTER TABLE [dbo].[datClientMembershipDocument] CHECK CONSTRAINT [FK_datClientMembershipDocument_lkpDocumentType]
GO
