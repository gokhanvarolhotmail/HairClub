/* CreateDate: 03/09/2012 16:15:15.557 , ModifyDate: 09/16/2019 09:33:49.873 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [bi_cms_dds].[vwFactSalesConect-OCT2012]
AS
-------------------------------------------------------------------------
-- [vwFactSalesFirstSurgeryInfo] is used to retrieve a
-- list of Sales Transactions for First Surgery Net Dollars
--
--   SELECT * FROM [bi_cms_dds].[vwFactSalesConect]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    02/22/2010  RLifke       Initial Creation
--  v1.1    03/22/2011  CFleming     Changes to correct Surgery Flash
--  v1.2	05/27/2011	Kmurdoch	 Added Deposits
--  V1.3	03/19/2012  Kmurdoch     Modified to derive ReportingCenterSSID
--          04/10/2012  EKnapp		 Added join to Client and Lead
--
-------------------------------------------------------------------------

	SELECT		DD.[FullDate] AS [PartitionDate]
		  ,		DD.[FullDate] as [OrderDate]
		  ,		fst.[OrderDateKey]
		  ,		fst.[SalesOrderKey]
		  ,		fst.[SalesOrderDetailKey]
		  ,		fst.ClientHomeCenterKey
		  ,		fst.[SalesOrderTypeKey]
		  --,		fst.[CenterKey]
		  ,     RDC.[CenterKey]
		  ,		fst.[ClientKey]
		  ,		fst.[MembershipKey]
		  ,		fst.[ClientMembershipKey]
		  ,		fst.[SalesCodeKey]
		  ,		fst.[AccumulatorKey]
		  ,		fst.[Employee1Key]
		  ,		fst.[Employee2Key]
		  ,		fst.[Employee3Key]
		  ,		fst.[Employee4Key]
		  ,		fst.[Quantity] AS 'SF-Quantity'
		  ,		fst.[Price] AS 'SF-Price'
		  ,		fst.[Discount] AS 'SF-Discount'
		  ,		fst.[ExtendedPrice] AS 'SF-ExtendedPrice'
		  ,		fst.[Tax1] AS 'SF-Tax1'
		  ,		fst.[Tax2] AS 'SF-Tax2'
		  ,		fst.[TaxRate1] AS 'SF-TaxRate1'
		  ,		fst.[TaxRate2] AS 'SF-TaxRate2'
		  ,		fst.[ExtendedPricePlusTax] AS 'SF-ExtendedPricePlusTax'
		  ,		fst.[TotalTaxAmount] AS 'SF-TotalTaxAmount'
	------------------------------------------------------------------------------------------
	--GET FIRST AND ADDITIONAL SURGERY INFORMATION
	------------------------------------------------------------------------------------------
		  ,		CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1010 ) -- Agreements (MMAgree)
				  AND dm.[MembershipSSID] = 43 THEN 1  ---- First Surgery (1stSURG)
					ELSE 0
				END AS 'S1_Sale#'

		  ,		CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1099 ) -- Cancellations (MMCancel)
				  AND dm.[MembershipSSID] = 43 THEN 1 ---- First Surgery (1stSURG)
					ELSE 0
				END  AS 'S-Cancel#'

		  ,		CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1010 ) -- Agreements (MMAgree)
				  AND dm.[MembershipSSID] = 43 THEN 1  ---- First Surgery (1stSURG)
				 ELSE 0
				END
				-
		   		CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1099 ) -- Cancellations (MMCancel)
						  AND dm.[MembershipSSID] = 43 THEN 1 ---- First Surgery (1stSURG)
					 ELSE 0
				END  AS 'S1_NetSales#'


	 	  ,		CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 2020 ) -- Membership Revenue (MRRevenue)
						  AND dm.[MembershipSSID] = 43 THEN fst.[ExtendedPrice] -- First Surgery (1stSURG)
					 ELSE 0
				END AS 'S1_NetSales$'

		  ,		CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1010, 1030, 1040 )
						  AND dm.[MembershipSSID] = 43 THEN fst.[MoneyChange]
					 ELSE 0
				END AS 'S1_ContractAmount$'

		  ,		CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1010, 1030, 1040 )
						  AND dm.[MembershipSSID] = 43 THEN fst.[QuantityTotalChange]
					 ELSE 0
				END AS 'S1_EstGrafts#'

		  ,		[bief_dds].[fn_DivideByZeroCheck]
				(
				CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1010, 1030, 1040 ) AND dm.[MembershipSSID] = 43
					THEN fst.[MoneyChange] ELSE 0 END,
				CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1010, 1030, 1040 ) AND dm.[MembershipSSID] = 43
					THEN fst.[QuantityTotalChange] ELSE 0
					END) AS 'S1_EstPerGrafts$'

		  ,		CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1075,1090 )  -- Conversions(MMConv) Renewals (MMRenew)
						  AND dm.[MembershipSSID] = 44 THEN 1
					 ELSE 0
				END
				-
				CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1099 )  -- Cancellations (MMCancel)
						  AND dm.[MembershipSSID] = 44 THEN 1
					 ELSE 0
				END AS 'SA_NetSales#'

		   ,	CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 2020 )  -- Membership Revenue (MRRevenue)
						  AND dm.[MembershipSSID] = 44 THEN fst.[ExtendedPrice]
					 ELSE 0
				END AS 'SA_NetSales$'

		   ,	CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1075, 1030, 1040, 1090 )	-- Conversions {MMConv)  Renewals (MMRenew)
						  AND dm.[MembershipSSID] = 44 THEN fst.[MoneyChange]
					 ELSE 0
				END AS 'SA_ContractAmount$'

		   ,	CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1030, 1040, 1075, 1090 )  -- Conversions {MMConv)  Renewals (MMRenew)
						  AND dm.[MembershipSSID] = 44 THEN fst.[QuantityTotalChange]
					 ELSE 0
				END AS 'SA_EstGrafts#'

		   ,	[bief_dds].[fn_DivideByZeroCheck]
					(
					CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1075,1030, 1040, 1090 ) AND dm.[MembershipSSID] = 44
						THEN fst.[MoneyChange] ELSE 0 END,
					CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1075,1030, 1040, 1090 ) AND dm.[MembershipSSID] = 44
						THEN fst.[QuantityTotalChange] ELSE 0
					END) AS 'SA_EstPerGraft$'

		   ,	CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 2025 ) THEN fst.[Quantity]   --  Post Extreme (MRPostExt)
					 ELSE 0
				END AS 'S_PostExt#'

		   ,	CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 2025 ) THEN fst.[ExtendedPrice]
					 ELSE 0
				END AS 'S_PostExt$'

	------------------------------------------------------------------------------------------
	--GET TOTAL SURGERIES PERFORMED DATA
	------------------------------------------------------------------------------------------
		   ,	CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 5060 ) THEN 1  -- Surgery (SVSurg)
					 ELSE 0
				END AS 'S_SurgeryPerformed#'

		   ,	CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 5060 ) THEN dcm.ClientMembershipContractPrice  -- Surgery (SVSurg)
					 ELSE 0
				END AS 'S_SurgeryPerformed$'

		   ,	CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 5060 ) THEN fst.[Quantity]  -- Surgery (SVSurg)
					 ELSE 0
					END AS 'S_SurgeryGrafts#'
			,	CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 7015 ) THEN fst.[Quantity]  -- Deposit Count
					ELSE 0
					END AS 'S1_DepositsTaken#'
			,	CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 7015 ) THEN fst.[ExtendedPrice]  --Deposits $
					ELSE 0
					END AS 'S1_DepositsTaken$'
	------------------------------------------------------------------------------------------
	--GET NON SURGERY DATA
	------------------------------------------------------------------------------------------
			,	CASE WHEN dsc.[SalesCodeDepartmentSSID] IN (1010) and mem.BusinessSegmentSSID <> 3
						THEN fst.Quantity
					ELSE
						(CASE WHEN dsc.[SalesCodeDepartmentSSID] IN (1010) and mem.BusinessSegmentSSID = 3  THEN 1
								ELSE 0 END )
					END AS 'NB_GrossNB1#'
			,	(	CASE WHEN dsc.SalesCodeDepartmentSSID IN (1010) AND mem.MembershipDescriptionShort IN ('TRADITION')
						THEN fst.Quantity
					ELSE 0
					END
					-
		  			CASE WHEN dsc.SalesCodeDepartmentSSID IN (1099) AND prevmem.MembershipDescriptionShort IN ('TRADITION')
						THEN fst.Quantity
					ELSE 0
					END) AS 'NB_Trad#'
			,	CASE WHEN ((dsc.SalesCodeDepartmentSSID IN (2020)
								AND mem.RevenueGroupSSID = 1)			--RevGrp (NewBus)
								AND mem.BusinessSegmentSSID = 1					--BusSeg (BIO)
								AND mem.MembershipDescriptionShort IN ('TRADITION'))
							OR
								(dsc.salescodedescriptionshort IN ('NB1REVWO', 'EXTREVWO', 'SURCREDITPCP','SURCREDITNB1')
								AND mem.MembershipDescriptionShort NOT IN ('EXT6','EXT12','EXTENH6','EXTENH12',
												'EXTMEM','EXTMEMSOL', 'GRAD','GRADSOL6','GRADSOL12','GRDSV12','GRDSVSOL12',
												'GRDSV','GRDSVSOL','ELITENB','ELITENBSOL'))
					THEN fst.ExtendedPrice
					ELSE 0
					END AS 'NB_Trad$'
			,	(	CASE WHEN dsc.SalesCodeDepartmentSSID IN (1010)
								AND mem.MembershipDescriptionShort
									IN ('GRAD','GRADSOL6','GRADSOL12','GRDSV12','GRDSVSOL12','GRDSV','GRDSVSOL','ELITENB','ELITENBSOL')
					THEN fst.quantity
					ELSE 0
					END
					-
					CASE WHEN dsc.SalesCodeDepartmentSSID IN (1099)
								AND prevmem.MembershipDescriptionShort
										IN ('GRAD','GRADSOL6','GRADSOL12','GRDSV12','GRDSVSOL12',
											'GRDSV','GRDSVSOL','ELITENB','ELITENBSOL')
					THEN fst.quantity
					ELSE 0
					END) AS 'NB_Grad#'
			,	CASE WHEN ((dsc.SalesCodeDepartmentSSID IN (2020) OR (dsc.SalesCodeDescriptionShort LIKE 'SURCREDIT%'))
								AND mem.MembershipDescriptionShort
									IN ('GRAD','GRADSOL6','GRADSOL12','GRDSV12','GRDSVSOL12',
										'GRDSV','GRDSVSOL','ELITENB','ELITENBSOL')
								AND
									dsc.SalesCodeDescriptionShort NOT IN ('EFTFEE','PCPREVWO'))
					THEN
						fst.ExtendedPrice
					ELSE 0
					END AS 'NB_Grad$'
			,	(		CASE WHEN dsc.SalesCodeDepartmentSSID IN (1010)
							AND mem.RevenueGroupSSID = 1 --RevGrp (NewBus)
							AND mem.BusinessSegmentSSID = 2 --BusSeg (EXT)
						THEN fst.Quantity
						ELSE 0
						END
						-
						CASE WHEN dsc.SalesCodeDepartmentSSID IN (1099)
							AND prevmem.RevenueGroupSSID = 1 --RevGrp (NewBus)
							AND prevmem.BusinessSegmentSSID = 2 --BusSeg (EXT)
						THEN fst.Quantity
						ELSE 0 END) AS 'NB_Ext#'
			,	CASE WHEN ((dsc.SalesCodeDepartmentSSID IN (2020) OR (dsc.SalesCodeDescriptionShort LIKE 'SURCREDIT%'))
							AND mem.MembershipDescriptionShort IN ('EXT6','EXT12','EXTENH6','EXTENH12')
							AND dsc.SalesCodeDescriptionShort NOT IN ('EFTFEE','PCPREVWO','PCPMBRPMT'))
					THEN
							fst.ExtendedPrice
					ELSE 0
					END AS 'NB_Ext$'
			,	CASE WHEN dsc.SalesCodeDepartmentSSID IN (5010)
					THEN fst.Quantity
					ELSE 0
					END AS 'NB_Apps#'

			,	CASE WHEN dsc.SalesCodeDepartmentSSID IN (1075)
						AND prevmem.BusinessSegmentSSID not in (2,3)
					THEN fst.Quantity
					ELSE 0
					END AS 'NB_BIOConv#'

			,	CASE WHEN dsc.SalesCodeDepartmentSSID IN (1075)
						AND prevmem.BusinessSegmentSSID = 2
					THEN fst.Quantity
					ELSE 0
					END AS 'NB_EXTConv#'
			,	CASE WHEN (dsc.SalesCodeDepartmentSSID IN (2020)
								AND mem.BusinessSegmentSSID = 1 and mem.RevenueGroupSSID IN (2,3)
								AND mem.MembershipDescriptionShort NOT IN ('MODEL','EMPLOYEE','EMPLOYEXT','MODELEXT',
												'EXT6','EXT12','EXTENH6','EXTENH12')
								AND dsc.SalesCodeDescriptionShort NOT IN ('EXTREVWO','NB1REVWO'))
							OR
								(mem.MembershipDescriptionShort IN ('EXTMEM','EXTMEMSOL')
								AND dsc.SalesCodeDescriptionShort IN ('EXTREVWO'))
							OR
								(dsc.SalesCodeDepartmentSSID IN (2020) and
								 mem.MembershipDescriptionShort IN ('EXTMEM','EXTMEMSOL'))
							OR
								(dsc.SalesCodeDescriptionShort IN ('PCPREVWO','PCPMBRPMT','EFTFEE'))
									--OR
										--(mem.MembershipDescriptionShort IN ('EXT')
										--AND SC.SalesCodeDescriptionShort NOT IN ('EFTFEE'))

					THEN fst.ExtendedPrice
					ELSE 0
					END AS 'PCP_NB2$'

			,	CASE WHEN ((dsc.SalesCodeDepartmentSSID IN (2020)
								AND mem.BusinessSegmentSSID = 1 AND mem.RevenueGroupSSID = 2
								AND mem.MembershipDescriptionShort NOT IN ('NONPGM','MODEL','EMPLOYEE','EMPLOYEXT','MODELEXT',
									'EXT6','EXT12','EXTENH6','EXTENH12')
								AND dsc.SalesCodeDescriptionShort NOT IN ('EXTREVWO','NB1REVWO'))
							OR
								(mem.MembershipDescriptionShort IN ('EXTMEM','EXTMEMSOL')
									AND dsc.SalesCodeDescriptionShort IN ('EXTREVWO'))
							OR
								(mem.MembershipDescriptionShort IN ('NONPGM')
									AND dsc.SalesCodeDescriptionShort IN ('EFTFEE','PCPMBRPMT'))
							OR
								(dsc.SalesCodeDepartmentSSID IN (2020)
									AND mem.MembershipDescriptionShort IN ('EXTMEM','EXTMEMSOL'))
							OR
								(dsc.SalesCodeDescriptionShort IN ('PCPREVWO','PCPMBRPMT','EFTFEE')
									AND mem.MembershipDescriptionShort NOT IN ('NONPGM')))

					THEN fst.ExtendedPrice
					ELSE 0
					END AS 'PCP_PCP$'

			,	CASE WHEN (dsc.SalesCodeDepartmentSSID IN (2020)
							AND mem.BusinessSegmentSSID = 1 AND mem.RevenueGroupSSID = 2
							AND mem.MembershipDescriptionShort NOT IN ('NONPGM')
							AND dsc.SalesCodeDescriptionShort NOT IN ('EXTREVWO','NB1REVWO'))
						OR
							(mem.BusinessSegmentSSID = 1
							AND dsc.SalesCodeDescriptionShort IN ('EFTFEE','PCPMBRPMT','PCPREVWO'))
					THEN fst.ExtendedPrice
					ELSE 0
					END AS 'PCP_Bio$'

			,	CASE WHEN (dsc.SalesCodeDepartmentSSID IN (2020)
							AND mem.BusinessSegmentSSID = 2 AND mem.RevenueGroupSSID = 2)
						OR
							(mem.MembershipDescriptionShort IN ('EXTMEM','EXTMEMSOL')
							AND dsc.SalesCodeDescriptionShort IN ('EXTREVWO'))
					THEN fst.ExtendedPrice
					ELSE 0
					END AS 'PCP_ExtMem$'

			,	CASE WHEN (dsc.SalesCodeDepartmentSSID IN (2020)
							AND mem.MembershipDescriptionShort IN ('NONPGM','RETAIL','HCFK')
							AND dsc.SalesCodeDescriptionShort NOT IN ('PCPMBRPMT','EFTFEE'))
					THEN fst.ExtendedPrice
					ELSE 0
					END AS 'PCPNonPgm$'

			,	CASE WHEN dsc.SalesCodeDepartmentSSID IN (5010,5020,5030,5040,5050)
							AND mem.BusinessSegmentSSID IN (1,2,4)
						THEN fst.ExtendedPrice
						ELSE 0
						END AS 'Service$'

			,	CASE WHEN dscd.SalesCodeDivisionSSID = 30
							AND mem.BusinessSegmentSSID IN (1,2,4)
						THEN fst.ExtendedPrice
						ELSE 0
						END AS 'Retail$'

			,	CASE WHEN
					CASE WHEN dsc.SalesCodeDepartmentSSID IN (5010, 5020, 5030, 5040)
							AND mem.BusinessSegmentSSID IN (1,2,4)
						THEN fst.Quantity
						ELSE 0
						END > 0
					THEN 1
					ELSE 0
					END AS 'ClientServiced#'

			,	CASE WHEN (dsc.SalesCodeDepartmentSSID IN (2020))
						THEN fst.ExtendedPrice
						ELSE 0
						END AS 'NetMembership$'
			,	CASE WHEN dsc.SalesCodeDepartmentSSID IN (1010, 1075, 1090, 2025)
								and mem.BusinessSegmentSSID = 3
								AND DSOD.IsRefundedFlag = 0
						THEN 1
						ELSE 0
						END AS 'S_GrossSur#'

			,	CASE WHEN dsc.SalesCodeDescriptionShort IN ('INITASG','CONV','RENEW')
								AND mem.BusinessSegmentSSID = 3
								AND fst.AccumulatorKey = 37
						THEN 1
						ELSE
							(CASE WHEN dsc.SalesCodeDepartmentssID IN (1099)
								AND mem.BusinessSegmentSSID = 3
								AND fst.AccumulatorKey = 37
						THEN -1
						ELSE 0
						END) END AS 'S_Sur#'

			,	CASE WHEN dsc.SalesCodeDepartmentSSID IN (2020)
								AND mem.BusinessSegmentSSID = 3
						THEN ExtendedPriceCalc
						ELSE 0
						END AS 'S_Sur$'

			--, dsc.[SalesCodeDepartmentSSID]
			  , ISNULL(CLI.contactkey, -1) as contactkey
			  , ISNULL(lead.GenderKey, -1) as GenderKey
			  , ISNULL(lead.OccupationKey, -1) as OccupationKey
			  , ISNULL(lead.EthnicityKey, -1) as EthnicityKey
			  , ISNULL(lead.MaritalStatusKey, -1) as MaritalStatusKey
			  , ISNULL(lead.HairLossTypeKey, -1) as HairLossTypeKey
			  , ISNULL(lead.AgeRangeKey, -1) as AgeRangeKey
			  , ISNULL(lead.PromotionCodeKey, -1) as PromotionCodeKey

	  FROM [bi_cms_dds].[vwFactSalesTransaction_Flash] fst
		 INNER JOIN [bi_cms_dds].[DimSalesCode] dsc
				ON fst.[SalesCodeKey] = dsc.[SalesCodeKey]
		  INNER JOIN [bi_cms_dds].[DimSalesCodeDepartment] dscd
				ON dsc.SalesCodeDepartmentKey = dscd.SalesCodeDepartmentKey
		  INNER JOIN [bi_cms_dds].[DimMembership] dm
				ON fst.[MembershipKey] = dm.[MembershipKey]
		  INNER JOIN [bi_cms_dds].[DimClientMembership] dcm
				ON fst.[ClientMembershipKey] = dcm.[ClientMembershipKey]
		  INNER JOIN [bi_cms_dds].[DimMembership] mem
				ON dcm.MembershipSSID = mem.MembershipSSID
		  INNER JOIN [bi_cms_dds].[DimSalesOrderDetail] dsod
				ON fst.SalesOrderDetailKey = dsod.SalesOrderDetailKey
		  LEFT OUTER JOIN [bi_cms_dds].[DimClientMembership] prevdcm
				ON dsod.[PreviousClientMembershipSSID] = prevdcm.[ClientMembershipSSID]
				and dsod.PreviousClientMembershipSSID <> '00000000-0000-0000-0000-000000000002'
		  LEFT OUTER JOIN [bi_cms_dds].[DimMembership] prevmem
				ON prevdcm.MembershipSSID = prevmem.MembershipSSID
		  INNER JOIN  [bi_cms_dds].[synHC_ENT_DDS_DimDate] DD
				ON fst.[OrderDateKey] = DD.[DateKey]
		  INNER JOIN  HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
				ON fst.CenterKey = DC.CenterKey
		  INNER JOIN  HC_BI_ENT_DDS.bi_ent_dds.DimCenter RDC
				ON DC.ReportingCenterSSID = RDC.CenterSSID
			INNER JOIN [bi_cms_dds].[DimClient] CLI with (nolock)
				ON fst.ClientKey = CLI.ClientKey
			LEFT JOIN bi_cms_dds.synHC_MKTG_DDS_FactLead Lead with (nolock)
				ON CLI.contactkey=Lead.ContactKey


where dsc.SalesCodeDescriptionShort NOT IN ('UPDMBR','TXFROUT')
GO
