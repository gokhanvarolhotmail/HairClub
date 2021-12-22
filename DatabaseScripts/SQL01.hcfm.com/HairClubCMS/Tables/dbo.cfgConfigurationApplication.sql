CREATE TABLE [dbo].[cfgConfigurationApplication](
	[ConfigurationApplicationID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[Version32ReleaseDate] [date] NOT NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[Version41ReleaseDate] [date] NOT NULL,
	[ScheduleCreateRange] [int] NULL,
	[HairSystemOrderCounter] [int] NOT NULL,
	[HairSystemOrderMaximumDaysInFuture] [int] NOT NULL,
	[AccountingExportBatchCounter] [int] NOT NULL,
	[AccountingExportDefaultPath] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[HairSystemTurnaroundDaysRange1] [int] NOT NULL,
	[HairSystemTurnaroundDaysRange2] [int] NOT NULL,
	[HairSystemTurnaroundDaysRange3] [int] NOT NULL,
	[HairSystemTurnaroundLongHairExtraDays] [int] NOT NULL,
	[HairSystemTurnaroundLongHairLength] [int] NOT NULL,
	[AccountingExportReceiveAPVarianceGLNumber] [int] NULL,
	[AccountingExportReceiveAPCreditGLNumber] [int] NULL,
	[LastUpdateClientEFT] [datetime] NULL,
	[MonetraProcessingBufferInMinutes] [int] NOT NULL,
	[SalesConsultationDayBuffer] [int] NOT NULL,
	[NumberOfRefundMonths] [int] NOT NULL,
	[PhotoQuality] [int] NOT NULL,
	[IsPreviousConsultationWarningEnabled] [bit] NOT NULL,
 CONSTRAINT [PK_cfgConfigurationApplication] PRIMARY KEY CLUSTERED
(
	[ConfigurationApplicationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgConfigurationApplication] ADD  DEFAULT ((7)) FOR [HairSystemOrderMaximumDaysInFuture]
GO
ALTER TABLE [dbo].[cfgConfigurationApplication] ADD  DEFAULT ((10000)) FOR [AccountingExportBatchCounter]
GO
ALTER TABLE [dbo].[cfgConfigurationApplication] ADD  DEFAULT ('') FOR [AccountingExportDefaultPath]
GO
ALTER TABLE [dbo].[cfgConfigurationApplication] ADD  DEFAULT ((0)) FOR [HairSystemTurnaroundDaysRange1]
GO
ALTER TABLE [dbo].[cfgConfigurationApplication] ADD  DEFAULT ((0)) FOR [HairSystemTurnaroundDaysRange2]
GO
ALTER TABLE [dbo].[cfgConfigurationApplication] ADD  DEFAULT ((0)) FOR [HairSystemTurnaroundDaysRange3]
GO
ALTER TABLE [dbo].[cfgConfigurationApplication] ADD  DEFAULT ((0)) FOR [HairSystemTurnaroundLongHairExtraDays]
GO
ALTER TABLE [dbo].[cfgConfigurationApplication] ADD  DEFAULT ((0)) FOR [HairSystemTurnaroundLongHairLength]
GO
ALTER TABLE [dbo].[cfgConfigurationApplication] ADD  DEFAULT ((60)) FOR [MonetraProcessingBufferInMinutes]
GO
ALTER TABLE [dbo].[cfgConfigurationApplication] ADD  CONSTRAINT [DF_cfgConfigurationApplication_SalesConsultationDayBuffer]  DEFAULT ((7)) FOR [SalesConsultationDayBuffer]
GO
ALTER TABLE [dbo].[cfgConfigurationApplication] ADD  DEFAULT ((0)) FOR [NumberOfRefundMonths]
GO
ALTER TABLE [dbo].[cfgConfigurationApplication] ADD  DEFAULT ((80)) FOR [PhotoQuality]
GO
ALTER TABLE [dbo].[cfgConfigurationApplication] ADD  DEFAULT ((1)) FOR [IsPreviousConsultationWarningEnabled]
GO
ALTER TABLE [dbo].[cfgConfigurationApplication]  WITH CHECK ADD  CONSTRAINT [FK_cfgConfigurationApplication_lkpGeneralLedger_AccountingExportReceiveAPCreditGLNumber] FOREIGN KEY([AccountingExportReceiveAPCreditGLNumber])
REFERENCES [dbo].[lkpGeneralLedger] ([GeneralLedgerID])
GO
ALTER TABLE [dbo].[cfgConfigurationApplication] CHECK CONSTRAINT [FK_cfgConfigurationApplication_lkpGeneralLedger_AccountingExportReceiveAPCreditGLNumber]
GO
ALTER TABLE [dbo].[cfgConfigurationApplication]  WITH CHECK ADD  CONSTRAINT [FK_cfgConfigurationApplication_lkpGeneralLedger_AccountingExportReceiveAPVarianceGLNumber] FOREIGN KEY([AccountingExportReceiveAPVarianceGLNumber])
REFERENCES [dbo].[lkpGeneralLedger] ([GeneralLedgerID])
GO
ALTER TABLE [dbo].[cfgConfigurationApplication] CHECK CONSTRAINT [FK_cfgConfigurationApplication_lkpGeneralLedger_AccountingExportReceiveAPVarianceGLNumber]
