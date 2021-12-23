/* CreateDate: 01/25/2010 11:09:09.740 , ModifyDate: 06/21/2012 10:00:47.800 */
GO
CREATE TABLE [dbo].[onca_user_lotus](
	[user_lotus_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[document_id] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[default_appointment_folder] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[default_task_folder] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[default_contact_folder] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_user_lotus] PRIMARY KEY CLUSTERED
(
	[user_lotus_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_user_lotus]  WITH NOCHECK ADD  CONSTRAINT [user_user_lotus_727] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[onca_user_lotus] CHECK CONSTRAINT [user_user_lotus_727]
GO
