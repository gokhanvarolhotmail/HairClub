CREATE TABLE [dbo].[transdata](
	[userid] [int] NOT NULL,
	[ttid] [bigint] NOT NULL,
	[subuserid] [bigint] NOT NULL,
	[txnstatus] [int] NOT NULL,
	[auth_proc] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[m_type] [bigint] NOT NULL,
	[cardtype] [int] NOT NULL,
	[ts] [bigint] NOT NULL,
	[last_modified_ts] [bigint] NOT NULL,
	[settlets] [bigint] NOT NULL,
	[abaroute] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[account] [varchar](2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last4] [int] NOT NULL,
	[expdate] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[checknum] [int] NOT NULL,
	[micr] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[accounttype] [int] NOT NULL,
	[amount] [bigint] NOT NULL,
	[clerkid] [varchar](2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[stationid] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[comments] [varchar](2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ptrannum] [bigint] NOT NULL,
	[examount] [int] NOT NULL,
	[tranflags] [bigint] NOT NULL,
	[origauthamount] [bigint] NOT NULL,
	[authamount] [bigint] NOT NULL,
	[reqamount] [bigint] NOT NULL,
	[bdate] [bigint] NOT NULL,
	[edate] [bigint] NOT NULL,
	[rate] [int] NOT NULL,
	[roomnum] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[excharge] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[currency] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[language] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[descmerch] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[descloc] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[tax] [int] NOT NULL,
	[pclevel] [int] NOT NULL,
	[startdate] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[issuenum] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cardholdername] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[verbiage] [varchar](2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[code] [int] NOT NULL,
	[msoft_code] [int] NOT NULL,
	[phard_code] [int] NOT NULL,
	[reasoncode] [int] NOT NULL,
	[cashback] [int] NOT NULL,
	[divisionnum] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[promoid] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cavv] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[zip] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[shipzip] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[installment_num] [int] NOT NULL,
	[installment_total] [int] NOT NULL,
	[ordernum] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[custref] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[voucherserial] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[discountamount] [bigint] NOT NULL,
	[freightamount] [bigint] NOT NULL,
	[dutyamount] [bigint] NOT NULL,
	[shipcountry] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[l3num] [int] NOT NULL,
	[actcode] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[apcode] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[authsource] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[avsresp] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[batnum] [int] NOT NULL,
	[cardlevel] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cavvresp] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[commind] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cvresp] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[icc] [varchar](2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[issuerrespcode] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[itemnum] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[netident] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[posdata] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[proccode] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[raci] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[rrefnum] [varchar](2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[settledate] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[stan] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sqi] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[trandate] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[transid] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[trantime] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[valcode] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED
(
	[userid] ASC,
	[ttid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_transdata_txnstatus] ON [dbo].[transdata]
(
	[txnstatus] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_transdata_user_batch] ON [dbo].[transdata]
(
	[userid] ASC,
	[batnum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_transdata_user_card] ON [dbo].[transdata]
(
	[userid] ASC,
	[cardtype] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_transdata_user_last4] ON [dbo].[transdata]
(
	[userid] ASC,
	[last4] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_transdata_user_ptran] ON [dbo].[transdata]
(
	[userid] ASC,
	[ptrannum] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_transdata_user_settlets] ON [dbo].[transdata]
(
	[userid] ASC,
	[settlets] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_transdata_user_status_type] ON [dbo].[transdata]
(
	[userid] ASC,
	[txnstatus] ASC,
	[m_type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_transdata_user_sub] ON [dbo].[transdata]
(
	[userid] ASC,
	[subuserid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_transdata_user_ts] ON [dbo].[transdata]
(
	[userid] ASC,
	[ts] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_transdata_user_type] ON [dbo].[transdata]
(
	[userid] ASC,
	[m_type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
