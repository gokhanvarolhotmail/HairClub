/* CreateDate: 01/18/2005 09:34:09.780 , ModifyDate: 06/21/2012 10:03:58.420 */
GO
CREATE TABLE [dbo].[onct_sql](
	[sql_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[stop_on_error] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[quiet_mode] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[chain_mode] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sql_statement] [nvarchar](3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[security_table_name] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onct_sql] PRIMARY KEY CLUSTERED
(
	[sql_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
