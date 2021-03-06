/****** Object:  Table [ODS].[SF_ServiceAppointment]    Script Date: 3/23/2022 10:16:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[SF_ServiceAppointment]
(
	[Id] [varchar](8000) NULL,
	[OwnerId] [varchar](8000) NULL,
	[IsDeleted] [bit] NULL,
	[AppointmentNumber] [varchar](8000) NULL,
	[CurrencyIsoCode] [varchar](8000) NULL,
	[CreatedDate] [datetime2](7) NULL,
	[CreatedById] [varchar](8000) NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedById] [varchar](8000) NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[ParentRecordId] [varchar](8000) NULL,
	[ParentRecordType] [varchar](8000) NULL,
	[AccountId] [varchar](8000) NULL,
	[WorkTypeId] [varchar](8000) NULL,
	[ContactId] [varchar](8000) NULL,
	[Street] [varchar](8000) NULL,
	[City] [varchar](8000) NULL,
	[State] [varchar](8000) NULL,
	[PostalCode] [varchar](8000) NULL,
	[Country] [varchar](8000) NULL,
	[StateCode] [varchar](8000) NULL,
	[CountryCode] [varchar](8000) NULL,
	[Latitude] [numeric](38, 18) NULL,
	[Longitude] [numeric](38, 18) NULL,
	[GeocodeAccuracy] [varchar](8000) NULL,
	[Description] [varchar](8000) NULL,
	[EarliestStartTime] [datetime2](7) NULL,
	[DueDate] [datetime2](7) NULL,
	[Duration] [numeric](38, 18) NULL,
	[ArrivalWindowStartTime] [datetime2](7) NULL,
	[ArrivalWindowEndTime] [datetime2](7) NULL,
	[Status] [varchar](8000) NULL,
	[SchedStartTime] [datetime2](7) NULL,
	[SchedEndTime] [datetime2](7) NULL,
	[ActualStartTime] [datetime2](7) NULL,
	[ActualEndTime] [datetime2](7) NULL,
	[ActualDuration] [numeric](38, 18) NULL,
	[DurationType] [varchar](8000) NULL,
	[DurationInMinutes] [numeric](38, 18) NULL,
	[ServiceTerritoryId] [varchar](8000) NULL,
	[Subject] [varchar](8000) NULL,
	[ParentRecordStatusCategory] [varchar](8000) NULL,
	[StatusCategory] [varchar](8000) NULL,
	[ServiceNote] [varchar](8000) NULL,
	[AppointmentType] [varchar](8000) NULL,
	[Email] [varchar](8000) NULL,
	[Phone] [varchar](8000) NULL,
	[CancellationReason] [varchar](8000) NULL,
	[AdditionalInformation] [varchar](8000) NULL,
	[Comments] [varchar](8000) NULL,
	[Center_Type__c] [varchar](8000) NULL,
	[External_Id__c] [varchar](8000) NULL,
	[Service_Appointment__c] [varchar](8000) NULL,
	[Work_Type_Group__c] [varchar](8000) NULL,
	[Appointment_Type__c] [varchar](8000) NULL,
	[Meeting_Platform_Id__c] [varchar](8000) NULL,
	[Meeting_Platform__c] [varchar](8000) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
