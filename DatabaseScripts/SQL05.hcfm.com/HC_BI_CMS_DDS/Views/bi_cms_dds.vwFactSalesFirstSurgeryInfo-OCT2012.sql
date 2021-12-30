/* CreateDate: 05/03/2010 12:17:24.583 , ModifyDate: 10/03/2019 22:52:22.970 */
GO
CREATE VIEW [bi_cms_dds].[vwFactSalesFirstSurgeryInfo-OCT2012]
AS
-------------------------------------------------------------------------
-- [vwFactSalesFirstSurgeryInfo] is used to retrieve a
-- list of Sales Transactions for First Surgery Net Dollars
--
--   SELECT * FROM [bi_cms_dds].[vwFactSalesFirstSurgeryInfo]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    02/22/2010  RLifke       Initial Creation
--  v1.1    03/22/2011  CFleming     Changes to correct Surgery Flash
--  v1.2	05/27/2011	Kmurdoch	 Added Deposits
--	v1.3	03/19/2012  Kmurdoch	 Modified to only include Surgery Centers
--          04/10/2012  EKnapp		 Added join to Client and Lead
--
-------------------------------------------------------------------------

	SELECT	DD.[FullDate] AS [PartitionDate]
		  , DD.[FullDate] as [OrderDate]
		  , fst.[OrderDateKey]
		  , fst.[SalesOrderKey]
		  , fst.[SalesOrderDetailKey]
		  , fst.ClientHomeCenterKey
		  , fst.[SalesOrderTypeKey]
		  , fst.[CenterKey]
		  , fst.[ClientKey]
		  , fst.[MembershipKey]
		  , fst.[ClientMembershipKey]
		  , fst.[SalesCodeKey]
		  , fst.[AccumulatorKey]
		  , fst.[Employee1Key]
		  , fst.[Employee2Key]
		  , fst.[Employee3Key]
		  , fst.[Employee4Key]
		  , fst.[Quantity] AS [SF-Quantity]
		  , fst.[Price] AS [SF-Price]
		  , fst.[Discount] AS [SF-Discount]
		  , fst.[ExtendedPrice] AS [SF-ExtendedPrice]
		  , fst.[Tax1] AS [SF-Tax1]
		  , fst.[Tax2] AS [SF-Tax2]
		  , fst.[TaxRate1] AS [SF-TaxRate1]
		  , fst.[TaxRate2] AS [SF-TaxRate2]
		  , fst.[ExtendedPricePlusTax] AS [SF-ExtendedPricePlusTax]
		  , fst.[TotalTaxAmount] AS [SF-TotalTaxAmount]
	------------------------------------------------------------------------------------------
	--GET FIRST AND ADDITIONAL SURGERY INFORMATION
	------------------------------------------------------------------------------------------
		  ,	CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1010 ) -- Agreements (MMAgree)
				  AND dm.[MembershipSSID] = 43 THEN 1  ---- First Surgery (1stSURG)
				 ELSE 0
				END AS [SF-SaleCount]

		  ,	CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1099 ) -- Cancellations (MMCancel)
				  AND dm.[MembershipSSID] = 43 THEN 1 ---- First Surgery (1stSURG)
				 ELSE 0
				END  AS [SF-CancellationCount]

		  ,	(CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1010 ) -- Agreements (MMAgree)
				  AND dm.[MembershipSSID] = 43 THEN 1  ---- First Surgery (1stSURG)
				 ELSE 0
				END
			-
		   	CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1099 ) -- Cancellations (MMCancel)
						  AND dm.[MembershipSSID] = 43 THEN 1 ---- First Surgery (1stSURG)
					 ELSE 0
				END ) AS [SF-First_Surgery_Net_Sales]


	 	  , CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 2020 ) -- Membership Revenue (MRRevenue)
						  AND dm.[MembershipSSID] = 43 THEN fst.[ExtendedPrice] -- First Surgery (1stSURG)
					 ELSE 0
			END AS [SF-First_Surgery_Net$]

			--CCF:  Making Changes for Suregery Flash
		  , CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1010, 1030, 1040 )
			--			  AND dm.[MembershipSSID] = 43 THEN dcm.ClientMembershipContractPrice
						  AND dm.[MembershipSSID] = 43 THEN fst.[MoneyChange]
					 ELSE 0
			END AS [SF-First_Surgery_Contract_Amount]
			--,fst.[MoneyChange] AS [SF-First_Surgery_Contract_Amount]

			--CCF:  Adding 1030, 1040 and picking up QuantityTotalChange instead of fst.[Quantity].
		  , CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1010, 1030, 1040 )
						  AND dm.[MembershipSSID] = 43 THEN fst.[QuantityTotalChange]
					 ELSE 0
			END AS [SF-First_Surgery_Est_Grafts]

			--CCF: Adding 1030, 1040.  Then picking up fst.[MoneyChange] instead of dcm.ClientMembershipContractPrice and
			--CCF: fst.[QuantityTotalChange instead of fst.[Quantity]
			-- #TempAccumByDateTimePeriod.EstimatedContractPrice
		  , [bief_dds].[fn_DivideByZeroCheck](
				CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1010, 1030, 1040 ) AND dm.[MembershipSSID] = 43 THEN fst.[MoneyChange] ELSE 0 END,
				CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1010, 1030, 1040 ) AND dm.[MembershipSSID] = 43 THEN fst.[QuantityTotalChange] ELSE 0 END
				) AS [SF-First_Surgery_Est_Per_Grafts]

		  , CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1075,1090 )  -- Conversions(MMConv) Renewals (MMRenew)
						  AND dm.[MembershipSSID] = 44 THEN 1
					 ELSE 0
				END
			-
			CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1099 )  -- Cancellations (MMCancel)
						  AND dm.[MembershipSSID] = 44 THEN 1
					 ELSE 0
				END AS [SF-Addtl_Surgery_Net_Sales]

		   , CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 2020 )  -- Membership Revenue (MRRevenue)
						  AND dm.[MembershipSSID] = 44 THEN fst.[ExtendedPrice]
					 ELSE 0
			   END AS [SF-Addtl_Surgery_Net$]

			 --CCF: Adding in 1030, 1040.  Replacing dcm.ClientMembershipContractPrice with fst.[MoneyChange]
		   , CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1075, 1030, 1040, 1090 )	-- Conversions {MMConv)  Renewals (MMRenew)
						  AND dm.[MembershipSSID] = 44 THEN fst.[MoneyChange]
					 ELSE 0
				END AS [SF-Addtl_Surgery_Contract_Amount]

			--CCF:  Adding in 1030, 1040.  Replacing  fst.[Quantity] with fst.[QuantityTotalChange]
		   , CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1030, 1040, 1075, 1090 )  -- Conversions {MMConv)  Renewals (MMRenew)
						  AND dm.[MembershipSSID] = 44 THEN fst.[QuantityTotalChange]
					 ELSE 0
				END AS [SF-Addtl_Surgery_Est_Grafts]

			--CCF:	Adding in 1030, 1040. Replacing  dcm.ClientMembershipContractPrice with fst.[MoneyChange].
			--CCF:  fst.[Quantity] with fst.[QuantityTotalChange]
		   , [bief_dds].[fn_DivideByZeroCheck](
				CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1075,1030, 1040, 1090 ) AND dm.[MembershipSSID] = 44 THEN fst.[MoneyChange] ELSE 0 END,
				CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1075,1030, 1040, 1090 ) AND dm.[MembershipSSID] = 44 THEN fst.[QuantityTotalChange] ELSE 0 END
			) AS [SF-Addtl_Surgery_Est_Per_Grafts]

		   , CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 2025 ) THEN fst.[Quantity]   --  Post Extreme (MRPostExt)
					 ELSE 0
				END AS [SF-Total_POSTEXTPMT_Count]

		   , CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 2025 ) THEN fst.[ExtendedPrice]
					 ELSE 0
				END AS [SF-Total_POSTEXTPMT]

	------------------------------------------------------------------------------------------
	--GET TOTAL SURGERIES PERFORMED DATA
	------------------------------------------------------------------------------------------
		   , CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 5060 ) THEN 1  -- Surgery (SVSurg)
					 ELSE 0
				END AS [SF-Total_Surgery_Performed]

		   , CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 5060 ) THEN dcm.ClientMembershipContractPrice  -- Surgery (SVSurg)
					 ELSE 0
				END AS [SF-Total_Net$]

		   , CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 5060 ) THEN fst.[Quantity]  -- Surgery (SVSurg)
					 ELSE 0
				END AS [SF-Total_Grafts]
			, CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 7015 ) THEN fst.[Quantity]  -- Deposit Count
					 ELSE 0
				END AS [SF-DepositsTaken]
			, CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 7015 ) THEN fst.[ExtendedPrice]  --Deposits $
					 ELSE 0
				END AS [SF-DepositsTaken$]
			, dsc.[SalesCodeDepartmentSSID]
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
				ON dsc.[SalesCodeKey] = fst.[SalesCodeKey]
			INNER JOIN [bi_cms_dds].[DimMembership] dm
				ON dm.[MembershipKey] = fst.[MembershipKey]
			INNER JOIN [bi_cms_dds].[DimClientMembership]dcm
				ON dcm.[ClientMembershipKey] = fst.[ClientMembershipKey]
			LEFT OUTER JOIN  HC_BI_ENT_DDS.bief_dds.DimDate DD
				ON fst.[OrderDateKey] = DD.[DateKey]
			LEFT OUTER JOIN [bi_cms_dds].[DimClient] CLI with (nolock)
				ON fst.ClientKey = CLI.ClientKey
			LEFT JOIN bi_cms_dds.synHC_MKTG_DDS_FactLead Lead with (nolock)
				ON CLI.contactkey=Lead.ContactKey
			INNER JOIN [bi_cms_dds].[synHC_ENT_DDS_DimCenter] c
				ON fst.CenterKey = c.centerkey
	 WHERE
		c.CenterSSID LIKE '[356]%'
GO
