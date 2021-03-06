/****** Object:  Table [ODS].[CNCT_datAppointment]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_datAppointment]
(
	[AppointmentGUID] [uniqueidentifier] NOT NULL,
	[AppointmentID_Temp] [int] NULL,
	[ClientGUID] [uniqueidentifier] NULL,
	[ClientMembershipGUID] [uniqueidentifier] NULL,
	[ParentAppointmentGUID] [uniqueidentifier] NULL,
	[CenterID] [int] NULL,
	[ClientHomeCenterID] [int] NULL,
	[ResourceID] [int] NULL,
	[ConfirmationTypeID] [int] NULL,
	[AppointmentTypeID] [int] NULL,
	[AppointmentDate] [date] NULL,
	[StartTime] [time](0) NULL,
	[EndTime] [time](0) NULL,
	[CheckinTime] [datetime] NULL,
	[CheckoutTime] [datetime] NULL,
	[AppointmentSubject] [nvarchar](500) NULL,
	[CanPrintCommentFlag] [bit] NULL,
	[IsNonAppointmentFlag] [bit] NULL,
	[RecurrenceRule] [varchar](1024) NULL,
	[StartDateTimeCalc] [datetime] NULL,
	[EndDateTimeCalc] [datetime] NULL,
	[AppointmentDurationCalc] [time](0) NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) NULL,
	[UpdateStamp] [varchar](1) NULL,
	[AppointmentStatusID] [int] NULL,
	[IsDeletedFlag] [bit] NULL,
	[OnContactActivityID] [nchar](10) NULL,
	[OnContactContactID] [nchar](10) NULL,
	[CheckedInFlag] [bit] NULL,
	[IsAuthorizedFlag] [bit] NOT NULL,
	[LastChangeUser] [nvarchar](25) NOT NULL,
	[LastChangeDate] [datetime] NOT NULL,
	[ScalpHealthID] [int] NULL,
	[AppointmentPriorityColorID] [int] NULL,
	[CompletedVisitTypeID] [int] NULL,
	[IsFullTrichoView] [bit] NOT NULL,
	[SalesforceContactID] [nvarchar](18) NULL,
	[SalesforceTaskID] [nvarchar](18) NULL,
	[KorvueID] [int] NULL,
	[ServiceStartTime] [datetime] NULL,
	[ServiceEndTime] [datetime] NULL,
	[IsClientContactInformationConfirmed] [bit] NULL
)
WITH
(
	DISTRIBUTION = HASH ( [SalesforceTaskID] ),
	CLUSTERED COLUMNSTORE INDEX
)
GO
