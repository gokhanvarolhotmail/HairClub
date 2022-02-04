/* CreateDate: 09/03/2021 09:37:06.807 , ModifyDate: 01/10/2022 12:08:22.790 */
GO
CREATE TABLE [bi_mktg_dds].[FactActivityResults](
	[ActivityKey] [int] NOT NULL,
	[ActivityDateKey] [int] NOT NULL,
	[ActivityTimeKey] [int] NOT NULL,
	[ActivityResultDateKey] [int] NOT NULL,
	[ActivityResultKey] [int] NOT NULL,
	[ActivityResultTimeKey] [int] NOT NULL,
	[ActivityCompletedDateKey] [int] NOT NULL,
	[ActivityCompletedTimeKey] [int] NOT NULL,
	[ActivityDueDateKey] [int] NOT NULL,
	[ActivityStartTimeKey] [int] NOT NULL,
	[OriginalAppointmentDateKey] [int] NOT NULL,
	[ActivitySavedDateKey] [int] NOT NULL,
	[ActivitySavedTimeKey] [int] NOT NULL,
	[ContactKey] [int] NOT NULL,
	[CenterKey] [int] NOT NULL,
	[SalesTypeKey] [int] NOT NULL,
	[SourceKey] [int] NOT NULL,
	[ActionCodeKey] [int] NOT NULL,
	[ResultCodeKey] [int] NOT NULL,
	[GenderKey] [int] NOT NULL,
	[OccupationKey] [int] NOT NULL,
	[EthnicityKey] [int] NOT NULL,
	[MaritalStatusKey] [int] NOT NULL,
	[HairLossTypeKey] [int] NOT NULL,
	[AgeRangeKey] [int] NOT NULL,
	[CompletedByEmployeeKey] [int] NOT NULL,
	[ClientNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Appointments] [int] NOT NULL,
	[Show] [int] NOT NULL,
	[NoShow] [int] NOT NULL,
	[Sale] [int] NOT NULL,
	[NoSale] [int] NOT NULL,
	[Consultation] [int] NOT NULL,
	[BeBack] [int] NOT NULL,
	[SurgeryOffered] [int] NOT NULL,
	[ReferredToDoctor] [int] NOT NULL,
	[InitialPayment] [money] NOT NULL,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [timestamp] NOT NULL,
	[ActivityEmployeeKey] [int] NULL,
	[Accomodation] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadSourceKey] [int] NULL,
	[LeadCreationDateKey] [int] NULL,
	[LeadCreationTimeKey] [int] NULL,
	[PromoCodeKey] [int] NULL,
 CONSTRAINT [PK_FactActivityResults] PRIMARY KEY CLUSTERED
(
	[ActivityKey] ASC,
	[ActivityDateKey] ASC,
	[ActivityTimeKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [FAR_ADDK] ON [bi_mktg_dds].[FactActivityResults]
(
	[ActivityDueDateKey] ASC
)
INCLUDE([ActivityKey],[ActivityDateKey],[ContactKey],[CenterKey],[SourceKey],[ActionCodeKey],[Show],[Consultation],[BeBack],[Accomodation]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
