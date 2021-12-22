/* CreateDate: 12/04/2015 10:57:02.430 , ModifyDate: 10/23/2017 02:00:02.540 */
GO
CREATE TABLE [dbo].[cstd_skip_trace_export_candidates](
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[needs_address] [bit] NULL,
	[needs_email] [bit] NULL,
	[needs_phone] [bit] NULL,
	[address_next_vendor_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone_next_vendor_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email_next_vendor_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[next_vendor_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [skiptraceexportcandidates_i1] ON [dbo].[cstd_skip_trace_export_candidates]
(
	[contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [skiptraceexportcandidates_i2] ON [dbo].[cstd_skip_trace_export_candidates]
(
	[next_vendor_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
