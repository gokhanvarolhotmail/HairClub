/* CreateDate: 06/01/2005 12:54:54.750 , ModifyDate: 06/21/2012 10:04:33.373 */
GO
CREATE TABLE [dbo].[oncs_transaction_apply](
	[packet_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[transaction_date] [datetime] NOT NULL,
	[transaction_order] [int] NOT NULL,
	[transaction_status_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sort_order] [int] NOT NULL,
	[table_name] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[sql_action_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[key_data] [nchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[acknowledged_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncs_transaction_apply] PRIMARY KEY CLUSTERED
(
	[packet_id] ASC,
	[transaction_date] ASC,
	[transaction_order] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncs_transaction_apply]  WITH CHECK ADD  CONSTRAINT [action_transaction_897] FOREIGN KEY([sql_action_code])
REFERENCES [dbo].[onca_action] ([action_code])
GO
ALTER TABLE [dbo].[oncs_transaction_apply] CHECK CONSTRAINT [action_transaction_897]
GO
ALTER TABLE [dbo].[oncs_transaction_apply]  WITH CHECK ADD  CONSTRAINT [packet_transaction__387] FOREIGN KEY([packet_id])
REFERENCES [dbo].[oncs_packet] ([packet_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncs_transaction_apply] CHECK CONSTRAINT [packet_transaction__387]
GO
