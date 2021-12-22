/* CreateDate: 04/26/2021 12:28:48.900 , ModifyDate: 04/26/2021 12:28:48.970 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ord_taxtracking](
	[user_id] [bigint] NOT NULL,
	[timestamp_ms] [bigint] NOT NULL,
	[taxrate_id] [bigint] NOT NULL,
	[order_id] [bigint] NOT NULL,
	[amount] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED
(
	[user_id] ASC,
	[timestamp_ms] ASC,
	[taxrate_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_ord_taxtracking_order] ON [dbo].[ord_taxtracking]
(
	[order_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
