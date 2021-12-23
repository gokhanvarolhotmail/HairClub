/* CreateDate: 01/18/2005 09:34:08.920 , ModifyDate: 06/21/2012 10:08:09.683 */
GO
CREATE TABLE [dbo].[oncd_contact_interest](
	[contact_interest_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
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
 CONSTRAINT [pk_oncd_contact_interest] PRIMARY KEY CLUSTERED
(
	[contact_interest_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_interest_i2] ON [dbo].[oncd_contact_interest]
(
	[contact_id] ASC,
	[primary_flag] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_interest_i3] ON [dbo].[oncd_contact_interest]
(
	[interest_code] ASC,
	[interest_sub_code] ASC,
	[interest_status_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncd_contact_interest_i4] ON [dbo].[oncd_contact_interest]
(
	[interest_sub_code] ASC,
	[interest_status_code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_contact_interest]  WITH NOCHECK ADD  CONSTRAINT [contact_contact_inte_71] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncd_contact_interest] CHECK CONSTRAINT [contact_contact_inte_71]
GO
ALTER TABLE [dbo].[oncd_contact_interest]  WITH NOCHECK ADD  CONSTRAINT [interest_contact_inte_595] FOREIGN KEY([interest_code])
REFERENCES [dbo].[onca_interest] ([interest_code])
GO
ALTER TABLE [dbo].[oncd_contact_interest] CHECK CONSTRAINT [interest_contact_inte_595]
GO
ALTER TABLE [dbo].[oncd_contact_interest]  WITH NOCHECK ADD  CONSTRAINT [interest_sta_contact_inte_596] FOREIGN KEY([interest_status_code])
REFERENCES [dbo].[onca_interest_status] ([interest_status_code])
GO
ALTER TABLE [dbo].[oncd_contact_interest] CHECK CONSTRAINT [interest_sta_contact_inte_596]
GO
ALTER TABLE [dbo].[oncd_contact_interest]  WITH NOCHECK ADD  CONSTRAINT [interest_sub_contact_inte_791] FOREIGN KEY([interest_sub_code])
REFERENCES [dbo].[onca_interest_subgroup] ([interest_sub_code])
GO
ALTER TABLE [dbo].[oncd_contact_interest] CHECK CONSTRAINT [interest_sub_contact_inte_791]
GO
ALTER TABLE [dbo].[oncd_contact_interest]  WITH NOCHECK ADD  CONSTRAINT [user_contact_inte_593] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_interest] CHECK CONSTRAINT [user_contact_inte_593]
GO
ALTER TABLE [dbo].[oncd_contact_interest]  WITH NOCHECK ADD  CONSTRAINT [user_contact_inte_594] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[oncd_contact_interest] CHECK CONSTRAINT [user_contact_inte_594]
GO
