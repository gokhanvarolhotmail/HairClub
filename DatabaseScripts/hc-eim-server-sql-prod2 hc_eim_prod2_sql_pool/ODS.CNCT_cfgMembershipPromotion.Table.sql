/****** Object:  Table [ODS].[CNCT_cfgMembershipPromotion]    Script Date: 3/23/2022 10:16:57 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_cfgMembershipPromotion]
(
	[MembershipPromotionID] [int] NULL,
	[MembershipPromotionSortOrder] [int] NULL,
	[MembershipPromotionDescription] [nvarchar](max) NULL,
	[MembershipPromotionDescriptionShort] [nvarchar](max) NULL,
	[MembershipPromotionTypeID] [int] NULL,
	[BeginDate] [datetime2](7) NULL,
	[EndDate] [datetime2](7) NULL,
	[Amount] [decimal](38, 18) NULL,
	[RevenueGroupID] [int] NULL,
	[BusinessSegmentID] [int] NULL,
	[AdditionalSystems] [int] NULL,
	[AdditionalServices] [int] NULL,
	[AdditionalSolutions] [int] NULL,
	[AdditionalProductKits] [int] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime2](7) NULL,
	[CreateUser] [nvarchar](max) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [nvarchar](max) NULL,
	[UpdateStamp] [varbinary](max) NULL,
	[AdditionalHCSL] [int] NULL,
	[AdditionalStrands] [int] NULL,
	[MembershipPromotionGroupID] [int] NULL,
	[MembershipPromotionAdjustmentTypeID] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
