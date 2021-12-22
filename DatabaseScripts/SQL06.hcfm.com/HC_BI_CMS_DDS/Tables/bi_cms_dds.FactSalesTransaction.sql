/* CreateDate: 10/03/2019 23:03:42.417 , ModifyDate: 04/06/2021 09:38:49.140 */
GO
CREATE TABLE [bi_cms_dds].[FactSalesTransaction](
	[OrderDateKey] [int] NOT NULL,
	[SalesOrderKey] [int] NOT NULL,
	[SalesOrderDetailKey] [int] NOT NULL,
	[SalesOrderTypeKey] [int] NOT NULL,
	[CenterKey] [int] NOT NULL,
	[ClientKey] [int] NOT NULL,
	[MembershipKey] [int] NOT NULL,
	[ClientMembershipKey] [int] NOT NULL,
	[SalesCodeKey] [int] NOT NULL,
	[Employee1Key] [int] NOT NULL,
	[Employee2Key] [int] NOT NULL,
	[Employee3Key] [int] NOT NULL,
	[Employee4Key] [int] NOT NULL,
	[Quantity] [int] NULL,
	[Price] [money] NULL,
	[Discount] [money] NULL,
	[ExtendedPrice]  AS (isnull([Price],(0))*isnull([Quantity],(0))-isnull([Discount],(0))) PERSISTED,
	[Tax1] [money] NULL,
	[Tax2] [money] NULL,
	[TaxRate1] [money] NULL,
	[TaxRate2] [money] NULL,
	[ExtendedPricePlusTax]  AS (((isnull([Price],(0))*isnull([Quantity],(0))-isnull([Discount],(0)))+isnull([Tax1],(0)))+isnull([Tax2],(0))) PERSISTED,
	[TotalTaxAmount]  AS (isnull([Tax1],(0))+isnull([Tax2],(0))) PERSISTED,
	[InsertAuditKey] [int] NOT NULL,
	[UpdateAuditKey] [int] NOT NULL,
	[RowTimeStamp] [binary](8) NOT NULL,
	[msrepl_tran_version] [uniqueidentifier] NOT NULL,
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
	[MbrPromotion] [varchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
) ON [FG1]
GO
CREATE UNIQUE CLUSTERED INDEX [PK_FactSalesTransaction] ON [bi_cms_dds].[FactSalesTransaction]
(
	[OrderDateKey] ASC,
	[SalesOrderKey] ASC,
	[SalesOrderDetailKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IDX_FactSalesTransaction_CenterKey] ON [bi_cms_dds].[FactSalesTransaction]
(
	[CenterKey] ASC
)
INCLUDE([SalesOrderKey],[ClientKey],[MembershipKey],[ClientMembershipKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IDX_FactSalesTransaction_ClientKeySalesCodeKey_INCLUDEOrderDateKeyetc] ON [bi_cms_dds].[FactSalesTransaction]
(
	[ClientKey] ASC,
	[SalesCodeKey] ASC
)
INCLUDE([OrderDateKey],[SalesOrderKey],[ClientMembershipKey],[Employee1Key]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IDX_FactSalesTransaction_ContactKey] ON [bi_cms_dds].[FactSalesTransaction]
(
	[ContactKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IDX_FactSalesTransaction_SalesOrderDetailKey] ON [bi_cms_dds].[FactSalesTransaction]
(
	[SalesOrderDetailKey] ASC
)
INCLUDE([OrderDateKey],[SalesOrderKey],[SalesOrderTypeKey],[CenterKey],[ClientKey],[MembershipKey],[ClientMembershipKey],[SalesCodeKey],[Employee1Key],[Employee2Key],[Employee3Key],[Employee4Key],[Quantity],[Price],[Discount],[ExtendedPrice],[Tax1],[Tax2],[TaxRate1],[TaxRate2],[ExtendedPricePlusTax],[TotalTaxAmount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IDX_FactSaleTransaction_SaleOrderKey] ON [bi_cms_dds].[FactSalesTransaction]
(
	[SalesOrderKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
GO
CREATE NONCLUSTERED INDEX [IX_31005_31004_FactSalesTransaction] ON [bi_cms_dds].[FactSalesTransaction]
(
	[ExtendedPrice] ASC
)
INCLUDE([ContactKey],[S_PostExtAmt],[NB_TradAmt],[NB_GradAmt],[NB_ExtAmt],[RetailAmt],[S_SurAmt],[NB_XTRAmt],[S_PRPAmt],[NB_MDPAmt],[NB_LaserAmt]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IX_FactSalesTransaction_AccountID] ON [bi_cms_dds].[FactSalesTransaction]
(
	[AccountID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IX_FactSalesTransaction_CenterKeyEmployee2KeyINCL] ON [bi_cms_dds].[FactSalesTransaction]
(
	[CenterKey] ASC,
	[Employee2Key] ASC
)
INCLUDE([OrderDateKey],[ClientKey],[MembershipKey],[SalesCodeKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FactSalesTransaction_CenterKeyONLY] ON [bi_cms_dds].[FactSalesTransaction]
(
	[CenterKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FactSalesTransaction_CenterKeyOrderDateKeyINCL] ON [bi_cms_dds].[FactSalesTransaction]
(
	[CenterKey] ASC
)
INCLUDE([OrderDateKey],[SalesOrderKey],[ClientKey],[Employee1Key],[Employee2Key],[NB_TradCnt],[NB_GradCnt]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IX_FactSalesTransaction_CenterKeyOrderDateKeySalesCodeKey] ON [bi_cms_dds].[FactSalesTransaction]
(
	[CenterKey] ASC,
	[OrderDateKey] ASC,
	[SalesCodeKey] ASC
)
INCLUDE([SalesOrderKey],[SalesOrderDetailKey],[ClientKey],[MembershipKey],[ClientMembershipKey],[Quantity],[ExtendedPrice]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IX_FactSalesTransaction_ClientMembershipKeyINCL] ON [bi_cms_dds].[FactSalesTransaction]
(
	[ClientMembershipKey] ASC
)
INCLUDE([OrderDateKey],[SalesOrderKey],[SalesOrderDetailKey],[CenterKey],[MembershipKey],[SalesCodeKey],[ExtendedPrice]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IX_FactSalesTransaction_DiscountINCL] ON [bi_cms_dds].[FactSalesTransaction]
(
	[Discount] ASC
)
INCLUDE([OrderDateKey],[SalesOrderKey],[SalesOrderDetailKey],[ClientKey],[SalesCodeKey],[Employee1Key]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IX_FactSalesTransaction_INCL] ON [bi_cms_dds].[FactSalesTransaction]
(
	[SalesOrderDetailKey] ASC
)
INCLUDE([SalesOrderKey],[SalesOrderTypeKey],[CenterKey],[ClientKey],[MembershipKey],[ClientMembershipKey],[SalesCodeKey],[Employee1Key],[Employee2Key],[Employee3Key],[Employee4Key],[ContactKey],[SourceKey],[GenderKey],[OccupationKey],[EthnicityKey],[MaritalStatusKey],[HairLossTypeKey],[AgeRangeKey],[PromotionCodeKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IX_FactSalesTransaction_OrderDateKey] ON [bi_cms_dds].[FactSalesTransaction]
(
	[OrderDateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IX_FactSalesTransaction_SalesCodeKey] ON [bi_cms_dds].[FactSalesTransaction]
(
	[SalesCodeKey] ASC
)
INCLUDE([OrderDateKey],[SalesOrderKey],[SalesOrderDetailKey],[ClientKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IX_FactSalesTransaction_SalesCodeKeyINCL] ON [bi_cms_dds].[FactSalesTransaction]
(
	[SalesCodeKey] ASC
)
INCLUDE([OrderDateKey],[SalesOrderKey],[ClientKey],[Employee1Key]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IX_FactSalesTransaction_SalesOrderKeyINCL] ON [bi_cms_dds].[FactSalesTransaction]
(
	[SalesOrderKey] ASC
)
INCLUDE([SalesOrderDetailKey],[CenterKey],[ClientMembershipKey],[SalesCodeKey],[Quantity],[Price],[Discount],[ExtendedPrice]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IXX_FactSalesTransaction_SalesCodeKey] ON [bi_cms_dds].[FactSalesTransaction]
(
	[SalesCodeKey] ASC
)
INCLUDE([OrderDateKey],[SalesOrderKey],[SalesOrderDetailKey],[ClientKey],[Employee1Key],[Discount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [Temp_FactSalesTransaction_ClientMembershipKey] ON [bi_cms_dds].[FactSalesTransaction]
(
	[ClientMembershipKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
