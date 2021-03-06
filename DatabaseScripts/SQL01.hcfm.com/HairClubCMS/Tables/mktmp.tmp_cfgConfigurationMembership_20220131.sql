/* CreateDate: 01/31/2022 16:48:50.403 , ModifyDate: 02/07/2022 11:17:35.963 */
GO
CREATE TABLE [mktmp].[tmp_cfgConfigurationMembership_20220131](
	[ConfigurationMembershipID] [int] IDENTITY(1,1) NOT NULL,
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
	[IsBosleyMembership] [bit] NULL
) ON [PRIMARY]
GO
