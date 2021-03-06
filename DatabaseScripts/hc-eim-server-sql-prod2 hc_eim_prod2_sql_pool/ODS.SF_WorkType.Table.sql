/****** Object:  Table [ODS].[SF_WorkType]    Script Date: 3/23/2022 10:16:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[SF_WorkType]
(
	[Id] [varchar](8000) NULL,
	[OwnerId] [varchar](8000) NULL,
	[IsDeleted] [bit] NULL,
	[Name] [varchar](8000) NULL,
	[CurrencyIsoCode] [varchar](8000) NULL,
	[CreatedDate] [datetime2](7) NULL,
	[CreatedById] [varchar](8000) NULL,
	[LastModifiedDate] [datetime2](7) NULL,
	[LastModifiedById] [varchar](8000) NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[Description] [varchar](8000) NULL,
	[EstimatedDuration] [numeric](38, 18) NULL,
	[DurationType] [varchar](8000) NULL,
	[DurationInMinutes] [numeric](38, 18) NULL,
	[TimeframeStart] [int] NULL,
	[TimeframeEnd] [int] NULL,
	[BlockTimeBeforeAppointment] [int] NULL,
	[BlockTimeAfterAppointment] [int] NULL,
	[DefaultAppointmentType] [varchar](8000) NULL,
	[TimeFrameStartUnit] [varchar](8000) NULL,
	[TimeFrameEndUnit] [varchar](8000) NULL,
	[BlockTimeBeforeUnit] [varchar](8000) NULL,
	[BlockTimeAfterUnit] [varchar](8000) NULL,
	[OperatingHoursId] [varchar](8000) NULL,
	[External_Id__c] [varchar](8000) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
