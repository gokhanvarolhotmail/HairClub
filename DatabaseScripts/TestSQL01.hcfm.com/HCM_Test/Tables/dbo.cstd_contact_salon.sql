/* CreateDate: 07/14/2010 15:37:14.667 , ModifyDate: 08/11/2014 00:59:28.510 */
GO
CREATE TABLE [dbo].[cstd_contact_salon](
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[locked_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[referring_store_phone] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[referring_store_manager] [nchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_cstd_contact_salon] PRIMARY KEY CLUSTERED
(
	[contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [cstd_contact_salon_i1] ON [dbo].[cstd_contact_salon]
(
	[locked_by_user_code] ASC,
	[contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_contact_salon]  WITH CHECK ADD  CONSTRAINT [cstd_contact_salon_oncd_contact] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[cstd_contact_salon] CHECK CONSTRAINT [cstd_contact_salon_oncd_contact]
GO
ALTER TABLE [dbo].[cstd_contact_salon]  WITH CHECK ADD  CONSTRAINT [locking_user_contact] FOREIGN KEY([locked_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_contact_salon] CHECK CONSTRAINT [locking_user_contact]
GO
