/* CreateDate: 11/02/2015 10:07:03.463 , ModifyDate: 01/05/2016 16:19:23.457 */
GO
CREATE TABLE [dbo].[cstd_skip_trace_import_detail](
	[skip_trace_import_detail_id] [uniqueidentifier] NOT NULL,
	[skip_trace_import_id] [uniqueidentifier] NOT NULL,
	[import_target_table_id_value] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[skip_sent_date] [datetime] NULL,
	[skip_request_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[skip_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[skip_trace_import_row_processing_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[updated_address_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_address_line_1] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_address_line_2] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_address_line_3] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_city] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_state_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_zip_code] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_country_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[original_address_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[original_address_line_1] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[original_address_line_2] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[original_address_line_3] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[original_city] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[original_state_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[original_zip_code] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[original_country_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_phone_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_country_code_prefix] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_area_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_phone_number] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_extension] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[original_phone_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[original_country_code_prefix] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[original_area_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[original_phone_number] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[original_extension] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_email_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_email] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[original_email_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[original_email] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[skip_trace_vendor_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[status_message] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[row_number] [int] NULL,
	[data_type] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[marketing_score] [decimal](15, 4) NULL,
	[data_block_number] [int] NULL,
	[skip_trace_export_id] [uniqueidentifier] NULL,
	[skip_trace_import_target_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
 CONSTRAINT [PK__cstd_import_detail] PRIMARY KEY CLUSTERED
(
	[skip_trace_import_detail_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [cstd_skip_trace_import_detail_i3] ON [dbo].[cstd_skip_trace_import_detail]
(
	[skip_trace_export_id] ASC,
	[contact_id] ASC,
	[skip_trace_import_target_code] ASC,
	[import_target_table_id_value] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [skip_trace_import_detail_i1] ON [dbo].[cstd_skip_trace_import_detail]
(
	[skip_trace_import_id] ASC,
	[contact_id] ASC,
	[import_target_table_id_value] ASC
)
INCLUDE([row_number],[data_block_number]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_skip_trace_import_detail]  WITH CHECK ADD  CONSTRAINT [import_detail_import] FOREIGN KEY([skip_trace_import_id])
REFERENCES [dbo].[cstd_skip_trace_import] ([skip_trace_import_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[cstd_skip_trace_import_detail] CHECK CONSTRAINT [import_detail_import]
GO
ALTER TABLE [dbo].[cstd_skip_trace_import_detail]  WITH CHECK ADD  CONSTRAINT [import_detail_row_processing_status] FOREIGN KEY([skip_trace_import_row_processing_status_code])
REFERENCES [dbo].[csta_skip_trace_import_row_processing_status] ([skip_trace_import_row_processing_status_code])
GO
ALTER TABLE [dbo].[cstd_skip_trace_import_detail] CHECK CONSTRAINT [import_detail_row_processing_status]
GO
