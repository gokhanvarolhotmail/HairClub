CREATE TABLE [dbo].[cardshield_keys](
	[key_id] [bigint] NOT NULL,
	[enc_type] [int] NOT NULL,
	[last_device_id] [int] NOT NULL,
	[provision_allowed] [tinyint] NOT NULL,
	[ts] [bigint] NOT NULL,
	[descr] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[enckey] [varbinary](max) NULL,
PRIMARY KEY CLUSTERED
(
	[key_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_cardshield_keys_enc_ts] ON [dbo].[cardshield_keys]
(
	[enc_type] ASC,
	[ts] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
