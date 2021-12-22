/* CreateDate: 05/03/2010 12:08:47.537 , ModifyDate: 05/03/2010 12:08:47.867 */
GO
CREATE TABLE [bief_dds].[_DBVersion](
	[DBVersionMajor] [int] NOT NULL,
	[DBVersionMinor] [int] NOT NULL,
	[DBVersionBuild] [int] NOT NULL,
	[DBVersionRevision] [int] NOT NULL,
	[RowUpdateDate] [datetime] NOT NULL
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
