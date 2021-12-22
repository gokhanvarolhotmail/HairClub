/* CreateDate: 01/09/2007 17:07:14.647 , ModifyDate: 01/09/2007 17:07:14.647 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[hcmtbl_leads_unqualified](
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[first_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL,
	[created_by_user_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone_number] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_1] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address_line_2] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[city] [nchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[state_code] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[zip_code] [nchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
