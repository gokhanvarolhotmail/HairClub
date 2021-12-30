/* CreateDate: 10/22/2007 09:46:33.947 , ModifyDate: 10/22/2007 10:23:46.370 */
GO
CREATE TABLE [dbo].[HC_EXCEPTIONoncd_contact_company](
	[contact_company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_role_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[reports_to_contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[title] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[department_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[internal_title_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TooManyCompanies] [tinyint] NULL,
	[DuplicatePrimaryFlag] [tinyint] NULL,
	[DateOfOccurence] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[HC_EXCEPTIONoncd_contact_company] ADD  CONSTRAINT [DF_HC_EXCEPTIONoncd_contact_company_DateOfOccurance]  DEFAULT (getdate()) FOR [DateOfOccurence]
GO
