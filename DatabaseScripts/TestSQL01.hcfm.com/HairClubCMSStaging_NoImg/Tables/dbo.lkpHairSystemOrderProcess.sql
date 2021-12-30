/* CreateDate: 12/31/2010 13:21:01.073 , ModifyDate: 12/28/2021 09:20:54.650 */
GO
CREATE TABLE [dbo].[lkpHairSystemOrderProcess](
	[HairSystemOrderProcessID] [int] NOT NULL,
	[HairSystemOrderProcessSortOrder] [int] NOT NULL,
	[HairSystemOrderProcessDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemOrderProcessDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpHairSystemOrderProcess] PRIMARY KEY CLUSTERED
(
	[HairSystemOrderProcessID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpHairSystemOrderProcess] ADD  DEFAULT ((0)) FOR [IsActiveFlag]
GO
