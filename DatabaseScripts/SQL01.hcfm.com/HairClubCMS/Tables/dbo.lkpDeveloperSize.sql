/* CreateDate: 08/27/2008 11:39:13.417 , ModifyDate: 05/26/2020 10:49:35.883 */
GO
CREATE TABLE [dbo].[lkpDeveloperSize](
	[DeveloperSizeID] [int] NOT NULL,
	[DeveloperSizeSortOrder] [int] NOT NULL,
	[DeveloperSizeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DeveloperSizeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ColorBrandID] [int] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpDeveloperSize] PRIMARY KEY CLUSTERED
(
	[DeveloperSizeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpDeveloperSize] ADD  CONSTRAINT [DF_lkpDeveloperSize_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[lkpDeveloperSize]  WITH NOCHECK ADD  CONSTRAINT [FK_lkpDeveloperSize_lkpColorBrand] FOREIGN KEY([ColorBrandID])
REFERENCES [dbo].[lkpColorBrand] ([ColorBrandID])
GO
ALTER TABLE [dbo].[lkpDeveloperSize] CHECK CONSTRAINT [FK_lkpDeveloperSize_lkpColorBrand]
GO
