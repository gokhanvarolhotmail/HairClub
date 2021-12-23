/* CreateDate: 09/04/2007 09:40:44.243 , ModifyDate: 06/21/2012 10:12:16.303 */
GO
CREATE TABLE [dbo].[cstd_hcmtbl_leadstoimport_pagelynx_WRONG](
	[hcmtbl_leadstoimport_pagelynx_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[result_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[source_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[promotion_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[action_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[territory] [nchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[creation_time] [datetime] NULL,
	[first_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_1] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_2] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[city] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[state_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[zip_code] [nchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone_02] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[appointment_date] [datetime] NULL,
	[appointment_time] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[gender_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[age_range_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[hair_loss_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cst_sessionid] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_affiliateid] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[alt_center] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_loginid] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_cstd_hcmtbl_leadstoimport_pagelynx] PRIMARY KEY NONCLUSTERED
(
	[hcmtbl_leadstoimport_pagelynx_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_hcmtbl_leadstoimport_pagelynx_WRONG]  WITH NOCHECK ADD  CONSTRAINT [csta_contact_age_range_cstd_hcmtbl_leadstoimport_pagelynx_799] FOREIGN KEY([age_range_code])
REFERENCES [dbo].[csta_contact_age_range] ([age_range_code])
GO
ALTER TABLE [dbo].[cstd_hcmtbl_leadstoimport_pagelynx_WRONG] CHECK CONSTRAINT [csta_contact_age_range_cstd_hcmtbl_leadstoimport_pagelynx_799]
GO
ALTER TABLE [dbo].[cstd_hcmtbl_leadstoimport_pagelynx_WRONG]  WITH NOCHECK ADD  CONSTRAINT [csta_contact_hair_loss_cstd_hcmtbl_leadstoimport_pagelynx_800] FOREIGN KEY([hair_loss_code])
REFERENCES [dbo].[csta_contact_hair_loss] ([hair_loss_code])
GO
ALTER TABLE [dbo].[cstd_hcmtbl_leadstoimport_pagelynx_WRONG] CHECK CONSTRAINT [csta_contact_hair_loss_cstd_hcmtbl_leadstoimport_pagelynx_800]
GO
ALTER TABLE [dbo].[cstd_hcmtbl_leadstoimport_pagelynx_WRONG]  WITH NOCHECK ADD  CONSTRAINT [csta_promotion_code_cstd_hcmtbl_leadstoimport_pagelynx_798] FOREIGN KEY([promotion_code])
REFERENCES [dbo].[csta_promotion_code] ([promotion_code])
GO
ALTER TABLE [dbo].[cstd_hcmtbl_leadstoimport_pagelynx_WRONG] CHECK CONSTRAINT [csta_promotion_code_cstd_hcmtbl_leadstoimport_pagelynx_798]
GO
ALTER TABLE [dbo].[cstd_hcmtbl_leadstoimport_pagelynx_WRONG]  WITH NOCHECK ADD  CONSTRAINT [onca_action_cstd_hcmtbl_leadstoimport_pagelynx_795] FOREIGN KEY([action_code])
REFERENCES [dbo].[onca_action] ([action_code])
GO
ALTER TABLE [dbo].[cstd_hcmtbl_leadstoimport_pagelynx_WRONG] CHECK CONSTRAINT [onca_action_cstd_hcmtbl_leadstoimport_pagelynx_795]
GO
ALTER TABLE [dbo].[cstd_hcmtbl_leadstoimport_pagelynx_WRONG]  WITH NOCHECK ADD  CONSTRAINT [onca_result_cstd_hcmtbl_leadstoimport_pagelynx_796] FOREIGN KEY([result_code])
REFERENCES [dbo].[onca_result] ([result_code])
GO
ALTER TABLE [dbo].[cstd_hcmtbl_leadstoimport_pagelynx_WRONG] CHECK CONSTRAINT [onca_result_cstd_hcmtbl_leadstoimport_pagelynx_796]
GO
ALTER TABLE [dbo].[cstd_hcmtbl_leadstoimport_pagelynx_WRONG]  WITH NOCHECK ADD  CONSTRAINT [onca_source_cstd_hcmtbl_leadstoimport_pagelynx_797] FOREIGN KEY([source_code])
REFERENCES [dbo].[onca_source] ([source_code])
GO
ALTER TABLE [dbo].[cstd_hcmtbl_leadstoimport_pagelynx_WRONG] CHECK CONSTRAINT [onca_source_cstd_hcmtbl_leadstoimport_pagelynx_797]
GO
ALTER TABLE [dbo].[cstd_hcmtbl_leadstoimport_pagelynx_WRONG]  WITH NOCHECK ADD  CONSTRAINT [onca_user_cstd_hcmtbl_leadstoimport_pagelynx_794] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_hcmtbl_leadstoimport_pagelynx_WRONG] CHECK CONSTRAINT [onca_user_cstd_hcmtbl_leadstoimport_pagelynx_794]
GO
ALTER TABLE [dbo].[cstd_hcmtbl_leadstoimport_pagelynx_WRONG]  WITH NOCHECK ADD  CONSTRAINT [oncd_contact_cstd_hcmtbl_leadstoimport_pagelynx_793] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[cstd_hcmtbl_leadstoimport_pagelynx_WRONG] CHECK CONSTRAINT [oncd_contact_cstd_hcmtbl_leadstoimport_pagelynx_793]
GO
