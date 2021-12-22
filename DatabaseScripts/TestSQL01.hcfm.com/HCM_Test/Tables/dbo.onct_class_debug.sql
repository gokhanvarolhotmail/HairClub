/* CreateDate: 01/18/2005 09:34:09.717 , ModifyDate: 06/21/2012 10:04:23.480 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onct_class_debug](
	[class_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[program_database] [image] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onct_class_debug] PRIMARY KEY CLUSTERED
(
	[class_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[onct_class_debug]  WITH CHECK ADD  CONSTRAINT [class_class_debug_60] FOREIGN KEY([class_id])
REFERENCES [dbo].[onct_class] ([class_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onct_class_debug] CHECK CONSTRAINT [class_class_debug_60]
GO
