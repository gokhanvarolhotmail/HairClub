/****** Object:  Table [dbo].[FactAppointment]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactAppointment]
(
	[FactDate] [datetime] NULL,
	[FactTimeKey] [int] NULL,
	[FactDateKey] [int] NULL,
	[AppointmentDate] [datetime] NULL,
	[AppointmentTimeKey] [int] NULL,
	[AppointmentDateKey] [int] NULL,
	[LeadKey] [int] NULL,
	[LeadId] [varchar](50) NULL,
	[AccountKey] [int] NULL,
	[AccountId] [varchar](50) NULL,
	[ContactKey] [int] NULL,
	[ContactId] [varchar](50) NULL,
	[ParentRecordType] [varchar](100) NULL,
	[WorkTypeKey] [int] NULL,
	[WorkTypeId] [varchar](50) NULL,
	[AccountAddress] [varchar](100) NULL,
	[AccountCity] [varchar](100) NULL,
	[AccountState] [varchar](100) NULL,
	[AccountPostalCode] [varchar](100) NULL,
	[AccountCountry] [varchar](100) NULL,
	[GeographyKey] [int] NULL,
	[AppointmentDescription] [varchar](8000) NULL,
	[AppointmentStatus] [varchar](100) NULL,
	[CenterKey] [int] NULL,
	[ServiceTerritoryId] [varchar](50) NULL,
	[CenterNumber] [int] NULL,
	[AppointmentTypeKey] [int] NULL,
	[AppointmentType] [varchar](100) NULL,
	[AppointmentCenterType] [varchar](100) NULL,
	[ExternalId] [varchar](50) NULL,
	[ServiceAppointment] [varchar](100) NULL,
	[MeetingPlatformKey] [int] NULL,
	[MeetingPlatformId] [varchar](50) NULL,
	[MeetingPlatform] [varchar](100) NULL,
	[DWH_LoadDate] [datetime] NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[ParentRecordId] [nvarchar](100) NULL,
	[AppointmentId] [varchar](50) NULL,
	[ExternalTaskId] [varchar](100) NULL,
	[StatusKey] [int] NULL,
	[CancellationReason] [nvarchar](2048) NULL,
	[BeBackFlag] [bit] NULL,
	[OldStatus] [varchar](1048) NULL,
	[AppoinmentStatusCategory] [varchar](1048) NULL,
	[IsDeleted] [bit] NULL,
	[IsOld] [int] NULL,
	[OpportunityId] [nvarchar](100) NULL,
	[OpportunityStatus] [nvarchar](500) NULL,
	[OpportunityDate] [datetime] NULL,
	[OpportunityReferralCode] [nvarchar](1024) NULL,
	[OpportunityReferralCodeExpirationDate] [datetime] NULL,
	[OpportunityAmmount] [numeric](38, 18) NULL,
	[Performer] [varchar](200) NULL,
	[performerKey] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
