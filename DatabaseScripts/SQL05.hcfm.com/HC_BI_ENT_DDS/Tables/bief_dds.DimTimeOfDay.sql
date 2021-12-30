/* CreateDate: 05/03/2010 12:08:47.477 , ModifyDate: 01/08/2021 15:21:36.830 */
GO
CREATE TABLE [bief_dds].[DimTimeOfDay](
	[TimeOfDayKey] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Time] [varchar](12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Time24] [varchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Hour] [smallint] NULL,
	[HourName] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Minute] [smallint] NULL,
	[MinuteKey] [smallint] NULL,
	[MinuteName] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Second] [smallint] NULL,
	[Hour24] [smallint] NULL,
	[AM] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_DimTimeOfDay] PRIMARY KEY CLUSTERED
(
	[TimeOfDayKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bief_dds].[DimTimeOfDay] ADD  CONSTRAINT [MSrepl_tran_version_default_0229C83F_EAB4_4907_A67E_1BBD75E3618D_2121058592]  DEFAULT (newid()) FOR [msrepl_tran_version]
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Surrogate primary key' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'TimeOfDayKey'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'TimeOfDayKey' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'TimeOfDayKey'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'1, 2, 3.' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'TimeOfDayKey'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'TimeOfDayKey'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'String expression of Time of day' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'Time'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'Time' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'Time'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'11:59:00 PM' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'Time'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'Time'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'Time'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'String expression of Time of day in Military time' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'Time24'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'Time24' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'Time24'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'23:59:00 PM' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'Time24'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'Time24'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'Time24'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'Hour' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'Hour'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'11' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'Hour'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'Hour'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'Hour'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'HourName' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'HourName'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'11 PM' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'HourName'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'HourName'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'HourName'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'Minute' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'Minute'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'15' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'Minute'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'Minute'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'Minute'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'MinuteKey' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'MinuteKey'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'1,2,3,.' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'MinuteKey'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'MinuteName' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'MinuteName'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'11:15 PM' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'MinuteName'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'MinuteName'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'MinuteName'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'TimeSecond' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'Second'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'0' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'Second'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'Second'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'Second'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'Hour24' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'Hour24'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'13' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'Hour24'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'Hour24'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'Hour24'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'AM' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'AM'
GO
EXEC sys.sp_addextendedproperty @name=N'Example Values', @value=N'AM or PM' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'AM'
GO
EXEC sys.sp_addextendedproperty @name=N'SCD  Type', @value=N'1' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'AM'
GO
EXEC sys.sp_addextendedproperty @name=N'Source System', @value=N'Derived' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay', @level2type=N'COLUMN',@level2name=N'AM'
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'Date dimension contains one row for second of the day. There may also be rows for "hasn''t happened yet."' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay'
GO
EXEC sys.sp_addextendedproperty @name=N'Display Name', @value=N'TimeOfDay' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay'
GO
EXEC sys.sp_addextendedproperty @name=N'Table Type', @value=N'Dimension' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay'
GO
EXEC sys.sp_addextendedproperty @name=N'Used in schemas', @value=N'List of schemas using this table' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay'
GO
EXEC sys.sp_addextendedproperty @name=N'View Name', @value=N'vw_TimeOfDay' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'DimTimeOfDay'
GO
