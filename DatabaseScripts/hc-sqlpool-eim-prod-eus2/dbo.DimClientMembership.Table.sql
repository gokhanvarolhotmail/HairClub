/****** Object:  Table [dbo].[DimClientMembership]    Script Date: 1/7/2022 4:05:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimClientMembership]
(
	[ClientMembershipKey] [int] IDENTITY(1,1) NOT NULL,
	[ClientMembershipID] [uniqueidentifier] NULL,
	[Member1_ID_Temp] [int] NULL,
	[ClientKey] [int] NULL,
	[ClientID] [uniqueidentifier] NULL,
	[CenterKey] [int] NULL,
	[CenterID] [int] NULL,
	[MembershipKey] [int] NULL,
	[MembershipID] [int] NULL,
	[ClientMembershipStatusID] [int] NULL,
	[ClientMembershipStatusDescription] [nvarchar](50) NULL,
	[ClientMembershipStatusDescriptionShort] [nvarchar](10) NULL,
	[ClientMembershipContractPrice] [money] NULL,
	[ClientMembershipContractPaidAmount] [money] NULL,
	[ClientMembershipMonthlyFee] [money] NULL,
	[ClientMembershipBeginDate] [datetime] NULL,
	[ClientMembershipEndDate] [datetime] NULL,
	[ClientMembershipCancelDate] [datetime] NULL,
	[ClientMembershipIdentifier] [nvarchar](50) NULL,
	[NationalMonthlyFee] [money] NULL,
	[SourceSystem] [varchar](50) NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[ClientMembershipID] ASC
	)
)
GO
