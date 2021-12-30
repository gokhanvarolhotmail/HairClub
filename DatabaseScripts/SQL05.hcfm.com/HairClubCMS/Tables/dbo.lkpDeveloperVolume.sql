/* CreateDate: 05/05/2020 17:42:52.540 , ModifyDate: 05/05/2020 17:43:14.143 */
GO
CREATE TABLE [dbo].[lkpDeveloperVolume](
	[DeveloperVolumeID] [int] NOT NULL,
	[DeveloperVolumeSortOrder] [int] NOT NULL,
	[DeveloperVolumeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DeveloperVolumeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ColorBrandID] [int] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpDeveloperVolume] PRIMARY KEY CLUSTERED
(
	[DeveloperVolumeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
