/* CreateDate: 12/04/2015 15:36:04.890 , ModifyDate: 12/04/2015 15:36:04.890 */
GO
CREATE TABLE [dbo].[cstd_skip_trace_external_import_staging](
	[vendor_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[skip_trace_export_id] [uniqueidentifier] NULL,
	[address1_line_1] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address1_line_2] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address1_city] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address1_state_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address1_zip_code] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address2_line_1] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address2_line_2] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address2_city] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address2_state_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address2_zip_code] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address3_line_1] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address3_line_2] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address3_city] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address3_state_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address3_zip_code] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address4_line_1] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address4_line_2] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address4_city] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address4_state_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address4_zip_code] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address5_line_1] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address5_line_2] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address5_city] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address5_state_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address5_zip_code] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address6_line_1] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address6_line_2] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address6_city] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address6_state_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address6_zip_code] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address7_line_1] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address7_line_2] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address7_city] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address7_state_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address7_zip_code] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address8_line_1] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address8_line_2] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address8_city] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address8_state_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address8_zip_code] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address9_line_1] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address9_line_2] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address9_city] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address9_state_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address9_zip_code] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address10_line_1] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address10_line_2] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address10_city] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address10_state_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address10_zip_code] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone1_area_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone1_phone_number] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone2_area_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone2_phone_number] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone3_area_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone3_phone_number] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone4_area_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone4_phone_number] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone5_area_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone5_phone_number] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone6_area_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone6_phone_number] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone7_area_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone7_phone_number] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone8_area_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone8_phone_number] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone9_area_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone9_phone_number] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone10_area_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone10_phone_number] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email1] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email2] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email3] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email4] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email5] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email6] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email7] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email8] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email9] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email10] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO