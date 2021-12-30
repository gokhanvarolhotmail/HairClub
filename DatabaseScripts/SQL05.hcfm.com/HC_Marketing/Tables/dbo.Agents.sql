/* CreateDate: 09/01/2020 16:24:07.300 , ModifyDate: 09/01/2020 16:24:07.300 */
GO
CREATE TABLE [dbo].[Agents](
	[login_id] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[first_name] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[last_name] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[team_name] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[agent_country] [nvarchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[agent_city] [nvarchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[rank] [nvarchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[start_time] [datetime2](7) NOT NULL,
	[end_time] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Agents] PRIMARY KEY CLUSTERED
(
	[login_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
