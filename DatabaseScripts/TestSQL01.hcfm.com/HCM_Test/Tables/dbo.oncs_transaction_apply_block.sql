/* CreateDate: 06/01/2005 12:54:54.830 , ModifyDate: 06/21/2012 10:04:33.413 */
GO
CREATE TABLE [dbo].[oncs_transaction_apply_block](
	[server_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[table_name] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sql_action_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[key_data] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[original_transaction_date] [datetime] NOT NULL,
 CONSTRAINT [pk_oncs_transaction_apply_block] PRIMARY KEY CLUSTERED
(
	[server_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
