/* CreateDate: 01/18/2005 09:34:09.263 , ModifyDate: 06/21/2012 10:05:29.177 */
GO
CREATE TABLE [dbo].[oncd_contract](
	[contract_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contract_number] [int] NULL,
	[start_date] [datetime] NULL,
	[end_date] [datetime] NULL,
	[contract_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contract_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[total_value] [decimal](15, 4) NULL,
	[total_time] [int] NULL,
	[total_time_used] [int] NULL,
	[status_updated_date] [datetime] NULL,
	[status_updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_contract] PRIMARY KEY CLUSTERED
(
	[contract_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contract_i2] ON [dbo].[oncd_contract]
(
	[company_id] ASC,
	[contact_id] ASC,
	[active] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contract_i3] ON [dbo].[oncd_contract]
(
	[contact_id] ASC,
	[active] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [oncd_contract_i4] ON [dbo].[oncd_contract]
(
	[contract_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contract_i5] ON [dbo].[oncd_contract]
(
	[contract_type_code] ASC,
	[contract_status_code] ASC,
	[active] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contract_i6] ON [dbo].[oncd_contract]
(
	[contract_status_code] ASC,
	[active] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_contract]  WITH CHECK ADD  CONSTRAINT [company_contract_141] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
GO
ALTER TABLE [dbo].[oncd_contract] CHECK CONSTRAINT [company_contract_141]
GO
ALTER TABLE [dbo].[oncd_contract]  WITH CHECK ADD  CONSTRAINT [contact_contract_337] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
GO
ALTER TABLE [dbo].[oncd_contract] CHECK CONSTRAINT [contact_contract_337]
GO
ALTER TABLE [dbo].[oncd_contract]  WITH CHECK ADD  CONSTRAINT [contract_sta_contract_630] FOREIGN KEY([contract_status_code])
REFERENCES [dbo].[onca_contract_status] ([contract_status_code])
GO
ALTER TABLE [dbo].[oncd_contract] CHECK CONSTRAINT [contract_sta_contract_630]
GO
ALTER TABLE [dbo].[oncd_contract]  WITH CHECK ADD  CONSTRAINT [contract_typ_contract_631] FOREIGN KEY([contract_type_code])
REFERENCES [dbo].[onca_contract_type] ([contract_type_code])
GO
ALTER TABLE [dbo].[oncd_contract] CHECK CONSTRAINT [contract_typ_contract_631]
GO
ALTER TABLE [dbo].[oncd_contract]  WITH CHECK ADD  CONSTRAINT [user_contract_627] FOREIGN KEY([status_updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contract] CHECK CONSTRAINT [user_contract_627]
GO
ALTER TABLE [dbo].[oncd_contract]  WITH CHECK ADD  CONSTRAINT [user_contract_628] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contract] CHECK CONSTRAINT [user_contract_628]
GO
ALTER TABLE [dbo].[oncd_contract]  WITH CHECK ADD  CONSTRAINT [user_contract_629] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contract] CHECK CONSTRAINT [user_contract_629]
GO
