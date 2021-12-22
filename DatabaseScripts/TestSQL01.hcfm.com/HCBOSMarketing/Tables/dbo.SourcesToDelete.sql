/* CreateDate: 02/13/2009 09:56:49.187 , ModifyDate: 02/13/2009 09:56:49.190 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SourcesToDelete](
	[Media] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Location] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Creative] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Language] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Format] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceCode] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Number] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NumberType] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StartDate] [datetime] NULL,
	[EndDate] [datetime] NULL,
	[REMOVE] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
