/* CreateDate: 09/17/2014 10:04:08.380 , ModifyDate: 09/10/2019 22:46:42.890 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cstd_contact_flat](
	[contact_flat_id] [uniqueidentifier] NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[first_name] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_name] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[city] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[state_description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[zip_code] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[time_zone_code] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_country_code_prefix] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_area_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_phone_number] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_phone_type_description] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[business_country_code_prefix] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[business_area_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[business_phone_number] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[business_phone_type_description] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[home_country_code_prefix] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[home_area_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[home_phone_number] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[home_phone_type_description] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cell_country_code_prefix] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cell_area_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cell_phone_number] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cell_phone_type_description] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[home_2_country_code_prefix] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[home_2_area_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[home_2_phone_number] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[home_2_phone_type_description] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_center_number] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_center_name] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[age_range_description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[hair_loss_alternative_description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[language_description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[gender_description] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_source_description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[current_source_description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[promotion_description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[lead_creation_date] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_activity_date] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_activity_result_description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[open_call_activity_id] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[open_call_action_description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[open_call_due_date] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[open_call_start_time] [nvarchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[current_appointment_date] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[current_appointment_time] [nvarchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_appointment_date] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_appointment_result_description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[total_appointments] [int] NULL,
	[no_show_appointments] [int] NULL,
	[show_sale_appointments] [int] NULL,
	[canceled_appointments] [int] NULL,
	[rescheduled_appointments] [int] NULL,
	[current_appointment_type] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[lead_created_by_display_name] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[confirmation_call_activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[do_not_solicit] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[do_not_call] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_address_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_phone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[business_phone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[home_phone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cell_phone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[home_2_phone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[secondary_country_code_prefix] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[secondary_area_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[secondary_phone_number] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[secondary_phone_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[secondary_phone_type_description] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[secondary_phone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[primary_phone_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[call_country_code_prefix] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[call_area_code] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[call_phone_number] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[call_phone_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[call_phone_type_description] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[call_phone_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[has_open_confirmation_call] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_cstd_contact_flat] PRIMARY KEY CLUSTERED
(
	[contact_flat_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE UNIQUE NONCLUSTERED INDEX [cstd_contact_flat_i2] ON [dbo].[cstd_contact_flat]
(
	[contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_contact_flat] ADD  CONSTRAINT [DF_cstd_contact_flat_contact_flat_id]  DEFAULT (newsequentialid()) FOR [contact_flat_id]
GO
