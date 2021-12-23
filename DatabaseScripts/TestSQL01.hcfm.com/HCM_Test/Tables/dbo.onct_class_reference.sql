/* CreateDate: 01/25/2010 11:09:44.280 , ModifyDate: 06/21/2012 10:04:24.150 */
GO
CREATE TABLE [dbo].[onct_class_reference](
	[class_reference_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[class_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[reference_name] [nchar](64) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[reference_source] [nvarchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[reference_type_code] [nchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[creation_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onct_class_reference] PRIMARY KEY CLUSTERED
(
	[class_reference_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_class_reference_i2] ON [dbo].[onct_class_reference]
(
	[reference_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [onct_class_reference_i3] ON [dbo].[onct_class_reference]
(
	[class_id] ASC,
	[reference_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onct_class_reference]  WITH CHECK ADD  CONSTRAINT [class_class_refere_187] FOREIGN KEY([class_id])
REFERENCES [dbo].[onct_class] ([class_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onct_class_reference] CHECK CONSTRAINT [class_class_refere_187]
GO
