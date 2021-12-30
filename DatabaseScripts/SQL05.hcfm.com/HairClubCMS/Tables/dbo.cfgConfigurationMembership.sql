/* CreateDate: 05/05/2020 17:42:41.530 , ModifyDate: 05/31/2020 14:27:44.807 */
GO
CREATE TABLE [dbo].[cfgConfigurationMembership](
	[ConfigurationMembershipID] [int] NOT NULL,
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
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
