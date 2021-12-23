/* CreateDate: 01/18/2005 09:34:09.750 , ModifyDate: 06/21/2012 10:04:07.907 */
GO
CREATE TABLE [dbo].[onct_object_property](
	[property_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[object_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[property_name] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[property_value] [nvarchar](3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[multiline] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_onct_object_property] PRIMARY KEY CLUSTERED
(
	[property_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_object_property_i2] ON [dbo].[onct_object_property]
(
	[object_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_object_property_i3] ON [dbo].[onct_object_property]
(
	[property_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [onct_object_property_i4] ON [dbo].[onct_object_property]
(
	[object_id] ASC,
	[property_id] ASC
)
INCLUDE([property_name],[property_value],[sort_order],[multiline]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onct_object_property]  WITH CHECK ADD  CONSTRAINT [object_object_prope_54] FOREIGN KEY([object_id])
REFERENCES [dbo].[onct_object] ([object_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onct_object_property] CHECK CONSTRAINT [object_object_prope_54]
GO
