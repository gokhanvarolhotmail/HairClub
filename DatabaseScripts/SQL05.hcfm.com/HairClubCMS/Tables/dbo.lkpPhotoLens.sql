/* CreateDate: 05/05/2020 17:42:54.753 , ModifyDate: 05/05/2020 17:43:16.090 */
GO
CREATE TABLE [dbo].[lkpPhotoLens](
	[PhotoLensID] [int] NOT NULL,
	[PhotoLensSortOrder] [int] NOT NULL,
	[PhotoLensDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PhotoLensDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[Size] [int] NOT NULL,
	[Units] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Model] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FOVX] [float] NOT NULL,
	[FOVY] [float] NOT NULL,
	[Manufacturer] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HelpText] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DescriptionResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HelpTextResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lkpPhotoLens] PRIMARY KEY CLUSTERED
(
	[PhotoLensID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
