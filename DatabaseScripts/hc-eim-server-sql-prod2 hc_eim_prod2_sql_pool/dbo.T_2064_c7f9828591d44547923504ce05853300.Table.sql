/****** Object:  Table [dbo].[T_2064_c7f9828591d44547923504ce05853300]    Script Date: 3/3/2022 9:01:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T_2064_c7f9828591d44547923504ce05853300]
(
	[FactDate] [datetime2](7) NULL,
	[AppointmentId] [nvarchar](max) NULL,
	[FactTimeKey] [int] NULL,
	[FactDateKey] [int] NULL,
	[AppointmentDate] [datetime2](7) NULL,
	[AppointmentTimeKey] [int] NULL,
	[AppointmentDateKey] [int] NULL,
	[LeadKey] [int] NULL,
	[AccountKey] [int] NULL,
	[AccountId] [nvarchar](max) NULL,
	[ContactKey] [int] NULL,
	[ContactId] [nvarchar](max) NULL,
	[ParentRecordType] [nvarchar](max) NULL,
	[ParentRecordId] [nvarchar](max) NULL,
	[LeadId] [nvarchar](max) NULL,
	[CenterKey] [int] NULL,
	[CenterNumber] [int] NULL,
	[WorkTypeKey] [int] NULL,
	[WorkTypeId] [nvarchar](max) NULL,
	[AccountCity] [nvarchar](max) NULL,
	[AccountState] [nvarchar](max) NULL,
	[AccountPostalCode] [nvarchar](max) NULL,
	[AccountCountry] [nvarchar](max) NULL,
	[GeographyKey] [int] NULL,
	[AppointmentDescription] [nvarchar](max) NULL,
	[AppointmentStatus] [nvarchar](max) NULL,
	[ServiceTerritoryId] [nvarchar](max) NULL,
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
	[StatusKey] [int] NULL,
	[IsOld] [int] NULL,
	[AppoinmentStatusCategory] [nvarchar](max) NULL,
	[IsDeleted] [bit] NULL,
	[OpportunityDate] [datetime2](7) NULL,
	[OpportunityId] [nvarchar](max) NULL,
	[OpportunityStatus] [nvarchar](max) NULL,
	[OpportunityReferralCode] [nvarchar](max) NULL,
	[OpportunityReferralCodeExpirationDate] [datetime2](7) NULL,
	[OpportunityAmmount] [decimal](38, 18) NULL,
	[r258af5485c484bf4b7268ebea58b3c02] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
