/* CreateDate: 10/04/2010 12:08:45.967 , ModifyDate: 12/03/2021 10:24:48.537 */
GO
CREATE TABLE [dbo].[lkpHairSystemOrderSpecialInstruction](
	[HairSystemOrderSpecialInstructionID] [int] NOT NULL,
	[HairSystemOrderSpecialInstructionSortOrder] [int] NOT NULL,
	[HairSystemOrderSpecialInstructionDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemOrderSpecialInstructionDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsShippingFlag] [bit] NULL,
	[IsReceivingFlag] [bit] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpHairSystemOrderSpecialInstruction] PRIMARY KEY CLUSTERED
(
	[HairSystemOrderSpecialInstructionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpHairSystemOrderSpecialInstruction] ADD  DEFAULT ((0)) FOR [IsShippingFlag]
GO
ALTER TABLE [dbo].[lkpHairSystemOrderSpecialInstruction] ADD  DEFAULT ((0)) FOR [IsReceivingFlag]
GO
ALTER TABLE [dbo].[lkpHairSystemOrderSpecialInstruction] ADD  DEFAULT ((0)) FOR [IsActiveFlag]
GO
