/* CreateDate: 01/03/2014 07:07:46.490 , ModifyDate: 01/03/2014 07:07:46.497 */
GO
CREATE TABLE [core].[wait_types](
	[category_id] [smallint] NOT NULL,
	[wait_type] [nvarchar](45) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_events] PRIMARY KEY CLUSTERED
(
	[wait_type] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [core].[wait_types]  WITH CHECK ADD  CONSTRAINT [FK_events_categories] FOREIGN KEY([category_id])
REFERENCES [core].[wait_categories] ([category_id])
GO
ALTER TABLE [core].[wait_types] CHECK CONSTRAINT [FK_events_categories]
GO
