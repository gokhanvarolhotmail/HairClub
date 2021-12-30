/* CreateDate: 01/25/2010 11:09:41.690 , ModifyDate: 06/21/2012 10:03:46.003 */
GO
CREATE TABLE [dbo].[oncw_control_visibility](
	[control_visibility_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[portal_page_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[control_id] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[visibility] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[role_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_oncw_control_visibility] PRIMARY KEY CLUSTERED
(
	[control_visibility_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncw_control_visibility_i1] ON [dbo].[oncw_control_visibility]
(
	[portal_page_id] ASC,
	[control_id] ASC,
	[role_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncw_control_visibility_i2] ON [dbo].[oncw_control_visibility]
(
	[role_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncw_control_visibility]  WITH CHECK ADD  CONSTRAINT [portal_page_control_visi_413] FOREIGN KEY([portal_page_id])
REFERENCES [dbo].[oncw_portal_page] ([portal_page_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncw_control_visibility] CHECK CONSTRAINT [portal_page_control_visi_413]
GO
ALTER TABLE [dbo].[oncw_control_visibility]  WITH CHECK ADD  CONSTRAINT [role_control_visi_1162] FOREIGN KEY([role_id])
REFERENCES [dbo].[oncw_role] ([role_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncw_control_visibility] CHECK CONSTRAINT [role_control_visi_1162]
GO
