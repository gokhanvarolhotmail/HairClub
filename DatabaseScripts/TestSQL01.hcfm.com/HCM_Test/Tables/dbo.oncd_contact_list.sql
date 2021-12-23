/* CreateDate: 01/18/2005 09:34:08.920 , ModifyDate: 06/21/2012 10:08:09.697 */
GO
CREATE TABLE [dbo].[oncd_contact_list](
	[contact_list_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[list_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[list_subgroup_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[assignment_date] [datetime] NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[publish] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_contact_list] PRIMARY KEY CLUSTERED
(
	[contact_list_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_list_i2] ON [dbo].[oncd_contact_list]
(
	[contact_id] ASC,
	[primary_flag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_list_i3] ON [dbo].[oncd_contact_list]
(
	[list_code] ASC,
	[list_subgroup_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_list_i4] ON [dbo].[oncd_contact_list]
(
	[list_subgroup_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_contact_list]  WITH CHECK ADD  CONSTRAINT [contact_contact_list_77] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_contact_list] CHECK CONSTRAINT [contact_contact_list_77]
GO
ALTER TABLE [dbo].[oncd_contact_list]  WITH CHECK ADD  CONSTRAINT [list_contact_list_599] FOREIGN KEY([list_code])
REFERENCES [dbo].[onca_list] ([list_code])
GO
ALTER TABLE [dbo].[oncd_contact_list] CHECK CONSTRAINT [list_contact_list_599]
GO
ALTER TABLE [dbo].[oncd_contact_list]  WITH CHECK ADD  CONSTRAINT [list_subgrou_contact_list_1092] FOREIGN KEY([list_subgroup_code])
REFERENCES [dbo].[onca_list_subgroup] ([list_subgroup_code])
GO
ALTER TABLE [dbo].[oncd_contact_list] CHECK CONSTRAINT [list_subgrou_contact_list_1092]
GO
ALTER TABLE [dbo].[oncd_contact_list]  WITH CHECK ADD  CONSTRAINT [user_contact_list_597] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_list] CHECK CONSTRAINT [user_contact_list_597]
GO
ALTER TABLE [dbo].[oncd_contact_list]  WITH CHECK ADD  CONSTRAINT [user_contact_list_598] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_list] CHECK CONSTRAINT [user_contact_list_598]
GO
