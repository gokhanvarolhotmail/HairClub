/* CreateDate: 12/19/2006 09:11:08.620 , ModifyDate: 12/19/2006 09:11:08.620 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[csta_closed](
	[territory] [char](6) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[day] [int] NOT NULL,
	[start_time] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[end_time] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[increments] [char](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[max_appt] [int] NULL,
	[closed_] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
