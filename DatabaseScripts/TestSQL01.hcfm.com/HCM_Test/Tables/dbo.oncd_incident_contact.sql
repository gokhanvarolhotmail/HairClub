/* CreateDate: 01/18/2005 09:34:09.407 , ModifyDate: 06/21/2012 10:05:29.357 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_incident_contact](
	[incident_contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[incident_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[incident_role_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[assignment_date] [datetime] NULL,
 CONSTRAINT [pk_oncd_incident_contact] PRIMARY KEY CLUSTERED
(
	[incident_contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_incident_contact_i2] ON [dbo].[oncd_incident_contact]
(
	[incident_id] ASC,
	[primary_flag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_incident_contact_i3] ON [dbo].[oncd_incident_contact]
(
	[contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_incident_contact]  WITH CHECK ADD  CONSTRAINT [contact_incident_con_144] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_incident_contact] CHECK CONSTRAINT [contact_incident_con_144]
GO
ALTER TABLE [dbo].[oncd_incident_contact]  WITH CHECK ADD  CONSTRAINT [incident_incident_con_143] FOREIGN KEY([incident_id])
REFERENCES [dbo].[oncd_incident] ([incident_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_incident_contact] CHECK CONSTRAINT [incident_incident_con_143]
GO
ALTER TABLE [dbo].[oncd_incident_contact]  WITH CHECK ADD  CONSTRAINT [incident_rol_incident_con_666] FOREIGN KEY([incident_role_code])
REFERENCES [dbo].[onca_incident_role] ([incident_role_code])
GO
ALTER TABLE [dbo].[oncd_incident_contact] CHECK CONSTRAINT [incident_rol_incident_con_666]
GO
ALTER TABLE [dbo].[oncd_incident_contact]  WITH CHECK ADD  CONSTRAINT [user_incident_con_664] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_incident_contact] CHECK CONSTRAINT [user_incident_con_664]
GO
ALTER TABLE [dbo].[oncd_incident_contact]  WITH CHECK ADD  CONSTRAINT [user_incident_con_665] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_incident_contact] CHECK CONSTRAINT [user_incident_con_665]
GO
