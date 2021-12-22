/* CreateDate: 01/11/2007 17:11:29.057 , ModifyDate: 01/11/2007 17:11:29.057 */
GO
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cst_hcmtbl_leads_duplicated](
	[mynewid] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[first_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[last_name] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
