/* CreateDate: 01/18/2005 09:34:14.907 , ModifyDate: 06/21/2012 10:00:52.040 */
GO
CREATE TABLE [dbo].[onca_milestone](
	[milestone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[milestone_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onca_milestone] PRIMARY KEY CLUSTERED
(
	[milestone_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_milestone]  WITH NOCHECK ADD  CONSTRAINT [milestone_st_milestone_273] FOREIGN KEY([milestone_status_code])
REFERENCES [dbo].[onca_milestone_status] ([milestone_status_code])
GO
ALTER TABLE [dbo].[onca_milestone] CHECK CONSTRAINT [milestone_st_milestone_273]
GO
