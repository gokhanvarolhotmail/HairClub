/* CreateDate: 09/12/2007 09:21:41.013 , ModifyDate: 07/29/2014 03:51:47.640 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[hcmtbl_file_import_file_header](
	[file_id] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[import_date] [datetime] NULL,
	[company] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[file_name] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_cstd_file_import_file_header] PRIMARY KEY NONCLUSTERED
(
	[file_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
