/* CreateDate: 03/21/2022 13:00:03.953 , ModifyDate: 03/21/2022 13:00:06.653 */
GO
CREATE TABLE [dbo].[ODS_SF_ServiceAppointment](
	[CreatedDate] [datetime] NULL,
	[Id] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OwnerId] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsDeleted] [bit] NULL,
	[AppointmentNumber] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyIsoCode] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedById] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedById] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[ParentRecordId] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ParentRecordType] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccountId] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WorkTypeId] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactId] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Street] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PostalCode] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Country] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateCode] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryCode] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Latitude] [numeric](38, 18) NULL,
	[Longitude] [numeric](38, 18) NULL,
	[GeocodeAccuracy] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Description] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EarliestStartTime] [datetime2](7) NULL,
	[DueDate] [datetime2](7) NULL,
	[Duration] [numeric](38, 18) NULL,
	[ArrivalWindowStartTime] [datetime2](7) NULL,
	[ArrivalWindowEndTime] [datetime2](7) NULL,
	[Status] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SchedStartTime] [datetime2](7) NULL,
	[SchedEndTime] [datetime2](7) NULL,
	[ActualStartTime] [datetime2](7) NULL,
	[ActualEndTime] [datetime2](7) NULL,
	[ActualDuration] [numeric](38, 18) NULL,
	[DurationType] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DurationInMinutes] [numeric](38, 18) NULL,
	[ServiceTerritoryId] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Subject] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ParentRecordStatusCategory] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StatusCategory] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceNote] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AppointmentType] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Email] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CancellationReason] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AdditionalInformation] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Comments] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Center_Type__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[External_Id__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Service_Appointment__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Work_Type_Group__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Appointment_Type__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Meeting_Platform_Id__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Meeting_Platform__c] [varchar](8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
