/* CreateDate: 05/03/2010 12:09:34.790 , ModifyDate: 05/03/2010 12:09:35.093 */
GO
CREATE TABLE [bief_stage].[_DBVersion](
	[DBVersionMajor] [int] NOT NULL,
	[DBVersionMinor] [int] NOT NULL,
	[DBVersionBuild] [int] NOT NULL,
	[DBVersionRevision] [int] NOT NULL,
	[RowUpdateDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [bief_stage].[_DBVersion] ADD  CONSTRAINT [DF__DBVersion_DBVersionMajor]  DEFAULT ((0)) FOR [DBVersionMajor]
GO
ALTER TABLE [bief_stage].[_DBVersion] ADD  CONSTRAINT [DF__DBVersion_DBVersioMinor]  DEFAULT ((0)) FOR [DBVersionMinor]
GO
ALTER TABLE [bief_stage].[_DBVersion] ADD  CONSTRAINT [DF__DBVersion_DBVersionBuild]  DEFAULT ((0)) FOR [DBVersionBuild]
GO
ALTER TABLE [bief_stage].[_DBVersion] ADD  CONSTRAINT [DF__DBVersion_DBVersionRevision]  DEFAULT ((0)) FOR [DBVersionRevision]
GO
ALTER TABLE [bief_stage].[_DBVersion] ADD  CONSTRAINT [DF__DBVersion_RowUpdateDate]  DEFAULT (getdate()) FOR [RowUpdateDate]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Database Major Version' , @level0type=N'SCHEMA',@level0name=N'bief_stage', @level1type=N'TABLE',@level1name=N'_DBVersion', @level2type=N'COLUMN',@level2name=N'DBVersionMajor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Database Minor Version' , @level0type=N'SCHEMA',@level0name=N'bief_stage', @level1type=N'TABLE',@level1name=N'_DBVersion', @level2type=N'COLUMN',@level2name=N'DBVersionMinor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Database Build Version' , @level0type=N'SCHEMA',@level0name=N'bief_stage', @level1type=N'TABLE',@level1name=N'_DBVersion', @level2type=N'COLUMN',@level2name=N'DBVersionBuild'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Database Revison Version' , @level0type=N'SCHEMA',@level0name=N'bief_stage', @level1type=N'TABLE',@level1name=N'_DBVersion', @level2type=N'COLUMN',@level2name=N'DBVersionRevision'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Date and time the record was last updated.' , @level0type=N'SCHEMA',@level0name=N'bief_stage', @level1type=N'TABLE',@level1name=N'_DBVersion', @level2type=N'COLUMN',@level2name=N'RowUpdateDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identifies the Database Version' , @level0type=N'SCHEMA',@level0name=N'bief_stage', @level1type=N'TABLE',@level1name=N'_DBVersion'
GO
