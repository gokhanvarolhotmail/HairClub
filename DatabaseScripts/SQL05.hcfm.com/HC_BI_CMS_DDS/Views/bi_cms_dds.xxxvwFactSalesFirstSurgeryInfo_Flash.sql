/* CreateDate: 03/23/2011 08:39:55.720 , ModifyDate: 10/03/2019 22:52:23.033 */
GO
CREATE VIEW [bi_cms_dds].[xxxvwFactSalesFirstSurgeryInfo_Flash]
AS
-------------------------------------------------------------------------
-- [vwFactSalesFirstSurgeryInfo] is used to retrieve a
-- list of Sales Transactions for First Surgery Net Dollars
--
--   SELECT * FROM [bi_cms_dds].[vwFactSalesFirstSurgeryInfo_Flash]
--
-------------------------------------------------------------------------
-- Change History
-------------------------------------------------------------------------
-- Version  Date        Author       Description
-- -------  ----------  -----------  ------------------------------------
--  v1.0    03/23/2011  CFleming     Initial Creation
-------------------------------------------------------------------------

	SELECT	DD.[FullDate] AS [PartitionDate]
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

			--CCF: Changing how we are deriving First_Surgery_Contact_Amount
			--CCF: This should be 1010, 1030, 1040 - get the MoneyChange Values instead
			-- , CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1010 )
			--			  AND dm.[MembershipSSID] = 43 THEN dcm.ClientMembershipContractPrice
			--		 ELSE 0
			--END AS [SF-First_Surgery_Contract_Amount]

			,fst.[MoneyChange] AS [SF-First_Surgery_Contract_Amount]


		  , CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1010 )
						  AND dm.[MembershipSSID] = 43 THEN fst.[Quantity]
					 ELSE 0
			END AS [SF-First_Surgery_Est_Grafts]
			-- #TempAccumByDateTimePeriod.EstimatedContractPrice
		  , [bief_dds].[fn_DivideByZeroCheck](
				CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1010 ) AND dm.[MembershipSSID] = 43 THEN dcm.ClientMembershipContractPrice ELSE 0 END,
				CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1010 ) AND dm.[MembershipSSID] = 43 THEN fst.[Quantity] ELSE 0 END
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

			 --CCF: This should be Current and 1030, 1040 - get the MoneyChange Values instead
		   , CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1075,1090 )	-- Conversions {MMConv)  Renewals (MMRenew)
						  AND dm.[MembershipSSID] = 44 THEN dcm.ClientMembershipContractPrice
					 ELSE 0
				END AS [SF-Addtl_Surgery_Contract_Amount]



			--CCF:  Need to do something here?
		   , CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1075,1090 )  -- Conversions {MMConv)  Renewals (MMRenew)
						  AND dm.[MembershipSSID] = 44 THEN fst.[Quantity]
					 ELSE 0
				END AS [SF-Addtl_Surgery_Est_Grafts]

		   , [bief_dds].[fn_DivideByZeroCheck](
				CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1075,1090 ) AND dm.[MembershipSSID] = 44 THEN dcm.ClientMembershipContractPrice ELSE 0 END,
				CASE WHEN dsc.[SalesCodeDepartmentSSID] IN ( 1075,1090 ) AND dm.[MembershipSSID] = 44 THEN fst.[Quantity] ELSE 0 END
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

				----New fields
				--,MoneyChange
	   --         ,QuantityTotalChange
	   --         ,QuantityUsedChange



	  FROM [bi_cms_dds].[vwFactSalesTransaction_Flash] fst
		  INNER JOIN [bi_cms_dds].[DimSalesCode] dsc
				ON dsc.[SalesCodeKey] = fst.[SalesCodeKey]
		  INNER JOIN [bi_cms_dds].[DimMembership] dm
				ON dm.[MembershipKey] = fst.[MembershipKey]
			INNER JOIN [bi_cms_dds].[DimClientMembership]dcm
				ON dcm.[ClientMembershipKey] = fst.[ClientMembershipKey]
		LEFT OUTER JOIN  [bi_cms_dds].[synHC_ENT_DDS_DimDate] DD
			ON fst.[OrderDateKey] = DD.[DateKey]
GO
