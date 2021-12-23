/* CreateDate: 06/01/2005 12:54:54.843 , ModifyDate: 06/21/2012 10:04:45.273 */
GO
CREATE TABLE [dbo].[oncs_apply_condition](
	[condition_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[server_id] [int] NOT NULL,
	[table_name] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[reject_insert] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[reject_update] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[reject_delete] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[survivor_on_insert] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[survivor_on_update] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[keyname_to_generate] [nchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[generate_type] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[generate_length] [int] NULL,
 CONSTRAINT [pk_oncs_apply_condition] PRIMARY KEY CLUSTERED
(
	[condition_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncs_apply_condition]  WITH CHECK ADD  CONSTRAINT [condition_apply_condit_879] FOREIGN KEY([condition_id])
REFERENCES [dbo].[onca_condition] ([condition_id])
GO
ALTER TABLE [dbo].[oncs_apply_condition] CHECK CONSTRAINT [condition_apply_condit_879]
GO
ALTER TABLE [dbo].[oncs_apply_condition]  WITH CHECK ADD  CONSTRAINT [server_apply_condit_396] FOREIGN KEY([server_id])
REFERENCES [dbo].[oncs_server] ([server_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncs_apply_condition] CHECK CONSTRAINT [server_apply_condit_396]
GO
