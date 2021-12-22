CREATE TABLE [dbo].[cfgDocumentLibrary](
	[DocumentLibraryID] [int] NOT NULL,
	[DocumentLibrarySortOrder] [int] NOT NULL,
	[DocumentLibraryTypeID] [int] NOT NULL,
	[DocumentLibraryDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[DocumentLibraryUrl] [nvarchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[IsAvailableToStylistApp] [bit] NOT NULL,
 CONSTRAINT [PK_cfgDocumentLibrary] PRIMARY KEY CLUSTERED
(
	[DocumentLibraryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgDocumentLibrary] ADD  DEFAULT ((0)) FOR [IsActiveFlag]
GO
ALTER TABLE [dbo].[cfgDocumentLibrary]  WITH CHECK ADD  CONSTRAINT [FK_cfgDocumentLibrary_lkpDocumentLibraryType_DocumentLibraryTypeID] FOREIGN KEY([DocumentLibraryTypeID])
REFERENCES [dbo].[lkpDocumentLibraryType] ([DocumentLibraryTypeID])
GO
ALTER TABLE [dbo].[cfgDocumentLibrary] CHECK CONSTRAINT [FK_cfgDocumentLibrary_lkpDocumentLibraryType_DocumentLibraryTypeID]
