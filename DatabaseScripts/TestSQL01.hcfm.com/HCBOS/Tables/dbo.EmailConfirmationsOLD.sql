/* CreateDate: 12/18/2006 15:40:01.890 , ModifyDate: 08/09/2007 14:18:13.373 */
GO
CREATE TABLE [dbo].[EmailConfirmationsOLD](
	[recordid] [int] NULL,
	[appt_date] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[appt_time] [varchar](7) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[territory] [char](6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_fname] [varchar](21) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email_] [char](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[center] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address1] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address2] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [varchar](35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State] [varchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Zip] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Maplink] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
