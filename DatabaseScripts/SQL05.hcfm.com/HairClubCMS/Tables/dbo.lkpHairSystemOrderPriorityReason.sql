/* CreateDate: 05/05/2020 17:42:50.857 , ModifyDate: 05/05/2020 17:43:11.373 */
GO
CREATE TABLE [dbo].[lkpHairSystemOrderPriorityReason](
	[HairSystemOrderPriorityReasonID] [int] NOT NULL,
	[HairSystemOrderPriorityReasonSortOrder] [int] NOT NULL,
	[HairSystemOrderPriorityReasonDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemOrderPriorityReasonDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_lkpHairSystemOrderPriorityReason] PRIMARY KEY CLUSTERED
(
	[HairSystemOrderPriorityReasonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
