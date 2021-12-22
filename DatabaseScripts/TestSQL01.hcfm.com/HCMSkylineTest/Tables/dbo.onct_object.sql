/* CreateDate: 11/08/2012 11:13:35.187 , ModifyDate: 11/08/2012 11:14:36.530 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onct_object](
	[object_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[object_type] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[object_attribute] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[parent_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[logical_parent_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[main_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[class_name] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[object_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[unique_name] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onct_object] PRIMARY KEY CLUSTERED
(
	[object_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
