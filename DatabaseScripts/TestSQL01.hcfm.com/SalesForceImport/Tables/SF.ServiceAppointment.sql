/* CreateDate: 03/03/2022 13:53:56.810 , ModifyDate: 03/03/2022 22:19:12.883 */
GO
CREATE TABLE [SF].[ServiceAppointment](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[OwnerId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsDeleted] [bit] NULL,
	[AppointmentNumber] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[ParentRecordId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ParentRecordType] [varchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AccountId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WorkTypeId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ContactId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Street] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[City] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[State] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PostalCode] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Country] [varchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StateCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CountryCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Latitude] [decimal](25, 15) NULL,
	[Longitude] [decimal](25, 15) NULL,
	[GeocodeAccuracy] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Address] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EarliestStartTime] [datetime2](7) NULL,
	[DueDate] [datetime2](7) NULL,
	[Duration] [decimal](16, 2) NULL,
	[ArrivalWindowStartTime] [datetime2](7) NULL,
	[ArrivalWindowEndTime] [datetime2](7) NULL,
	[Status] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SchedStartTime] [datetime2](7) NULL,
	[SchedEndTime] [datetime2](7) NULL,
	[ActualStartTime] [datetime2](7) NULL,
	[ActualEndTime] [datetime2](7) NULL,
	[ActualDuration] [decimal](16, 2) NULL,
	[DurationType] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DurationInMinutes] [decimal](16, 2) NULL,
	[ServiceTerritoryId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Subject] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ParentRecordStatusCategory] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[StatusCategory] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ServiceNote] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AppointmentType] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Email] [varchar](128) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Phone] [varchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CancellationReason] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AdditionalInformation] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Comments] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsAnonymousBooking] [bit] NULL,
	[IsOffsiteAppointment] [bit] NULL,
	[ApptBookingInfoUrl] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Confirmer_User__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[External_Id__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Meeting_Platform_Id__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Meeting_Platform__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Service_Appointment__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Work_Type_Group__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Appointment_Type__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Scheduled_End_Text__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Scheduled_Start_Text__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Agent_Appointment_Link__c] [varchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Automatic_Trigger__c] [bit] NULL,
	[Guest_Appointment_Link__c] [varchar](1024) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Meeting_Point__c] [bit] NULL,
	[Video_Session_Mode__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Agent_Link__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Guest_Link__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Is_Video_Appointment__c] [bit] NULL,
	[Sightcall_Appointment__c] [bit] NULL,
	[Test_date__c] [datetime2](7) NULL,
	[Are_you_sure_confirm__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Appointment_Start_Date__c] [date] NULL,
	[Appointment_End_Date__c] [date] NULL,
	[Lead__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Person_Account__c] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Parent_Record_Type__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Scheduled_Start_Date_Value__c] [date] NULL,
	[Service_Territory_Number__c] [varchar](4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Result__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Created_By_Title__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Bosley_Center_Number__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Gender__c] [varchar](1300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Previous_Appt_Same_Day__c] [bit] NULL,
 CONSTRAINT [pk_ServiceAppointment] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreatedDate] ON [SF].[ServiceAppointment]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LastModifiedDate] ON [SF].[ServiceAppointment]
(
	[LastModifiedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
