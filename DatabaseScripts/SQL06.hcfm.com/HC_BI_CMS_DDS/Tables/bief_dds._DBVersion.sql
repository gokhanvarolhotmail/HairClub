/* CreateDate: 03/17/2022 11:57:04.290 , ModifyDate: 03/17/2022 11:57:13.540 */
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
