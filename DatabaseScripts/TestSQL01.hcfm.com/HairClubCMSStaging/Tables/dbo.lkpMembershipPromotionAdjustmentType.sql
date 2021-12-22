/* CreateDate: 07/31/2017 06:33:47.253 , ModifyDate: 07/31/2017 06:33:49.467 */
GO
CREATE TABLE [dbo].[lkpMembershipPromotionAdjustmentType](
	[MembershipPromotionAdjustmentTypeID] [int] NOT NULL,
	[MembershipPromotionAdjustmentTypeSortOrder] [int] NOT NULL,
	[MembershipPromotionAdjustmentTypeDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MembershipPromotionAdjustmentTypeDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime] NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastUpdate] [datetime] NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UpdateStamp] [timestamp] NULL,
 CONSTRAINT [PK_lkpMembershipPromotionAdjustmentType] PRIMARY KEY CLUSTERED
(
	[MembershipPromotionAdjustmentTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
