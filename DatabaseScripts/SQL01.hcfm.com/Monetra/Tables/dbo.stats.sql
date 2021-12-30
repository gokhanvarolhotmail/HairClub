/* CreateDate: 10/01/2018 08:53:16.750 , ModifyDate: 11/11/2021 09:25:22.817 */
GO
CREATE TABLE [dbo].[stats](
	[userid] [int] NOT NULL,
	[sdate] [int] NOT NULL,
	[num_auths] [bigint] NOT NULL,
	[amnt_auths] [bigint] NOT NULL,
	[num_returns] [bigint] NOT NULL,
	[amnt_returns] [bigint] NOT NULL,
	[chksum] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED
(
	[userid] ASC,
	[sdate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_stats_sdate] ON [dbo].[stats]
(
	[sdate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
