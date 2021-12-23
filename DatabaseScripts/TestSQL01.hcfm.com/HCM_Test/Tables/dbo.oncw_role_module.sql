/* CreateDate: 01/25/2010 11:09:44.263 , ModifyDate: 06/21/2012 10:03:46.110 */
GO
CREATE TABLE [dbo].[oncw_role_module](
	[role_module_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[module_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[role_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_oncw_role_module] PRIMARY KEY CLUSTERED
(
	[role_module_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncw_role_module_i1] ON [dbo].[oncw_role_module]
(
	[module_id] ASC,
	[role_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncw_role_module_i2] ON [dbo].[oncw_role_module]
(
	[role_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncw_role_module]  WITH CHECK ADD  CONSTRAINT [module_role_module_412] FOREIGN KEY([module_id])
REFERENCES [dbo].[oncw_module] ([module_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncw_role_module] CHECK CONSTRAINT [module_role_module_412]
GO
ALTER TABLE [dbo].[oncw_role_module]  WITH CHECK ADD  CONSTRAINT [role_role_module_1163] FOREIGN KEY([role_id])
REFERENCES [dbo].[oncw_role] ([role_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncw_role_module] CHECK CONSTRAINT [role_role_module_1163]
GO
