/* CreateDate: 11/08/2012 13:39:51.490 , ModifyDate: 07/11/2017 10:53:44.377 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_contact_company](
	[contact_company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_role_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[reports_to_contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[title] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[department_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[internal_title_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_preferred_center_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_contact_company] PRIMARY KEY CLUSTERED
(
	[contact_company_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_company_i2] ON [dbo].[oncd_contact_company]
(
	[contact_id] ASC,
	[primary_flag] ASC
)
INCLUDE([company_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_company_test1] ON [dbo].[oncd_contact_company]
(
	[primary_flag] ASC
)
INCLUDE([contact_company_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_contact_company]  WITH CHECK ADD  CONSTRAINT [company_contact_comp_97] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_contact_company] CHECK CONSTRAINT [company_contact_comp_97]
GO
ALTER TABLE [dbo].[oncd_contact_company]  WITH CHECK ADD  CONSTRAINT [company_role_contact_comp_587] FOREIGN KEY([company_role_code])
REFERENCES [dbo].[onca_company_role] ([company_role_code])
GO
ALTER TABLE [dbo].[oncd_contact_company] CHECK CONSTRAINT [company_role_contact_comp_587]
GO
ALTER TABLE [dbo].[oncd_contact_company]  WITH CHECK ADD  CONSTRAINT [contact_contact_comp_331] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_contact_company] CHECK CONSTRAINT [contact_contact_comp_331]
GO
ALTER TABLE [dbo].[oncd_contact_company]  WITH CHECK ADD  CONSTRAINT [contact_contact_comp_96] FOREIGN KEY([reports_to_contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
GO
ALTER TABLE [dbo].[oncd_contact_company] CHECK CONSTRAINT [contact_contact_comp_96]
GO
ALTER TABLE [dbo].[oncd_contact_company]  WITH CHECK ADD  CONSTRAINT [department_contact_comp_588] FOREIGN KEY([department_code])
REFERENCES [dbo].[onca_department] ([department_code])
GO
ALTER TABLE [dbo].[oncd_contact_company] CHECK CONSTRAINT [department_contact_comp_588]
GO
ALTER TABLE [dbo].[oncd_contact_company]  WITH CHECK ADD  CONSTRAINT [internal_tit_contact_comp_589] FOREIGN KEY([internal_title_code])
REFERENCES [dbo].[onca_internal_title] ([internal_title_code])
GO
ALTER TABLE [dbo].[oncd_contact_company] CHECK CONSTRAINT [internal_tit_contact_comp_589]
GO
ALTER TABLE [dbo].[oncd_contact_company]  WITH CHECK ADD  CONSTRAINT [user_contact_comp_585] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_company] CHECK CONSTRAINT [user_contact_comp_585]
GO
ALTER TABLE [dbo].[oncd_contact_company]  WITH CHECK ADD  CONSTRAINT [user_contact_comp_586] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_company] CHECK CONSTRAINT [user_contact_comp_586]
GO
