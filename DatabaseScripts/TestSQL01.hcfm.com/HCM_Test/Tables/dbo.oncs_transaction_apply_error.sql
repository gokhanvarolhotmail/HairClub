/* CreateDate: 06/01/2005 12:54:54.780 , ModifyDate: 06/21/2012 10:04:33.423 */
GO
CREATE TABLE [dbo].[oncs_transaction_apply_error](
	[transaction_date] [datetime] NOT NULL,
	[transaction_order] [int] NOT NULL,
	[packet_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[error_number] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[notes] [nvarchar](3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncs_transaction_apply_error] PRIMARY KEY CLUSTERED
(
	[transaction_date] ASC,
	[transaction_order] ASC,
	[packet_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncs_transaction_apply_error]  WITH CHECK ADD  CONSTRAINT [transaction__transaction__382] FOREIGN KEY([packet_id], [transaction_date], [transaction_order])
REFERENCES [dbo].[oncs_transaction_apply] ([packet_id], [transaction_date], [transaction_order])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncs_transaction_apply_error] CHECK CONSTRAINT [transaction__transaction__382]
GO
