/* CreateDate: 10/01/2018 08:53:16.827 , ModifyDate: 10/01/2018 08:53:16.830 */
GO
CREATE TABLE [dbo].[cardshield_keys_info](
	[key_id] [bigint] NOT NULL,
	[flags] [int] NOT NULL,
	[userid] [int] NULL,
	[last_ts] [bigint] NULL,
PRIMARY KEY CLUSTERED
(
	[key_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_cardshield_keys_info_lastts_flags] ON [dbo].[cardshield_keys_info]
(
	[last_ts] ASC,
	[flags] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
