/* CreateDate: 05/03/2010 12:17:22.967 , ModifyDate: 09/16/2019 09:33:49.807 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bief_dds].[_DBVersion] ADD  CONSTRAINT [DF__DBVersion_DBVersionMajor]  DEFAULT ((0)) FOR [DBVersionMajor]
GO
ALTER TABLE [bief_dds].[_DBVersion] ADD  CONSTRAINT [DF__DBVersion_DBVersioMinor]  DEFAULT ((0)) FOR [DBVersionMinor]
GO
ALTER TABLE [bief_dds].[_DBVersion] ADD  CONSTRAINT [DF__DBVersion_DBVersionBuild]  DEFAULT ((0)) FOR [DBVersionBuild]
GO
ALTER TABLE [bief_dds].[_DBVersion] ADD  CONSTRAINT [DF__DBVersion_DBVersionRevision]  DEFAULT ((0)) FOR [DBVersionRevision]
GO
ALTER TABLE [bief_dds].[_DBVersion] ADD  CONSTRAINT [DF__DBVersion_RowUpdateDate]  DEFAULT (getdate()) FOR [RowUpdateDate]
GO
