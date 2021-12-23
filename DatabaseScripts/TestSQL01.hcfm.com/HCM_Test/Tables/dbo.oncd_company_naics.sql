/* CreateDate: 01/18/2005 09:34:08.610 , ModifyDate: 06/21/2012 10:10:48.380 */
GO
CREATE TABLE [dbo].[oncd_company_naics](
	[company_naics_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[naics_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_company_naics] PRIMARY KEY CLUSTERED
(
	[company_naics_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_naics_i2] ON [dbo].[oncd_company_naics]
(
	[company_id] ASC,
	[primary_flag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_naics_i3] ON [dbo].[oncd_company_naics]
(
	[naics_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_company_naics]  WITH NOCHECK ADD  CONSTRAINT [company_company_naic_86] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_company_naics] CHECK CONSTRAINT [company_company_naic_86]
GO
ALTER TABLE [dbo].[oncd_company_naics]  WITH NOCHECK ADD  CONSTRAINT [naics_company_naic_533] FOREIGN KEY([naics_code])
REFERENCES [dbo].[onca_naics] ([naics_code])
GO
ALTER TABLE [dbo].[oncd_company_naics] CHECK CONSTRAINT [naics_company_naic_533]
GO
ALTER TABLE [dbo].[oncd_company_naics]  WITH NOCHECK ADD  CONSTRAINT [user_company_naic_534] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_naics] CHECK CONSTRAINT [user_company_naic_534]
GO
ALTER TABLE [dbo].[oncd_company_naics]  WITH NOCHECK ADD  CONSTRAINT [user_company_naic_535] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_naics] CHECK CONSTRAINT [user_company_naic_535]
GO
