/* CreateDate: 09/24/2014 22:36:49.097 , ModifyDate: 12/03/2021 10:24:48.730 */
GO
CREATE TABLE [dbo].[lkpHairDensityLevels](
	[HairDensityLevelsID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairDensityLevelsSortOrder] [int] NOT NULL,
	[HairDensityLevelsDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairDensityLevelsDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairDensityLevelsDescriptionLong] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[MinValue] [decimal](18, 0) NOT NULL,
	[MaxValue] [decimal](18, 0) NOT NULL,
	[DescriptionResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DescriptionLongResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lkpHairDensityLevels] PRIMARY KEY CLUSTERED
(
	[HairDensityLevelsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
