/****** Object:  Table [ODS].[SQL06_FactSalesTransaction]    Script Date: 3/7/2022 8:42:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ODS].[SQL06_FactSalesTransaction]
(
	[OrderDateKey] [int] NULL,
	[SalesOrderKey] [int] NULL,
	[SalesOrderDetailKey] [int] NULL,
	[SalesOrderTypeKey] [int] NULL,
	[CenterKey] [int] NULL,
	[ClientKey] [int] NULL,
	[MembershipKey] [int] NULL,
	[ClientMembershipKey] [int] NULL,
	[SalesCodeKey] [int] NULL,
	[Employee1Key] [int] NULL,
	[Employee2Key] [int] NULL,
	[Employee3Key] [int] NULL,
	[Employee4Key] [int] NULL,
	[Quantity] [int] NULL,
	[Price] [money] NULL,
	[Discount] [money] NULL,
	[ExtendedPrice] [money] NULL,
	[Tax1] [money] NULL,
	[Tax2] [money] NULL,
	[TaxRate1] [money] NULL,
	[TaxRate2] [money] NULL,
	[ExtendedPricePlusTax] [money] NULL,
	[TotalTaxAmount] [money] NULL,
	[InsertAuditKey] [int] NULL,
	[UpdateAuditKey] [int] NULL,
	[RowTimeStamp] [binary](8) NULL,
	[msrepl_tran_version] [uniqueidentifier] NULL,
	[IsClosed] [tinyint] NULL,
	[IsVoided] [tinyint] NULL,
	[ContactKey] [int] NULL,
	[SourceKey] [int] NULL,
	[GenderKey] [int] NULL,
	[OccupationKey] [int] NULL,
	[EthnicityKey] [int] NULL,
	[MaritalStatusKey] [int] NULL,
	[HairLossTypeKey] [int] NULL,
	[AgeRangeKey] [int] NULL,
	[PromotionCodeKey] [int] NULL,
	[S1_SaleCnt] [int] NULL,
	[S_CancelCnt] [int] NULL,
	[S1_NetSalesCnt] [int] NULL,
	[S1_NetSalesAmt] [money] NULL,
	[S1_ContractAmountAmt] [money] NULL,
	[S1_EstGraftsCnt] [int] NULL,
	[S1_EstPerGraftsAmt] [float] NULL,
	[SA_NetSalesCnt] [int] NULL,
	[SA_NetSalesAmt] [money] NULL,
	[SA_ContractAmountAmt] [money] NULL,
	[SA_EstGraftsCnt] [int] NULL,
	[SA_EstPerGraftAmt] [float] NULL,
	[S_PostExtCnt] [int] NULL,
	[S_PostExtAmt] [money] NULL,
	[S_SurgeryPerformedCnt] [int] NULL,
	[S_SurgeryPerformedAmt] [money] NULL,
	[S_SurgeryGraftsCnt] [int] NULL,
	[S1_DepositsTakenCnt] [int] NULL,
	[S1_DepositsTakenAmt] [money] NULL,
	[NB_GrossNB1Cnt] [int] NULL,
	[NB_TradCnt] [int] NULL,
	[NB_TradAmt] [money] NULL,
	[NB_GradCnt] [int] NULL,
	[NB_GradAmt] [money] NULL,
	[NB_ExtCnt] [int] NULL,
	[NB_ExtAmt] [money] NULL,
	[NB_AppsCnt] [int] NULL,
	[NB_BIOConvCnt] [int] NULL,
	[NB_EXTConvCnt] [int] NULL,
	[PCP_NB2Amt] [money] NULL,
	[PCP_PCPAmt] [money] NULL,
	[PCP_BioAmt] [money] NULL,
	[PCP_ExtMemAmt] [money] NULL,
	[PCPNonPgmAmt] [money] NULL,
	[ServiceAmt] [money] NULL,
	[RetailAmt] [money] NULL,
	[ClientServicedCnt] [int] NULL,
	[NetMembershipAmt] [money] NULL,
	[S_GrossSurCnt] [int] NULL,
	[S_SurCnt] [int] NULL,
	[S_SurAmt] [money] NULL,
	[AccountID] [int] NULL,
	[PCP_UpgCnt] [int] NULL,
	[PCP_DwnCnt] [int] NULL,
	[NB_RemCnt] [int] NULL,
	[NB_XTRAmt] [money] NULL,
	[NB_XTRCnt] [int] NULL,
	[NB_XTRConvCnt] [int] NULL,
	[PCP_XtrAmt] [money] NULL,
	[MbrPromotion] [varchar](10) NULL,
	[NetSalesAmt] [money] NULL,
	[S_PRPCnt] [int] NULL,
	[S_PRPAmt] [money] NULL,
	[LaserAmt] [money] NULL,
	[S_StripCnt] [int] NULL,
	[S_StripAmt] [money] NULL,
	[S_ArtasCnt] [int] NULL,
	[S_ArtasAmt] [money] NULL,
	[LaserCnt] [int] NULL,
	[NB_MDPCnt] [int] NULL,
	[NB_MDPAmt] [money] NULL,
	[NB_LaserCnt] [int] NULL,
	[NB_LaserAmt] [money] NULL,
	[PCP_LaserCnt] [int] NULL,
	[PCP_LaserAmt] [money] NULL,
	[EMP_RetailAmt] [money] NULL,
	[EMP_NB_LaserCnt] [int] NULL,
	[EMP_NB_LaserAmt] [money] NULL,
	[EMP_PCP_LaserCnt] [int] NULL,
	[EMP_PCP_LaserAmt] [money] NULL
)
WITH
(
	DISTRIBUTION = ROUND_ROBIN,
	CLUSTERED COLUMNSTORE INDEX
)
GO
