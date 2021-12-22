CREATE TABLE [dbo].[push_endpoints](
	[id] [bigint] NOT NULL,
	[display_name] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[url] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[eventflags] [bigint] NOT NULL,
	[authtype] [smallint] NOT NULL,
	[authname] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[authdata] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[tracking_sequence] [bigint] NULL,
	[tracking_ts] [bigint] NULL,
	[tracking_status] [smallint] NULL,
PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_push_endpoints_ts] ON [dbo].[push_endpoints]
(
	[tracking_ts] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
