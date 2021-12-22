/* CreateDate: 02/04/2005 08:28:19.577 , ModifyDate: 06/21/2012 10:05:29.217 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_defect](
	[defect_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[product_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[defect_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[part_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[defect_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[priority] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[assigned_to_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[open_date] [datetime] NULL,
	[completion_date] [datetime] NULL,
	[completed_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[status_updated_date] [datetime] NULL,
	[status_updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[version_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[defect_number] [int] NULL,
 CONSTRAINT [pk_oncd_defect] PRIMARY KEY CLUSTERED
(
	[defect_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_defect_i2] ON [dbo].[oncd_defect]
(
	[product_code] ASC,
	[part_code] ASC,
	[version_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_defect_i3] ON [dbo].[oncd_defect]
(
	[product_code] ASC,
	[version_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_defect_i4] ON [dbo].[oncd_defect]
(
	[part_code] ASC,
	[version_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_defect_i5] ON [dbo].[oncd_defect]
(
	[assigned_to_user_code] ASC,
	[defect_status_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_defect]  WITH CHECK ADD  CONSTRAINT [defect_statu_defect_640] FOREIGN KEY([defect_status_code])
REFERENCES [dbo].[onca_defect_status] ([defect_status_code])
GO
ALTER TABLE [dbo].[oncd_defect] CHECK CONSTRAINT [defect_statu_defect_640]
GO
ALTER TABLE [dbo].[oncd_defect]  WITH CHECK ADD  CONSTRAINT [defect_type_defect_641] FOREIGN KEY([defect_type_code])
REFERENCES [dbo].[onca_defect_type] ([defect_type_code])
GO
ALTER TABLE [dbo].[oncd_defect] CHECK CONSTRAINT [defect_type_defect_641]
GO
ALTER TABLE [dbo].[oncd_defect]  WITH CHECK ADD  CONSTRAINT [product_defect_639] FOREIGN KEY([product_code])
REFERENCES [dbo].[onca_product] ([product_code])
GO
ALTER TABLE [dbo].[oncd_defect] CHECK CONSTRAINT [product_defect_639]
GO
ALTER TABLE [dbo].[oncd_defect]  WITH CHECK ADD  CONSTRAINT [product_part_defect_1090] FOREIGN KEY([part_code])
REFERENCES [dbo].[onca_product_part] ([part_code])
GO
ALTER TABLE [dbo].[oncd_defect] CHECK CONSTRAINT [product_part_defect_1090]
GO
ALTER TABLE [dbo].[oncd_defect]  WITH CHECK ADD  CONSTRAINT [product_vers_defect_1091] FOREIGN KEY([version_code])
REFERENCES [dbo].[onca_product_version] ([version_code])
GO
ALTER TABLE [dbo].[oncd_defect] CHECK CONSTRAINT [product_vers_defect_1091]
GO
ALTER TABLE [dbo].[oncd_defect]  WITH CHECK ADD  CONSTRAINT [user_defect_634] FOREIGN KEY([assigned_to_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_defect] CHECK CONSTRAINT [user_defect_634]
GO
ALTER TABLE [dbo].[oncd_defect]  WITH CHECK ADD  CONSTRAINT [user_defect_635] FOREIGN KEY([status_updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_defect] CHECK CONSTRAINT [user_defect_635]
GO
ALTER TABLE [dbo].[oncd_defect]  WITH CHECK ADD  CONSTRAINT [user_defect_636] FOREIGN KEY([completed_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_defect] CHECK CONSTRAINT [user_defect_636]
GO
ALTER TABLE [dbo].[oncd_defect]  WITH CHECK ADD  CONSTRAINT [user_defect_637] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_defect] CHECK CONSTRAINT [user_defect_637]
GO
ALTER TABLE [dbo].[oncd_defect]  WITH CHECK ADD  CONSTRAINT [user_defect_638] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_defect] CHECK CONSTRAINT [user_defect_638]
GO
