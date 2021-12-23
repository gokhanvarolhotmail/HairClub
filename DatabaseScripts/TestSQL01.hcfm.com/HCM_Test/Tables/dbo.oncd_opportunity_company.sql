/* CreateDate: 01/18/2005 09:34:09.483 , ModifyDate: 06/21/2012 10:05:17.843 */
GO
CREATE TABLE [dbo].[oncd_opportunity_company](
	[opportunity_company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[opportunity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[assignment_date] [datetime] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_opportunity_company] PRIMARY KEY CLUSTERED
(
	[opportunity_company_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_opportunity_company_i2] ON [dbo].[oncd_opportunity_company]
(
	[opportunity_id] ASC,
	[primary_flag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_opportunity_company_i3] ON [dbo].[oncd_opportunity_company]
(
	[company_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_opportunity_company]  WITH NOCHECK ADD  CONSTRAINT [company_opportunity__150] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_opportunity_company] CHECK CONSTRAINT [company_opportunity__150]
GO
ALTER TABLE [dbo].[oncd_opportunity_company]  WITH NOCHECK ADD  CONSTRAINT [opportunity_opportunity__149] FOREIGN KEY([opportunity_id])
REFERENCES [dbo].[oncd_opportunity] ([opportunity_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_opportunity_company] CHECK CONSTRAINT [opportunity_opportunity__149]
GO
ALTER TABLE [dbo].[oncd_opportunity_company]  WITH NOCHECK ADD  CONSTRAINT [user_opportunity__682] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_opportunity_company] CHECK CONSTRAINT [user_opportunity__682]
GO
ALTER TABLE [dbo].[oncd_opportunity_company]  WITH NOCHECK ADD  CONSTRAINT [user_opportunity__683] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_opportunity_company] CHECK CONSTRAINT [user_opportunity__683]
GO
