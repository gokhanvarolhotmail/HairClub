/* CreateDate: 10/01/2018 08:53:16.847 , ModifyDate: 10/01/2018 08:53:16.850 */
GO
CREATE TABLE [dbo].[l3items](
	[userid] [int] NOT NULL,
	[ttid] [bigint] NOT NULL,
	[l3id] [bigint] NOT NULL,
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
	[l3id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_l3items_user_ttid] ON [dbo].[l3items]
(
	[userid] ASC,
	[ttid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
