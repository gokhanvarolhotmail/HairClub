/* CreateDate: 01/18/2005 09:34:17.153 , ModifyDate: 06/18/2013 09:25:03.177 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onca_security_group_security](
	[security_group_security_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[security_group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[security_set_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_onca_security_group_security] PRIMARY KEY CLUSTERED
(
	[security_group_security_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_security_group_security]  WITH CHECK ADD  CONSTRAINT [security_gro_security_gro_250] FOREIGN KEY([security_group_id])
REFERENCES [dbo].[onca_security_group] ([security_group_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_security_group_security] CHECK CONSTRAINT [security_gro_security_gro_250]
GO
ALTER TABLE [dbo].[onca_security_group_security]  WITH NOCHECK ADD  CONSTRAINT [security_set_security_gro_251] FOREIGN KEY([security_set_id])
REFERENCES [dbo].[onca_security_set] ([security_set_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_security_group_security] CHECK CONSTRAINT [security_set_security_gro_251]
GO
