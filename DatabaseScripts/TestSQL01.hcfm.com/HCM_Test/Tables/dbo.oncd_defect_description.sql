/* CreateDate: 06/01/2005 13:05:18.123 , ModifyDate: 10/23/2017 12:35:14.803 */
GO
CREATE TABLE [dbo].[oncd_defect_description](
	[defect_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_defect_description] PRIMARY KEY CLUSTERED
(
	[defect_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE FULLTEXT INDEX ON [dbo].[oncd_defect_description]
KEY INDEX [pk_oncd_defect_description]ON ([oncd_defect_description], FILEGROUP [PRIMARY])
WITH (CHANGE_TRACKING = AUTO, STOPLIST = SYSTEM)
GO
ALTER TABLE [dbo].[oncd_defect_description]  WITH NOCHECK ADD  CONSTRAINT [defect_defect_descr_220] FOREIGN KEY([defect_id])
REFERENCES [dbo].[oncd_defect] ([defect_id])
GO
ALTER TABLE [dbo].[oncd_defect_description] CHECK CONSTRAINT [defect_defect_descr_220]
GO
ALTER TABLE [dbo].[oncd_defect_description]  WITH NOCHECK ADD  CONSTRAINT [user_defect_descr_874] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_defect_description] CHECK CONSTRAINT [user_defect_descr_874]
GO
ALTER TABLE [dbo].[oncd_defect_description]  WITH NOCHECK ADD  CONSTRAINT [user_defect_descr_875] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_defect_description] CHECK CONSTRAINT [user_defect_descr_875]
GO
