/* CreateDate: 01/18/2005 09:34:17.233 , ModifyDate: 06/18/2013 09:25:03.150 */
GO
CREATE TABLE [dbo].[onca_security_item](
	[security_item_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[security_set_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[condition_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[win_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[object_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[item_type] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[item_name] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[allow_access] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
 CONSTRAINT [pk_onca_security_item] PRIMARY KEY CLUSTERED
(
	[security_item_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[onca_security_item]  WITH CHECK ADD  CONSTRAINT [condition_security_ite_253] FOREIGN KEY([condition_id])
REFERENCES [dbo].[onca_condition] ([condition_id])
GO
ALTER TABLE [dbo].[onca_security_item] CHECK CONSTRAINT [condition_security_ite_253]
GO
ALTER TABLE [dbo].[onca_security_item]  WITH CHECK ADD  CONSTRAINT [object_security_ite_292] FOREIGN KEY([object_id])
REFERENCES [dbo].[onct_object] ([object_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_security_item] CHECK CONSTRAINT [object_security_ite_292]
GO
ALTER TABLE [dbo].[onca_security_item]  WITH CHECK ADD  CONSTRAINT [security_set_security_ite_252] FOREIGN KEY([security_set_id])
REFERENCES [dbo].[onca_security_set] ([security_set_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[onca_security_item] CHECK CONSTRAINT [security_set_security_ite_252]
GO
