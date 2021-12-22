CREATE TABLE [dbo].[restrictions](
	[rest_num] [bigint] NOT NULL,
	[rest_user] [int] NOT NULL,
	[rest_type] [int] NOT NULL,
	[rest_data] [varchar](2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[rest_data_len] [int] NOT NULL,
PRIMARY KEY CLUSTERED
(
	[rest_num] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [i_restrictions_user] ON [dbo].[restrictions]
(
	[rest_user] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
