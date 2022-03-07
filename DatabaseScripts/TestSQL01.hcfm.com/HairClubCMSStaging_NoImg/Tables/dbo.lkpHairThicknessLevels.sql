/* CreateDate: 08/05/2014 08:15:14.787 , ModifyDate: 03/04/2022 16:09:12.743 */
GO
CREATE TABLE [dbo].[lkpHairThicknessLevels](
	[HairThicknessLevelsID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[HairThicknessLevelsSortOrder] [int] NOT NULL,
	[HairThicknessLevelsDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairThicknessLevelsDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairThicknessLevelsDescriptionLong] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
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
 CONSTRAINT [PK_lkpHairThicknessLevels] PRIMARY KEY CLUSTERED
(
	[HairThicknessLevelsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
