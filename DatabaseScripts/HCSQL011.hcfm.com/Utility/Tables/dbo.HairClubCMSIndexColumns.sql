/* CreateDate: 08/05/2018 20:50:56.360 , ModifyDate: 08/05/2018 20:50:56.360 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[HairClubCMSIndexColumns](
	[ObjectId] [int] NOT NULL,
	[TableName] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IndexId] [int] NULL,
	[IndexName] [sysname] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[KeyColumns] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IncludeColumns] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HeapColumns] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
