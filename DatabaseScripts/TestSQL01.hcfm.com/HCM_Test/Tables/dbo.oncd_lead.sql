/* CreateDate: 01/25/2010 11:09:09.663 , ModifyDate: 06/21/2012 10:05:19.843 */
GO
CREATE TABLE [dbo].[oncd_lead](
	[lead_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[salutation_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[first_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[middle_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[title] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[area_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone_number] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_name_1] [nchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[web_address] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_1] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_2] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[city] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[state_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[zip_code] [nchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[country_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[source_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[comments] [nvarchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[host_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[host_ip] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[host_referrer] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[submit_url] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_lead] PRIMARY KEY CLUSTERED
(
	[lead_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_lead]  WITH NOCHECK ADD  CONSTRAINT [country_lead_1142] FOREIGN KEY([country_code])
REFERENCES [dbo].[onca_country] ([country_code])
GO
ALTER TABLE [dbo].[oncd_lead] CHECK CONSTRAINT [country_lead_1142]
GO
ALTER TABLE [dbo].[oncd_lead]  WITH NOCHECK ADD  CONSTRAINT [salutation_lead_1144] FOREIGN KEY([salutation_code])
REFERENCES [dbo].[onca_salutation] ([salutation_code])
GO
ALTER TABLE [dbo].[oncd_lead] CHECK CONSTRAINT [salutation_lead_1144]
GO
ALTER TABLE [dbo].[oncd_lead]  WITH NOCHECK ADD  CONSTRAINT [source_lead_1143] FOREIGN KEY([source_code])
REFERENCES [dbo].[onca_source] ([source_code])
GO
ALTER TABLE [dbo].[oncd_lead] CHECK CONSTRAINT [source_lead_1143]
GO
ALTER TABLE [dbo].[oncd_lead]  WITH NOCHECK ADD  CONSTRAINT [state_lead_1141] FOREIGN KEY([state_code])
REFERENCES [dbo].[onca_state] ([state_code])
GO
ALTER TABLE [dbo].[oncd_lead] CHECK CONSTRAINT [state_lead_1141]
GO
ALTER TABLE [dbo].[oncd_lead]  WITH NOCHECK ADD  CONSTRAINT [user_lead_1146] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_lead] CHECK CONSTRAINT [user_lead_1146]
GO
