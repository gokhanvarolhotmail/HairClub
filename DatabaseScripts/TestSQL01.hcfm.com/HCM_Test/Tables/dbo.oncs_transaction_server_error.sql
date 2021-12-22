/* CreateDate: 06/01/2005 12:54:54.843 , ModifyDate: 06/21/2012 10:04:33.447 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncs_transaction_server_error](
	[transaction_date] [datetime] NOT NULL,
	[transaction_order] [int] NOT NULL,
	[server_id] [int] NOT NULL,
	[error_number] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[notes] [nvarchar](3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncs_transaction_server_error] PRIMARY KEY CLUSTERED
(
	[transaction_date] ASC,
	[transaction_order] ASC,
	[server_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncs_transaction_server_error]  WITH CHECK ADD  CONSTRAINT [transaction__transaction__397] FOREIGN KEY([transaction_date], [server_id], [transaction_order])
REFERENCES [dbo].[oncs_transaction_server] ([transaction_date], [server_id], [transaction_order])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncs_transaction_server_error] CHECK CONSTRAINT [transaction__transaction__397]
GO
