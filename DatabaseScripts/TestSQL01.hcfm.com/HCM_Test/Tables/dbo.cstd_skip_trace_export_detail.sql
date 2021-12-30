/* CreateDate: 12/04/2015 10:57:00.950 , ModifyDate: 12/04/2015 15:32:59.667 */
GO
CREATE TABLE [dbo].[cstd_skip_trace_export_detail](
	[skip_trace_export_detail_id] [uniqueidentifier] NOT NULL,
	[skip_trace_export_id] [uniqueidentifier] NOT NULL,
	[entity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[entity_table_name] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[row_sequence] [int] NULL,
	[slot_number] [int] NULL,
	[process_address_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[process_email_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[process_phone_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK__cstd_skip_trace_export_detail] PRIMARY KEY CLUSTERED
(
	[skip_trace_export_detail_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [skip_trace_export_detail_entity] ON [dbo].[cstd_skip_trace_export_detail]
(
	[entity_id] ASC,
	[entity_table_name] ASC,
	[skip_trace_export_id] ASC
)
INCLUDE([skip_trace_export_detail_id],[process_address_flag],[process_email_flag],[process_phone_flag]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_skip_trace_export_detail]  WITH CHECK ADD  CONSTRAINT [cstd_skip_trace_export_detail_export_id] FOREIGN KEY([skip_trace_export_id])
REFERENCES [dbo].[cstd_skip_trace_export] ([skip_trace_export_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[cstd_skip_trace_export_detail] CHECK CONSTRAINT [cstd_skip_trace_export_detail_export_id]
GO
