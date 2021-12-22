/* CreateDate: 01/25/2010 11:09:10.177 , ModifyDate: 06/21/2012 10:04:45.333 */
GO
CREATE TABLE [dbo].[oncs_audit_requester](
	[audit_requester_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[get_inserted] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[get_updated] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[get_deleted] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_oncs_audit_requester] PRIMARY KEY CLUSTERED
(
	[audit_requester_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncs_audit_requester] ADD  DEFAULT ('Y') FOR [get_inserted]
GO
ALTER TABLE [dbo].[oncs_audit_requester] ADD  DEFAULT ('Y') FOR [get_updated]
GO
ALTER TABLE [dbo].[oncs_audit_requester] ADD  DEFAULT ('Y') FOR [get_deleted]
GO
