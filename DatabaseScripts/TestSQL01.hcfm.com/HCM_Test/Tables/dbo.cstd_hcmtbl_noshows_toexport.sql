/* CreateDate: 12/20/2006 12:33:38.440 , ModifyDate: 06/21/2012 10:12:21.123 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cstd_hcmtbl_noshows_toexport](
	[noshows_toexport_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[firstname] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[lastname] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[center] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[apptdate] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[appttime] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[gender] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creative] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[type] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sendcount] [int] NULL,
	[centerid] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_cstd_hcmtbl_noshows_toexport] PRIMARY KEY NONCLUSTERED
(
	[noshows_toexport_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cstd_hcmtbl_noshows_toexport]  WITH CHECK ADD  CONSTRAINT [oncd_contact_cstd_hcmtbl_noshows_toexport_813] FOREIGN KEY([contact_id])
REFERENCES [dbo].[oncd_contact] ([contact_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[cstd_hcmtbl_noshows_toexport] CHECK CONSTRAINT [oncd_contact_cstd_hcmtbl_noshows_toexport_813]
GO
