/* CreateDate: 09/01/2020 15:56:33.657 , ModifyDate: 09/02/2020 11:48:07.387 */
GO
CREATE TABLE [dbo].[lkpBPAgents](
	[login_id] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[first_name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[team_name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[agent_country] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[agent_city] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[rank] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[start_time] [datetime] NULL,
	[end_time] [datetime] NULL
) ON [PRIMARY]
GO
