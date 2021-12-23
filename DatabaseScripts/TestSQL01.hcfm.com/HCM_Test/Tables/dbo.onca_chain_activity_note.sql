/* CreateDate: 06/01/2005 13:05:17.717 , ModifyDate: 06/21/2012 10:01:08.763 */
GO
CREATE TABLE [dbo].[onca_chain_activity_note](
	[chain_activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[note] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_chain_activity_note] PRIMARY KEY CLUSTERED
(
	[chain_activity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_chain_activity_note]  WITH NOCHECK ADD  CONSTRAINT [chain_activi_chain_activi_262] FOREIGN KEY([chain_activity_id])
REFERENCES [dbo].[onca_chain_activity] ([chain_activity_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_chain_activity_note] CHECK CONSTRAINT [chain_activi_chain_activi_262]
GO
