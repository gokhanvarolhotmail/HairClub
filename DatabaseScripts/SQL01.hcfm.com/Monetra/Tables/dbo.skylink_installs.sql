CREATE TABLE [dbo].[skylink_installs](
	[user_id] [int] NOT NULL,
	[device_id] [varchar](64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[is_deactivated] [bigint] NOT NULL,
	[deactivation_cnt] [int] NOT NULL,
	[last_used_ts] [bigint] NOT NULL,
	[last_used_user] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[name] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[manuf] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[model] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[os] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[osver] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[tagged_fields] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED
(
	[user_id] ASC,
	[device_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_skylink_installs_deactive_user] ON [dbo].[skylink_installs]
(
	[is_deactivated] ASC,
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
