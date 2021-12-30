/* CreateDate: 06/01/2005 13:04:51.607 , ModifyDate: 06/21/2012 10:05:29.353 */
GO
CREATE TABLE [dbo].[oncd_incident_resolution](
	[incident_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_incident_resolution] PRIMARY KEY CLUSTERED
(
	[incident_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_incident_resolution]  WITH CHECK ADD  CONSTRAINT [incident_incident_res_148] FOREIGN KEY([incident_id])
REFERENCES [dbo].[oncd_incident] ([incident_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_incident_resolution] CHECK CONSTRAINT [incident_incident_res_148]
GO
