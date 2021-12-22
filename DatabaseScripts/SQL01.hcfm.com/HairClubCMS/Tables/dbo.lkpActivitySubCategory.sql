CREATE TABLE [dbo].[lkpActivitySubCategory](
	[ActivitySubCategoryID] [int] IDENTITY(1,1) NOT NULL,
	[ActivityCategoryID] [int] NOT NULL,
	[ActivitySubCategorySortOrder] [int] NOT NULL,
	[ActivitySubCategoryDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ActivitySubCategoryDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[DescriptionResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lkpActivitySubCategory] PRIMARY KEY CLUSTERED
(
	[ActivitySubCategoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpActivitySubCategory]  WITH CHECK ADD  CONSTRAINT [FK_lkpActivitySubCategory_lkpActivityCategory] FOREIGN KEY([ActivityCategoryID])
REFERENCES [dbo].[lkpActivityCategory] ([ActivityCategoryID])
GO
ALTER TABLE [dbo].[lkpActivitySubCategory] CHECK CONSTRAINT [FK_lkpActivitySubCategory_lkpActivityCategory]
