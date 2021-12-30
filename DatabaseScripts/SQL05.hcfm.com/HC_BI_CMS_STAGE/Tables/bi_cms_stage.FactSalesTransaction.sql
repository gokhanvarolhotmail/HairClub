/* CreateDate: 10/26/2011 12:13:26.680 , ModifyDate: 09/10/2021 20:31:47.870 */
GO
CREATE TABLE [bi_cms_stage].[FactSalesTransaction](
	[DataPkgKey] [int] NOT NULL,
	[OrderDateKey] [int] NULL,
	[OrderDate] [datetime] NULL,
	[SalesOrderKey] [int] NULL,
	[SalesOrderSSID] [uniqueidentifier] NULL,
	[SalesOrderDetailKey] [int] NULL,
	[SalesOrderDetailSSID] [uniqueidentifier] NULL,
	[SalesOrderTypeKey] [int] NULL,
	[SalesOrderTypeSSID] [int] NULL,
	[CenterKey] [int] NULL,
	[CenterSSID] [int] NULL,
	[ClientKey] [int] NULL,
	[ClientSSID] [uniqueidentifier] NULL,
	[MembershipKey] [int] NULL,
	[ClientMembershipKey] [int] NULL,
	[ClientMembershipSSID] [uniqueidentifier] NULL,
	[SalesCodeKey] [int] NULL,
	[SalesCodeSSID] [int] NULL,
	[Employee1Key] [int] NULL,
	[Employee1SSID] [uniqueidentifier] NULL,
	[Employee2Key] [int] NULL,
	[Employee2SSID] [uniqueidentifier] NULL,
	[Employee3Key] [int] NULL,
	[Employee3SSID] [uniqueidentifier] NULL,
	[Employee4Key] [int] NULL,
	[Employee4SSID] [uniqueidentifier] NULL,
	[Quantity] [int] NULL,
	[Price] [decimal](21, 6) NULL,
	[Discount] [money] NULL,
	[Tax1] [money] NULL,
	[Tax2] [money] NULL,
	[TaxRate1] [decimal](6, 5) NULL,
	[TaxRate2] [decimal](6, 5) NULL,
	[IsVoided] [tinyint] NULL,
	[IsClosed] [tinyint] NULL,
	[IsNew] [tinyint] NULL,
	[IsUpdate] [tinyint] NULL,
	[IsDelete] [tinyint] NULL,
	[IsDuplicate] [tinyint] NULL,
	[IsException] [tinyint] NULL,
	[IsHealthy] [tinyint] NULL,
	[IsRejected] [tinyint] NULL,
	[IsAllowed] [tinyint] NULL,
	[IsFixed] [tinyint] NULL,
	[SourceSystemKey] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[RuleKey] [int] NULL,
	[DataQualityAuditKey] [int] NULL,
	[IsNewDQA] [tinyint] NULL,
	[IsValidated] [tinyint] NULL,
	[IsLoaded] [tinyint] NULL,
	[CDC_Operation] [varchar](2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExceptionMessage] [varchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
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
	[S_StripCnt] [int] NULL,
	[S_StripAmt] [money] NULL,
	[S_ArtasCnt] [int] NULL,
	[S_ArtasAmt] [money] NULL,
	[LaserCnt] [int] NULL,
	[LaserAmt] [money] NULL,
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
) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IDX_FactSalesTransaction_SalesOrderDetailSSID_DataPkgKey] ON [bi_cms_stage].[FactSalesTransaction]
(
	[DataPkgKey] ASC,
	[SalesOrderDetailSSID] ASC,
	[IsException] ASC,
	[IsNew] ASC,
	[IsUpdate] ASC,
	[IsDelete] ASC,
	[IsDuplicate] ASC
)
INCLUDE([IsLoaded]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [FG1]
GO
CREATE NONCLUSTERED INDEX [IX_FactSalesTransaction_DataPkgKey] ON [bi_cms_stage].[FactSalesTransaction]
(
	[DataPkgKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [IX_FactSalesTransaction_DataPkgKeyONLY] ON [bi_cms_stage].[FactSalesTransaction]
(
	[DataPkgKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [bi_cms_stage].[FactSalesTransaction] ADD  CONSTRAINT [DF_FactSalesTransaction_TaxRate1]  DEFAULT ((0)) FOR [TaxRate1]
GO
ALTER TABLE [bi_cms_stage].[FactSalesTransaction] ADD  CONSTRAINT [DF_FactSalesTransaction_TaxRate2]  DEFAULT ((0)) FOR [TaxRate2]
GO
ALTER TABLE [bi_cms_stage].[FactSalesTransaction] ADD  CONSTRAINT [DF_FactSalesTransaction_IsException1]  DEFAULT ((0)) FOR [IsVoided]
GO
ALTER TABLE [bi_cms_stage].[FactSalesTransaction] ADD  CONSTRAINT [DF_FactSalesTransaction_IsException1_1]  DEFAULT ((0)) FOR [IsClosed]
GO
ALTER TABLE [bi_cms_stage].[FactSalesTransaction] ADD  CONSTRAINT [DF_FactSalesTransaction_IsNew]  DEFAULT ((0)) FOR [IsNew]
GO
ALTER TABLE [bi_cms_stage].[FactSalesTransaction] ADD  CONSTRAINT [DF_FactSalesTransaction_IsUpdate]  DEFAULT ((0)) FOR [IsUpdate]
GO
ALTER TABLE [bi_cms_stage].[FactSalesTransaction] ADD  CONSTRAINT [DF_FactSalesTransaction_IsDelete]  DEFAULT ((0)) FOR [IsDelete]
GO
ALTER TABLE [bi_cms_stage].[FactSalesTransaction] ADD  CONSTRAINT [DF_FactSalesTransaction_IsDuplicate]  DEFAULT ((0)) FOR [IsDuplicate]
GO
ALTER TABLE [bi_cms_stage].[FactSalesTransaction] ADD  CONSTRAINT [DF_FactSalesTransaction_IsException]  DEFAULT ((0)) FOR [IsException]
GO
ALTER TABLE [bi_cms_stage].[FactSalesTransaction] ADD  CONSTRAINT [DF_FactSalesTransaction_IsHealthy]  DEFAULT ((0)) FOR [IsHealthy]
GO
ALTER TABLE [bi_cms_stage].[FactSalesTransaction] ADD  CONSTRAINT [DF_FactSalesTransaction_IsRejected]  DEFAULT ((0)) FOR [IsRejected]
GO
ALTER TABLE [bi_cms_stage].[FactSalesTransaction] ADD  CONSTRAINT [DF_FactSalesTransaction_IsAllowed]  DEFAULT ((0)) FOR [IsAllowed]
GO
ALTER TABLE [bi_cms_stage].[FactSalesTransaction] ADD  CONSTRAINT [DF_FactSalesTransaction_IsFixed]  DEFAULT ((0)) FOR [IsFixed]
GO
ALTER TABLE [bi_cms_stage].[FactSalesTransaction] ADD  CONSTRAINT [DF_FactSalesTransaction_IsNewDQA]  DEFAULT ((0)) FOR [IsNewDQA]
GO
ALTER TABLE [bi_cms_stage].[FactSalesTransaction] ADD  CONSTRAINT [DF_FactSalesTransaction_IsValidated]  DEFAULT ((0)) FOR [IsValidated]
GO
ALTER TABLE [bi_cms_stage].[FactSalesTransaction] ADD  CONSTRAINT [DF_FactSalesTransaction_IsLoaded]  DEFAULT ((0)) FOR [IsLoaded]
GO
