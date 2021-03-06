/****** Object:  Table [ODS].[CNCT_lkpMembershipOrderReason]    Script Date: 3/23/2022 10:16:58 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_lkpMembershipOrderReason]
(
	[MembershipOrderReasonID] [int] NULL,
	[MembershipOrderReasonTypeID] [int] NULL,
	[MembershipOrderReasonSortOrder] [int] NULL,
	[MembershipOrderReasonDescription] [varchar](8000) NULL,
	[MembershipOrderReasonDescriptionShort] [varchar](8000) NULL,
	[BusinessSegmentID] [int] NULL,
	[RevenueTypeID] [int] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime2](7) NULL,
	[CreateUser] [varchar](8000) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [varchar](8000) NULL,
	[UpdateStamp] [varbinary](max) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
