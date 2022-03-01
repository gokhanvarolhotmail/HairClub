/****** Object:  Table [ODS].[T_2099_1fb8fea8d0214a35b7ec645b61070e2e]    Script Date: 3/1/2022 8:53:37 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[T_2099_1fb8fea8d0214a35b7ec645b61070e2e]
(
	[AppointmentGUID] [nvarchar](max) NULL,
	[AppointmentID_Temp] [int] NULL,
	[ClientGUID] [nvarchar](max) NULL,
	[ClientMembershipGUID] [nvarchar](max) NULL,
	[ParentAppointmentGUID] [nvarchar](max) NULL,
	[CenterID] [int] NULL,
	[ClientHomeCenterID] [int] NULL,
	[ResourceID] [int] NULL,
	[ConfirmationTypeID] [int] NULL,
	[AppointmentTypeID] [int] NULL,
	[AppointmentDate] [date] NULL,
	[StartTime] [datetime2](7) NULL,
	[EndTime] [datetime2](7) NULL,
	[CheckinTime] [datetime2](7) NULL,
	[CheckoutTime] [datetime2](7) NULL,
	[AppointmentSubject] [nvarchar](max) NULL,
	[CanPrintCommentFlag] [bit] NULL,
	[IsNonAppointmentFlag] [bit] NULL,
	[RecurrenceRule] [nvarchar](max) NULL,
	[StartDateTimeCalc] [datetime2](7) NULL,
	[EndDateTimeCalc] [datetime2](7) NULL,
	[AppointmentDurationCalc] [datetime2](7) NULL,
	[CreateDate] [datetime2](7) NULL,
	[CreateUser] [nvarchar](max) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [nvarchar](max) NULL,
	[AppointmentStatusID] [int] NULL,
	[IsDeletedFlag] [bit] NULL,
	[OnContactActivityID] [nvarchar](max) NULL,
	[OnContactContactID] [nvarchar](max) NULL,
	[CheckedInFlag] [bit] NULL,
	[IsAuthorizedFlag] [bit] NULL,
	[LastChangeUser] [nvarchar](max) NULL,
	[LastChangeDate] [datetime2](7) NULL,
	[ScalpHealthID] [int] NULL,
	[AppointmentPriorityColorID] [int] NULL,
	[CompletedVisitTypeID] [int] NULL,
	[IsFullTrichoView] [bit] NULL,
	[SalesforceContactID] [nvarchar](max) NULL,
	[SalesforceTaskID] [nvarchar](max) NULL,
	[KorvueID] [int] NULL,
	[ServiceStartTime] [datetime2](7) NULL,
	[ServiceEndTime] [datetime2](7) NULL,
	[IsClientContactInformationConfirmed] [bit] NULL,
	[r2c0b2ff77d93445cafeec562ea06e80c] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
