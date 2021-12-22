/* CreateDate: 06/01/2005 13:05:21.187 , ModifyDate: 06/21/2012 10:05:29.173 */
GO
CREATE TABLE [dbo].[oncd_contract_description](
	[contract_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_contract_description] PRIMARY KEY CLUSTERED
(
	[contract_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_contract_description]  WITH CHECK ADD  CONSTRAINT [contract_contract_des_335] FOREIGN KEY([contract_id])
REFERENCES [dbo].[oncd_contract] ([contract_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_contract_description] CHECK CONSTRAINT [contract_contract_des_335]
GO
ALTER TABLE [dbo].[oncd_contract_description]  WITH CHECK ADD  CONSTRAINT [user_contract_des_632] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contract_description] CHECK CONSTRAINT [user_contract_des_632]
GO
ALTER TABLE [dbo].[oncd_contract_description]  WITH CHECK ADD  CONSTRAINT [user_contract_des_633] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contract_description] CHECK CONSTRAINT [user_contract_des_633]
GO
