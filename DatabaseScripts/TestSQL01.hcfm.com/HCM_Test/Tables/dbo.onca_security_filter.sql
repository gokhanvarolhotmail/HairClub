/* CreateDate: 01/18/2005 09:34:20.403 , ModifyDate: 06/21/2012 10:00:47.243 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onca_security_filter](
	[security_filter_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[table_name] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sql_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_security_filter] PRIMARY KEY CLUSTERED
(
	[security_filter_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_security_filter]  WITH CHECK ADD  CONSTRAINT [sql_security_fil_1184] FOREIGN KEY([sql_id])
REFERENCES [dbo].[onct_sql] ([sql_id])
GO
ALTER TABLE [dbo].[onca_security_filter] CHECK CONSTRAINT [sql_security_fil_1184]
GO
