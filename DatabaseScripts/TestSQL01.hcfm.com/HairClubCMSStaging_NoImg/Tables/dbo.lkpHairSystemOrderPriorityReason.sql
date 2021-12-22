/* CreateDate: 02/22/2016 08:56:32.127 , ModifyDate: 12/03/2021 10:24:48.560 */
GO
CREATE TABLE [dbo].[lkpHairSystemOrderPriorityReason](
	[HairSystemOrderPriorityReasonID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
