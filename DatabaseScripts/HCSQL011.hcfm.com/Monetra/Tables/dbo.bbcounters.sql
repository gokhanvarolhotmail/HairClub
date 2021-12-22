/* CreateDate: 10/01/2018 08:53:16.873 , ModifyDate: 10/01/2018 08:53:16.883 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bbcounters](
	[bbacctid] [int] NOT NULL,
	[bbbatchid] [int] NOT NULL,
	[status] [int] NOT NULL,
	[ts] [bigint] NOT NULL,
	[details_no_l3] [int] NOT NULL,
	[details_with_l3] [int] NOT NULL,
	[l3num] [int] NOT NULL,
	[num_merchants] [int] NOT NULL,
	[amnt_auths] [bigint] NOT NULL,
	[amnt_returns] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED
(
	[bbbatchid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_bbcounters_acct_status] ON [dbo].[bbcounters]
(
	[bbacctid] ASC,
	[status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_bbcounters_status] ON [dbo].[bbcounters]
(
	[status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
