/* CreateDate: 10/01/2018 08:53:16.730 , ModifyDate: 10/01/2018 08:53:16.730 */
GO
CREATE TABLE [dbo].[misc](
	[db_schema_ver] [varchar](32) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[timeleft] [bigint] NOT NULL,
	[lasttime] [bigint] NOT NULL,
	[product] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED
(
	[db_schema_ver] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
