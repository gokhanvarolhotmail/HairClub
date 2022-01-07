/****** Object:  Table [dbo].[FactAppointment]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactAppointment]
(
	[AppointmentId] [nvarchar](2048) NULL,
	[FactDate] [datetime] NULL,
	[FactTimeKey] [int] NULL,
	[FactDateKey] [int] NULL,
	[AppointmentDate] [datetime] NULL,
	[AppointmentTimeKey] [int] NULL,
	[AppointmentDateKey] [int] NULL,
	[LeadKey] [int] NULL,
	[LeadId] [nvarchar](2048) NULL,
	[AccountKey] [int] NULL,
	[AccountId] [nvarchar](2048) NULL,
	[ContactKey] [int] NULL,
	[ContactId] [nvarchar](2048) NULL,
	[ParentRecordType] [nvarchar](2048) NULL,
	[WorkTypeKey] [int] NULL,
	[WorkTypeId] [nvarchar](2048) NULL,
	[AccountAddress] [nvarchar](2048) NULL,
	[AccountCity] [nvarchar](2048) NULL,
	[AccountState] [nvarchar](2048) NULL,
	[AccountPostalCode] [nvarchar](250) NULL,
	[AccountCountry] [nvarchar](2048) NULL,
	[GeographyKey] [int] NULL,
	[AppointmentDescription] [nvarchar](4000) NULL,
	[AppointmentStatus] [nvarchar](2048) NULL,
	[CenterKey] [int] NULL,
	[ServiceTerritoryId] [nvarchar](2048) NULL,
	[CenterNumber] [int] NULL,
	[AppointmentTypeKey] [int] NULL,
	[AppointmentType] [nvarchar](2048) NULL,
	[AppointmentCenterType] [nvarchar](2048) NULL,
	[ExternalId] [nvarchar](2048) NULL,
	[ServiceAppointment] [nvarchar](2048) NULL,
	[MeetingPlatformKey] [int] NULL,
	[MeetingPlatformId] [nvarchar](2048) NULL,
	[MeetingPlatform] [nvarchar](2048) NULL,
	[DWH_LoadDate] [datetime] NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[SourceSystem] [nvarchar](2048) NULL,
	[IsDeleted] [bit] NULL,
	[BeBackFlag] [bit] NULL,
	[IsOld] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
