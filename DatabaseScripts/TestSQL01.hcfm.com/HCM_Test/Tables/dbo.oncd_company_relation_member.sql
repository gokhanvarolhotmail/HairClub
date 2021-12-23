/* CreateDate: 01/18/2005 09:34:08.687 , ModifyDate: 06/21/2012 10:10:43.647 */
GO
CREATE TABLE [dbo].[oncd_company_relation_member](
	[company_relation_member_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_relation_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_member_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[assignment_date] [datetime] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_company_relation_member] PRIMARY KEY CLUSTERED
(
	[company_relation_member_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_relation_memb_i01] ON [dbo].[oncd_company_relation_member]
(
	[company_id] ASC,
	[company_relation_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_relation_memb_i03] ON [dbo].[oncd_company_relation_member]
(
	[company_relation_id] ASC,
	[company_member_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_relation_memb_i04] ON [dbo].[oncd_company_relation_member]
(
	[company_member_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_company_relation_member]  WITH CHECK ADD  CONSTRAINT [company_company_rela_114] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_company_relation_member] CHECK CONSTRAINT [company_company_rela_114]
GO
ALTER TABLE [dbo].[oncd_company_relation_member]  WITH CHECK ADD  CONSTRAINT [company_memb_company_rela_547] FOREIGN KEY([company_member_code])
REFERENCES [dbo].[onca_company_member] ([company_member_code])
GO
ALTER TABLE [dbo].[oncd_company_relation_member] CHECK CONSTRAINT [company_memb_company_rela_547]
GO
ALTER TABLE [dbo].[oncd_company_relation_member]  WITH CHECK ADD  CONSTRAINT [company_rela_company_rela_115] FOREIGN KEY([company_relation_id])
REFERENCES [dbo].[oncd_company_relation] ([company_relation_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_company_relation_member] CHECK CONSTRAINT [company_rela_company_rela_115]
GO
ALTER TABLE [dbo].[oncd_company_relation_member]  WITH CHECK ADD  CONSTRAINT [user_company_rela_548] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_relation_member] CHECK CONSTRAINT [user_company_rela_548]
GO
ALTER TABLE [dbo].[oncd_company_relation_member]  WITH CHECK ADD  CONSTRAINT [user_company_rela_549] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_relation_member] CHECK CONSTRAINT [user_company_rela_549]
GO
