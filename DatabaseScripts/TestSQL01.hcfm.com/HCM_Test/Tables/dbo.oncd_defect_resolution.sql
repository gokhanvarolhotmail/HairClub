/* CreateDate: 06/01/2005 13:05:14.887 , ModifyDate: 10/23/2017 12:35:14.763 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_defect_resolution](
	[resolution_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[defect_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[resolution_note] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[resolution_date] [datetime] NULL,
	[version_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[resolution_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[status_updated_date] [datetime] NULL,
	[status_updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_defect_resolution] PRIMARY KEY CLUSTERED
(
	[resolution_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_defect_resolution_i2] ON [dbo].[oncd_defect_resolution]
(
	[defect_id] ASC,
	[primary_flag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_defect_resolution_i3] ON [dbo].[oncd_defect_resolution]
(
	[defect_id] ASC,
	[resolution_status_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_defect_resolution]  WITH CHECK ADD  CONSTRAINT [defect_defect_resol_223] FOREIGN KEY([defect_id])
REFERENCES [dbo].[oncd_defect] ([defect_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_defect_resolution] CHECK CONSTRAINT [defect_defect_resol_223]
GO
ALTER TABLE [dbo].[oncd_defect_resolution]  WITH CHECK ADD  CONSTRAINT [resolution_s_defect_resol_647] FOREIGN KEY([resolution_status_code])
REFERENCES [dbo].[onca_resolution_status] ([resolution_status_code])
GO
ALTER TABLE [dbo].[oncd_defect_resolution] CHECK CONSTRAINT [resolution_s_defect_resol_647]
GO
ALTER TABLE [dbo].[oncd_defect_resolution]  WITH CHECK ADD  CONSTRAINT [user_defect_resol_644] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_defect_resolution] CHECK CONSTRAINT [user_defect_resol_644]
GO
ALTER TABLE [dbo].[oncd_defect_resolution]  WITH CHECK ADD  CONSTRAINT [user_defect_resol_645] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_defect_resolution] CHECK CONSTRAINT [user_defect_resol_645]
GO
ALTER TABLE [dbo].[oncd_defect_resolution]  WITH CHECK ADD  CONSTRAINT [user_defect_resol_646] FOREIGN KEY([status_updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_defect_resolution] CHECK CONSTRAINT [user_defect_resol_646]
GO
