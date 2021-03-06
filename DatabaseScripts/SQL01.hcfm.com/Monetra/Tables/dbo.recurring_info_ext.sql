/* CreateDate: 09/30/2019 07:07:32.873 , ModifyDate: 09/30/2019 07:07:32.960 */
GO
CREATE TABLE [dbo].[recurring_info_ext](
	[token] [bigint] NOT NULL,
	[customer_id] [bigint] NOT NULL,
	[create_ts] [bigint] NOT NULL,
	[update_ts] [bigint] NOT NULL,
	[tagged_fields] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED
(
	[token] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_recurring_info_ext_cust] ON [dbo].[recurring_info_ext]
(
	[customer_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
