/* CreateDate: 12/03/2014 14:31:34.177 , ModifyDate: 12/03/2014 14:31:34.663 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cstd_index_maintenance](
	[index_maintenance_id] [uniqueidentifier] NOT NULL,
	[table_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[index_name] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[percent_fragmented] [decimal](15, 12) NOT NULL,
	[start_date] [datetime] NULL,
	[process_date] [datetime] NOT NULL,
 CONSTRAINT [PK_cstd_index_maintenance] PRIMARY KEY CLUSTERED
(
	[index_maintenance_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_index_maintenance] ADD  CONSTRAINT [DF_cstd_index_maintenance_index_maintenance_id]  DEFAULT (newsequentialid()) FOR [index_maintenance_id]
GO
ALTER TABLE [dbo].[cstd_index_maintenance] ADD  CONSTRAINT [DF_cstd_index_maintenance_process_date]  DEFAULT (getdate()) FOR [process_date]
GO
