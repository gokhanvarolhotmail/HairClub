/* CreateDate: 05/03/2010 12:22:42.677 , ModifyDate: 12/15/2020 13:33:06.557 */
GO
CREATE TABLE [bi_mktg_dqa].[FactActivityResults](
	[DataQualityAuditKey] [int] IDENTITY(1,1) NOT NULL,
	[DataPkgKey] [int] NULL,
	[ActivityResultDateKey] [int] NULL,
	[ActivityResultDateSSID] [date] NULL,
	[ActivityResultKey] [int] NULL,
	[ActivityResultSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivityResultTimeKey] [int] NULL,
	[ActivityResultTimeSSID] [time](0) NULL,
	[ActivityKey] [int] NULL,
	[ActivitySSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivityDateKey] [int] NULL,
	[ActivityDateSSID] [date] NULL,
	[ActivityTimeKey] [int] NULL,
	[ActivityTimeSSID] [time](0) NULL,
	[ActivityDueDateKey] [int] NULL,
	[ActivityDueDateSSID] [date] NULL,
	[ActivityStartTimeKey] [int] NULL,
	[ActivityStartTimeSSID] [time](0) NULL,
	[ActivityCompletedDateKey] [int] NULL,
	[ActivityCompletedDateSSID] [date] NULL,
	[ActivityCompletedTimeKey] [int] NULL,
	[ActivityCompletedTimeSSID] [time](0) NULL,
	[OriginalAppointmentDateKey] [int] NULL,
	[OriginalAppointmentDateSSID] [date] NULL,
	[ActivitySavedDateKey] [int] NULL,
	[ActivitySavedDateSSID] [date] NULL,
	[ActivitySavedTimeKey] [int] NULL,
	[ActivitySavedTimeSSID] [time](0) NULL,
	[ContactKey] [int] NULL,
	[ContactSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CenterKey] [int] NULL,
	[CenterSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SalesTypeKey] [int] NULL,
	[SalesTypeSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SourceKey] [int] NULL,
	[SourceSSID] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActionCodeKey] [int] NULL,
	[ActionCodeSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ResultCodeKey] [int] NULL,
	[ResultCodeSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[GenderKey] [int] NULL,
	[GenderSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OccupationKey] [int] NULL,
	[OccupationSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EthnicityKey] [int] NULL,
	[EthnicitySSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MaritalStatusKey] [int] NULL,
	[MaritalStatusSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[HairLossTypeKey] [int] NULL,
	[HairLossTypeSSID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NorwoodSSID] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LudwigSSID] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[AgeRangeKey] [int] NULL,
	[Age] [int] NULL,
	[AgeRangeSSID] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CompletedByEmployeeKey] [int] NULL,
	[CompletedByEmployeeSSID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ClientNumber] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SaleNoSaleFlag] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ShowNoShowFlag] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SurgeryOfferedFlag] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ReferredToDoctorFlag] [char](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Appointments] [int] NULL,
	[Show] [int] NULL,
	[NoShow] [int] NULL,
	[Sale] [int] NULL,
	[NoSale] [int] NULL,
	[Consultation] [int] NULL,
	[BeBack] [int] NULL,
	[SurgeryOffered] [int] NULL,
	[ReferredToDoctor] [int] NULL,
	[InitialPayment] [decimal](15, 4) NULL,
	[IsNew] [tinyint] NULL,
	[IsUpdate] [tinyint] NULL,
	[IsDelete] [tinyint] NULL,
	[IsDuplicate] [tinyint] NULL,
	[IsException] [tinyint] NULL,
	[IsHealthy] [tinyint] NULL,
	[IsRejected] [tinyint] NULL,
	[IsAllowed] [tinyint] NULL,
	[IsFixed] [tinyint] NULL,
	[SourceSystemKey] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreateTimestamp] [datetime] NOT NULL,
	[ActivityEmployeeSSID] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ActivityEmployeeKey] [int] NULL,
	[SFDC_TaskID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_LeadID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Accomodation] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SFDC_PersonAccountID] [nvarchar](18) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LeadSourceKey] [int] NULL,
	[LeadCreationDateKey] [int] NULL,
	[LeadCreationTimeKey] [int] NULL,
	[PromoCodeKey] [int] NULL,
 CONSTRAINT [PK_FactActivityResults] PRIMARY KEY CLUSTERED
(
	[DataQualityAuditKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [bi_mktg_dqa].[FactActivityResults] ADD  CONSTRAINT [DF_FactActivityResults_IsNew_1]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_mktg_dqa].[FactActivityResults] ADD  CONSTRAINT [DF_FactActivityResults_IsUpdate_1]  DEFAULT ((0)) FOR [IsUpdate]
GO
ALTER TABLE [bi_mktg_dqa].[FactActivityResults] ADD  CONSTRAINT [DF_FactActivityResults_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_mktg_dqa].[FactActivityResults] ADD  CONSTRAINT [DF_FactActivityResults_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_mktg_dqa].[FactActivityResults] ADD  CONSTRAINT [DF_FactActivityResults_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_mktg_dqa].[FactActivityResults] ADD  CONSTRAINT [DF_FactActivityResults_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_mktg_dqa].[FactActivityResults] ADD  CONSTRAINT [DF_FactActivityResults_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_mktg_dqa].[FactActivityResults] ADD  CONSTRAINT [DF_FactActivityResults_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_mktg_dqa].[FactActivityResults] ADD  CONSTRAINT [DF_FactActivityResults_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_mktg_dqa].[FactActivityResults] ADD  CONSTRAINT [DF_FactActivityResults_CreateTimestamp]  DEFAULT (getdate()) FOR [CreateTimestamp]
GO
