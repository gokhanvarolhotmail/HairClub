/* CreateDate: 01/25/2010 11:09:10.100 , ModifyDate: 06/21/2012 10:04:45.277 */
GO
CREATE TABLE [dbo].[oncs_audit_checkpoint](
	[audit_checkpoint_id] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[audit_requester_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[transaction_date] [datetime] NOT NULL,
	[transaction_order] [int] NOT NULL,
	[audit_client_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_oncs_audit_checkpoint] PRIMARY KEY CLUSTERED
(
	[audit_checkpoint_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncs_audit_checkpoint]  WITH NOCHECK ADD  CONSTRAINT [audit_client_audit_checkp_1189] FOREIGN KEY([audit_client_id])
REFERENCES [dbo].[oncs_audit_client] ([audit_client_id])
GO
ALTER TABLE [dbo].[oncs_audit_checkpoint] CHECK CONSTRAINT [audit_client_audit_checkp_1189]
GO
ALTER TABLE [dbo].[oncs_audit_checkpoint]  WITH NOCHECK ADD  CONSTRAINT [audit_reques_audit_checkp_1187] FOREIGN KEY([audit_requester_id])
REFERENCES [dbo].[oncs_audit_requester] ([audit_requester_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncs_audit_checkpoint] CHECK CONSTRAINT [audit_reques_audit_checkp_1187]
GO
