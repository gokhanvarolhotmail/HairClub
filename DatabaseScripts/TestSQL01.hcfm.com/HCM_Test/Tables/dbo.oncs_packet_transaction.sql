/* CreateDate: 06/01/2005 12:54:54.750 , ModifyDate: 06/21/2012 10:04:45.400 */
GO
CREATE TABLE [dbo].[oncs_packet_transaction](
	[packet_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[transaction_date] [datetime] NOT NULL,
	[transaction_order] [int] NOT NULL,
	[transaction_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_oncs_packet_transaction] PRIMARY KEY CLUSTERED
(
	[packet_id] ASC,
	[transaction_date] ASC,
	[transaction_order] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncs_packet_transaction]  WITH CHECK ADD  CONSTRAINT [packet_packet_trans_376] FOREIGN KEY([packet_id])
REFERENCES [dbo].[oncs_packet] ([packet_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncs_packet_transaction] CHECK CONSTRAINT [packet_packet_trans_376]
GO
ALTER TABLE [dbo].[oncs_packet_transaction]  WITH CHECK ADD  CONSTRAINT [transaction_packet_trans_377] FOREIGN KEY([transaction_date], [transaction_order])
REFERENCES [dbo].[oncs_transaction] ([transaction_date], [transaction_order])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncs_packet_transaction] CHECK CONSTRAINT [transaction_packet_trans_377]
GO
