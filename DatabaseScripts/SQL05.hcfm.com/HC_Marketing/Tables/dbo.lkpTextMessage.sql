/* CreateDate: 08/23/2016 15:46:35.630 , ModifyDate: 08/23/2016 15:46:35.663 */
GO
CREATE TABLE [dbo].[lkpTextMessage](
	[TextMessageID] [int] IDENTITY(1,1) NOT NULL,
	[TextMessageProcessID] [int] NOT NULL,
	[LanguageCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TextMessage] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_lkpTextMessage] PRIMARY KEY CLUSTERED
(
	[TextMessageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpTextMessage] ADD  CONSTRAINT [DF_lkpTextMessage_IsActiveFlag]  DEFAULT ((0)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[lkpTextMessage]  WITH CHECK ADD  CONSTRAINT [FK_lkpTextMessage_lkpTextMessageProcess] FOREIGN KEY([TextMessageProcessID])
REFERENCES [dbo].[lkpTextMessageProcess] ([TextMessageProcessID])
GO
ALTER TABLE [dbo].[lkpTextMessage] CHECK CONSTRAINT [FK_lkpTextMessage_lkpTextMessageProcess]
GO
