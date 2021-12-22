/* CreateDate: 01/11/2007 17:11:29.450 , ModifyDate: 01/11/2007 17:11:29.450 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cst_hcmtbl_leads_unqualified](
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[first_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[area_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone_number] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_1] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_2] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[city] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[state_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[zip_code] [nchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_gender_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[cst_promotion_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[cst_complete_sale] [int] NULL
) ON [PRIMARY]
GO
