/* CreateDate: 08/27/2008 11:30:23.997 , ModifyDate: 12/29/2021 15:38:46.283 */
GO
CREATE TABLE [dbo].[lkpNoteType](
	[NoteTypeID] [int] NOT NULL,
	[NoteTypeSortOrder] [int] NOT NULL,
	[NoteTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[NoteTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[DescriptionResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsTypeAllowedForManualEntry] [bit] NOT NULL,
 CONSTRAINT [PK_lkpNoteType] PRIMARY KEY CLUSTERED
(
	[NoteTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[lkpNoteType] ADD  CONSTRAINT [DF_lkpNoteType_IsActiveFlag]  DEFAULT ((1)) FOR [IsActiveFlag]
GO
