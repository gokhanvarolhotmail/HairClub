/* CreateDate: 07/30/2013 15:15:31.740 , ModifyDate: 07/30/2014 19:10:14.610 */
GO
CREATE TABLE [dbo].[dbaMarginByYear](
	[ClientProfitabilityID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ClientCenterId] [int] NOT NULL,
	[ClientMembershipGUID] [uniqueidentifier] NOT NULL,
	[ClientMembershipKey] [int] NOT NULL,
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[ClientName] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientIdentifier] [int] NOT NULL,
	[Gender] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Age] [int] NULL,
	[AgeRangeKey] [int] NULL,
	[AgeRangeDescription] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MembershipID] [int] NOT NULL,
	[Year] [int] NOT NULL,
	[NewContactYear] [int] NOT NULL,
	[BusinessSegment] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MembershipDescription] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Status] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MembershipIdentifier] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IsMembershipActive] [bit] NOT NULL,
	[MembershipStartDate] [datetime] NULL,
	[MembershipEndDate] [datetime] NULL,
	[MembershipDuration] [int] NULL,
	[PaymentsTotal] [money] NOT NULL,
	[RefundsTotal] [money] NOT NULL,
	[WriteOff] [money] NOT NULL,
	[NetPaymentsCalc]  AS (([PaymentsTotal]-[WriteOff])-[RefundsTotal]),
	[NetMembershipAmount] [money] NOT NULL,
	[ServiceRevenue] [money] NOT NULL,
	[ProductRevenue] [money] NOT NULL,
	[HairOrderCount] [int] NOT NULL,
	[HairOrderTotalCost] [money] NOT NULL,
	[FullService] [int] NOT NULL,
	[Applications] [int] NOT NULL,
	[NB1Applications] [int] NOT NULL,
	[Services] [int] NOT NULL,
	[ServiceDuration] [int] NOT NULL,
	[ServiceCost] [money] NOT NULL,
	[TotalRevenue]  AS ((([PaymentsTotal]-[RefundsTotal])+[ProductRevenue])+[ServiceRevenue]),
	[TotalCost]  AS ([HairOrderTotalCost]+[ServiceCost]),
	[Margin]  AS (((([PaymentsTotal]-[RefundsTotal])+[ProductRevenue])+[ServiceRevenue])-([HairOrderTotalCost]+[ServiceCost])),
	[Margin_PCT]  AS (case when CONVERT([decimal](20,4),(([PaymentsTotal]-[RefundsTotal])+[ProductRevenue])+[ServiceRevenue],(0))=(0) then (0) else CONVERT([decimal](20,4),CONVERT([decimal](20,4),((([PaymentsTotal]-[RefundsTotal])+[ProductRevenue])+[ServiceRevenue])-([HairOrderTotalCost]+[ServiceCost]),(0))/CONVERT([decimal](20,4),(([PaymentsTotal]-[RefundsTotal])+[ProductRevenue])+[ServiceRevenue],(0)),(0)) end),
	[NB_EXTConvCnt] [int] NOT NULL,
	[NB_BIOConvCnt] [int] NOT NULL,
	[PCP_PCPAmt] [money] NOT NULL,
	[PCP_NB2Amt] [money] NOT NULL,
	[PCP_BioAmt] [money] NOT NULL,
	[PCP_ExtMemAmt] [money] NOT NULL,
	[PCP_NonPgmAmt] [money] NOT NULL,
	[NB_TradAmt] [money] NOT NULL,
	[NB_GradAmt] [money] NOT NULL,
	[NB_ExtAmt] [money] NOT NULL,
	[S_SurCnt] [money] NOT NULL,
	[S_SurAmt] [money] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_dbaMarginByYear] PRIMARY KEY CLUSTERED
(
	[ClientProfitabilityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dbaMarginByYear] ADD  CONSTRAINT [DF_dbaMarginByYear_FullService]  DEFAULT ((0)) FOR [FullService]
GO
ALTER TABLE [dbo].[dbaMarginByYear] ADD  CONSTRAINT [DF_dbaMarginByYear_Applications]  DEFAULT ((0)) FOR [Applications]
GO
ALTER TABLE [dbo].[dbaMarginByYear] ADD  CONSTRAINT [DF_dbaMarginByYear_Services]  DEFAULT ((0)) FOR [Services]
GO
ALTER TABLE [dbo].[dbaMarginByYear] ADD  CONSTRAINT [DF_dbaMarginByYear_ServiceDuration]  DEFAULT ((0)) FOR [ServiceDuration]
GO
ALTER TABLE [dbo].[dbaMarginByYear] ADD  CONSTRAINT [DF_dbaMarginByYear_ServiceCost]  DEFAULT ((0)) FOR [ServiceCost]
GO
