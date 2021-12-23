/* CreateDate: 09/12/2007 09:21:40.920 , ModifyDate: 09/10/2019 22:47:59.457 */
GO
CREATE TABLE [dbo].[hcmtbl_file_import_file_detail](
	[file_detail_id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[file_id] [int] NOT NULL,
	[lineitem_id] [int] NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[first_name] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_name] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[is_new_lead] [bit] NULL,
	[is_new_appointment] [bit] NULL,
	[is_new_brochure] [bit] NULL,
	[notes] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_hcmtbl_file_import_file_detail] PRIMARY KEY CLUSTERED
(
	[file_detail_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [hcmtbl_file_import_file_detail_i2] ON [dbo].[hcmtbl_file_import_file_detail]
(
	[file_id] ASC,
	[lineitem_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[hcmtbl_file_import_file_detail]  WITH NOCHECK ADD  CONSTRAINT [cstd_file_import_file_header_cstd_file_import_file_detail_786] FOREIGN KEY([file_id])
REFERENCES [dbo].[hcmtbl_file_import_file_header] ([file_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[hcmtbl_file_import_file_detail] CHECK CONSTRAINT [cstd_file_import_file_header_cstd_file_import_file_detail_786]
GO
