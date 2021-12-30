/* CreateDate: 05/05/2020 17:42:43.140 , ModifyDate: 05/05/2020 17:43:01.887 */
GO
CREATE TABLE [dbo].[lkpHairSystemFrontalDesign](
	[HairSystemFrontalDesignID] [int] NOT NULL,
	[HairSystemFrontalDesignSortOrder] [int] NOT NULL,
	[HairSystemFrontalDesignDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemFrontalDesignDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [binary](8) NULL,
	[IsExtendedLaceAddOnFlag] [bit] NOT NULL
) ON [FG_CDC]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_lkpHairSystemFrontalDesign] ON [dbo].[lkpHairSystemFrontalDesign]
(
	[HairSystemFrontalDesignID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
