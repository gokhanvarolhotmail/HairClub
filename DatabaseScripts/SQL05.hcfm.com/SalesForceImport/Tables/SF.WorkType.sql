/* CreateDate: 03/03/2022 13:53:57.637 , ModifyDate: 03/05/2022 13:04:23.773 */
GO
CREATE TABLE [SF].[WorkType](
	[Id] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[OwnerId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsDeleted] [bit] NULL,
	[Name] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrencyIsoCode] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[CreatedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastModifiedDate] [datetime2](7) NOT NULL,
	[LastModifiedById] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SystemModstamp] [datetime2](7) NULL,
	[LastViewedDate] [datetime2](7) NULL,
	[LastReferencedDate] [datetime2](7) NULL,
	[Description] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EstimatedDuration] [decimal](16, 2) NULL,
	[DurationType] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DurationInMinutes] [decimal](16, 2) NULL,
	[TimeframeStart] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TimeframeEnd] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BlockTimeBeforeAppointment] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BlockTimeAfterAppointment] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DefaultAppointmentType] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TimeFrameStartUnit] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TimeFrameEndUnit] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BlockTimeBeforeUnit] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BlockTimeAfterUnit] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OperatingHoursId] [varchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[External_Id__c] [varchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [pk_WorkType] PRIMARY KEY CLUSTERED
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, DATA_COMPRESSION = ROW) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [CreatedDate] ON [SF].[WorkType]
(
	[CreatedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [LastModifiedDate] ON [SF].[WorkType]
(
	[LastModifiedDate] DESC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
