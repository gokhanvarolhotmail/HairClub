/* CreateDate: 10/13/2010 16:37:06.143 , ModifyDate: 03/10/2022 14:15:12.207 */
GO
CREATE TABLE [bief_dds].[_DBConfig](
	[setting_key] [int] NOT NULL,
	[setting_name] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[setting_value_bit] [bit] NOT NULL,
	[setting_value_int] [int] NULL,
	[setting_value_varchar] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[setting_value_datatime] [datetime] NULL,
	[setting_value_decimal] [decimal](18, 4) NULL,
 CONSTRAINT [PK__DBConfig] PRIMARY KEY CLUSTERED
(
	[setting_key] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [bief_dds].[_DBConfig] ADD  CONSTRAINT [DF__DBConfig_setting_value_bit]  DEFAULT ((0)) FOR [setting_value_bit]
GO
ALTER TABLE [bief_dds].[_DBConfig] ADD  CONSTRAINT [DF__DBConfig_setting_value_int]  DEFAULT (NULL) FOR [setting_value_int]
GO
ALTER TABLE [bief_dds].[_DBConfig] ADD  CONSTRAINT [DF__DBConfig_setting_value_varchar]  DEFAULT (NULL) FOR [setting_value_varchar]
GO
ALTER TABLE [bief_dds].[_DBConfig] ADD  CONSTRAINT [DF__DBConfig_setting_value_datatime]  DEFAULT (NULL) FOR [setting_value_datatime]
GO
ALTER TABLE [bief_dds].[_DBConfig] ADD  CONSTRAINT [DF__DBConfig_setting_value_decimal]  DEFAULT (NULL) FOR [setting_value_decimal]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Name of setting' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'_DBConfig', @level2type=N'COLUMN',@level2name=N'setting_name'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Boolean value of setting' , @level0type=N'SCHEMA',@level0name=N'bief_dds', @level1type=N'TABLE',@level1name=N'_DBConfig', @level2type=N'COLUMN',@level2name=N'setting_value_bit'
GO
