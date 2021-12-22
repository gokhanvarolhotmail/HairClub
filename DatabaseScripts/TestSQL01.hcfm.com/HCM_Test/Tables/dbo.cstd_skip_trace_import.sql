/* CreateDate: 11/02/2015 10:07:03.333 , ModifyDate: 12/18/2015 10:48:37.047 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cstd_skip_trace_import](
	[skip_trace_import_id] [uniqueidentifier] NOT NULL,
	[skip_trace_import_date] [datetime] NOT NULL,
	[skip_trace_import_file_name] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[skip_trace_import_target_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[skip_trace_import_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[skip_trace_import_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[skip_trace_import_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[skip_trace_vendor_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK__cstd_import] PRIMARY KEY CLUSTERED
(
	[skip_trace_import_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_skip_trace_import]  WITH CHECK ADD  CONSTRAINT [import_import_status] FOREIGN KEY([skip_trace_import_status_code])
REFERENCES [dbo].[csta_skip_trace_import_status] ([skip_trace_import_status_code])
GO
ALTER TABLE [dbo].[cstd_skip_trace_import] CHECK CONSTRAINT [import_import_status]
GO
ALTER TABLE [dbo].[cstd_skip_trace_import]  WITH CHECK ADD  CONSTRAINT [import_import_target] FOREIGN KEY([skip_trace_import_target_code])
REFERENCES [dbo].[csta_skip_trace_import_target] ([skip_trace_import_target_code])
GO
ALTER TABLE [dbo].[cstd_skip_trace_import] CHECK CONSTRAINT [import_import_target]
GO
ALTER TABLE [dbo].[cstd_skip_trace_import]  WITH CHECK ADD  CONSTRAINT [import_import_type] FOREIGN KEY([skip_trace_import_type_code])
REFERENCES [dbo].[csta_skip_trace_import_type] ([skip_trace_import_type_code])
GO
ALTER TABLE [dbo].[cstd_skip_trace_import] CHECK CONSTRAINT [import_import_type]
GO
ALTER TABLE [dbo].[cstd_skip_trace_import]  WITH CHECK ADD  CONSTRAINT [import_user] FOREIGN KEY([skip_trace_import_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_skip_trace_import] CHECK CONSTRAINT [import_user]
GO
ALTER TABLE [dbo].[cstd_skip_trace_import]  WITH CHECK ADD  CONSTRAINT [import_vendor] FOREIGN KEY([skip_trace_vendor_code])
REFERENCES [dbo].[csta_skip_trace_vendor] ([skip_trace_vendor_code])
ON DELETE SET NULL
GO
ALTER TABLE [dbo].[cstd_skip_trace_import] CHECK CONSTRAINT [import_vendor]
GO
