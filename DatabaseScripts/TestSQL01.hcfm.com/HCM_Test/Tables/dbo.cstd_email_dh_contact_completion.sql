/* CreateDate: 06/20/2012 11:34:07.290 , ModifyDate: 06/21/2012 10:11:47.017 */
GO
CREATE TABLE [dbo].[cstd_email_dh_contact_completion](
	[contact_completion_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[creation_date] [datetime] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [cstd_email_dh_contact_completion_i1] ON [dbo].[cstd_email_dh_contact_completion]
(
	[contact_id] ASC
)
INCLUDE([contact_completion_id]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
