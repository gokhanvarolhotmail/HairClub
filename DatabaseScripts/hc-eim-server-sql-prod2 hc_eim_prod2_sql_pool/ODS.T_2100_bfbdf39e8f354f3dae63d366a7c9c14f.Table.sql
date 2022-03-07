/****** Object:  Table [ODS].[T_2100_bfbdf39e8f354f3dae63d366a7c9c14f]    Script Date: 3/7/2022 8:42:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[T_2100_bfbdf39e8f354f3dae63d366a7c9c14f]
(
	[ClientMembershipStatusID] [int] NULL,
	[ClientMembershipStatusSortOrder] [int] NULL,
	[ClientMembershipStatusDescription] [nvarchar](max) NULL,
	[ClientMembershipStatusDescriptionShort] [nvarchar](max) NULL,
	[IsActiveMembershipFlag] [bit] NULL,
	[IsActiveFlag] [bit] NULL,
	[CreateDate] [datetime2](7) NULL,
	[CreateUser] [nvarchar](max) NULL,
	[LastUpdate] [datetime2](7) NULL,
	[LastUpdateUser] [nvarchar](max) NULL,
	[UpdateStamp] [varbinary](max) NULL,
	[CanSearchAndDisplayFlag] [bit] NULL,
	[CanCheckInForConsultation] [bit] NULL,
	[DescriptionResourceKey] [nvarchar](max) NULL,
	[r60eaad51a675475ea03d83cbef5d310e] [int] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	HEAP
)
GO
