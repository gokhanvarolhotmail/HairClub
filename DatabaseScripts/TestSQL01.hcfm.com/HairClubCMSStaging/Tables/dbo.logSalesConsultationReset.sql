/* CreateDate: 02/12/2018 17:14:29.283 , ModifyDate: 07/30/2018 05:35:55.163 */
GO
CREATE TABLE [dbo].[logSalesConsultationReset](
	[SalesConsultationResetID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[AppointmentGUID] [uniqueidentifier] NULL,
	[AppointmentAction] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[SalesforceTaskID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesforceContactID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterID] [int] NOT NULL,
	[ResultCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsCheckedIn] [bit] NOT NULL,
	[IsCheckedOut] [bit] NOT NULL,
	[IsTrichoViewCompleted] [bit] NOT NULL,
	[IsMoneyCollected] [bit] NOT NULL,
	[AppointmentCreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AppointmentLastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
 CONSTRAINT [PK_logSalesConsultationReset] PRIMARY KEY CLUSTERED
(
	[SalesConsultationResetID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[logSalesConsultationReset]  WITH NOCHECK ADD  CONSTRAINT [FK_logSalesConsultationReset_datAppointment] FOREIGN KEY([AppointmentGUID])
REFERENCES [dbo].[datAppointment] ([AppointmentGUID])
GO
ALTER TABLE [dbo].[logSalesConsultationReset] CHECK CONSTRAINT [FK_logSalesConsultationReset_datAppointment]
GO
