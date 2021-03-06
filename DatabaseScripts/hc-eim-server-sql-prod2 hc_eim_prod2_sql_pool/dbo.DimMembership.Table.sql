/****** Object:  Table [dbo].[DimMembership]    Script Date: 3/23/2022 10:16:56 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimMembership]
(
	[MembershipKey] [int] IDENTITY(1,1) NOT NULL,
	[MembershipID] [int] NOT NULL,
	[MembershipName] [varchar](200) NULL,
	[MembershipShortName] [varchar](200) NULL,
	[BusinessSegmentKey] [int] NOT NULL,
	[BusinessSegmentID] [int] NOT NULL,
	[RevenueGroupKey] [int] NOT NULL,
	[RevenueGroupID] [int] NOT NULL,
	[GenderKey] [int] NOT NULL,
	[GenderID] [varchar](100) NULL,
	[DurationMonths] [int] NULL,
	[ContractPrice] [decimal](18, 0) NULL,
	[MonthlyFee] [decimal](18, 0) NULL,
	[IsTaxableFlag] [bit] NULL,
	[IsDefaultMembershipFlag] [bit] NULL,
	[IsActive] [bit] NULL,
	[DWH_CreatedDate] [datetime] NULL,
	[DWH_LastUpdateDate] [datetime] NULL,
	[SourceSystem] [varchar](100) NOT NULL,
	[BusinessSegmentName] [nvarchar](200) NULL,
	[BusinessSegmentShortName] [nvarchar](100) NULL,
	[RevenueGroupName] [nvarchar](200) NULL,
	[RevenueGroupShortName] [nvarchar](100) NULL,
	[MembershipCreateDate] [datetime] NULL,
	[MembershipLastUpdateDate] [datetime] NULL
)
WITH
(
	DISTRIBUTION = REPLICATE,
	CLUSTERED INDEX
	(
		[MembershipKey] ASC
	)
)
GO
