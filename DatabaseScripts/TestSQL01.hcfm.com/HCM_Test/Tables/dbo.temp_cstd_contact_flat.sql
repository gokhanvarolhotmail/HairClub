/* CreateDate: 09/26/2014 21:11:54.040 , ModifyDate: 09/10/2019 22:39:13.247 */
GO
CREATE TABLE [dbo].[temp_cstd_contact_flat](
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
 CONSTRAINT [PK_temp_cstd_contact_flat] PRIMARY KEY CLUSTERED
(
	[contact_flat_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = PAGE) ON [PRIMARY]
) ON [PRIMARY]
GO