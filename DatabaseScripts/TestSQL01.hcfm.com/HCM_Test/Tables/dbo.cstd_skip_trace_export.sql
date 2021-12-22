/* CreateDate: 12/04/2015 10:57:00.630 , ModifyDate: 12/04/2015 10:57:00.983 */
GO
CREATE TABLE [dbo].[cstd_skip_trace_export](
	[skip_trace_export_id] [uniqueidentifier] NOT NULL,
	[export_date] [datetime] NOT NULL,
	[export_file_name] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[vendor_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[system_user] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[export_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[export_status_message] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK__cstd_skip_trace_export] PRIMARY KEY CLUSTERED
(
	[skip_trace_export_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
