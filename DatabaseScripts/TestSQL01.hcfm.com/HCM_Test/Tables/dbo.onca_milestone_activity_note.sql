/* CreateDate: 06/01/2005 13:05:18.043 , ModifyDate: 06/21/2012 10:00:52.043 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onca_milestone_activity_note](
	[milestone_activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[note] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_milestone_activity_note] PRIMARY KEY CLUSTERED
(
	[milestone_activity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_milestone_activity_note]  WITH CHECK ADD  CONSTRAINT [milestone_ac_milestone_ac_271] FOREIGN KEY([milestone_activity_id])
REFERENCES [dbo].[onca_milestone_activity] ([milestone_activity_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_milestone_activity_note] CHECK CONSTRAINT [milestone_ac_milestone_ac_271]
GO
