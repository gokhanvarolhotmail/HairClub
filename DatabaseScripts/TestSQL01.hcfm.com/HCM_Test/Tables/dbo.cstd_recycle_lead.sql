/* CreateDate: 06/18/2013 09:24:41.300 , ModifyDate: 08/11/2014 01:01:12.080 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cstd_recycle_lead](
	[recycle_lead_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[lead_date] [datetime] NULL,
	[lead_time] [datetime] NULL,
	[first_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone_number] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[source_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[zip_code] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_cstd_recycle_lead] PRIMARY KEY CLUSTERED
(
	[recycle_lead_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_recycle_lead]  WITH CHECK ADD  CONSTRAINT [FK_cstd_recycle_lead_created_by_user] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_recycle_lead] CHECK CONSTRAINT [FK_cstd_recycle_lead_created_by_user]
GO
ALTER TABLE [dbo].[cstd_recycle_lead]  WITH CHECK ADD  CONSTRAINT [FK_cstd_recycle_lead_cstd_recycle_lead] FOREIGN KEY([recycle_lead_id])
REFERENCES [dbo].[cstd_recycle_lead] ([recycle_lead_id])
GO
ALTER TABLE [dbo].[cstd_recycle_lead] CHECK CONSTRAINT [FK_cstd_recycle_lead_cstd_recycle_lead]
GO
ALTER TABLE [dbo].[cstd_recycle_lead]  WITH CHECK ADD  CONSTRAINT [FK_cstd_recycle_lead_onca_source] FOREIGN KEY([source_code])
REFERENCES [dbo].[onca_source] ([source_code])
GO
ALTER TABLE [dbo].[cstd_recycle_lead] CHECK CONSTRAINT [FK_cstd_recycle_lead_onca_source]
GO
ALTER TABLE [dbo].[cstd_recycle_lead]  WITH CHECK ADD  CONSTRAINT [FK_cstd_recycle_lead_onca_user] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_recycle_lead] CHECK CONSTRAINT [FK_cstd_recycle_lead_onca_user]
GO
ALTER TABLE [dbo].[cstd_recycle_lead]  WITH CHECK ADD  CONSTRAINT [FK_cstd_recycle_lead_updated_by_user] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_recycle_lead] CHECK CONSTRAINT [FK_cstd_recycle_lead_updated_by_user]
GO
