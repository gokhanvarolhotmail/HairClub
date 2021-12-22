/* CreateDate: 03/01/2006 08:13:59.523 , ModifyDate: 06/21/2012 10:04:33.300 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncs_task_server_error](
	[task_server_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[error_number] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[note] [nvarchar](3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK_oncs_task_server_error] PRIMARY KEY CLUSTERED
(
	[task_server_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncs_task_server_error]  WITH CHECK ADD  CONSTRAINT [task_server_task_server__408] FOREIGN KEY([task_server_id])
REFERENCES [dbo].[oncs_task_server] ([task_server_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncs_task_server_error] CHECK CONSTRAINT [task_server_task_server__408]
GO
