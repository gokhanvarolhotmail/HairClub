/* CreateDate: 10/04/2010 12:08:46.157 , ModifyDate: 03/04/2022 16:09:12.670 */
GO
CREATE TABLE [dbo].[lkpHairSystemOrderTransferReason](
	[HairSystemOrderTransferReasonID] [int] NOT NULL,
	[HairSystemOrderTransferReasonSortOrder] [int] NOT NULL,
	[HairSystemOrderTransferReasonDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemOrderTransferReasonDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpHairSystemOrderTransferReason] PRIMARY KEY CLUSTERED
(
	[HairSystemOrderTransferReasonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpHairSystemOrderTransferReason] ADD  DEFAULT ((0)) FOR [IsActiveFlag]
GO
