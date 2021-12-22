/* CreateDate: 11/08/2006 14:57:17.183 , ModifyDate: 10/23/2017 12:35:40.123 */
GO
CREATE TABLE [dbo].[cstd_activity_demographic](
	[activity_demographic_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[gender] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[birthday] [datetime] NULL,
	[occupation_code] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ethnicity_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[maritalstatus_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[norwood] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ludwig] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[age] [int] NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[performer] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[price_quoted] [money] NULL,
	[solution_offered] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[no_sale_reason] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[disc_style] [nvarchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_cstd_activity_demographic] PRIMARY KEY CLUSTERED
(
	[activity_demographic_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_cstd_Activity_demographic_Activity_ID] ON [dbo].[cstd_activity_demographic]
(
	[activity_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_cstd_activity_demographic_Creation_date] ON [dbo].[cstd_activity_demographic]
(
	[creation_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_activity_demographic]  WITH CHECK ADD  CONSTRAINT [csta_contact_ethnicity_cstd_activity_demographic_807] FOREIGN KEY([ethnicity_code])
REFERENCES [dbo].[csta_contact_ethnicity] ([ethnicity_code])
GO
ALTER TABLE [dbo].[cstd_activity_demographic] CHECK CONSTRAINT [csta_contact_ethnicity_cstd_activity_demographic_807]
GO
ALTER TABLE [dbo].[cstd_activity_demographic]  WITH CHECK ADD  CONSTRAINT [csta_contact_maritalstatus_cstd_activity_demographic_808] FOREIGN KEY([maritalstatus_code])
REFERENCES [dbo].[csta_contact_maritalstatus] ([maritalstatus_code])
GO
ALTER TABLE [dbo].[cstd_activity_demographic] CHECK CONSTRAINT [csta_contact_maritalstatus_cstd_activity_demographic_808]
GO
ALTER TABLE [dbo].[cstd_activity_demographic]  WITH CHECK ADD  CONSTRAINT [csta_contact_occupation_cstd_activity_demographic_806] FOREIGN KEY([occupation_code])
REFERENCES [dbo].[csta_contact_occupation] ([occupation_code])
GO
ALTER TABLE [dbo].[cstd_activity_demographic] CHECK CONSTRAINT [csta_contact_occupation_cstd_activity_demographic_806]
GO
ALTER TABLE [dbo].[cstd_activity_demographic]  WITH CHECK ADD  CONSTRAINT [onca_user_cstd_activity_demographic_809] FOREIGN KEY([created_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_activity_demographic] CHECK CONSTRAINT [onca_user_cstd_activity_demographic_809]
GO
ALTER TABLE [dbo].[cstd_activity_demographic]  WITH CHECK ADD  CONSTRAINT [onca_user_cstd_activity_demographic_810] FOREIGN KEY([updated_by_user_code])
REFERENCES [dbo].[onca_user] ([user_code])
GO
ALTER TABLE [dbo].[cstd_activity_demographic] CHECK CONSTRAINT [onca_user_cstd_activity_demographic_810]
GO
ALTER TABLE [dbo].[cstd_activity_demographic]  WITH CHECK ADD  CONSTRAINT [oncd_activity_cstd_activity_demographic_805] FOREIGN KEY([activity_id])
REFERENCES [dbo].[oncd_activity] ([activity_id])
GO
ALTER TABLE [dbo].[cstd_activity_demographic] CHECK CONSTRAINT [oncd_activity_cstd_activity_demographic_805]
GO
