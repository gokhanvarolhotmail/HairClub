/* CreateDate: 09/03/2014 07:45:47.310 , ModifyDate: 03/04/2022 16:09:12.630 */
GO
CREATE TABLE [dbo].[lkpNoteSubType](
	[NoteSubTypeID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[NoteSubTypeSortOrder] [int] NOT NULL,
	[NoteSubTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[NoteSubTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[DescriptionResourceKey] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsSubTypeAllowedForManualEntry] [bit] NOT NULL,
 CONSTRAINT [PK_lkpNoteSubType] PRIMARY KEY CLUSTERED
(
	[NoteSubTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
