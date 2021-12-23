/* CreateDate: 01/18/2005 09:34:18.840 , ModifyDate: 06/21/2012 10:00:47.593 */
GO
CREATE TABLE [dbo].[onca_system_state_process](
	[system_state_process_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[system_state_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[system_process_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_onca_system_state_process] PRIMARY KEY CLUSTERED
(
	[system_state_process_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_system_state_process]  WITH CHECK ADD  CONSTRAINT [system_proce_system_state_321] FOREIGN KEY([system_process_code])
REFERENCES [dbo].[onca_system_process] ([system_process_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_system_state_process] CHECK CONSTRAINT [system_proce_system_state_321]
GO
ALTER TABLE [dbo].[onca_system_state_process]  WITH CHECK ADD  CONSTRAINT [system_state_system_state_322] FOREIGN KEY([system_state_code])
REFERENCES [dbo].[onca_system_state] ([system_state_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_system_state_process] CHECK CONSTRAINT [system_state_system_state_322]
GO
