CREATE TABLE [dbo].[emv_capks](
	[user_id] [int] NOT NULL,
	[rid] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[key_index] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[modulus] [varchar](2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[exponent] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[checksum] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED
(
	[user_id] ASC,
	[rid] ASC,
	[key_index] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_emv_capks_user] ON [dbo].[emv_capks]
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
