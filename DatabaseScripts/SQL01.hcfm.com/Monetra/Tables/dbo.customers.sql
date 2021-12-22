CREATE TABLE [dbo].[customers](
	[id] [bigint] NOT NULL,
	[user_id] [int] NULL,
	[group_id] [bigint] NULL,
	[flags] [bigint] NULL,
	[ts_created] [bigint] NULL,
	[ts_modified] [bigint] NULL,
	[display_name] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[name_company] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone_work] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone_home] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone_mobile] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[accounting_id] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[tagged_fields] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[default_billing_id] [bigint] NULL,
	[default_shipping_id] [bigint] NULL,
	[default_token] [bigint] NULL,
PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_customers_deftoken] ON [dbo].[customers]
(
	[default_token] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_customers_group] ON [dbo].[customers]
(
	[group_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_customers_user] ON [dbo].[customers]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
