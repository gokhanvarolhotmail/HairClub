/* CreateDate: 04/28/2008 09:44:24.470 , ModifyDate: 06/21/2012 10:11:08.707 */
GO
CREATE TABLE [dbo].[cstd_appointment_matrix_ftp](
	[appointment_matrix_ftp_id] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ftp_site_address] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[root_folder] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[login_id] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[password_value] [nchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[active] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [PK__cstd_appointment__7B32CBC7] PRIMARY KEY CLUSTERED
(
	[appointment_matrix_ftp_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
