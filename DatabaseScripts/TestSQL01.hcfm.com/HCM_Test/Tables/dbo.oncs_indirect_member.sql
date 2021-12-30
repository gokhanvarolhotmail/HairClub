/* CreateDate: 01/18/2005 09:34:19.043 , ModifyDate: 06/21/2012 10:04:45.343 */
GO
CREATE TABLE [dbo].[oncs_indirect_member](
	[transaction_date] [datetime] NOT NULL,
	[transaction_order] [int] NOT NULL,
	[indirect_date] [datetime] NOT NULL,
	[indirect_order] [int] NOT NULL,
	[is_original_action] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [pk_oncs_indirect_member] PRIMARY KEY CLUSTERED
(
	[transaction_date] ASC,
	[transaction_order] ASC,
	[indirect_date] ASC,
	[indirect_order] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncs_indirect_member]  WITH CHECK ADD  CONSTRAINT [indirect_indirect_mem_302] FOREIGN KEY([indirect_date], [indirect_order])
REFERENCES [dbo].[oncs_indirect] ([indirect_date], [indirect_order])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncs_indirect_member] CHECK CONSTRAINT [indirect_indirect_mem_302]
GO
ALTER TABLE [dbo].[oncs_indirect_member]  WITH CHECK ADD  CONSTRAINT [transaction_indirect_mem_303] FOREIGN KEY([transaction_date], [transaction_order])
REFERENCES [dbo].[oncs_transaction] ([transaction_date], [transaction_order])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncs_indirect_member] CHECK CONSTRAINT [transaction_indirect_mem_303]
GO
