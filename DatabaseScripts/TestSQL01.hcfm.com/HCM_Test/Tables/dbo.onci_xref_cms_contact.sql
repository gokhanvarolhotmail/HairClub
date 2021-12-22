/* CreateDate: 02/09/2007 12:30:56.320 , ModifyDate: 01/25/2010 11:08:55.190 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[onci_xref_cms_contact](
	[xref_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[s_recordid] [int] NULL,
	[t_contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
