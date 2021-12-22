/* CreateDate: 12/04/2015 15:32:59.747 , ModifyDate: 12/04/2015 15:32:59.777 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cstd_contact_skip_trace_events](
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[last_address_export_date] [datetime] NULL,
	[last_address_export_vendor_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_phone_export_date] [datetime] NULL,
	[last_phone_export_vendor_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_email_export_date] [datetime] NULL,
	[last_email_export_vendor_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[next_address_export_date] [datetime] NULL,
	[next_address_export_vendor_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[next_phone_export_date] [datetime] NULL,
	[next_phone_export_vendor_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[next_email_export_date] [datetime] NULL,
	[next_email_export_vendor_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK__cstd_contact_skip_trace_events] PRIMARY KEY CLUSTERED
(
	[contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_contact_skip_trace_events]  WITH CHECK ADD  CONSTRAINT [contact_skip_trace_events_contact] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
GO
ALTER TABLE [dbo].[cstd_contact_skip_trace_events] CHECK CONSTRAINT [contact_skip_trace_events_contact]
GO
