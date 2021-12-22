/* CreateDate: 08/10/2006 13:45:08.127 , ModifyDate: 08/10/2006 13:45:08.127 */
GO
CREATE TABLE [dbo].[Appointments_Scheduled](
	[Center] [int] NULL,
	[ApptDate] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ApptTime] [char](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Appts] [int] NULL
) ON [PRIMARY]
GO
