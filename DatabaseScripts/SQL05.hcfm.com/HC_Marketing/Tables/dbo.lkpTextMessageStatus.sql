/* CreateDate: 08/16/2016 15:47:26.850 , ModifyDate: 12/06/2017 16:41:56.267 */
GO
CREATE TABLE [dbo].[lkpTextMessageStatus](
	[TextMessageStatusID] [int] IDENTITY(1,1) NOT NULL,
	[TextMessageStatusDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TextMessageStatusDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_lkpTextMessageStatus] PRIMARY KEY CLUSTERED
(
	[TextMessageStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpTextMessageStatus] ADD  CONSTRAINT [DF_lkpTextMessageStatus_IsActiveFlag]  DEFAULT ((0)) FOR [IsActiveFlag]
GO
