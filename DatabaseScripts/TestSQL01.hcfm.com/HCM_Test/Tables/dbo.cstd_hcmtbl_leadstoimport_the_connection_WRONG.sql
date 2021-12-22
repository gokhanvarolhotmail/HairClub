/* CreateDate: 09/04/2007 09:40:45.633 , ModifyDate: 09/04/2007 09:40:45.650 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cstd_hcmtbl_leadstoimport_the_connection_WRONG](
	[hcmtbl_leadstoimport_the_connection_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[result_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[source_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[promotion_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[action_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[territory] [nchar](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[creation_time] [datetime] NULL,
	[first_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_1] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_2] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[city] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[state_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[zip_code] [nchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone_02] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[appointment_date] [datetime] NULL,
	[appointment_time] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[gender_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[age_range_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[hair_loss_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cst_sessionid] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_affiliateid] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[alt_center] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_loginid] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
