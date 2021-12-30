/* CreateDate: 05/03/2010 12:19:12.987 , ModifyDate: 05/03/2010 12:19:13.357 */
GO
CREATE TABLE [bief_dq].[_DBConfig](
	[setting_name] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[setting_value_bit] [bit] NOT NULL,
	[setting_value_int] [int] NULL,
	[setting_value_varchar] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[setting_value_datatime] [datetime] NULL,
	[setting_value_decimal] [decimal](18, 4) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [bief_dq].[_DBConfig] ADD  CONSTRAINT [DF__DBConfig_setting_value_bit]  DEFAULT ((0)) FOR [setting_value_bit]
GO
ALTER TABLE [bief_dq].[_DBConfig] ADD  CONSTRAINT [DF__DBConfig_setting_value_int]  DEFAULT (NULL) FOR [setting_value_int]
GO
ALTER TABLE [bief_dq].[_DBConfig] ADD  CONSTRAINT [DF__DBConfig_setting_value_varchar]  DEFAULT (NULL) FOR [setting_value_varchar]
GO
ALTER TABLE [bief_dq].[_DBConfig] ADD  CONSTRAINT [DF__DBConfig_setting_value_datatime]  DEFAULT (NULL) FOR [setting_value_datatime]
GO
ALTER TABLE [bief_dq].[_DBConfig] ADD  CONSTRAINT [DF__DBConfig_setting_value_decimal]  DEFAULT (NULL) FOR [setting_value_decimal]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Name of setting' , @level0type=N'SCHEMA',@level0name=N'bief_dq', @level1type=N'TABLE',@level1name=N'_DBConfig', @level2type=N'COLUMN',@level2name=N'setting_name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Boolean value of setting' , @level0type=N'SCHEMA',@level0name=N'bief_dq', @level1type=N'TABLE',@level1name=N'_DBConfig', @level2type=N'COLUMN',@level2name=N'setting_value_bit'
GO
