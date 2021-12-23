/* CreateDate: 06/18/2013 09:24:41.257 , ModifyDate: 07/21/2014 01:16:20.027 */
GO
CREATE TABLE [dbo].[cstd_corporate_callback_lead](
	[corporate_callback_lead_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[lead_date] [datetime] NULL,
	[lead_time] [datetime] NULL,
	[first_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone_number] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[current_client_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[corporate_callback_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[activity_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_cstd_corporate_callback_lead] PRIMARY KEY CLUSTERED
(
	[corporate_callback_lead_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_corporate_callback_lead]  WITH NOCHECK ADD  CONSTRAINT [FK_cstd_corporate_callback_lead_created_by_user] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_corporate_callback_lead] CHECK CONSTRAINT [FK_cstd_corporate_callback_lead_created_by_user]
GO
ALTER TABLE [dbo].[cstd_corporate_callback_lead]  WITH NOCHECK ADD  CONSTRAINT [FK_cstd_corporate_callback_lead_csta_activity_type] FOREIGN KEY([activity_type_code])
REFERENCES [dbo].[csta_activity_type] ([activity_type_code])
GO
ALTER TABLE [dbo].[cstd_corporate_callback_lead] CHECK CONSTRAINT [FK_cstd_corporate_callback_lead_csta_activity_type]
GO
ALTER TABLE [dbo].[cstd_corporate_callback_lead]  WITH NOCHECK ADD  CONSTRAINT [FK_cstd_corporate_callback_lead_csta_corporate_callback_type] FOREIGN KEY([corporate_callback_type_code])
REFERENCES [dbo].[csta_corporate_callback_type] ([corporate_callback_type_code])
GO
ALTER TABLE [dbo].[cstd_corporate_callback_lead] CHECK CONSTRAINT [FK_cstd_corporate_callback_lead_csta_corporate_callback_type]
GO
ALTER TABLE [dbo].[cstd_corporate_callback_lead]  WITH NOCHECK ADD  CONSTRAINT [FK_cstd_corporate_callback_lead_onca_user] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_corporate_callback_lead] CHECK CONSTRAINT [FK_cstd_corporate_callback_lead_onca_user]
GO
ALTER TABLE [dbo].[cstd_corporate_callback_lead]  WITH NOCHECK ADD  CONSTRAINT [FK_cstd_corporate_callback_lead_updated_by_user] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_corporate_callback_lead] CHECK CONSTRAINT [FK_cstd_corporate_callback_lead_updated_by_user]
GO
