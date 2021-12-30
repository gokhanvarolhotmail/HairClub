/* CreateDate: 12/29/2021 15:26:43.687 , ModifyDate: 12/29/2021 15:26:43.687 */
GO
CREATE TABLE [dbo].[DimMembershipPromotion](
	[MembershipPromotionID] [int] NOT NULL,
	[MembershipPromotionDescriptionShort] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MembershipPromotionTypeID] [int] NOT NULL
) ON [FG1]
GO
