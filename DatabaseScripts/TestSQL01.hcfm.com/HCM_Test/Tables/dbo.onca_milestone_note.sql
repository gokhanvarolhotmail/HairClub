/* CreateDate: 06/01/2005 13:04:51.467 , ModifyDate: 06/21/2012 10:00:52.047 */
GO
CREATE TABLE [dbo].[onca_milestone_note](
	[milestone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_milestone_note] PRIMARY KEY CLUSTERED
(
	[milestone_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_milestone_note]  WITH CHECK ADD  CONSTRAINT [milestone_milestone_no_269] FOREIGN KEY([milestone_id])
REFERENCES [dbo].[onca_milestone] ([milestone_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_milestone_note] CHECK CONSTRAINT [milestone_milestone_no_269]
GO
