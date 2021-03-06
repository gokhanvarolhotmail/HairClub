/****** Object:  Table [ODS].[CNCT_cfgConfigurationCenter]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_cfgConfigurationCenter]
(
	[ConfigurationCenterID] [int] NULL,
	[ConfigurationCenterSortOrder] [int] NULL,
	[CenterID] [int] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) NULL,
	[UpdateStamp] [varbinary](8) NULL,
	[UseCreditCardProcessorFlag] [bit] NULL,
	[AccountingExportFreightBaseRate] [money] NULL,
	[AccountingExportFreightPerItemRate] [money] NULL,
	[AccountingExportReceiveAPDebitGLNumber] [int] NULL,
	[FeeNotificationDays] [int] NULL,
	[IsFeeProcessedCentrallyFlag] [bit] NULL,
	[LastClientEFTUpdate] [datetime] NULL,
	[CenterBusinessTypeID] [int] NULL,
	[HasFullAccess] [bit] NULL,
	[EndOfDayLastRunDate] [datetime] NULL,
	[IsSalesConsultationEnabled] [bit] NULL,
	[IsSalesOrderRoundingEnabled] [bit] NULL,
	[IsScheduleFeatureEnabled] [bit] NULL,
	[IsFulfillmentEnabled] [bit] NULL,
	[IsEnhSalesConsultEnabled] [bit] NULL,
	[IsAutoConfirmEnabled] [bit] NULL,
	[IsNoteDeletionEnabled] [bit] NULL,
	[NACHAFileProfileID] [int] NULL,
	[IsNewClientEnabled] [bit] NULL,
	[LanguageID] [int] NULL,
	[EntityID] [int] NULL,
	[IsAutomatedAgreementEnabled] [bit] NULL,
	[IsAccountReceivableProcEnabled] [bit] NULL,
	[HairOrderDelayDays] [int] NULL,
	[IsActiveForVipAccess] [bit] NULL,
	[UseCreditCardProcessorForCreditCardOnFile] [bit] NULL,
	[NewBusinessSizeID] [int] NULL,
	[RecurringBusinessSizeID] [int] NULL,
	[IsTrichoViewEnabledForMobile] [bit] NULL,
	[IsSalesConsultationEnabledForMobile] [bit] NULL,
	[IsLiveWithBosley] [bit] NULL,
	[CanCompleteVisitNextDay] [bit] NULL,
	[IsNonSerializedInventoryEnabled] [bit] NULL,
	[NewClientMembershipID] [int] NULL,
	[IncludeInNationalPricingRenewal] [bit] NULL,
	[IsTransferToHWEnabled] [bit] NULL,
	[IsConfirmAppointmentClientContactInformationEnabled] [bit] NULL,
	[IsStylistCareerPathEnabled] [bit] NULL,
	[IsHWIntegrationEnabled] [bit] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
