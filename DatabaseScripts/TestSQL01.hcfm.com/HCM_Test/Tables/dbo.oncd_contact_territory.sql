/* CreateDate: 01/18/2005 09:34:09.233 , ModifyDate: 10/23/2017 12:35:40.133 */
GO
CREATE TABLE [dbo].[oncd_contact_territory](
	[contact_territory_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[territory_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_contact_territory] PRIMARY KEY CLUSTERED
(
	[contact_territory_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_contact_territory]  WITH NOCHECK ADD  CONSTRAINT [contact_contact_terr_67] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_contact_territory] CHECK CONSTRAINT [contact_contact_terr_67]
GO
ALTER TABLE [dbo].[oncd_contact_territory]  WITH NOCHECK ADD  CONSTRAINT [territory_contact_terr_622] FOREIGN KEY([territory_code])
REFERENCES [dbo].[onca_territory] ([territory_code])
GO
ALTER TABLE [dbo].[oncd_contact_territory] CHECK CONSTRAINT [territory_contact_terr_622]
GO
ALTER TABLE [dbo].[oncd_contact_territory]  WITH NOCHECK ADD  CONSTRAINT [user_contact_terr_620] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_territory] CHECK CONSTRAINT [user_contact_terr_620]
GO
ALTER TABLE [dbo].[oncd_contact_territory]  WITH NOCHECK ADD  CONSTRAINT [user_contact_terr_621] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_territory] CHECK CONSTRAINT [user_contact_terr_621]
GO
