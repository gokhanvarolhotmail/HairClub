/* CreateDate: 04/26/2021 12:28:48.840 , ModifyDate: 04/26/2021 12:28:48.870 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ord_items](
	[id] [bigint] NOT NULL,
	[order_id] [bigint] NOT NULL,
	[timestamp_ms] [bigint] NOT NULL,
	[is_deleted] [int] NOT NULL,
	[type] [smallint] NOT NULL,
	[status] [smallint] NULL,
	[ref_id] [bigint] NOT NULL,
	[ringorder] [smallint] NOT NULL,
	[qty] [bigint] NOT NULL,
	[amount] [bigint] NOT NULL,
	[total_modifiers] [bigint] NULL,
	[total_mod_disc] [bigint] NULL,
	[total_ord_disc] [bigint] NULL,
	[taxrate_1] [bigint] NULL,
	[taxrate_2] [bigint] NULL,
	[taxrate_3] [bigint] NULL,
	[taxrate_4] [bigint] NULL,
	[tagged_fields] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_ord_items_del_ts] ON [dbo].[ord_items]
(
	[is_deleted] ASC,
	[timestamp_ms] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_ord_items_order_ts] ON [dbo].[ord_items]
(
	[order_id] ASC,
	[timestamp_ms] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_ord_items_order_type_ref] ON [dbo].[ord_items]
(
	[order_id] ASC,
	[type] ASC,
	[ref_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
