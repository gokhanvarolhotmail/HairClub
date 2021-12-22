/* CreateDate: 02/27/2006 15:15:42.580 , ModifyDate: 06/21/2012 10:01:04.417 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onca_dashboard](
	[dashboard_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[object_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[display_text] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[initial_filter] [nvarchar](3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_dashboard] PRIMARY KEY CLUSTERED
(
	[dashboard_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_dashboard]  WITH CHECK ADD  CONSTRAINT [object_dashboard_433] FOREIGN KEY([object_id])
REFERENCES [dbo].[onct_object] ([object_id])
GO
ALTER TABLE [dbo].[onca_dashboard] CHECK CONSTRAINT [object_dashboard_433]
GO
