/* CreateDate: 01/18/2005 09:34:20.373 , ModifyDate: 06/21/2012 10:01:00.567 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onca_group_security_filter](
	[group_security_filter_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[security_filter_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_onca_group_security_filter] PRIMARY KEY CLUSTERED
(
	[group_security_filter_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_group_security_filter]  WITH CHECK ADD  CONSTRAINT [group_group_securi_323] FOREIGN KEY([group_id])
REFERENCES [dbo].[onca_group] ([group_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_group_security_filter] CHECK CONSTRAINT [group_group_securi_323]
GO
ALTER TABLE [dbo].[onca_group_security_filter]  WITH CHECK ADD  CONSTRAINT [security_fil_group_securi_324] FOREIGN KEY([security_filter_id])
REFERENCES [dbo].[onca_security_filter] ([security_filter_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_group_security_filter] CHECK CONSTRAINT [security_fil_group_securi_324]
GO
