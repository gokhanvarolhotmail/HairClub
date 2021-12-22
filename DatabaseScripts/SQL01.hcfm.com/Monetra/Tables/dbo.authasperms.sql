CREATE TABLE [dbo].[authasperms](
	[subuserid] [bigint] NOT NULL,
	[trantypes] [bigint] NOT NULL,
	[admintypes] [bigint] NOT NULL,
PRIMARY KEY CLUSTERED
(
	[subuserid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
