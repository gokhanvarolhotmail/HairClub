/* CreateDate: 08/26/2019 10:57:54.593 , ModifyDate: 08/26/2019 10:57:54.853 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[datClientTrackingPlan](
	[ClientTrackingPlanID] [int] IDENTITY(1,1) NOT NULL,
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[DayOfWeekID] [int] NOT NULL,
	[IsEXTAMApplicable] [bit] NOT NULL,
	[IsEXTPMApplicable] [bit] NOT NULL,
	[IsLaserApplicable] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_datClientTrackingPlan] PRIMARY KEY CLUSTERED
(
	[ClientTrackingPlanID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[datClientTrackingPlan]  WITH CHECK ADD  CONSTRAINT [FK_datClientTrackingPlan_datClient] FOREIGN KEY([ClientGUID])
REFERENCES [dbo].[datClient] ([ClientGUID])
GO
ALTER TABLE [dbo].[datClientTrackingPlan] CHECK CONSTRAINT [FK_datClientTrackingPlan_datClient]
GO
ALTER TABLE [dbo].[datClientTrackingPlan]  WITH CHECK ADD  CONSTRAINT [FK_datClientTrackingPlan_lkpDayOfWeek] FOREIGN KEY([DayOfWeekID])
REFERENCES [dbo].[lkpDayOfWeek] ([DayOfWeekID])
GO
ALTER TABLE [dbo].[datClientTrackingPlan] CHECK CONSTRAINT [FK_datClientTrackingPlan_lkpDayOfWeek]
GO
