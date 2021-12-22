CREATE TABLE [dbo].[ord_orders](
	[id] [bigint] NOT NULL,
	[user_id] [int] NOT NULL,
	[subuser_id] [bigint] NOT NULL,
	[timestamp_ms] [bigint] NOT NULL,
	[is_deleted] [int] NOT NULL,
	[type] [smallint] NOT NULL,
	[flags] [bigint] NOT NULL,
	[status] [smallint] NOT NULL,
	[cancel_reason] [smallint] NULL,
	[merch_status] [smallint] NOT NULL,
	[customer_id] [bigint] NULL,
	[ordernum] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ponumber] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[allowed_cardtypes] [int] NULL,
	[securitytoken] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[timestamp_create] [bigint] NOT NULL,
	[timestamp_close] [bigint] NULL,
	[timestamp_sent] [bigint] NULL,
	[timestamp_viewed] [bigint] NULL,
	[invoice_date] [int] NULL,
	[invoice_due] [int] NULL,
	[taxrate_1] [bigint] NULL,
	[taxrate_2] [bigint] NULL,
	[taxrate_3] [bigint] NULL,
	[taxrate_4] [bigint] NULL,
	[taxamount_1] [bigint] NULL,
	[taxamount_2] [bigint] NULL,
	[taxamount_3] [bigint] NULL,
	[taxamount_4] [bigint] NULL,
	[total_amount] [bigint] NULL,
	[total_tax] [bigint] NULL,
	[total_discount] [bigint] NULL,
	[total_paid] [bigint] NULL,
	[total_tip] [bigint] NULL,
	[ship_zip] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[tagged_fields] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_ord_orders_del_ts] ON [dbo].[ord_orders]
(
	[is_deleted] ASC,
	[timestamp_ms] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_ord_orders_tsclose_stat_user] ON [dbo].[ord_orders]
(
	[timestamp_close] ASC,
	[status] ASC,
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_ord_orders_tscreate_user_stat] ON [dbo].[ord_orders]
(
	[timestamp_create] ASC,
	[user_id] ASC,
	[status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_ord_orders_user_cust] ON [dbo].[ord_orders]
(
	[user_id] ASC,
	[customer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [i_ord_orders_user_order] ON [dbo].[ord_orders]
(
	[user_id] ASC,
	[ordernum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_ord_orders_user_status] ON [dbo].[ord_orders]
(
	[user_id] ASC,
	[status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_ord_orders_user_tax1] ON [dbo].[ord_orders]
(
	[user_id] ASC,
	[taxrate_1] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_ord_orders_user_tax2] ON [dbo].[ord_orders]
(
	[user_id] ASC,
	[taxrate_2] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_ord_orders_user_tax3] ON [dbo].[ord_orders]
(
	[user_id] ASC,
	[taxrate_3] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_ord_orders_user_tax4] ON [dbo].[ord_orders]
(
	[user_id] ASC,
	[taxrate_4] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_ord_orders_user_ts] ON [dbo].[ord_orders]
(
	[user_id] ASC,
	[timestamp_ms] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
