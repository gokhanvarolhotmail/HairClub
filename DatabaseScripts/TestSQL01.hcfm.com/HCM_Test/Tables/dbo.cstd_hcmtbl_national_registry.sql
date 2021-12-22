/* CreateDate: 11/29/2006 09:07:37.057 , ModifyDate: 06/21/2012 10:12:21.120 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cstd_hcmtbl_national_registry](
	[national_registry_id] [numeric](5, 0) NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[result_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sort_order] [int] NULL,
	[project_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[flag1] [nvarchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[flag2] [nvarchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[flag3] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[flag4] [nvarchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[updated_date] [datetime] NULL,
 CONSTRAINT [pk_cstd_hcmtbl_national_registry] PRIMARY KEY NONCLUSTERED
(
	[national_registry_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_hcmtbl_national_registry]  WITH CHECK ADD  CONSTRAINT [oncd_contact_cstd_hcmtbl_national_registry_811] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
GO
ALTER TABLE [dbo].[cstd_hcmtbl_national_registry] CHECK CONSTRAINT [oncd_contact_cstd_hcmtbl_national_registry_811]
GO
