/* CreateDate: 08/16/2016 15:45:52.347 , ModifyDate: 12/06/2017 16:41:56.240 */
GO
CREATE TABLE [dbo].[lkpTextMessageProcess](
	[TextMessageProcessID] [int] IDENTITY(1,1) NOT NULL,
	[TextMessageProcessDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TextMessageProcessDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_lkpTextMessageProcess] PRIMARY KEY CLUSTERED
(
	[TextMessageProcessID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpTextMessageProcess] ADD  CONSTRAINT [DF_lkpTextMessageProcess_IsActiveFlag]  DEFAULT ((0)) FOR [IsActiveFlag]
GO
