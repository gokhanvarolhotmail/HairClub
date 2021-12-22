/* CreateDate: 01/18/2005 09:34:19.700 , ModifyDate: 06/21/2012 10:04:33.437 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncs_transaction_server](
	[transaction_date] [datetime] NOT NULL,
	[transaction_order] [int] NOT NULL,
	[server_id] [int] NOT NULL,
	[transaction_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[packet_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncs_transaction_server] PRIMARY KEY CLUSTERED
(
	[transaction_date] ASC,
	[server_id] ASC,
	[transaction_order] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncs_transaction_server] ADD  CONSTRAINT [DF__oncs_tran__trans__4C0144E4]  DEFAULT ('NEW') FOR [transaction_status_code]
GO
ALTER TABLE [dbo].[oncs_transaction_server]  WITH CHECK ADD  CONSTRAINT [server_transaction__900] FOREIGN KEY([server_id])
REFERENCES [dbo].[oncs_server] ([server_id])
GO
ALTER TABLE [dbo].[oncs_transaction_server] CHECK CONSTRAINT [server_transaction__900]
GO
ALTER TABLE [dbo].[oncs_transaction_server]  WITH CHECK ADD  CONSTRAINT [transaction_transaction__305] FOREIGN KEY([transaction_date], [transaction_order])
REFERENCES [dbo].[oncs_transaction] ([transaction_date], [transaction_order])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncs_transaction_server] CHECK CONSTRAINT [transaction_transaction__305]
GO
