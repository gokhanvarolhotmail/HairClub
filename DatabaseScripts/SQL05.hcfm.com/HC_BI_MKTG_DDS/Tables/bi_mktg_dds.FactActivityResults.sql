/* CreateDate: 05/03/2010 12:21:09.710 , ModifyDate: 09/03/2021 09:35:33.413 */
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
CREATE NONCLUSTERED INDEX [IDX_FactActivityResults_ActivityKey] ON [bi_mktg_dds].[FactActivityResults]
(
	[ActivityKey] ASC
)
INCLUDE([ActivityDateKey],[ActivityTimeKey],[ActivityResultKey],[ActivityResultDateKey],[ActivityResultTimeKey],[ActivityCompletedDateKey],[ActivityCompletedTimeKey],[ActivityDueDateKey],[ActivityStartTimeKey],[OriginalAppointmentDateKey],[ActivitySavedDateKey],[ActivitySavedTimeKey],[ContactKey],[CenterKey],[SalesTypeKey],[SourceKey],[ActionCodeKey],[ResultCodeKey],[GenderKey],[OccupationKey],[EthnicityKey],[MaritalStatusKey],[HairLossTypeKey],[AgeRangeKey],[CompletedByEmployeeKey],[Appointments],[Show],[NoShow],[Sale],[NoSale],[Consultation],[BeBack],[SurgeryOffered],[ReferredToDoctor],[InitialPayment]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FactActivityResults_ActivityDueDateKey] ON [bi_mktg_dds].[FactActivityResults]
(
	[ActivityDueDateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FactActivityResults_ActivityResultKeyINCL] ON [bi_mktg_dds].[FactActivityResults]
(
	[ActivityResultKey] ASC
)
INCLUDE([ContactKey],[SalesTypeKey],[GenderKey],[OccupationKey],[EthnicityKey],[MaritalStatusKey],[AgeRangeKey],[Appointments],[Show],[Sale]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FactActivityResults_CenterKeyShow_INCL] ON [bi_mktg_dds].[FactActivityResults]
(
	[CenterKey] ASC,
	[Show] ASC
)
INCLUDE([ActivityDueDateKey],[ContactKey],[SourceKey],[ActionCodeKey],[BeBack]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FactActivityResults_Show_INCL] ON [bi_mktg_dds].[FactActivityResults]
(
	[Show] ASC
)
INCLUDE([ActivityDueDateKey],[ContactKey],[CenterKey],[SourceKey],[ActionCodeKey],[BeBack]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [bi_mktg_dds].[FactActivityResults] ADD  CONSTRAINT [DF_FactActivityResults_InsertAuditKey]  DEFAULT ((0)) FOR [InsertAuditKey]
GO
ALTER TABLE [bi_mktg_dds].[FactActivityResults] ADD  CONSTRAINT [DF_FactActivityResults_InsertAuditKey1]  DEFAULT ((0)) FOR [UpdateAuditKey]
GO
