/* CreateDate: 01/18/2005 09:34:14.263 , ModifyDate: 06/21/2012 10:04:13.423 */
GO
CREATE TABLE [dbo].[onct_object_group](
	[object_group_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onct_object_group] PRIMARY KEY CLUSTERED
(
	[object_group_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
