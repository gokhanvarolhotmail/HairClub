/* CreateDate: 02/13/2009 09:55:50.857 , ModifyDate: 02/13/2009 12:44:03.713 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SourcesWithCreatives](
	[Media] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level02Location] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level05Creative] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level03Language] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level04Format] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceCode] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Number] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NumberType] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[Creative Assignment] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Level05ID] [int] NULL
) ON [PRIMARY]
GO
