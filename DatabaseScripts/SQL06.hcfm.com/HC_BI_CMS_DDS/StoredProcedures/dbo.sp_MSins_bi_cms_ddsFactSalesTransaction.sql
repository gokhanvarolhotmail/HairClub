/* CreateDate: 10/03/2019 23:03:42.427 , ModifyDate: 10/03/2019 23:03:42.427 */
GO
create procedure [dbo].[sp_MSins_bi_cms_ddsFactSalesTransaction]
    @c1 int,
    @c2 int,
    @c3 int,
    @c4 int,
    @c5 int,
    @c6 int,
    @c7 int,
    @c8 int,
    @c9 int,
    @c10 int,
    @c11 int,
    @c12 int,
    @c13 int,
    @c14 int,
    @c15 money,
    @c16 money,
    @c17 money,
    @c18 money,
    @c19 money,
    @c20 money,
    @c21 int,
    @c22 int,
    @c23 binary(8),
    @c24 uniqueidentifier,
    @c25 tinyint,
    @c26 tinyint,
    @c27 int,
    @c28 int,
    @c29 int,
    @c30 int,
    @c31 int,
    @c32 int,
    @c33 int,
    @c34 int,
    @c35 int,
    @c36 int,
    @c37 int,
    @c38 int,
    @c39 money,
    @c40 money,
    @c41 int,
    @c42 float,
    @c43 int,
    @c44 money,
    @c45 money,
    @c46 int,
    @c47 float,
    @c48 int,
    @c49 money,
    @c50 int,
    @c51 money,
    @c52 int,
    @c53 int,
    @c54 money,
    @c55 int,
    @c56 int,
    @c57 money,
    @c58 int,
    @c59 money,
    @c60 int,
    @c61 money,
    @c62 int,
    @c63 int,
    @c64 int,
    @c65 money,
    @c66 money,
    @c67 money,
    @c68 money,
    @c69 money,
    @c70 money,
    @c71 money,
    @c72 int,
    @c73 money,
    @c74 int,
    @c75 int,
    @c76 money,
    @c77 int,
    @c78 int,
    @c79 int,
    @c80 int,
    @c81 money,
    @c82 int,
    @c83 int,
    @c84 money,
    @c85 varchar(10),
    @c86 money,
    @c87 int,
    @c88 money,
    @c89 money,
    @c90 int,
    @c91 money,
    @c92 int,
    @c93 money,
    @c94 int,
    @c95 int,
    @c96 money,
    @c97 int,
    @c98 money,
    @c99 int,
    @c100 money,
    @c101 money,
    @c102 int,
    @c103 money,
    @c104 int,
    @c105 money
as
begin
	insert into [bi_cms_dds].[FactSalesTransaction] (
		[OrderDateKey],
		[SalesOrderKey],
		[SalesOrderDetailKey],
		[SalesOrderTypeKey],
		[CenterKey],
		[ClientKey],
		[MembershipKey],
		[ClientMembershipKey],
		[SalesCodeKey],
		[Employee1Key],
		[Employee2Key],
		[Employee3Key],
		[Employee4Key],
		[Quantity],
		[Price],
		[Discount],
		[Tax1],
		[Tax2],
		[TaxRate1],
		[TaxRate2],
		[InsertAuditKey],
		[UpdateAuditKey],
		[RowTimeStamp],
		[msrepl_tran_version],
		[IsClosed],
		[IsVoided],
		[ContactKey],
		[SourceKey],
		[GenderKey],
		[OccupationKey],
		[EthnicityKey],
		[MaritalStatusKey],
		[HairLossTypeKey],
		[AgeRangeKey],
		[PromotionCodeKey],
		[S1_SaleCnt],
		[S_CancelCnt],
		[S1_NetSalesCnt],
		[S1_NetSalesAmt],
		[S1_ContractAmountAmt],
		[S1_EstGraftsCnt],
		[S1_EstPerGraftsAmt],
		[SA_NetSalesCnt],
		[SA_NetSalesAmt],
		[SA_ContractAmountAmt],
		[SA_EstGraftsCnt],
		[SA_EstPerGraftAmt],
		[S_PostExtCnt],
		[S_PostExtAmt],
		[S_SurgeryPerformedCnt],
		[S_SurgeryPerformedAmt],
		[S_SurgeryGraftsCnt],
		[S1_DepositsTakenCnt],
		[S1_DepositsTakenAmt],
		[NB_GrossNB1Cnt],
		[NB_TradCnt],
		[NB_TradAmt],
		[NB_GradCnt],
		[NB_GradAmt],
		[NB_ExtCnt],
		[NB_ExtAmt],
		[NB_AppsCnt],
		[NB_BIOConvCnt],
		[NB_EXTConvCnt],
		[PCP_NB2Amt],
		[PCP_PCPAmt],
		[PCP_BioAmt],
		[PCP_ExtMemAmt],
		[PCPNonPgmAmt],
		[ServiceAmt],
		[RetailAmt],
		[ClientServicedCnt],
		[NetMembershipAmt],
		[S_GrossSurCnt],
		[S_SurCnt],
		[S_SurAmt],
		[AccountID],
		[PCP_UpgCnt],
		[PCP_DwnCnt],
		[NB_RemCnt],
		[NB_XTRAmt],
		[NB_XTRCnt],
		[NB_XTRConvCnt],
		[PCP_XtrAmt],
		[MbrPromotion],
		[NetSalesAmt],
		[S_PRPCnt],
		[S_PRPAmt],
		[LaserAmt],
		[S_StripCnt],
		[S_StripAmt],
		[S_ArtasCnt],
		[S_ArtasAmt],
		[LaserCnt],
		[NB_MDPCnt],
		[NB_MDPAmt],
		[NB_LaserCnt],
		[NB_LaserAmt],
		[PCP_LaserCnt],
		[PCP_LaserAmt],
		[EMP_RetailAmt],
		[EMP_NB_LaserCnt],
		[EMP_NB_LaserAmt],
		[EMP_PCP_LaserCnt],
		[EMP_PCP_LaserAmt]
	) values (
		@c1,
		@c2,
		@c3,
		@c4,
		@c5,
		@c6,
		@c7,
		@c8,
		@c9,
		@c10,
		@c11,
		@c12,
		@c13,
		@c14,
		@c15,
		@c16,
		@c17,
		@c18,
		@c19,
		@c20,
		@c21,
		@c22,
		@c23,
		@c24,
		@c25,
		@c26,
		@c27,
		@c28,
		@c29,
		@c30,
		@c31,
		@c32,
		@c33,
		@c34,
		@c35,
		@c36,
		@c37,
		@c38,
		@c39,
		@c40,
		@c41,
		@c42,
		@c43,
		@c44,
		@c45,
		@c46,
		@c47,
		@c48,
		@c49,
		@c50,
		@c51,
		@c52,
		@c53,
		@c54,
		@c55,
		@c56,
		@c57,
		@c58,
		@c59,
		@c60,
		@c61,
		@c62,
		@c63,
		@c64,
		@c65,
		@c66,
		@c67,
		@c68,
		@c69,
		@c70,
		@c71,
		@c72,
		@c73,
		@c74,
		@c75,
		@c76,
		@c77,
		@c78,
		@c79,
		@c80,
		@c81,
		@c82,
		@c83,
		@c84,
		@c85,
		@c86,
		@c87,
		@c88,
		@c89,
		@c90,
		@c91,
		@c92,
		@c93,
		@c94,
		@c95,
		@c96,
		@c97,
		@c98,
		@c99,
		@c100,
		@c101,
		@c102,
		@c103,
		@c104,
		@c105	)
end
GO