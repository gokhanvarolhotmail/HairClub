/* CreateDate: 01/18/2005 09:34:16.967 , ModifyDate: 06/21/2012 10:01:00.553 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onca_group_security](
	[group_security_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[security_group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_onca_group_security] PRIMARY KEY CLUSTERED
(
	[group_security_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_group_security]  WITH CHECK ADD  CONSTRAINT [group_group_securi_248] FOREIGN KEY([group_id])
REFERENCES [dbo].[onca_group] ([group_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_group_security] CHECK CONSTRAINT [group_group_securi_248]
GO
ALTER TABLE [dbo].[onca_group_security]  WITH CHECK ADD  CONSTRAINT [security_gro_group_securi_249] FOREIGN KEY([security_group_id])
REFERENCES [dbo].[onca_security_group] ([security_group_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_group_security] CHECK CONSTRAINT [security_gro_group_securi_249]
GO
