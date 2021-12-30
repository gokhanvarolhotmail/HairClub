/* CreateDate: 12/31/2010 13:21:01.730 , ModifyDate: 05/26/2020 10:49:01.620 */
GO
CREATE TABLE [dbo].[lkpHairSystemFrontalLaceLength](
	[HairSystemFrontalLaceLengthID] [int] NOT NULL,
	[HairSystemFrontalLaceLengthSortOrder] [int] NOT NULL,
	[HairSystemFrontalLaceLengthDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemFrontalLaceLengthDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairSystemFrontalLaceLengthValue] [decimal](8, 4) NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpHairSystemFrontalLaceLength] PRIMARY KEY CLUSTERED
(
	[HairSystemFrontalLaceLengthID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
