/* CreateDate: 05/24/2011 14:59:21.403 , ModifyDate: 02/27/2017 09:49:15.313 */
GO
CREATE TABLE [dbo].[tmpCMSUpdate](
	[CMSUpdateId] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[CenterId] [int] NOT NULL,
	[Client_no] [int] NULL,
	[HairSystemOrderNumber] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CMS25Transact_no] [int] NULL,
	[CMS25TransactionDate] [datetime] NULL,
	[ProcessedDate] [datetime] NULL,
	[IsSuccessful] [bit] NULL,
	[ErrorMessage] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ErrorCode] [int] NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_tmpCMSUpdate] PRIMARY KEY CLUSTERED
(
	[CMSUpdateId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tmpCMSUpdate_CenterId] ON [dbo].[tmpCMSUpdate]
(
	[CenterId] ASC
)
INCLUDE([CMS25Transact_no]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_tmpCMSUpdate_CenterId_ProcessedDate] ON [dbo].[tmpCMSUpdate]
(
	[CenterId] ASC,
	[ProcessedDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
