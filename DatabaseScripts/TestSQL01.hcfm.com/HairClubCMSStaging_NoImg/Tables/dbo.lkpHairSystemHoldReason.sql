/* CreateDate: 12/31/2010 13:21:00.950 , ModifyDate: 12/03/2021 10:24:48.707 */
GO
CREATE TABLE [dbo].[lkpHairSystemHoldReason](
	[HairSystemHoldReasonID] [int] NOT NULL,
	[HairSystemHoldReasonSortOrder] [int] NOT NULL,
	[HairSystemHoldReasonDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemHoldReasonDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterID] [int] NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpHairSystemHoldReason] PRIMARY KEY CLUSTERED
(
	[HairSystemHoldReasonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpHairSystemHoldReason]  WITH NOCHECK ADD  CONSTRAINT [FK_lkpHairSystemHoldReason_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[lkpHairSystemHoldReason] CHECK CONSTRAINT [FK_lkpHairSystemHoldReason_cfgCenter]
GO
