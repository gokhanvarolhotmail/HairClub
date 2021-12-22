CREATE TABLE [dbo].[bbl3items](
	[bbbatchid] [int] NOT NULL,
	[bbmerchid] [int] NOT NULL,
	[merchbatch] [int] NOT NULL,
	[merchseq] [int] NOT NULL,
	[l3seq] [int] NOT NULL,
	[commoditycode] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[productcode] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[qty] [bigint] NOT NULL,
	[unit] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[unitprice] [bigint] NOT NULL,
	[discountamount] [bigint] NOT NULL,
	[discountrate] [bigint] NOT NULL,
	[amount] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED
(
	[bbbatchid] ASC,
	[bbmerchid] ASC,
	[merchbatch] ASC,
	[merchseq] ASC,
	[l3seq] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_bbl3items_id_batch] ON [dbo].[bbl3items]
(
	[bbmerchid] ASC,
	[merchbatch] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
