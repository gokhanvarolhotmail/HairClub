/* CreateDate: 01/26/2015 12:06:46.587 , ModifyDate: 01/26/2015 12:06:46.587 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AppointmentsUpdatedToCorrectClientMembership](
	[AppointmentGUID] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OldClientMembershipGUID] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NewClientmMembershipGUID] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OldClientHomeCenterID] [int] NULL,
	[NewClientHomeCenterID] [int] NULL,
	[LogCreateDate] [datetime] NULL,
	[TFSUser] [varchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
