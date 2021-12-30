/* CreateDate: 05/05/2020 17:42:51.440 , ModifyDate: 05/05/2020 17:43:12.213 */
GO
CREATE TABLE [dbo].[datNotification](
	[NotificationID] [int] NOT NULL,
	[NotificationDate] [datetime] NOT NULL,
	[NotificationTypeID] [int] NOT NULL,
	[ClientGUID] [uniqueidentifier] NULL,
	[FeePayCycleID] [int] NULL,
	[FeeDate] [date] NULL,
	[CenterID] [int] NOT NULL,
	[IsAcknowledgedFlag] [bit] NOT NULL,
	[Description] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[AppointmentGUID] [uniqueidentifier] NULL,
	[IsHairOrderRequestedFlag] [bit] NOT NULL,
	[VisitingCenterID] [int] NULL,
 CONSTRAINT [PK_datNotification] PRIMARY KEY CLUSTERED
(
	[NotificationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
