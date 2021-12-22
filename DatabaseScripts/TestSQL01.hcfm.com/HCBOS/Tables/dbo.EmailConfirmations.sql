/* CreateDate: 09/24/2007 16:09:32.553 , ModifyDate: 09/24/2007 16:09:32.583 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmailConfirmations](
	[recordid] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[appt_date] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[appt_time] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[territory] [varchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[contact_fname] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[email] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[center] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address1] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[address2] [varchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[city] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[state] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[zip] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[phone] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Maplink] [varchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[type] [char](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
