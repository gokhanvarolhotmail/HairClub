/* CreateDate: 01/18/2005 09:34:09.687 , ModifyDate: 06/21/2012 10:04:23.417 */
GO
CREATE TABLE [dbo].[onct_class_compiled](
	[class_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[portable_executable] [image] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onct_class_compiled] PRIMARY KEY CLUSTERED
(
	[class_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[onct_class_compiled]  WITH CHECK ADD  CONSTRAINT [class_class_compil_59] FOREIGN KEY([class_id])
REFERENCES [dbo].[onct_class] ([class_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onct_class_compiled] CHECK CONSTRAINT [class_class_compil_59]
GO
