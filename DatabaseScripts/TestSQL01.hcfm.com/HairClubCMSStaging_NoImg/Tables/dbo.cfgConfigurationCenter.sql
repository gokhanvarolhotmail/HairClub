/* CreateDate: 09/28/2009 00:02:00.337 , ModifyDate: 01/04/2022 10:56:36.887 */
GO
CREATE TABLE [dbo].[cfgConfigurationCenter](
	[ConfigurationCenterID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ConfigurationCenterSortOrder] [int] NULL,
	[CenterID] [int] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[UseCreditCardProcessorFlag] [bit] NOT NULL,
	[AccountingExportFreightBaseRate] [money] NOT NULL,
	[AccountingExportFreightPerItemRate] [money] NOT NULL,
	[AccountingExportReceiveAPDebitGLNumber] [int] NULL,
	[FeeNotificationDays] [int] NOT NULL,
	[IsFeeProcessedCentrallyFlag] [bit] NOT NULL,
	[LastClientEFTUpdate] [datetime] NULL,
	[CenterBusinessTypeID] [int] NOT NULL,
	[HasFullAccess] [bit] NOT NULL,
	[EndOfDayLastRunDate] [datetime] NULL,
	[IsSalesConsultationEnabled] [bit] NOT NULL,
	[IsSalesOrderRoundingEnabled] [bit] NOT NULL,
	[IsScheduleFeatureEnabled] [bit] NOT NULL,
	[IsFulfillmentEnabled] [bit] NOT NULL,
	[IsEnhSalesConsultEnabled] [bit] NOT NULL,
	[IsAutoConfirmEnabled] [bit] NOT NULL,
	[IsNoteDeletionEnabled] [bit] NOT NULL,
	[NACHAFileProfileID] [int] NULL,
	[IsNewClientEnabled] [bit] NOT NULL,
	[LanguageID] [int] NULL,
	[EntityID] [int] NOT NULL,
	[IsAutomatedAgreementEnabled] [bit] NOT NULL,
	[IsAccountReceivableProcEnabled] [bit] NOT NULL,
	[HairOrderDelayDays] [int] NOT NULL,
	[IsActiveForVipAccess] [bit] NOT NULL,
	[UseCreditCardProcessorForCreditCardOnFile] [bit] NOT NULL,
	[NewBusinessSizeID] [int] NULL,
	[RecurringBusinessSizeID] [int] NULL,
	[IsTrichoViewEnabledForMobile] [bit] NOT NULL,
	[IsSalesConsultationEnabledForMobile] [bit] NOT NULL,
	[IsLiveWithBosley] [bit] NOT NULL,
	[CanCompleteVisitNextDay] [bit] NOT NULL,
	[IsNonSerializedInventoryEnabled] [bit] NOT NULL,
	[NewClientMembershipID] [int] NULL,
	[IncludeInNationalPricingRenewal] [bit] NOT NULL,
	[IsTransferToHWEnabled] [bit] NOT NULL,
	[IsConfirmAppointmentClientContactInformationEnabled] [bit] NOT NULL,
	[IsStylistCareerPathEnabled] [bit] NOT NULL,
	[IsHWIntegrationEnabled] [bit] NULL,
 CONSTRAINT [PK_cfgConfigurationCenter] PRIMARY KEY CLUSTERED
(
	[ConfigurationCenterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgConfigurationCenter] ADD  DEFAULT ((0)) FOR [AccountingExportFreightBaseRate]
GO
ALTER TABLE [dbo].[cfgConfigurationCenter] ADD  DEFAULT ((0)) FOR [AccountingExportFreightPerItemRate]
GO
ALTER TABLE [dbo].[cfgConfigurationCenter] ADD  CONSTRAINT [DF_cfgConfigurationCenter_FeeNotificationDays]  DEFAULT ((5)) FOR [FeeNotificationDays]
GO
ALTER TABLE [dbo].[cfgConfigurationCenter] ADD  DEFAULT ((0)) FOR [IsFeeProcessedCentrallyFlag]
GO
ALTER TABLE [dbo].[cfgConfigurationCenter] ADD  DEFAULT ((0)) FOR [CenterBusinessTypeID]
GO
ALTER TABLE [dbo].[cfgConfigurationCenter] ADD  DEFAULT ((0)) FOR [HasFullAccess]
GO
ALTER TABLE [dbo].[cfgConfigurationCenter] ADD  CONSTRAINT [DF_cfgConfigurationCenter_IsSalesConsultationEnabled]  DEFAULT ((0)) FOR [IsSalesConsultationEnabled]
GO
ALTER TABLE [dbo].[cfgConfigurationCenter] ADD  CONSTRAINT [DF_cfgConfigurationCenter_IsSalesOrderRoundingEnabled]  DEFAULT ((0)) FOR [IsSalesOrderRoundingEnabled]
GO
ALTER TABLE [dbo].[cfgConfigurationCenter] ADD  DEFAULT ((0)) FOR [IsScheduleFeatureEnabled]
GO
ALTER TABLE [dbo].[cfgConfigurationCenter] ADD  DEFAULT ((0)) FOR [IsFulfillmentEnabled]
GO
ALTER TABLE [dbo].[cfgConfigurationCenter] ADD  DEFAULT ((0)) FOR [IsEnhSalesConsultEnabled]
GO
ALTER TABLE [dbo].[cfgConfigurationCenter] ADD  DEFAULT ((0)) FOR [IsAutoConfirmEnabled]
GO
ALTER TABLE [dbo].[cfgConfigurationCenter] ADD  DEFAULT ((0)) FOR [IsNoteDeletionEnabled]
GO
ALTER TABLE [dbo].[cfgConfigurationCenter] ADD  DEFAULT ((0)) FOR [IsNewClientEnabled]
GO
ALTER TABLE [dbo].[cfgConfigurationCenter] ADD  DEFAULT ((0)) FOR [IsAccountReceivableProcEnabled]
GO
ALTER TABLE [dbo].[cfgConfigurationCenter] ADD  DEFAULT ((0)) FOR [IsActiveForVipAccess]
GO
ALTER TABLE [dbo].[cfgConfigurationCenter] ADD  DEFAULT ((0)) FOR [UseCreditCardProcessorForCreditCardOnFile]
GO
ALTER TABLE [dbo].[cfgConfigurationCenter] ADD  CONSTRAINT [DF_cfgConfigurationCenter_IsTrichoViewEnabledForMobile]  DEFAULT ((0)) FOR [IsTrichoViewEnabledForMobile]
GO
ALTER TABLE [dbo].[cfgConfigurationCenter] ADD  CONSTRAINT [DF_cfgConfigurationCenter_IsSalesConsultationEnabledForMobile]  DEFAULT ((0)) FOR [IsSalesConsultationEnabledForMobile]
GO
ALTER TABLE [dbo].[cfgConfigurationCenter] ADD  CONSTRAINT [DF_cfgConfigurationCenter_IsLiveWithBosley]  DEFAULT ((0)) FOR [IsLiveWithBosley]
GO
ALTER TABLE [dbo].[cfgConfigurationCenter] ADD  CONSTRAINT [DF_cfgConfigurationCenter_CanCompleteVisitNextDay]  DEFAULT ((0)) FOR [CanCompleteVisitNextDay]
GO
ALTER TABLE [dbo].[cfgConfigurationCenter] ADD  DEFAULT ((0)) FOR [IsNonSerializedInventoryEnabled]
GO
ALTER TABLE [dbo].[cfgConfigurationCenter] ADD  DEFAULT ((0)) FOR [IncludeInNationalPricingRenewal]
GO
ALTER TABLE [dbo].[cfgConfigurationCenter]  WITH CHECK ADD  CONSTRAINT [FK_cfgConfigurationCenter_cfgCenter] FOREIGN KEY([CenterID])
REFERENCES [dbo].[cfgCenter] ([CenterID])
GO
ALTER TABLE [dbo].[cfgConfigurationCenter] CHECK CONSTRAINT [FK_cfgConfigurationCenter_cfgCenter]
GO
ALTER TABLE [dbo].[cfgConfigurationCenter]  WITH CHECK ADD  CONSTRAINT [FK_cfgConfigurationCenter_cfgEntity] FOREIGN KEY([EntityID])
REFERENCES [dbo].[cfgEntity] ([EntityID])
GO
ALTER TABLE [dbo].[cfgConfigurationCenter] CHECK CONSTRAINT [FK_cfgConfigurationCenter_cfgEntity]
GO
ALTER TABLE [dbo].[cfgConfigurationCenter]  WITH CHECK ADD  CONSTRAINT [FK_cfgConfigurationCenter_cfgMembership] FOREIGN KEY([NewClientMembershipID])
REFERENCES [dbo].[cfgMembership] ([MembershipID])
GO
ALTER TABLE [dbo].[cfgConfigurationCenter] CHECK CONSTRAINT [FK_cfgConfigurationCenter_cfgMembership]
GO
ALTER TABLE [dbo].[cfgConfigurationCenter]  WITH CHECK ADD  CONSTRAINT [FK_cfgConfigurationCenter_cfgNACHAFileProfile] FOREIGN KEY([NACHAFileProfileID])
REFERENCES [dbo].[cfgNACHAFileProfile] ([NACHAFileProfileID])
GO
ALTER TABLE [dbo].[cfgConfigurationCenter] CHECK CONSTRAINT [FK_cfgConfigurationCenter_cfgNACHAFileProfile]
GO
ALTER TABLE [dbo].[cfgConfigurationCenter]  WITH CHECK ADD  CONSTRAINT [FK_cfgConfigurationCenter_lkpCenterBusinessType] FOREIGN KEY([CenterBusinessTypeID])
REFERENCES [dbo].[lkpCenterBusinessType] ([CenterBusinessTypeID])
GO
ALTER TABLE [dbo].[cfgConfigurationCenter] CHECK CONSTRAINT [FK_cfgConfigurationCenter_lkpCenterBusinessType]
GO
ALTER TABLE [dbo].[cfgConfigurationCenter]  WITH CHECK ADD  CONSTRAINT [FK_cfgConfigurationCenter_lkpGeneralLedger_AccountingExportReceiveAPDebitGLNumber] FOREIGN KEY([AccountingExportReceiveAPDebitGLNumber])
REFERENCES [dbo].[lkpGeneralLedger] ([GeneralLedgerID])
GO
ALTER TABLE [dbo].[cfgConfigurationCenter] CHECK CONSTRAINT [FK_cfgConfigurationCenter_lkpGeneralLedger_AccountingExportReceiveAPDebitGLNumber]
GO
ALTER TABLE [dbo].[cfgConfigurationCenter]  WITH CHECK ADD  CONSTRAINT [FK_cfgConfigurationCenter_lkpLanguage] FOREIGN KEY([LanguageID])
REFERENCES [dbo].[lkpLanguage] ([LanguageID])
GO
ALTER TABLE [dbo].[cfgConfigurationCenter] CHECK CONSTRAINT [FK_cfgConfigurationCenter_lkpLanguage]
GO
ALTER TABLE [dbo].[cfgConfigurationCenter]  WITH CHECK ADD  CONSTRAINT [FK_cfgConfigurationCenter_lkpSizeNewBusiness] FOREIGN KEY([NewBusinessSizeID])
REFERENCES [dbo].[lkpSize] ([SizeID])
GO
ALTER TABLE [dbo].[cfgConfigurationCenter] CHECK CONSTRAINT [FK_cfgConfigurationCenter_lkpSizeNewBusiness]
GO
ALTER TABLE [dbo].[cfgConfigurationCenter]  WITH CHECK ADD  CONSTRAINT [FK_cfgConfigurationCenter_lkpSizeRecurringBusiness] FOREIGN KEY([RecurringBusinessSizeID])
REFERENCES [dbo].[lkpSize] ([SizeID])
GO
ALTER TABLE [dbo].[cfgConfigurationCenter] CHECK CONSTRAINT [FK_cfgConfigurationCenter_lkpSizeRecurringBusiness]
GO
