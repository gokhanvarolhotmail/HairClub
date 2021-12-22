/* CreateDate: 12/31/2010 13:20:58.060 , ModifyDate: 12/07/2021 16:20:16.147 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lkpHairSystemRepairReason](
	[HairSystemRepairReasonID] [int] NOT NULL,
	[HairSystemRepairReasonSortOrder] [int] NOT NULL,
	[HairSystemRepairReasonDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemRepairReasonDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpHairSystemRepairReason] PRIMARY KEY CLUSTERED
(
	[HairSystemRepairReasonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
