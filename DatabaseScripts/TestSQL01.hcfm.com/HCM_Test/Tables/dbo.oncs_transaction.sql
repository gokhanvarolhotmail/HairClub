/* CreateDate: 07/13/2005 16:58:17.770 , ModifyDate: 06/21/2012 10:04:33.313 */
GO
CREATE TABLE [dbo].[oncs_transaction](
	[transaction_date] [datetime] NOT NULL,
	[transaction_order] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[table_name] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[sql_action_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[transaction_type_code] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[creation_date] [datetime] NOT NULL,
	[key_data] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[original_transaction_date] [datetime] NULL,
 CONSTRAINT [pk_oncs_transaction] PRIMARY KEY CLUSTERED
(
	[transaction_date] ASC,
	[transaction_order] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
CREATE NONCLUSTERED INDEX [oncs_transaction_i2] ON [dbo].[oncs_transaction]
(
	[key_data] ASC,
	[table_name] ASC,
	[original_transaction_date] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
