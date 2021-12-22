/* CreateDate: 08/27/2008 11:39:37.957 , ModifyDate: 12/03/2021 10:24:48.663 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpDeveloperVolume] ADD  CONSTRAINT [DF_lkpDeveloperVolume_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[lkpDeveloperVolume]  WITH CHECK ADD  CONSTRAINT [FK_lkpDeveloperVolume_lkpColorBrand] FOREIGN KEY([ColorBrandID])
REFERENCES [dbo].[lkpColorBrand] ([ColorBrandID])
GO
ALTER TABLE [dbo].[lkpDeveloperVolume] CHECK CONSTRAINT [FK_lkpDeveloperVolume_lkpColorBrand]
GO
