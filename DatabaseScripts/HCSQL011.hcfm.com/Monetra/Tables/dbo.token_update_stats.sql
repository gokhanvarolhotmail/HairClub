/* CreateDate: 09/30/2019 07:07:32.987 , ModifyDate: 09/30/2019 07:07:32.987 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[token_update_stats](
	[ts] [bigint] NOT NULL,
	[provider] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[accounts_added] [bigint] NULL,
	[accounts_removed] [bigint] NULL,
	[accounts_queried] [bigint] NULL,
	[accounts_updated] [bigint] NULL,
PRIMARY KEY CLUSTERED
(
	[ts] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
