/* CreateDate: 11/04/2015 12:38:02.143 , ModifyDate: 11/11/2015 11:36:21.227 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cstd_skip_trace_import_staging](
	[vendor_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[skip_sent_date] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[skip_request_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[skip_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_address_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[append_address_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[append_address_1] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[append_address_2] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[append_address_3] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[append_city] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[append_state] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[append_zip_code] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[append_country_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_1] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_2] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_3] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[city] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[state] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[zip_code] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[country_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_email_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[append_email_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[append_email] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_phone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[append_phone_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[append_country_prefix] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[append_area_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[append_phone] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[append_extension] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[country_prefix] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[area_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[extension] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[row_number] [int] NULL,
	[data_type] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[marketing_score] [decimal](15, 4) NULL
) ON [PRIMARY]
GO
