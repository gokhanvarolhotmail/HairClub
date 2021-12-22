/* CreateDate: 04/13/2006 13:57:45.807 , ModifyDate: 06/21/2012 10:03:46.060 */
GO
CREATE TABLE [dbo].[oncw_page_role_module](
	[page_role_module_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[role_module_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[portal_page_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[container_id] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sort_order] [int] NULL,
 CONSTRAINT [PK_oncw_page_role_module] PRIMARY KEY CLUSTERED
(
	[page_role_module_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncw_page_role_module_i1] ON [dbo].[oncw_page_role_module]
(
	[role_module_id] ASC,
	[portal_page_id] ASC,
	[container_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncw_page_role_module_i2] ON [dbo].[oncw_page_role_module]
(
	[portal_page_id] ASC,
	[container_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncw_page_role_module]  WITH CHECK ADD  CONSTRAINT [portal_page_page_role_mo_414] FOREIGN KEY([portal_page_id])
REFERENCES [dbo].[oncw_portal_page] ([portal_page_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncw_page_role_module] CHECK CONSTRAINT [portal_page_page_role_mo_414]
GO
ALTER TABLE [dbo].[oncw_page_role_module]  WITH CHECK ADD  CONSTRAINT [role_module_page_role_mo_415] FOREIGN KEY([role_module_id])
REFERENCES [dbo].[oncw_role_module] ([role_module_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncw_page_role_module] CHECK CONSTRAINT [role_module_page_role_mo_415]
GO
