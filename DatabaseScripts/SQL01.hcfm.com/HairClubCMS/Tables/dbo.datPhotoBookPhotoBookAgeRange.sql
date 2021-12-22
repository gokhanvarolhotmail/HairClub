CREATE TABLE [dbo].[datPhotoBookPhotoBookAgeRange](
	[PhotoBookPhotoBookAgeRangeID] [int] IDENTITY(1,1) NOT NULL,
	[PhotoBookID] [int] NOT NULL,
	[PhotoBookAgeRangeID] [int] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datPhotoBookPhotoBookAgeRange] PRIMARY KEY CLUSTERED
(
	[PhotoBookPhotoBookAgeRangeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datPhotoBookPhotoBookAgeRange]  WITH CHECK ADD  CONSTRAINT [FK_datPhotoBookPhotoBookAgeRange_datPhotoBook] FOREIGN KEY([PhotoBookID])
REFERENCES [dbo].[datPhotoBook] ([PhotoBookID])
GO
ALTER TABLE [dbo].[datPhotoBookPhotoBookAgeRange] CHECK CONSTRAINT [FK_datPhotoBookPhotoBookAgeRange_datPhotoBook]
GO
ALTER TABLE [dbo].[datPhotoBookPhotoBookAgeRange]  WITH CHECK ADD  CONSTRAINT [FK_datPhotoBookPhotoBookAgeRange_lkpPhotoBookAgeRange] FOREIGN KEY([PhotoBookAgeRangeID])
REFERENCES [dbo].[lkpPhotoBookAgeRange] ([PhotoBookAgeRangeID])
GO
ALTER TABLE [dbo].[datPhotoBookPhotoBookAgeRange] CHECK CONSTRAINT [FK_datPhotoBookPhotoBookAgeRange_lkpPhotoBookAgeRange]
