/* CreateDate: 04/26/2021 12:28:48.680 , ModifyDate: 04/26/2021 12:28:48.690 */
GO
CREATE TABLE [dbo].[prod_taxrates](
	[id] [bigint] NOT NULL,
	[user_id] [int] NOT NULL,
	[timestamp_ms] [bigint] NOT NULL,
	[is_deleted] [int] NOT NULL,
	[name] [varchar](64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[percentage] [bigint] NOT NULL,
	[roundmethod] [smallint] NOT NULL,
	[tagged_fields] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_prod_taxrates_del_ts] ON [dbo].[prod_taxrates]
(
	[is_deleted] ASC,
	[timestamp_ms] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [i_prod_taxrates_user_name_del] ON [dbo].[prod_taxrates]
(
	[user_id] ASC,
	[name] ASC,
	[is_deleted] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_prod_taxrates_user_ts] ON [dbo].[prod_taxrates]
(
	[user_id] ASC,
	[timestamp_ms] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
