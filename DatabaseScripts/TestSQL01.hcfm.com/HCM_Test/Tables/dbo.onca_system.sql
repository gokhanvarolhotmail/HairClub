/* CreateDate: 01/18/2005 09:34:07.937 , ModifyDate: 06/21/2012 10:00:47.580 */
GO
CREATE TABLE [dbo].[onca_system](
	[system_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[server_id] [int] NULL,
	[number_of_servers] [int] NULL,
	[password_expires] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[password_days] [int] NULL,
	[password_length] [int] NULL,
	[password_min_length] [int] NULL,
	[login_attempts] [int] NULL,
	[login_lockout] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[product_key] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[system_state_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[database_version] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[is_sync_filtered] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_system] PRIMARY KEY CLUSTERED
(
	[system_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_system] ADD  CONSTRAINT [DF__onca_syst__is_sy__1F98B2C1]  DEFAULT ('N') FOR [is_sync_filtered]
GO
ALTER TABLE [dbo].[onca_system]  WITH CHECK ADD  CONSTRAINT [system_state_system_320] FOREIGN KEY([system_state_code])
REFERENCES [dbo].[onca_system_state] ([system_state_code])
GO
ALTER TABLE [dbo].[onca_system] CHECK CONSTRAINT [system_state_system_320]
GO
