/* CreateDate: 12/04/2015 10:57:02.577 , ModifyDate: 12/04/2015 10:57:02.577 */
GO
CREATE TABLE [dbo].[cstd_skip_trace_export_contact_list](
	[contact_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_cstd_skip_trace_export_contact_list] PRIMARY KEY CLUSTERED
(
	[contact_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
