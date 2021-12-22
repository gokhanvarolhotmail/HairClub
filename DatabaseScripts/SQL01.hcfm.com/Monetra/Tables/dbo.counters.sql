CREATE TABLE [dbo].[counters](
	[userid] [int] NOT NULL,
	[sub] [int] NOT NULL,
	[last_ttid] [bigint] NOT NULL,
	[seqnum] [int] NOT NULL,
	[batch] [int] NOT NULL,
	[itemsinbatch] [int] NOT NULL,
	[amountinbatch] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED
(
	[userid] ASC,
	[sub] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
