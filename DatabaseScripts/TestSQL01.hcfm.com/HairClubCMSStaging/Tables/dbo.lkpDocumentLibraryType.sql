/* CreateDate: 11/22/2017 14:34:59.920 , ModifyDate: 11/22/2017 14:35:00.017 */
GO
CREATE TABLE [dbo].[lkpDocumentLibraryType](
	[DocumentLibraryTypeID] [int] NOT NULL,
	[DocumentLibraryTypeSortOrder] [int] NOT NULL,
	[DocumentLibraryTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DocumentLibraryTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[DescriptionResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_lkpDocumentLibraryType] PRIMARY KEY CLUSTERED
(
	[DocumentLibraryTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpDocumentLibraryType] ADD  DEFAULT ((0)) FOR [IsActiveFlag]
GO
