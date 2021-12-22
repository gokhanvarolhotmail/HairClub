/* CreateDate: 10/03/2019 23:03:39.660 , ModifyDate: 10/03/2019 23:03:44.713 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [bief_dds].[_DBVersion](
	[DBVersionMajor] [int] NOT NULL,
	[DBVersionMinor] [int] NOT NULL,
	[DBVersionBuild] [int] NOT NULL,
	[DBVersionRevision] [int] NOT NULL,
	[RowUpdateDate] [datetime] NOT NULL,
 CONSTRAINT [PK__DBVersion] PRIMARY KEY CLUSTERED
(
	[DBVersionMajor] ASC,
	[DBVersionMinor] ASC,
	[DBVersionBuild] ASC,
	[DBVersionRevision] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
) ON [FG1]
GO
