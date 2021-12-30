/* CreateDate: 08/13/2021 16:26:08.010 , ModifyDate: 08/13/2021 16:26:08.010 */
GO
CREATE TABLE [Synapse_pool].[FactAppointmentTracking](
	[FactDate] [datetime] NULL,
	[FactTimeKey] [int] NULL,
	[FactDateKey] [int] NULL,
	[AppointmentDate] [datetime] NULL,
	[AppointmentTimeKey] [int] NULL,
	[AppointmentDateKey] [int] NULL,
	[LeadKey] [int] NULL,
	[LeadId] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccountKey] [int] NULL,
	[AccountId] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactKey] [int] NULL,
	[ContactId] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ParentRecordType] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WorkTypeKey] [int] NULL,
	[WorkTypeId] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccountAddress] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccountCity] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccountState] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccountPostalCode] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccountCountry] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GeographyKey] [int] NULL,
	[AppointmentDescription] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AppointmentStatus] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterKey] [int] NULL,
	[ServiceTerritoryId] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterNumber] [int] NULL,
	[AppointmentTypeKey] [int] NULL,
	[AppointmentType] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AppointmentCenterType] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExternalId] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceAppointment] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MeetingPlatformKey] [int] NULL,
	[MeetingPlatformId] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MeetingPlatform] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DWH_LoadDate] [datetime] NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[ParentRecordId] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AppointmentId] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExternalTaskId] [varchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StatusKey] [int] NULL,
	[CancellationReason] [nvarchar](2048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BeBackFlag] [bit] NULL,
	[OldStatus] [varchar](1048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AppoinmentStatusCategory] [varchar](1048) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsDeleted] [bit] NULL,
	[IsOld] [int] NULL,
	[OpportunityId] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OpportunityStatus] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OpportunityDate] [datetime] NULL,
	[OpportunityReferralCode] [nvarchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OpportunityReferralCodeExpirationDate] [datetime] NULL,
	[AppointmentDateEST] [datetime] NULL
) ON [PRIMARY]
GO
