/* CreateDate: 12/04/2015 10:57:02.537 , ModifyDate: 12/17/2015 09:06:01.250 */
GO
CREATE TABLE [dbo].[cstd_skip_trace_export_staging](
	[VendorCode] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[first_name] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[middle_name] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_name] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[suffix] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E1_contact_address_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E1_address_line_1] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E1_address_line_2] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E1_address_line_3] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E1_city] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E1_state_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E1_zip_code] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E1_country_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E2_contact_address_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E2_address_line_1] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E2_address_line_2] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E2_address_line_3] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E2_city] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E2_state_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E2_zip_code] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E2_country_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E3_contact_address_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E3_address_line_1] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E3_address_line_2] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E3_address_line_3] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E3_city] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E3_state_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E3_zip_code] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E3_country_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E4_contact_address_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E4_address_line_1] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E4_address_line_2] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E4_address_line_3] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E4_city] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E4_state_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E4_zip_code] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E4_country_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E5_contact_address_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E5_address_line_1] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E5_address_line_2] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E5_address_line_3] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E5_city] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E5_state_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E5_zip_code] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E5_country_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E6_contact_address_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E6_address_line_1] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E6_address_line_2] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E6_address_line_3] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E6_city] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E6_state_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E6_zip_code] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E6_country_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E7_contact_address_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E7_address_line_1] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E7_address_line_2] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E7_address_line_3] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E7_city] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E7_state_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E7_zip_code] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E7_country_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E8_contact_address_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E8_address_line_1] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E8_address_line_2] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E8_address_line_3] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E8_city] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E8_state_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E8_zip_code] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E8_country_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E9_contact_address_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E9_address_line_1] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E9_address_line_2] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E9_address_line_3] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E9_city] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E9_state_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E9_zip_code] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E9_country_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E10_contact_address_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E10_address_line_1] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E10_address_line_2] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E10_address_line_3] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E10_city] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E10_state_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E10_zip_code] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E10_country_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E1_contact_phone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E1_country_code_prefix] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E1_area_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E1_phone_number] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E1_extension] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E2_contact_phone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E2_country_code_prefix] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E2_area_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E2_phone_number] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E2_extension] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E3_contact_phone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E3_country_code_prefix] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E3_area_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E3_phone_number] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E3_extension] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E4_contact_phone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E4_country_code_prefix] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E4_area_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E4_phone_number] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E4_extension] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E5_contact_phone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E5_country_code_prefix] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E5_area_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E5_phone_number] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E5_extension] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E6_contact_phone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E6_country_code_prefix] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E6_area_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E6_phone_number] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E6_extension] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E7_contact_phone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E7_country_code_prefix] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E7_area_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E7_phone_number] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E7_extension] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E8_contact_phone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E8_country_code_prefix] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E8_area_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E8_phone_number] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E8_extension] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E9_contact_phone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E9_country_code_prefix] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E9_area_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E9_phone_number] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E9_extension] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E10_contact_phone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E10_country_code_prefix] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E10_area_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E10_phone_number] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E10_extension] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E1_contact_email_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E1_email] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E2_contact_email_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E2_email] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E3_contact_email_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E3_email] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E4_contact_email_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E4_email] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E5_contact_email_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E5_email] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E6_contact_email_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E6_email] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E7_contact_email_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E7_email] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E8_contact_email_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E8_email] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E9_contact_email_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E9_email] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E10_contact_email_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[E10_email] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[skip_send_date] [nchar](8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[skip_request_id] [int] NULL,
	[skip_address] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[skip_phone] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[skip_email] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[skip_trace_export_id] [uniqueidentifier] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE CLUSTERED INDEX [skiptracevendor_i1] ON [dbo].[cstd_skip_trace_export_staging]
(
	[contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO