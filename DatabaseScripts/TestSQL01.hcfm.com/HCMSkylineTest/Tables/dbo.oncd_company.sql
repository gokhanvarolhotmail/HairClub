/* CreateDate: 11/08/2012 11:06:14.230 , ModifyDate: 11/08/2012 13:51:06.990 */
GO
CREATE TABLE [dbo].[oncd_company](
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_name_1] [nchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_name_2] [nchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_name_1_search] [nchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_name_2_search] [nchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_name_1_soundex] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_name_2_soundex] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[annual_sales] [int] NULL,
	[number_of_employees] [int] NULL,
	[profile_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[external_id] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_method_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[do_not_solicit] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[company_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[duplicate_check] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[status_updated_date] [datetime] NULL,
	[status_updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[parent_company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_center_number] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_company_map_link] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_center_manager_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_director_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_dma] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncd_company] PRIMARY KEY CLUSTERED
(
	[company_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncd_company]  WITH CHECK ADD  CONSTRAINT [company_company_329] FOREIGN KEY([parent_company_id])
REFERENCES [dbo].[oncd_company] ([company_id])
GO
ALTER TABLE [dbo].[oncd_company] CHECK CONSTRAINT [company_company_329]
GO
