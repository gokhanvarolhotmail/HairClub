/* CreateDate: 08/27/2008 12:04:56.683 , ModifyDate: 12/07/2021 16:20:16.180 */
GO
CREATE TABLE [dbo].[lkpHairSystemType](
	[HairSystemTypeID] [int] NOT NULL,
	[HairSystemTypeSortOrder] [int] NOT NULL,
	[HairSystemTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpHairSystemType] PRIMARY KEY CLUSTERED
(
	[HairSystemTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpHairSystemType] ADD  CONSTRAINT [DF_lkpHairSystemType_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
