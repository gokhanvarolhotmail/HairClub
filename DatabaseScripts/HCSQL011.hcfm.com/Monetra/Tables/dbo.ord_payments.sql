/* CreateDate: 04/26/2021 12:28:48.890 , ModifyDate: 04/26/2021 12:28:48.900 */
GO
CREATE TABLE [dbo].[ord_payments](
	[id] [bigint] NOT NULL,
	[order_id] [bigint] NOT NULL,
	[timestamp_ms] [bigint] NOT NULL,
	[tendertype] [smallint] NOT NULL,
	[status] [smallint] NOT NULL,
	[amount] [bigint] NOT NULL,
	[tip] [bigint] NULL,
	[ttid] [bigint] NULL,
	[tagged_fields] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_ord_payments_order] ON [dbo].[ord_payments]
(
	[order_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_ord_payments_ts] ON [dbo].[ord_payments]
(
	[timestamp_ms] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_ord_payments_ttid] ON [dbo].[ord_payments]
(
	[ttid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO