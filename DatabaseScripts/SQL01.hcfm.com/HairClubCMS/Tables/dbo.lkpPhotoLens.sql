/* CreateDate: 05/06/2014 09:10:04.050 , ModifyDate: 05/26/2020 10:49:25.430 */
GO
CREATE TABLE [dbo].[lkpPhotoLens](
	[PhotoLensID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpPhotoLens] ADD  CONSTRAINT [DF_lkpPhotoLens_IsActiveFlag]  DEFAULT ((0)) FOR [IsActiveFlag]
GO
