/* CreateDate: 01/18/2005 09:34:09.593 , ModifyDate: 06/21/2012 10:04:33.740 */
GO
CREATE TABLE [dbo].[onct_class](
	[class_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[class_category_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[display_text] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[dependency_level] [int] NULL,
	[this_class_full_type_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[subject_full_type_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[subject_control_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[base_class_full_type_name] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[checkout_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[checkout_date] [datetime] NULL,
 CONSTRAINT [pk_onct_class] PRIMARY KEY CLUSTERED
(
	[class_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_class_i2] ON [dbo].[onct_class]
(
	[class_category_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_class_i3] ON [dbo].[onct_class]
(
	[display_text] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_class_i4] ON [dbo].[onct_class]
(
	[subject_control_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_class_i5] ON [dbo].[onct_class]
(
	[this_class_full_type_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_class_i6] ON [dbo].[onct_class]
(
	[base_class_full_type_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [onct_class_i8] ON [dbo].[onct_class]
(
	[checkout_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_class_i9] ON [dbo].[onct_class]
(
	[checkout_user_code] ASC,
	[checkout_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onct_class]  WITH NOCHECK ADD  CONSTRAINT [class_catego_class_117] FOREIGN KEY([class_category_code])
REFERENCES [dbo].[onct_class_category] ([class_category_code])
GO
ALTER TABLE [dbo].[onct_class] CHECK CONSTRAINT [class_catego_class_117]
GO
ALTER TABLE [dbo].[onct_class]  WITH NOCHECK ADD  CONSTRAINT [user_class_904] FOREIGN KEY([checkout_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[onct_class] CHECK CONSTRAINT [user_class_904]
GO
