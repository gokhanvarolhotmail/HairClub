/* CreateDate: 04/13/2016 09:57:40.177 , ModifyDate: 04/13/2016 09:57:40.317 */
GO
CREATE TABLE [dbo].[cstd_company_gender](
	[company_gender_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[gender_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
PRIMARY KEY CLUSTERED
(
	[company_gender_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_company_gender]  WITH CHECK ADD  CONSTRAINT [FK_company_gender_company] FOREIGN KEY([company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[cstd_company_gender] CHECK CONSTRAINT [FK_company_gender_company]
GO
