/* CreateDate: 02/09/2007 10:46:30.703 , ModifyDate: 06/21/2012 10:00:00.560 */
GO
CREATE TABLE [dbo].[csta_media_source](
	[source_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[media_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_csta_media_source] PRIMARY KEY NONCLUSTERED
(
	[source_code] ASC,
	[media_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_media_source] ADD  CONSTRAINT [DF__csta_medi__activ__7775B2CE]  DEFAULT ('Y') FOR [active]
GO
ALTER TABLE [dbo].[csta_media_source]  WITH CHECK ADD  CONSTRAINT [onca_source_csta_media_source_815] FOREIGN KEY([source_code])
REFERENCES [dbo].[onca_source] ([source_code])
GO
ALTER TABLE [dbo].[csta_media_source] CHECK CONSTRAINT [onca_source_csta_media_source_815]
GO
