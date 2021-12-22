/* CreateDate: 02/16/2005 08:48:35.967 , ModifyDate: 06/21/2012 10:04:17.833 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onct_form_filter](
	[form_filter_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[object_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[form_filter] [nvarchar](3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[default_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onct_form_filter] PRIMARY KEY CLUSTERED
(
	[form_filter_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_form_filter_i4] ON [dbo].[onct_form_filter]
(
	[object_id] ASC,
	[user_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_form_filter_i5] ON [dbo].[onct_form_filter]
(
	[user_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onct_form_filter]  WITH CHECK ADD  CONSTRAINT [object_form_filter_925] FOREIGN KEY([object_id])
REFERENCES [dbo].[onct_object] ([object_id])
GO
ALTER TABLE [dbo].[onct_form_filter] CHECK CONSTRAINT [object_form_filter_925]
GO
ALTER TABLE [dbo].[onct_form_filter]  WITH CHECK ADD  CONSTRAINT [user_form_filter_1075] FOREIGN KEY([user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[onct_form_filter] CHECK CONSTRAINT [user_form_filter_1075]
GO
