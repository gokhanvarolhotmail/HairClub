/* CreateDate: 06/01/2005 17:18:03.623 , ModifyDate: 06/21/2012 10:00:52.203 */
GO
CREATE TABLE [dbo].[onca_outlook_query](
	[outlook_query_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[display_text] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sql_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_outlook_query] PRIMARY KEY CLUSTERED
(
	[outlook_query_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_outlook_query]  WITH CHECK ADD  CONSTRAINT [sql_outlook_quer_1182] FOREIGN KEY([sql_id])
REFERENCES [dbo].[onct_sql] ([sql_id])
GO
ALTER TABLE [dbo].[onca_outlook_query] CHECK CONSTRAINT [sql_outlook_quer_1182]
GO
