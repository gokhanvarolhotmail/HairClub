/* CreateDate: 10/15/2013 00:28:22.427 , ModifyDate: 10/15/2013 00:28:30.650 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cstd_queue_staging](
	[queue_staging_id] [uniqueidentifier] NOT NULL,
	[activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_cstd_queue_staging] PRIMARY KEY CLUSTERED
(
	[queue_staging_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_queue_staging] ADD  CONSTRAINT [DF_cstd_queue_staging_queue_staging_id]  DEFAULT (newid()) FOR [queue_staging_id]
GO
