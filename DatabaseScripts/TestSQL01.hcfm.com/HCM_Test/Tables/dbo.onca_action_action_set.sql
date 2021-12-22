/* CreateDate: 01/18/2005 09:34:06.937 , ModifyDate: 09/26/2013 14:54:44.790 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onca_action_action_set](
	[action_action_set_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[action_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[action_set_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_onca_action_action_set] PRIMARY KEY CLUSTERED
(
	[action_action_set_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_action_action_set]  WITH NOCHECK ADD  CONSTRAINT [action_action_actio_128] FOREIGN KEY([action_code])
REFERENCES [dbo].[onca_action] ([action_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_action_action_set] CHECK CONSTRAINT [action_action_actio_128]
GO
ALTER TABLE [dbo].[onca_action_action_set]  WITH CHECK ADD  CONSTRAINT [action_set_action_actio_129] FOREIGN KEY([action_set_code])
REFERENCES [dbo].[onca_action_set] ([action_set_code])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_action_action_set] CHECK CONSTRAINT [action_set_action_actio_129]
GO
