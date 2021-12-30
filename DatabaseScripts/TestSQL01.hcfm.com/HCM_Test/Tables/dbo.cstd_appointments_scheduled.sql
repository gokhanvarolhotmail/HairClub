/* CreateDate: 01/04/2007 10:34:28.343 , ModifyDate: 01/04/2007 10:34:28.343 */
GO
CREATE TABLE [dbo].[cstd_appointments_scheduled](
	[Center] [int] NULL,
	[ApptDate] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ApptTime] [char](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Appts] [int] NULL
) ON [PRIMARY]
GO
