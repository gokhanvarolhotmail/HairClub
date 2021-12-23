/* CreateDate: 01/18/2005 09:34:08.640 , ModifyDate: 06/21/2012 10:10:43.637 */
GO
CREATE TABLE [dbo].[oncd_company_relation](
	[company_relation_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_relation_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_company_relation] PRIMARY KEY CLUSTERED
(
	[company_relation_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_relation_i2] ON [dbo].[oncd_company_relation]
(
	[company_relation_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_company_relation]  WITH NOCHECK ADD  CONSTRAINT [company_rela_company_rela_544] FOREIGN KEY([company_relation_code])
REFERENCES [dbo].[onca_company_relation] ([company_relation_code])
GO
ALTER TABLE [dbo].[oncd_company_relation] CHECK CONSTRAINT [company_rela_company_rela_544]
GO
ALTER TABLE [dbo].[oncd_company_relation]  WITH NOCHECK ADD  CONSTRAINT [user_company_rela_545] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_relation] CHECK CONSTRAINT [user_company_rela_545]
GO
ALTER TABLE [dbo].[oncd_company_relation]  WITH NOCHECK ADD  CONSTRAINT [user_company_rela_546] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_relation] CHECK CONSTRAINT [user_company_rela_546]
GO
