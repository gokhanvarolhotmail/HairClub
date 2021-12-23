/* CreateDate: 03/01/2006 08:13:59.773 , ModifyDate: 06/21/2012 10:04:33.283 */
GO
CREATE TABLE [dbo].[oncs_task_apply_error](
	[packet_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[task_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[error_number] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[error_description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[error_text] [nvarchar](2000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_oncs_packet_task_appy_error] PRIMARY KEY CLUSTERED
(
	[task_id] ASC,
	[packet_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncs_task_apply_error]  WITH NOCHECK ADD  CONSTRAINT [task_apply_task_apply_e_407] FOREIGN KEY([packet_id], [task_id])
REFERENCES [dbo].[oncs_task_apply] ([packet_id], [task_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncs_task_apply_error] CHECK CONSTRAINT [task_apply_task_apply_e_407]
GO
