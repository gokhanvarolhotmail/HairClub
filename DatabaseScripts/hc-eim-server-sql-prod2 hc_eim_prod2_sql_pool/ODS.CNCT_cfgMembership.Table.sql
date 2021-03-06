/****** Object:  Table [ODS].[CNCT_cfgMembership]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_cfgMembership]
(
	[MembershipID] [int] NULL,
	[MembershipSortOrder] [int] NULL,
	[MembershipDescription] [varchar](8000) NULL,
	[MembershipDescriptionShort] [varchar](8000) NULL,
	[BusinessSegmentID] [int] NULL,
	[RevenueGroupID] [int] NULL,
	[GenderID] [int] NULL,
	[DurationMonths] [int] NULL,
	[ContractPrice] [numeric](19, 4) NULL,
	[MonthlyFee] [numeric](19, 4) NULL,
	[IsTaxableFlag] [bit] NULL,
	[IsDefaultMembershipFlag] [bit] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime2](7) NULL,
	[CreateUser] [varchar](8000) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [varchar](8000) NULL,
	[UpdateStamp] [varbinary](max) NULL,
	[IsHairSystemOrderRushFlag] [bit] NULL,
	[HairSystemGeneralLedgerID] [int] NULL,
	[DefaultPaymentSalesCodeID] [int] NULL,
	[NumRenewalDays] [int] NULL,
	[NumDaysAfterCancelBeforeNew] [int] NULL,
	[CanCheckinForConsultation] [bit] NULL,
	[MaximumHairSystemHairLengthValue] [int] NULL,
	[ExpectedConversionDays] [int] NULL,
	[MinimumAge] [int] NULL,
	[MaximumAge] [int] NULL,
	[MaximumLongHairAddOnHairLengthValue] [int] NULL,
	[BOSSalesTypeCode] [varchar](8000) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
