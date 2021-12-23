/* CreateDate: 11/02/2015 10:07:03.173 , ModifyDate: 12/10/2015 17:28:53.667 */
GO
CREATE TABLE [dbo].[csta_skip_trace_vendor](
	[skip_trace_vendor_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[name] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[address_primary_vendor] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[email_primary_vendor] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[phone_primary_vendor] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[address_line_1] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_2] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_3] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[city] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[state_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[zip_code] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[country_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[fax] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_name] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_phone] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_email] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_next_vendor_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email_next_vendor_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone_next_vendor_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ftp_address] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ftp_type] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[login_name] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[password_] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active_ftp] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[note] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_next_vendor_delay_days] [int] NULL,
	[email_next_vendor_delay_days] [int] NULL,
	[phone_next_vendor_delay_days] [int] NULL,
	[ftp_remote_dir_in] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ftp_remote_dir_out] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sftp_fingerprint_key] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED
(
	[skip_trace_vendor_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_skip_trace_vendor] ADD  DEFAULT ('Y') FOR [active]
GO
ALTER TABLE [dbo].[csta_skip_trace_vendor] ADD  DEFAULT ('N') FOR [address_primary_vendor]
GO
ALTER TABLE [dbo].[csta_skip_trace_vendor] ADD  DEFAULT ('N') FOR [email_primary_vendor]
GO
ALTER TABLE [dbo].[csta_skip_trace_vendor] ADD  DEFAULT ('N') FOR [phone_primary_vendor]
GO
ALTER TABLE [dbo].[csta_skip_trace_vendor] ADD  DEFAULT ('Y') FOR [active_ftp]
GO
ALTER TABLE [dbo].[csta_skip_trace_vendor]  WITH NOCHECK ADD  CONSTRAINT [address_next_vendor] FOREIGN KEY([address_next_vendor_code])
REFERENCES [dbo].[csta_skip_trace_vendor] ([skip_trace_vendor_code])
GO
ALTER TABLE [dbo].[csta_skip_trace_vendor] CHECK CONSTRAINT [address_next_vendor]
GO
ALTER TABLE [dbo].[csta_skip_trace_vendor]  WITH NOCHECK ADD  CONSTRAINT [email_next_vendor] FOREIGN KEY([email_next_vendor_code])
REFERENCES [dbo].[csta_skip_trace_vendor] ([skip_trace_vendor_code])
GO
ALTER TABLE [dbo].[csta_skip_trace_vendor] CHECK CONSTRAINT [email_next_vendor]
GO
ALTER TABLE [dbo].[csta_skip_trace_vendor]  WITH NOCHECK ADD  CONSTRAINT [phone_next_vendor] FOREIGN KEY([phone_next_vendor_code])
REFERENCES [dbo].[csta_skip_trace_vendor] ([skip_trace_vendor_code])
GO
ALTER TABLE [dbo].[csta_skip_trace_vendor] CHECK CONSTRAINT [phone_next_vendor]
GO
ALTER TABLE [dbo].[csta_skip_trace_vendor]  WITH NOCHECK ADD  CONSTRAINT [vendor_state] FOREIGN KEY([state_code])
REFERENCES [dbo].[onca_state] ([state_code])
GO
ALTER TABLE [dbo].[csta_skip_trace_vendor] CHECK CONSTRAINT [vendor_state]
GO
