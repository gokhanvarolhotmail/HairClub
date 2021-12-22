/* CreateDate: 01/18/2005 09:34:08.593 , ModifyDate: 06/21/2012 10:10:48.380 */
GO
CREATE TABLE [dbo].[oncd_company_list](
	[company_list_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[list_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[list_subgroup_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[assignment_date] [datetime] NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_company_list] PRIMARY KEY CLUSTERED
(
	[company_list_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_list_i2] ON [dbo].[oncd_company_list]
(
	[company_id] ASC,
	[primary_flag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_list_i3] ON [dbo].[oncd_company_list]
(
	[list_code] ASC,
	[list_subgroup_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_list_i4] ON [dbo].[oncd_company_list]
(
	[list_subgroup_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_company_list]  WITH CHECK ADD  CONSTRAINT [company_company_list_85] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_company_list] CHECK CONSTRAINT [company_company_list_85]
GO
ALTER TABLE [dbo].[oncd_company_list]  WITH CHECK ADD  CONSTRAINT [list_company_list_530] FOREIGN KEY([list_code])
REFERENCES [dbo].[onca_list] ([list_code])
GO
ALTER TABLE [dbo].[oncd_company_list] CHECK CONSTRAINT [list_company_list_530]
GO
ALTER TABLE [dbo].[oncd_company_list]  WITH CHECK ADD  CONSTRAINT [list_subgrou_company_list_1165] FOREIGN KEY([list_subgroup_code])
REFERENCES [dbo].[onca_list_subgroup] ([list_subgroup_code])
GO
ALTER TABLE [dbo].[oncd_company_list] CHECK CONSTRAINT [list_subgrou_company_list_1165]
GO
ALTER TABLE [dbo].[oncd_company_list]  WITH CHECK ADD  CONSTRAINT [user_company_list_531] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_list] CHECK CONSTRAINT [user_company_list_531]
GO
ALTER TABLE [dbo].[oncd_company_list]  WITH CHECK ADD  CONSTRAINT [user_company_list_532] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_list] CHECK CONSTRAINT [user_company_list_532]
GO
