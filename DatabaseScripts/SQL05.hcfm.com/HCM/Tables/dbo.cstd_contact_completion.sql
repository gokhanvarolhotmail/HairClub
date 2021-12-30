/* CreateDate: 01/03/2018 16:31:35.040 , ModifyDate: 09/26/2019 21:42:14.927 */
GO
CREATE TABLE [dbo].[cstd_contact_completion](
	[contact_completion_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[company_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[updated_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sale_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sale_type_description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[show_no_show_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sale_no_sale_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contract_number] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contract_amount] [decimal](15, 4) NULL,
	[client_number] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[initial_payment] [decimal](15, 4) NULL,
	[systems] [int] NULL,
	[services] [int] NULL,
	[number_of_graphs] [int] NULL,
	[original_appointment_date] [datetime] NULL,
	[date_saved] [datetime] NULL,
	[status_line] [nvarchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[head_size] [nvarchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[base_price] [decimal](15, 4) NULL,
	[discount_amount] [decimal](15, 4) NULL,
	[discount_percentage] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[balance_amount] [decimal](15, 4) NULL,
	[balance_percentage] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[hair_length] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[reschedule_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[date_rescheduled] [datetime] NULL,
	[time_rescheduled] [datetime] NULL,
	[discount_markup_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[comment] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[followup_result_id] [int] NULL,
	[followup_result] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[surgery_offered_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[referred_to_doctor_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[updated_date] [datetime] NULL,
	[activity_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[length_price] [decimal](15, 4) NULL,
	[surgery_consultation_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_cstd_contact_completion] PRIMARY KEY CLUSTERED
(
	[contact_completion_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC] TEXTIMAGE_ON [FG_CDC]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [IX_cstd_contact_completion_activity_id] ON [dbo].[cstd_contact_completion]
(
	[activity_id] ASC
)
INCLUDE([sale_type_description]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
GO
