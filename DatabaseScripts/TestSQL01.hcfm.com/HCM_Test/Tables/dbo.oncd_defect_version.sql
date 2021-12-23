/* CreateDate: 01/18/2005 09:34:20.793 , ModifyDate: 06/21/2012 10:05:29.250 */
GO
CREATE TABLE [dbo].[oncd_defect_version](
	[defect_version_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[defect_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sort_order] [int] NULL,
	[version_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_defect_version] PRIMARY KEY CLUSTERED
(
	[defect_version_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_defect_version_i2] ON [dbo].[oncd_defect_version]
(
	[defect_id] ASC,
	[version_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_defect_version_i3] ON [dbo].[oncd_defect_version]
(
	[version_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_defect_version]  WITH NOCHECK ADD  CONSTRAINT [defect_defect_versi_339] FOREIGN KEY([defect_id])
REFERENCES [dbo].[oncd_defect] ([defect_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_defect_version] CHECK CONSTRAINT [defect_defect_versi_339]
GO
ALTER TABLE [dbo].[oncd_defect_version]  WITH NOCHECK ADD  CONSTRAINT [user_defect_versi_652] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_defect_version] CHECK CONSTRAINT [user_defect_versi_652]
GO
ALTER TABLE [dbo].[oncd_defect_version]  WITH NOCHECK ADD  CONSTRAINT [user_defect_versi_653] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_defect_version] CHECK CONSTRAINT [user_defect_versi_653]
GO
