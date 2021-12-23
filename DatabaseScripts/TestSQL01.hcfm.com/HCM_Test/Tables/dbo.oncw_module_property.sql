/* CreateDate: 04/13/2006 13:57:44.930 , ModifyDate: 06/21/2012 10:03:46.003 */
GO
CREATE TABLE [dbo].[oncw_module_property](
	[module_property_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[module_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sort_order] [int] NULL,
	[property_name] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[property_value] [nvarchar](3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_oncw_module_property] PRIMARY KEY CLUSTERED
(
	[module_property_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncw_module_property_i1] ON [dbo].[oncw_module_property]
(
	[module_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncw_module_property]  WITH NOCHECK ADD  CONSTRAINT [module_module_prope_411] FOREIGN KEY([module_id])
REFERENCES [dbo].[oncw_module] ([module_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncw_module_property] CHECK CONSTRAINT [module_module_prope_411]
GO
