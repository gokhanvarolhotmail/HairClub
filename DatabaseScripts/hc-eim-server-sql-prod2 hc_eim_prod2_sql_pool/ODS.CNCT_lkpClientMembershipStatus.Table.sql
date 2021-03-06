/****** Object:  Table [ODS].[CNCT_lkpClientMembershipStatus]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[CNCT_lkpClientMembershipStatus]
(
	[ClientMembershipStatusID] [int] NULL,
	[ClientMembershipStatusSortOrder] [int] NULL,
	[ClientMembershipStatusDescription] [varchar](8000) NULL,
	[ClientMembershipStatusDescriptionShort] [varchar](8000) NULL,
	[IsActiveMembershipFlag] [bit] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime2](7) NULL,
	[CreateUser] [varchar](8000) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [varchar](8000) NULL,
	[UpdateStamp] [varbinary](max) NULL,
	[CanSearchAndDisplayFlag] [bit] NULL,
	[CanCheckInForConsultation] [bit] NULL,
	[DescriptionResourceKey] [varchar](8000) NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
