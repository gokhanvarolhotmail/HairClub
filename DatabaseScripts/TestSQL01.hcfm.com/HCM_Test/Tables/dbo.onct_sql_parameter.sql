/* CreateDate: 01/18/2005 09:34:09.797 , ModifyDate: 06/21/2012 10:03:58.433 */
GO
CREATE TABLE [dbo].[onct_sql_parameter](
	[parameter_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sql_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[parameter_value] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
 CONSTRAINT [pk_onct_sql_parameter] PRIMARY KEY CLUSTERED
(
	[parameter_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_sql_parameter_i2] ON [dbo].[onct_sql_parameter]
(
	[sql_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onct_sql_parameter]  WITH NOCHECK ADD  CONSTRAINT [sql_sql_paramete_134] FOREIGN KEY([sql_id])
REFERENCES [dbo].[onct_sql] ([sql_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onct_sql_parameter] CHECK CONSTRAINT [sql_sql_paramete_134]
GO
