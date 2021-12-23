/* CreateDate: 01/18/2005 09:34:16.793 , ModifyDate: 06/21/2012 10:01:04.287 */
GO
CREATE TABLE [dbo].[onca_condition_trigger](
	[condition_trigger_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[condition_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[trigger_type] [nchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
 CONSTRAINT [pk_onca_condition_trigger] PRIMARY KEY CLUSTERED
(
	[condition_trigger_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_condition_trigger]  WITH NOCHECK ADD  CONSTRAINT [condition_condition_tr_254] FOREIGN KEY([condition_id])
REFERENCES [dbo].[onca_condition] ([condition_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_condition_trigger] CHECK CONSTRAINT [condition_condition_tr_254]
GO
