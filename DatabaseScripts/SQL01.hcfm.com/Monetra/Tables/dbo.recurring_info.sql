CREATE TABLE [dbo].[recurring_info](
	[token] [bigint] NOT NULL,
	[group_id] [bigint] NOT NULL,
	[origtransid] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[recamount] [int] NULL,
	[flags] [int] NULL,
PRIMARY KEY CLUSTERED
(
	[token] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
