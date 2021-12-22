/* CreateDate: 10/03/2019 23:03:43.357 , ModifyDate: 10/03/2019 23:03:43.357 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-----------------------------------------------------------------------
 [vwFactSalesTransaction_FLASH] is used to retrieve a
 list of Sales Transactions that is brought into the Surgery Flash

   SELECT * FROM [bi_cms_dds].[vwFactSalesTransaction_Flash]

-----------------------------------------------------------------------
 Change History
-----------------------------------------------------------------------
 Version  Date        Author       Description
 -------  ----------  -----------  ------------------------------------
  v1.0    03/23/2011  CFleming     Initial Creation
  v1.1    10/11/2012  KMurdoch	   Changed left outer Joins to Inner Joins

  */
CREATE VIEW [bi_cms_dds].[vwFactSalesTransaction_Flash]
AS
SELECT
			DD.FullDate AS PartitionDate,
			fst.OrderDateKey,
			fst.SalesOrderKey,
			fst.SalesOrderDetailKey,
			fst.SalesOrderTypeKey,
			fst.CenterKey,
			fs.ClientHomeCenterKey,
            fst.ClientKey,
			fst.MembershipKey,
			fst.ClientMembershipKey,
			fst.SalesCodeKey,
			fst.Employee1Key,
			fst.Employee2Key,
			fst.Employee3Key,
			fst.Employee4Key,
            fst.Quantity,
			fst.Price,
			fst.Discount,
			fst.ExtendedPrice,
			fst.Tax1,
			fst.Tax2,
			fst.TaxRate1,
			fst.TaxRate2,
			fst.ExtendedPricePlusTax,
			fst.TotalTaxAmount,
            COALESCE (SUM(DAA.MoneyChange), 0) AS MoneyChange,
			COALESCE (SUM(DAA.QuantityTotalChange), 0) AS QuantityTotalChange,
            COALESCE (SUM(DAA.QuantityUsedChange), 0) AS QuantityUsedChange,
			DAA.AccumulatorKey,
			DAA.AccumulatorSSID,
			sc.SalesCodeDepartmentSSID,
			fst.S1_SaleCnt,
            fst.S_CancelCnt,
			fst.S1_NetSalesCnt,
			fst.S1_NetSalesAmt,
			fst.S1_ContractAmountAmt,
			fst.S1_EstGraftsCnt,
			fst.S1_EstPerGraftsAmt,
			fst.SA_NetSalesCnt,
            fst.SA_NetSalesAmt,
			fst.SA_ContractAmountAmt,
			fst.SA_EstGraftsCnt,
			fst.SA_EstPerGraftAmt,
			fst.S_PostExtCnt,
			fst.S_PostExtAmt,
			fst.S_SurgeryPerformedCnt,
            fst.S_SurgeryPerformedAmt,
			fst.S_SurgeryGraftsCnt,
			fst.S1_DepositsTakenCnt,
			fst.S1_DepositsTakenAmt,
			fst.NB_GrossNB1Cnt,
			fst.NB_TradCnt,
			fst.NB_TradAmt,
            fst.NB_GradCnt,
			fst.NB_GradAmt,
			fst.NB_ExtCnt,
			fst.NB_ExtAmt,
			fst.NB_AppsCnt,
			fst.NB_BIOConvCnt,
			fst.NB_EXTConvCnt,
			fst.PCP_NB2Amt,
			fst.PCP_PCPAmt,
            fst.PCP_BioAmt,
			fst.PCP_ExtMemAmt,
			fst.PCPNonPgmAmt,
			fst.ServiceAmt,
			fst.RetailAmt,
			fst.ClientServicedCnt,
			fst.NetMembershipAmt,
			fst.S_GrossSurCnt,
            fst.S_SurCnt,
			fst.S_SurAmt
FROM        bi_cms_dds.FactSalesTransaction AS fst
			INNER JOIN bi_cms_dds.synHC_ENT_DDS_DimDate AS DD
				ON fst.OrderDateKey = DD.DateKey
			INNER JOIN bi_cms_dds.vwFactSales AS fs
				ON fs.SalesOrderKey = fst.SalesOrderKey
			LEFT OUTER JOIN bi_cms_dds.vwDimAccumulatorAdjustment AS DAA
				ON fst.SalesOrderDetailKey = DAA.SalesOrderDetailKey AND DAA.AccumulatorSSID IN (1, 12)
			INNER JOIN bi_cms_dds.vwDimSalesCode AS sc
				ON fst.SalesCodeKey = sc.SalesCodeKey
WHERE     (ISNULL(fs.ISSURGERYREVERSALFLAG, 0) <> 1)
GROUP BY DD.FullDate, fst.OrderDateKey, fst.SalesOrderKey, fst.SalesOrderDetailKey, fst.SalesOrderTypeKey, fst.CenterKey, fs.ClientHomeCenterKey, fst.ClientKey,
                      fst.MembershipKey, fst.ClientMembershipKey, fst.SalesCodeKey, fst.Employee1Key, fst.Employee2Key, fst.Employee3Key, fst.Employee4Key, fst.Quantity, fst.Price,
                      fst.Discount, fst.ExtendedPrice, fst.Tax1, fst.Tax2, fst.TaxRate1, fst.TaxRate2, fst.ExtendedPricePlusTax, fst.TotalTaxAmount, fst.SalesOrderDetailKey,
                      DAA.AccumulatorKey, DAA.AccumulatorSSID, sc.SalesCodeDepartmentSSID, fst.S1_SaleCnt, fst.S_CancelCnt, fst.S1_NetSalesCnt, fst.S1_NetSalesAmt,
                      fst.S1_ContractAmountAmt, fst.S1_EstGraftsCnt, fst.S1_EstPerGraftsAmt, fst.SA_NetSalesCnt, fst.SA_NetSalesAmt, fst.SA_ContractAmountAmt, fst.SA_EstGraftsCnt,
                      fst.SA_EstPerGraftAmt, fst.S_PostExtCnt, fst.S_PostExtAmt, fst.S_SurgeryPerformedCnt, fst.S_SurgeryPerformedAmt, fst.S_SurgeryGraftsCnt, fst.S1_DepositsTakenCnt,
                      fst.S1_DepositsTakenAmt, fst.NB_GrossNB1Cnt, fst.NB_TradCnt, fst.NB_TradAmt, fst.NB_GradCnt, fst.NB_GradAmt, fst.NB_ExtCnt, fst.NB_ExtAmt, fst.NB_AppsCnt,
                      fst.NB_BIOConvCnt, fst.NB_EXTConvCnt, fst.PCP_NB2Amt, fst.PCP_PCPAmt, fst.PCP_BioAmt, fst.PCP_ExtMemAmt, fst.PCPNonPgmAmt, fst.ServiceAmt, fst.RetailAmt,
                      fst.ClientServicedCnt, fst.NetMembershipAmt, fst.S_GrossSurCnt, fst.S_SurCnt, fst.S_SurAmt
GO
