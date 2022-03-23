/* CreateDate: 03/17/2022 11:57:03.243 , ModifyDate: 03/17/2022 11:57:13.513 */
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
) ON [FG1] TEXTIMAGE_ON [FG1]
GO
