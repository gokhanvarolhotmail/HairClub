/* CreateDate: 05/05/2020 17:42:40.823 , ModifyDate: 05/05/2020 17:42:59.473 */
GO
CREATE TABLE [dbo].[cfgMembershipPromotion](
	[MembershipPromotionID] [int] NOT NULL,
	[MembershipPromotionSortOrder] [int] NOT NULL,
	[MembershipPromotionDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MembershipPromotionDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MembershipPromotionTypeID] [int] NOT NULL,
	[BeginDate] [datetime] NOT NULL,
	[EndDate] [datetime] NULL,
	[Amount] [decimal](6, 2) NOT NULL,
	[RevenueGroupID] [int] NULL,
	[BusinessSegmentID] [int] NULL,
	[AdditionalSystems] [int] NOT NULL,
	[AdditionalServices] [int] NOT NULL,
	[AdditionalSolutions] [int] NOT NULL,
	[AdditionalProductKits] [int] NOT NULL,
	[IsActiveFlag] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[UpdateStamp] [timestamp] NOT NULL,
	[AdditionalHCSL] [int] NOT NULL,
	[AdditionalStrands] [int] NOT NULL,
	[MembershipPromotionGroupID] [int] NULL,
	[MembershipPromotionAdjustmentTypeID] [int] NULL,
 CONSTRAINT [PK_lkpMembershipPromotion] PRIMARY KEY CLUSTERED
(
	[MembershipPromotionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG_CDC]
) ON [FG_CDC]
GO
