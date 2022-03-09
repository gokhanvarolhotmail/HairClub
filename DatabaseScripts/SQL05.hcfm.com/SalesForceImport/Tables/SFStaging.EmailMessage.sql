/* CreateDate: 03/04/2022 08:17:51.347 , ModifyDate: 03/08/2022 08:42:59.947 */
GO
CREATE TABLE [SFStaging].[EmailMessage](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ParentId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivityId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[TextBody] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HtmlBody] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Headers] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
