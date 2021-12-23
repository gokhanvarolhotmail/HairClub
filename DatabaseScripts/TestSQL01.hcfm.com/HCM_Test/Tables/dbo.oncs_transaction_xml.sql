/* CreateDate: 06/01/2005 13:04:51.340 , ModifyDate: 06/21/2012 10:04:33.447 */
GO
CREATE TABLE [dbo].[oncs_transaction_xml](
	[transaction_date] [datetime] NOT NULL,
	[transaction_order] [int] NOT NULL,
	[transaction_xml] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncs_transaction_xml] PRIMARY KEY CLUSTERED
(
	[transaction_date] ASC,
	[transaction_order] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncs_transaction_xml]  WITH CHECK ADD  CONSTRAINT [transaction_transaction__304] FOREIGN KEY([transaction_date], [transaction_order])
REFERENCES [dbo].[oncs_transaction] ([transaction_date], [transaction_order])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncs_transaction_xml] CHECK CONSTRAINT [transaction_transaction__304]
GO
