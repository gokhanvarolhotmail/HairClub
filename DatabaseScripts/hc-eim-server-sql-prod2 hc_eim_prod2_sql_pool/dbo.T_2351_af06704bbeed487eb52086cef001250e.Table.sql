/****** Object:  Table [dbo].[T_2351_af06704bbeed487eb52086cef001250e]    Script Date: 3/4/2022 8:28:31 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_2351_af06704bbeed487eb52086cef001250e]
(
	[FactDate] [datetime2](7) NULL,
	[FactTimeKey] [int] NULL,
	[FactDateKey] [int] NULL,
	[AppointmentDate] [datetime2](7) NULL,
	[AppointmentTimeKey] [int] NULL,
	[AppointmentDateKey] [int] NULL,
	[LeadKey] [int] NULL,
	[LeadId] [nvarchar](max) NULL,
	[AccountKey] [int] NULL,
	[AccountId] [nvarchar](max) NULL,
	[ContactKey] [int] NULL,
	[ContactId] [nvarchar](max) NULL,
	[ParentRecordType] [nvarchar](max) NULL,
	[WorkTypeKey] [int] NULL,
	[WorkTypeId] [nvarchar](max) NULL,
	[AccountAddress] [nvarchar](max) NULL,
	[AccountCity] [nvarchar](max) NULL,
	[AccountState] [nvarchar](max) NULL,
	[AccountPostalCode] [nvarchar](max) NULL,
	[AccountCountry] [nvarchar](max) NULL,
	[GeographyKey] [int] NULL,
	[AppointmentDescription] [nvarchar](max) NULL,
	[AppointmentStatus] [nvarchar](max) NULL,
	[CenterKey] [int] NULL,
	[ServiceTerritoryId] [nvarchar](max) NULL,
	[CenterNumber] [int] NULL,
	[AppointmentTypeKey] [int] NULL,
	[AppointmentType] [nvarchar](max) NULL,
	[AppointmentCenterType] [nvarchar](max) NULL,
	[ExternalId] [nvarchar](max) NULL,
	[ServiceAppointment] [nvarchar](max) NULL,
	[MeetingPlatformKey] [int] NULL,
	[MeetingPlatformId] [nvarchar](max) NULL,
	[MeetingPlatform] [nvarchar](max) NULL,
	[DWH_LoadDate] [datetime2](7) NULL,
	[DWH_LastUpdateDate] [datetime2](7) NULL,
	[AppointmentId] [nvarchar](max) NULL,
	[r5fdace7970704d47a8851cb7b43523f9] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
