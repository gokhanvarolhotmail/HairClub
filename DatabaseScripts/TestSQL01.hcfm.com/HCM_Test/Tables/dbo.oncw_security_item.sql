/* CreateDate: 01/25/2010 11:09:10.037 , ModifyDate: 06/21/2012 10:03:41.163 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncw_security_item](
	[security_item_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[security_set_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[container_id] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[object_id] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[item_type] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[item_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[access_value] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
 CONSTRAINT [pk_oncw_security_item] PRIMARY KEY CLUSTERED
(
	[security_item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncw_security_item]  WITH CHECK ADD  CONSTRAINT [security_set_security_ite_1161] FOREIGN KEY([security_set_id])
REFERENCES [dbo].[oncw_security_set] ([security_set_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncw_security_item] CHECK CONSTRAINT [security_set_security_ite_1161]
GO
