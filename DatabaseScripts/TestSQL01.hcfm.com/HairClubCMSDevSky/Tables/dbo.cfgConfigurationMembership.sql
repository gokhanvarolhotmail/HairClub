/* CreateDate: 07/23/2009 00:10:06.930 , ModifyDate: 12/07/2021 16:20:15.963 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cfgConfigurationMembership](
	[ConfigurationMembershipID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ConfigurationMembershipSortOrder] [int] NULL,
	[MembershipID] [int] NOT NULL,
	[CancellationFeeSalesCodeID] [int] NULL,
	[CancellationFeeGracePeriodDays] [int] NULL,
	[CancellationFeeIsOptionalFlag] [bit] NULL,
	[NoShowFeeSalesCodeID] [int] NULL,
	[NoShowFeeIsOptionalFlag] [bit] NULL,
	[RescheduleFeeSalesCodeID] [int] NULL,
	[RescheduleFeeGracePeriodDays] [int] NULL,
	[RescheduleFeeIsOptionalFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
	[ExtraGraftDefault] [int] NULL,
	[CanOrderHairSystemFlag] [bit] NULL,
	[IsEFTEnabledFlag] [bit] NULL,
	[NumberOfAdditionalSystems] [int] NULL,
	[NumberOfDaysBeforeExpiration] [int] NULL,
	[CanTransferHairSystemFlag] [bit] NOT NULL,
	[IsAutoExpire] [bit] NOT NULL,
	[NumDaysExpirationBuffer] [int] NOT NULL,
	[IsContractRequired] [bit] NOT NULL,
	[CanTransferMembership] [bit] NOT NULL,
	[IsContractAdjustedOnInitialApp] [bit] NOT NULL,
	[IsZeroContractBalanceRequiredForConversion] [bit] NOT NULL,
	[EFTTermMonths] [int] NULL,
	[IsEFTAccountTypeCashAvailable] [bit] NOT NULL,
	[IsEFTProcessingRestrictedByContractBalance] [bit] NOT NULL,
	[IsBosleyMembership] [bit] NULL,
 CONSTRAINT [PK_cfgConfigurationMembership] PRIMARY KEY CLUSTERED
(
	[ConfigurationMembershipID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[cfgConfigurationMembership] ADD  DEFAULT ((0)) FOR [CanOrderHairSystemFlag]
GO
ALTER TABLE [dbo].[cfgConfigurationMembership] ADD  DEFAULT ((0)) FOR [IsEFTEnabledFlag]
GO
ALTER TABLE [dbo].[cfgConfigurationMembership] ADD  CONSTRAINT [DF_cfgConfigurationMembership_CanTransferHairSystemFlag]  DEFAULT ((0)) FOR [CanTransferHairSystemFlag]
GO
ALTER TABLE [dbo].[cfgConfigurationMembership] ADD  DEFAULT ((0)) FOR [IsAutoExpire]
GO
ALTER TABLE [dbo].[cfgConfigurationMembership] ADD  DEFAULT ((0)) FOR [NumDaysExpirationBuffer]
GO
ALTER TABLE [dbo].[cfgConfigurationMembership] ADD  DEFAULT ((0)) FOR [IsContractRequired]
GO
ALTER TABLE [dbo].[cfgConfigurationMembership] ADD  DEFAULT ((0)) FOR [CanTransferMembership]
GO
ALTER TABLE [dbo].[cfgConfigurationMembership] ADD  DEFAULT ((0)) FOR [IsContractAdjustedOnInitialApp]
GO
ALTER TABLE [dbo].[cfgConfigurationMembership]  WITH CHECK ADD  CONSTRAINT [FK_cfgConfigurationMembership_cfgMembership] FOREIGN KEY([MembershipID])
REFERENCES [dbo].[cfgMembership] ([MembershipID])
GO
ALTER TABLE [dbo].[cfgConfigurationMembership] CHECK CONSTRAINT [FK_cfgConfigurationMembership_cfgMembership]
GO
ALTER TABLE [dbo].[cfgConfigurationMembership]  WITH CHECK ADD  CONSTRAINT [FK_cfgConfigurationMembership_cfgSalesCode] FOREIGN KEY([CancellationFeeSalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[cfgConfigurationMembership] CHECK CONSTRAINT [FK_cfgConfigurationMembership_cfgSalesCode]
GO
ALTER TABLE [dbo].[cfgConfigurationMembership]  WITH CHECK ADD  CONSTRAINT [FK_cfgConfigurationMembership_cfgSalesCode1] FOREIGN KEY([NoShowFeeSalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[cfgConfigurationMembership] CHECK CONSTRAINT [FK_cfgConfigurationMembership_cfgSalesCode1]
GO
ALTER TABLE [dbo].[cfgConfigurationMembership]  WITH CHECK ADD  CONSTRAINT [FK_cfgConfigurationMembership_cfgSalesCode2] FOREIGN KEY([RescheduleFeeSalesCodeID])
REFERENCES [dbo].[cfgSalesCode] ([SalesCodeID])
GO
ALTER TABLE [dbo].[cfgConfigurationMembership] CHECK CONSTRAINT [FK_cfgConfigurationMembership_cfgSalesCode2]
GO
