/* CreateDate: 06/07/2005 10:44:29.127 , ModifyDate: 06/21/2012 10:04:45.397 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[oncs_packet_error](
	[packet_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[error_number] [nchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[description] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[notes] [nvarchar](3000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_oncs_packet_error] PRIMARY KEY CLUSTERED
(
	[packet_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[oncs_packet_error]  WITH CHECK ADD  CONSTRAINT [packet_packet_error_402] FOREIGN KEY([packet_id])
REFERENCES [dbo].[oncs_packet] ([packet_id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[oncs_packet_error] CHECK CONSTRAINT [packet_packet_error_402]
GO
