/* CreateDate: 01/18/2005 09:34:08.560 , ModifyDate: 06/21/2012 10:10:48.380 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncd_company_interest](
	[company_interest_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[interest_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[interest_sub_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[interest_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[assignment_date] [datetime] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_company_interest] PRIMARY KEY CLUSTERED
(
	[company_interest_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_interest_i2] ON [dbo].[oncd_company_interest]
(
	[company_id] ASC,
	[primary_flag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_interest_i3] ON [dbo].[oncd_company_interest]
(
	[interest_code] ASC,
	[interest_sub_code] ASC,
	[interest_status_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_interest_i4] ON [dbo].[oncd_company_interest]
(
	[interest_code] ASC,
	[interest_status_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_company_interest_i5] ON [dbo].[oncd_company_interest]
(
	[interest_status_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_company_interest]  WITH CHECK ADD  CONSTRAINT [company_company_inte_91] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_company_interest] CHECK CONSTRAINT [company_company_inte_91]
GO
ALTER TABLE [dbo].[oncd_company_interest]  WITH CHECK ADD  CONSTRAINT [interest_company_inte_525] FOREIGN KEY([interest_code])
REFERENCES [dbo].[onca_interest] ([interest_code])
GO
ALTER TABLE [dbo].[oncd_company_interest] CHECK CONSTRAINT [interest_company_inte_525]
GO
ALTER TABLE [dbo].[oncd_company_interest]  WITH CHECK ADD  CONSTRAINT [interest_sta_company_inte_527] FOREIGN KEY([interest_status_code])
REFERENCES [dbo].[onca_interest_status] ([interest_status_code])
GO
ALTER TABLE [dbo].[oncd_company_interest] CHECK CONSTRAINT [interest_sta_company_inte_527]
GO
ALTER TABLE [dbo].[oncd_company_interest]  WITH CHECK ADD  CONSTRAINT [interest_sub_company_inte_1164] FOREIGN KEY([interest_sub_code])
REFERENCES [dbo].[onca_interest_subgroup] ([interest_sub_code])
GO
ALTER TABLE [dbo].[oncd_company_interest] CHECK CONSTRAINT [interest_sub_company_inte_1164]
GO
ALTER TABLE [dbo].[oncd_company_interest]  WITH CHECK ADD  CONSTRAINT [user_company_inte_528] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_interest] CHECK CONSTRAINT [user_company_inte_528]
GO
ALTER TABLE [dbo].[oncd_company_interest]  WITH CHECK ADD  CONSTRAINT [user_company_inte_529] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_company_interest] CHECK CONSTRAINT [user_company_inte_529]
GO
