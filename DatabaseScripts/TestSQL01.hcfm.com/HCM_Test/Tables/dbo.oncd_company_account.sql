/* CreateDate: 01/18/2005 09:34:08.420 , ModifyDate: 06/21/2012 10:10:52.483 */
GO
CREATE TABLE [dbo].[oncd_company_account](
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[commission_percent] [int] NULL,
	[account_status] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[current_amount] [decimal](15, 4) NULL,
	[future_amount] [decimal](15, 4) NULL,
	[order_amount] [decimal](15, 4) NULL,
	[last_invoice_date] [datetime] NULL,
	[last_activity_date] [datetime] NULL,
	[discount_percent] [int] NULL,
	[program_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[terms_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[aging_1_amount] [decimal](15, 4) NULL,
	[aging_2_amount] [decimal](15, 4) NULL,
	[aging_3_amount] [decimal](15, 4) NULL,
	[aging_4_amount] [decimal](15, 4) NULL,
	[credit_limit_amount] [decimal](15, 4) NULL,
	[average_days] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_company_account] PRIMARY KEY CLUSTERED
(
	[company_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_account_i2] ON [dbo].[oncd_company_account]
(
	[contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_company_account]  WITH CHECK ADD  CONSTRAINT [company_company_acco_81] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_company_account] CHECK CONSTRAINT [company_company_acco_81]
GO
ALTER TABLE [dbo].[oncd_company_account]  WITH CHECK ADD  CONSTRAINT [contact_company_acco_404] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
GO
ALTER TABLE [dbo].[oncd_company_account] CHECK CONSTRAINT [contact_company_acco_404]
GO
ALTER TABLE [dbo].[oncd_company_account]  WITH CHECK ADD  CONSTRAINT [user_company_acco_508] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_account] CHECK CONSTRAINT [user_company_acco_508]
GO
ALTER TABLE [dbo].[oncd_company_account]  WITH CHECK ADD  CONSTRAINT [user_company_acco_509] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_account] CHECK CONSTRAINT [user_company_acco_509]
GO
