/* CreateDate: 03/29/2013 12:22:19.997 , ModifyDate: 01/27/2022 08:32:37.943 */
GO
CREATE TABLE [dbo].[dbaMargin](
	[ClientProfitabilityID] [int] IDENTITY(1,1) NOT FOR REPLICATION NOT NULL,
	[ClientGUID] [uniqueidentifier] NOT NULL,
	[ClientName] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ClientIdentifier] [int] NOT NULL,
	[ClientCenterId] [int] NOT NULL,
	[ClientMembershipGUID] [uniqueidentifier] NOT NULL,
	[MembershipID] [int] NOT NULL,
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
	[NetPayments]  AS ([PaymentsTotal]-[RefundsTotal]),
	[ServiceRevenue] [money] NOT NULL,
	[ProductRevenue] [money] NOT NULL,
	[HairOrderCount] [int] NOT NULL,
	[HairOrderTotalCost] [money] NOT NULL,
	[FullService] [int] NOT NULL,
	[Applications] [int] NOT NULL,
	[Services] [int] NOT NULL,
	[ServiceDuration] [int] NOT NULL,
	[ServiceCost] [money] NOT NULL,
	[TotalRevenue]  AS ((([PaymentsTotal]-[RefundsTotal])+[ProductRevenue])+[ServiceRevenue]),
	[TotalCost]  AS ([HairOrderTotalCost]+[ServiceCost]),
	[Margin]  AS (((([PaymentsTotal]-[RefundsTotal])+[ProductRevenue])+[ServiceRevenue])-([HairOrderTotalCost]+[ServiceCost])),
	[Margin_PCT]  AS (case when CONVERT([decimal](20,4),(([PaymentsTotal]-[RefundsTotal])+[ProductRevenue])+[ServiceRevenue],(0))=(0) then (0) else CONVERT([decimal](20,4),CONVERT([decimal](20,4),((([PaymentsTotal]-[RefundsTotal])+[ProductRevenue])+[ServiceRevenue])-([HairOrderTotalCost]+[ServiceCost]),(0))/CONVERT([decimal](20,4),(([PaymentsTotal]-[RefundsTotal])+[ProductRevenue])+[ServiceRevenue],(0)),(0)) end),
	[CreateDate] [datetime] NOT NULL,
	[CreateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LastUpdate] [datetime] NOT NULL,
	[LastUpdateUser] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_dbaMargin] PRIMARY KEY CLUSTERED
(
	[ClientProfitabilityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[dbaMargin] ADD  CONSTRAINT [DF_dbaMargin_FullService]  DEFAULT ((0)) FOR [FullService]
GO
ALTER TABLE [dbo].[dbaMargin] ADD  CONSTRAINT [DF_dbaMargin_Applications]  DEFAULT ((0)) FOR [Applications]
GO
ALTER TABLE [dbo].[dbaMargin] ADD  CONSTRAINT [DF_dbaMargin_Services]  DEFAULT ((0)) FOR [Services]
GO
ALTER TABLE [dbo].[dbaMargin] ADD  CONSTRAINT [DF_dbaMargin_ServiceDuration]  DEFAULT ((0)) FOR [ServiceDuration]
GO
ALTER TABLE [dbo].[dbaMargin] ADD  CONSTRAINT [DF_dbaMargin_ServiceCost]  DEFAULT ((0)) FOR [ServiceCost]
GO
