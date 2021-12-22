/* CreateDate: 06/01/2005 13:04:45.387 , ModifyDate: 10/23/2017 12:35:14.720 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_incident_description](
	[incident_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_incident_description] PRIMARY KEY CLUSTERED
(
	[incident_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_incident_description]  WITH CHECK ADD  CONSTRAINT [incident_incident_des_147] FOREIGN KEY([incident_id])
REFERENCES [dbo].[oncd_incident] ([incident_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_incident_description] CHECK CONSTRAINT [incident_incident_des_147]
GO
