CREATE TABLE [dbo].[transdata_info](
	[userid] [int] NOT NULL,
	[ttid] [bigint] NOT NULL,
	[tagged_req] [varchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[tagged_resp] [varchar](2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED
(
	[userid] ASC,
	[ttid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
