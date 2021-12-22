/* CreateDate: 06/19/2008 10:56:12.950 , ModifyDate: 06/21/2012 10:00:00.707 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[csta_query_criteria](
	[query_criteria_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_csta_query_criteria] PRIMARY KEY CLUSTERED
(
	[query_criteria_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[csta_query_criteria]  WITH CHECK ADD  CONSTRAINT [onca_user_csta_query_criteria_760] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[csta_query_criteria] CHECK CONSTRAINT [onca_user_csta_query_criteria_760]
GO
ALTER TABLE [dbo].[csta_query_criteria]  WITH CHECK ADD  CONSTRAINT [onca_user_csta_query_criteria_761] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[csta_query_criteria] CHECK CONSTRAINT [onca_user_csta_query_criteria_761]
GO
