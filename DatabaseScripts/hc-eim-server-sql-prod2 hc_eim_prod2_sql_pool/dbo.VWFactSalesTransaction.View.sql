/****** Object:  View [dbo].[VWFactSalesTransaction]    Script Date: 3/15/2022 2:11:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VWFactSalesTransaction] AS WITH MEDADDON AS (
	SELECT	ROW_NUMBER() OVER ( PARTITION BY clt.ClientIdentifier,sc.SalesCodeDescriptionShort ORDER BY so.OrderDate DESC) AS 'Ranking'
			,		so.SalesOrderGUID
			,		sod.SalesOrderDetailGUID
			,		so.InvoiceNumber
			,		clt.ClientIdentifier
			,		clt.ClientFullNameAltCalc
			,		m.MembershipDescription
			,		cms.ClientMembershipStatusDescription
			,		so.OrderDate
			,		sc.SalesCodeDescriptionShort
			,		sc.SalesCodeDescription
			,		sod.ExtendedPriceCalc
	FROM	[ODS].[CNCT_datSalesOrderDetail]  sod
			INNER JOIN [ODS].[CNCT_datSalesOrder] so
				ON so.SalesOrderGUID = sod.SalesOrderGUID
			INNER JOIN [ODS].[CNCT_Center] ctr
				ON ctr.CenterID = so.CenterID
			INNER JOIN [ODS].[CNCT_lkpTimeZone] tz
				ON tz.TimeZoneID = ctr.TimeZoneID
			INNER JOIN [ODS].[CNCT_cfgSalesCode] sc
				ON sc.SalesCodeID = sod.SalesCodeID
			INNER JOIN [ODS].[CNCT_datClient] clt
				ON clt.ClientGUID = so.ClientGUID
			INNER JOIN [ODS].[CNCT_datClientMembership]  cm
				ON cm.ClientMembershipGUID = so.ClientMembershipGUID
			INNER JOIN [ODS].[CNCT_lkpClientMembershipStatus] cms
				ON cms.ClientMembershipStatusID = cm.ClientMembershipStatusID
			INNER JOIN [ODS].[CNCT_cfgMembership] m
				ON m.MembershipID = cm.MembershipID
	WHERE	(sc.[SalesCodeDescriptionShort] IN ( 'MEDADDONTG','MEDADDONTG9','HMEDADDON','HMEDADDON3')
				OR sc.SalesCodeID IN(912,913,1653,1654,1655,1656,1661,1662,1664,1665) 	--Add-on Salescodes in Dept 2025 5/1/2017 km
				AND m.membershipid in ( 43,44,259,260,261,262,263,264,265,266,267,268,269,270,316,317 ))
				OR(sc.[SalesCodeDepartmentID] IN ( 1060 )
				AND sc.[SalesCodeDescriptionShort] = 'CANCELADDON'
				AND m.BusinessSegmentID = 3)
			AND so.IsVoidedFlag = 0
), Services AS (
	SELECT	ROW_NUMBER() OVER ( PARTITION BY clt.ClientIdentifier ORDER BY so.OrderDate ) AS 'RowID'
				,		so.SalesOrderGUID
				,		sod.SalesOrderDetailGUID
				,		so.InvoiceNumber
				,		clt.ClientIdentifier
				,		CONVERT(VARCHAR, clt.ClientIdentifier) + ' - ' + clt.ClientFullNameAlt2Calc AS 'ClientName'
				,		m.MembershipDescription AS 'Membership'
				,		cms.ClientMembershipStatusDescription AS 'MembershipStatus'
				--,		HairClubCMS.dbo.GetLocalFromUTC(so.OrderDate, tz.UTCOffset, tz.UsesDayLightSavingsFlag) AS 'OrderDate'
				,		sc.SalesCodeDescriptionShort AS 'SalesCode'
				,		sc.SalesCodeDescription AS 'Description'
				,		sod.ExtendedPriceCalc AS 'Price'
	FROM	[ODS].[CNCT_datSalesOrderDetail] sod
			INNER JOIN [ODS].[CNCT_datSalesOrder] so
				ON so.SalesOrderGUID = sod.SalesOrderGUID
			INNER JOIN [ODS].[CNCT_Center] ctr
				ON ctr.CenterID = so.CenterID
			INNER JOIN [ODS].[CNCT_lkpTimeZone] tz
				ON tz.TimeZoneID = ctr.TimeZoneID
			INNER JOIN [ODS].[CNCT_cfgSalesCode] sc
				ON sc.SalesCodeID = sod.SalesCodeID
			INNER JOIN [ODS].[CNCT_datClient] clt
				ON clt.ClientGUID = so.ClientGUID
			INNER JOIN [ODS].[CNCT_datClientMembership] cm
				ON cm.ClientMembershipGUID = so.ClientMembershipGUID
			INNER JOIN [ODS].[CNCT_lkpClientMembershipStatus] cms
				ON cms.ClientMembershipStatusID = cm.ClientMembershipStatusID
			INNER JOIN [ODS].[CNCT_cfgMembership] m
				ON m.MembershipID = cm.MembershipID
	WHERE	sc.SalesCodeDepartmentID = 5062
			AND sc.SalesCodeDescriptionShort NOT IN ( 'SVCSMP', 'ADDONMDP' )
			AND so.IsVoidedFlag = 0
)
SELECT
	FST.[OrderDate]
	,dbo.GetLocalFromUTC(FST.[OrderDate], TZ.[UTCOffset], TZ.[UsesDayLightSavingsFlag]) AS [OrderDateLocalUTC]
	,CONVERT(DATETIME,FST.[OrderDate] AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time') AS [OrderDateEastern]
	--dateadd(mi,datepart(tz,CONVERT(datetime,FST.[OrderDate] ) AT TIME ZONE 'Eastern Standard Time')) AS [OrderDate]
	--, FST.[OrderDate] AS [OrderDateOriginal]
	, FST.[OrderDetailId]
	, FST.[OrderId]
	, FST.[SalesCodeKey]
	, FST.[SalesCodeId]
	, DSC.[SalesCodeName]
	, FST.[SalesCodeDepartmentKey]
	, FST.[SalesCodeDepartmentId]
	, DSCD.[SalesCodeDepartmentName]
	, FST.[OrderTypeKey]
	, FST.[OrderTypeId]
	, FST.[CenterKey]
	, FST.[CenterId]
	, FST.[MembershipKey]
	, FST.[MembershipId]
	, DM.[RevenueGroupID]
	, DM.[BusinessSegmentID]
	, FST.[OrderUserId]
	, FST.[CustomerId]
	, FST.[LeadId]
	, FST.[AccountId]
	, FST.[AppointmentId]
	, FST.[PerformerId]
	, FST.[OrderQuantity]
	, FST.[OrderExtendedPriceCalc]
	, FST.[OrderPrice]
	, FST.[OrderDiscount]
	, FST.[OrderTax1]
	, FST.[OrderTax2]
	, FST.[OrderTaxRate1]
	, FST.[OrderTaxRate2]
	, CASE WHEN FST.[SalesCodeDepartmentId] IN ( 1010 )   -- Agreements (MMAgree)
			AND FST.[MembershipId] IN (43,259,260,261,262,263,264,316) ---- First Surgery (1stSURG)
			THEN 1  ELSE 0
		END S1_SaleCnt

	, CASE WHEN FST.[SalesCodeDepartmentId] IN ( 1099 ) -- Cancellations (MMCancel)
			AND FST.[MembershipId] in (43,259,260,261,262,263,264, 44,265,266,267,268,269,270,316,317)  ---- First Surgery (1stSURG)
			THEN 1 ELSE 0
			END S_CancelCnt

	, CASE WHEN FST.[SalesCodeDepartmentId] IN ( 1010 ) -- Agreements (MMAgree)
			AND FST.[MembershipId]  IN(43,259,260,261,262,263,264,316) ---- First Surgery (1stSURG)
			THEN 1  ELSE 0 END
				-
			CASE WHEN FST.[SalesCodeDepartmentId] IN ( 1099 ) -- Cancellations (MMCancel)
			AND FST.[MembershipId]  IN (43,259,260,261,262,263,264,316) ---- First Surgery (1stSURG)
			THEN 1 ELSE 0
			END  AS S1_NetSalesCnt

	, CASE WHEN FST.[SalesCodeDepartmentId] IN ( 2020 ) -- Membership Revenue (MRRevenue)
			AND FST.[MembershipId]  IN (58,43,259,260,261,262,263,264,316)
			AND FST.[SalesCodeId] NOT IN (912,913,1653,1654,1655,1656,1661,1662,1664,1665)   --Removing PRP from Addtl Surgery Amount -- First Surgery (1stSURG)
			THEN FST.[OrderExtendedPriceCalc] ELSE 0
			END S1_NetSalesAmt

	, CASE WHEN FST.[SalesCodeDepartmentId] IN ( 1010, 1030, 1040 )
			AND FST.[MembershipId]  IN (43,259,260,261,262,263,264,316)
			THEN FST.[ContBalMoneyChange] ELSE 0
			END S1_ContractAmountAmt

	, CASE WHEN FST.[SalesCodeDepartmentId] IN ( 1010, 1030, 1040 )
			AND FST.[MembershipId]  IN (43,259,260,261,262,263,264,316)
			THEN FST.[GraftsQuantityTotalChange] ELSE 0
			END  S1_EstGraftsCnt

	, CASE WHEN FST.[PPSGMoneyAdjustment] <> 0
			AND FST.[MembershipId]  IN (43,259,260,261,262,263,264,316)
			THEN FST.[PPSGMoneyAdjustment] ELSE 0
			END AS S1_EstPerGraftsAmt

	, CASE WHEN FST.[SalesCodeDepartmentId] IN ( 1075,1090 )  -- Conversions(MMConv) Renewals (MMRenew)
			AND FST.[MembershipId]  IN(44,265,266,267,268,269,270,317)
			THEN 1 ELSE 0 END
				-
			CASE WHEN FST.[SalesCodeDepartmentId] IN ( 1099 )  -- Cancellations (MMCancel)
			AND FST.[MembershipId]  IN (44,265,266,267,268,269,270,317)
			THEN 1 ELSE 0
			END SA_NetSalesCnt

	, CASE WHEN FST.[SalesCodeDepartmentId] IN ( 2020 )  -- Membership Revenue (MRRevenue)
			AND FST.[MembershipId]  IN (44,265,266,267,268,269,270,317)
			AND FST.[SalesCodeId] NOT IN (912,913,1653,1654,1655,1656,1661,1662,1664,1665) --Removing PRP from Addtl Surgery Amount
			THEN FST.[OrderExtendedPriceCalc] ELSE 0
			END AS SA_NetSalesAmt

	, CASE WHEN FST.[SalesCodeDepartmentId] IN ( 1075, 1030, 1040, 1090 )	-- Conversions {MMConv)  Renewals (MMRenew)
			AND FST.[MembershipId]  IN (44,265,266,267,268,269,270,317)
			THEN FST.[ContBalMoneyChange] ELSE 0
			END AS SA_ContractAmountAmt

	, CASE WHEN FST.[SalesCodeDepartmentId] IN ( 1030, 1040, 1075, 1090 )  -- Conversions {MMConv)  Renewals (MMRenew)
			AND FST.[MembershipId]  IN(44,265,266,267,268,269,270,317)
			THEN FST.[GraftsQuantityTotalChange] ELSE 0
			END AS SA_EstGraftsCnt

	, CASE WHEN FST.[PPSGMoneyAdjustment] <> 0
			AND FST.[MembershipId]  IN(44,265,266,267,268,269,270,317)
			THEN FST.[PPSGMoneyAdjustment] ELSE 0
			END AS SA_EstPerGraftAmt

	, CASE
			WHEN CONVERT(DATE,FST.[OrderDate]) <  '2013-10-05'
					THEN CASE WHEN FST.[SalesCodeDepartmentId] IN ( 2025 ) --AND DM.[BusinessSegmentID] in ( 2,3 )  --  Post Extreme (MRPostExt)
								THEN FST.[OrderQuantity] ELSE 0 END
			WHEN CONVERT(DATE,FST.[OrderDate]) >=  '2013-10-05'
			THEN CASE WHEN CC.[CenterBusinessTypeID] = 1
						THEN CASE WHEN (FST.[SalesCodeDepartmentId] IN ( 2025 )
							AND DM.[BusinessSegmentID] IN ( 2,3 )
							AND FST.[SalesCodeId] NOT IN(917,918,1230,1231) )   --'MEDADDONTG','MEDADDONTG9','HMEDADDON','HMEDADDON3' --  Post Extreme (MRPostExt)
							THEN FST.[OrderQuantity] ELSE 0 END
				WHEN CC.[CenterBusinessTypeID] IN (2,3)
				THEN CASE WHEN FST.[SalesCodeDepartmentId] IN ( 1010,1015 )
							AND FST.[MembershipId] = 13
							THEN FST.[OrderQuantity] ELSE 0 END --WHEN FST.[SalesCodeDepartmentId] IN ( 1006 )	--Additional Medical Services--		THEN 1
				-
			CASE WHEN FST.[SalesCodeDepartmentId] IN ( 1099 )
					AND FST.[MembershipId] = 13
					THEN 1 ELSE 0
					END
				END
			END S_PostExtCnt

	, CASE WHEN (FST.[SalesCodeDepartmentId] IN ( 2025 )	--Add-on Salescodes in Dept 2025 5/1/2017 km
			AND DM.[BusinessSegmentID] IN ( 2,3 )
			AND DSC.[SalesCodeNameShort] NOT IN ( 'BOSMEMADJTG','BOSMEMADJTGBPS','MEDADDONPMTTRI' ) )
			OR (FST.[SalesCodeDepartmentId] IN (2020) AND FST.[MembershipId] = 13)
			OR (DSC.[SalesCodeNameShort] IN ('NB1REVWO', 'EXTREVWO') AND DM.[MembershipShortName] IN ('POSTEXT'))
			THEN FST.[OrderExtendedPriceCalc] ELSE 0
			END S_PostExtAmt

	, CASE WHEN (MEDADDON.SalesOrderDetailGUID IS NOT NULL AND DSC.[SalesCodeNameShort] IN ( 'MEDADDONTG','MEDADDONTG9','HMEDADDON','HMEDADDON3')	--Add-on Salescodes in Dept 2025 5/1/2017 km
					AND FST.[MembershipId] in ( 43,44,259,260,261,262,263,264,265,266,267,268,269,270,316,317 ))
			THEN 1 ELSE 0 END
				-
			CASE WHEN (MEDADDON.SalesOrderDetailGUID IS NOT NULL AND FST.[SalesCodeDepartmentId] IN ( 1060 )
						AND DSC.[SalesCodeNameShort] = 'CANCELADDON' AND DM.[BusinessSegmentID] = 3) --Surgery
				THEN 1 ELSE 0
			END AS S_PRPCnt

	, CASE WHEN (FST.[SalesCodeId] IN (912,913,1653,1654,1655,1656,1661,1662,1664,1665)  --These are Tri-Gen or PRP Add-Ons
			AND FST.[MembershipId] IN ( 43,44,259,260,261,262,263,264,265,266,267,268,269,270,316,317 ))
			THEN FST.[OrderExtendedPriceCalc] ELSE 0
			END S_PRPAmt

	, CASE WHEN FST.[SalesCodeDepartmentId] IN ( 5060 ) -- Surgery (SVSurg)
			THEN 1 ELSE 0
			END AS S_SurgeryPerformedCnt

	, CASE WHEN FST.[SalesCodeDepartmentId] IN ( 5060 ) -- Surgery (SVSurg)
			THEN DCM.[CustomerMembershipContractPrice]  ELSE 0
			END AS S_SurgeryPerformedAmt

	, CASE WHEN FST.[SalesCodeDepartmentId] IN ( 5060 )   -- Surgery (SVSurg)
			THEN FST.[OrderQuantity] ELSE 0
			END AS S_SurgeryGraftsCnt

	, CASE WHEN FST.[SalesCodeDepartmentId] IN ( 7015 ) -- Deposit Count
			THEN FST.[OrderQuantity] ELSE 0
			END AS S1_DepositsTakenCnt

	, CASE WHEN FST.[SalesCodeDepartmentId] IN ( 7015 )  --Deposits Amt
			THEN FST.[OrderExtendedPriceCalc] ELSE 0
			END AS S1_DepositsTakenAmt

	, ISNULL(( CASE WHEN FST.[SalesCodeDepartmentId] IN ( 1010 ) AND DM.[BusinessSegmentID] <> 3
				AND DM.[RevenueGroupID] = 1 AND DM.[MembershipShortName] NOT IN ( 'SHOWSALE', 'SHOWNOSALE', 'SNSSURGOFF', 'RETAIL', 'HCFK', 'NONPGM', 'MODEL', 'EMPLOYEE', 'EMPLOYEXT', 'MODELEXT','EMPLOYEE6' )
			THEN 1 ELSE ( CASE WHEN FST.[SalesCodeDepartmentId] IN ( 1010, 2025, 1075, 1090 ) AND DSC.[SalesCodeNameShort] NOT IN ( 'POSTEXTPMT','POSTEXTPMTUS' )
											AND DM.[MembershipShortName] NOT IN ( 'SHOWSALE', 'SHOWNOSALE', 'SNSSURGOFF', 'RETAIL' ) AND DM.[BusinessSegmentID] = 3	AND FST.[OrderQuantity] > 0
											THEN 1 ELSE 0 END)
			END), 0) + ISNULL(( CASE WHEN Services.SalesOrderDetailGUID IS NOT NULL THEN 1 ELSE 0 END ), 0) AS NB_GrossNB1Cnt

	, CASE WHEN FST.[IsGuarantee]= 1
			THEN (CASE WHEN FST.[SalesCodeDepartmentId] IN (1010)
						AND DM.[MembershipShortName] IN ('TRADITION','NALACARTE','NFOLLIGRFT','HWBRIO')
						THEN 1 ELSE 0 END
						-
  					CASE WHEN FST.[SalesCodeDepartmentId] IN (1099)
						AND (DM.[MembershipShortName] IN ('TRADITION','NALACARTE','NFOLLIGRFT','HWBRIO'))
						THEN 1 ELSE 0 END)
						ELSE (CASE WHEN FST.[SalesCodeDepartmentId] IN (1010)
								AND DM.[MembershipShortName] IN ('TRADITION','NALACARTE','NFOLLIGRFT','HWBRIO')
								THEN 1 ELSE 0 END
						-
  					CASE WHEN FST.[SalesCodeDepartmentId] IN (1099)
						AND (PREVDM.[MembershipShortName] IN ('TRADITION','NALACARTE','NFOLLIGRFT','HWBRIO')
						or DM.[MembershipShortName] in ('TRADITION','NALACARTE','NFOLLIGRFT','HWBRIO')
					) THEN 1 ELSE 0 END)
			END	AS NB_TradCnt

	, CASE WHEN ((FST.[SalesCodeDepartmentId] IN (2020) AND DM.[RevenueGroupID] = 1 ) --RevGrp (NewBus)
			AND DM.[BusinessSegmentID] = 1 --BusSeg (BIO)
			AND DM.[MembershipShortName] IN ( 'TRADITION','NALACARTE','NFOLLIGRFT','HWBRIO' ))
			OR (DSC.[SalesCodeNameShort] IN ( 'NB1REVWO', 'EXTREVWO', 'SURCREDITPCP','SURCREDITNB1' )
				AND DM.[MembershipShortName] NOT IN ( 'EXT6','EXT12','EXT18','EXTENH6','EXTENH12', 'EXTENH9',
					'EXTMEM','EXTMEMSOL','EXTINITIAL','EXTPREMMEN', 'EXTPREMWOM', 'GRAD','GRDSVEZ','GRAD12','GRDSVEZ','GRADSOL12','GRADSOL6','GRADSOL12','GRDSV12','GRDSVSOL12',
					'GRDSV','GRDSVSOL','ELITENB','ELITENBSOL','NSILVER','NMINIPREM','NGOLD','NPLATINUM','NDIAMOND','NPREMIERE','NSUPERPREM','NULTRAPREM','NPREM24','NPREM36',
					'NPREM48','NPREM60','NPREM72','POSTEXT', 'EXTFLEX', 'EXTFLEXSOL' ))
			AND FST.[SalesCodeDepartmentId] <> 3065 --Exclude Laser
			THEN FST.[OrderExtendedPriceCalc] ELSE 0
			END AS NB_TradAmt

	, CASE WHEN FST.[IsGuarantee] = 1
			THEN (CASE WHEN FST.[SalesCodeDepartmentId] IN (1010)
					AND DM.[MembershipShortName]
					IN ('GRAD','GRAD12','GRDSVEZ','GRADSOL12','GRADSOL6','GRADSOL12','GRDSV12','GRDSVSOL12','GRDSV','GRDSVSOL','ELITENB','ELITENBSOL','NSILVER',
						'NMINIPREM','NGOLD','NPLATINUM','NDIAMOND','NPREMIERE','NSUPERPREM','NULTRAPREM','NPREM24','NPREM36',
						'NPREM48','NPREM60','NPREM72','HWSILVER','HWGOLD','HWPLAT')
					THEN 1 ELSE 0 END
						-
				CASE WHEN FST.[SalesCodeDepartmentId] IN (1099)
					AND (DM.[MembershipShortName]
					IN ('GRAD','GRAD12','GRDSVEZ','GRADSOL12','GRADSOL6','GRADSOL12','GRDSV12','GRDSVSOL12','GRDSV','GRDSVSOL','ELITENB','ELITENBSOL','NSILVER',
						'NMINIPREM','NGOLD','NPLATINUM','NDIAMOND','NPREMIERE','NSUPERPREM','NULTRAPREM','NPREM24','NPREM36',
						'NPREM48','NPREM60','NPREM72','HWSILVER','HWGOLD','HWPLAT'))
					THEN 1 ELSE 0 END)
					ELSE (CASE WHEN FST.[SalesCodeDepartmentId] IN (1010)
							AND DM.[MembershipShortName]
							IN ('GRAD','GRAD12','GRDSVEZ','GRADSOL12','GRADSOL6','GRADSOL12','GRDSV12','GRDSVSOL12','GRDSV','GRDSVSOL','ELITENB','ELITENBSOL','NSILVER',
								'NMINIPREM','NGOLD','NPLATINUM','NDIAMOND','NPREMIERE','NSUPERPREM','NULTRAPREM','NPREM24','NPREM36',
								'NPREM48','NPREM60','NPREM72','HWSILVER','HWGOLD','HWPLAT')
						THEN 1 ELSE 0 END
						-
					CASE WHEN FST.[SalesCodeDepartmentId] IN (1099)
							AND (PREVDM.[MembershipShortName]
							IN ('GRAD','GRAD12','GRDSVEZ','GRADSOL12','GRADSOL6','GRADSOL12','GRDSV12','GRDSVSOL12','GRDSV','GRDSVSOL','ELITENB','ELITENBSOL','NSILVER',
								'NMINIPREM','NGOLD','NPLATINUM','NDIAMOND','NPREMIERE','NSUPERPREM','NULTRAPREM','NPREM24','NPREM36',
								'NPREM48','NPREM60','NPREM72','HWSILVER','HWGOLD','HWPLAT')
								OR
								DM.[MembershipShortName] IN ('GRAD','GRAD12','GRDSVEZ','GRADSOL12','GRADSOL6','GRADSOL12','GRDSV12','GRDSVSOL12','GRDSV','GRDSVSOL',
																'ELITENB','ELITENBSOL','NSILVER','NMINIPREM','NGOLD','NPLATINUM','NDIAMOND','NPREMIERE','NSUPERPREM',
																'NULTRAPREM','NPREM24','NPREM36','NPREM48','NPREM60','NPREM72','HWSILVER','HWGOLD','HWPLAT'))
							THEN 1 ELSE 0 END)
					END AS NB_GradCnt

	, CASE WHEN ((( FST.[SalesCodeDepartmentId] IN ( 2020 ) OR DSC.[SalesCodeNameShort] LIKE 'SURCREDIT%' )
			AND DM.[MembershipShortName] IN ('GRAD','GRAD12','GRDSVEZ','GRADSOL12','GRADSOL6','GRADSOL12','GRDSV12','GRDSVSOL12','GRDSV','GRDSVSOL','ELITENB','ELITENBSOL',
													'NSILVER', 'NMINIPREM','NGOLD','NPLATINUM','NDIAMOND','NPREMIERE','NSUPERPREM','NULTRAPREM','NPREM24','NPREM36', 'NPREM48',
													'NPREM60','NPREM72','HWSILVER','HWGOLD','HWPLAT')
			AND DSC.[SalesCodeNameShort] NOT IN ('EFTFEE','PCPREVWO')
			AND FST.[SalesCodeDepartmentId] <> 3065)
			OR ( FST.[SalesCodeDepartmentId] IN ( 2020 ) AND DM.[MembershipShortName] IN ( 'GRDSVEZ' )))
			THEN FST.[OrderExtendedPriceCalc] ELSE 0
			END AS NB_GradAmt

	, CASE WHEN FST.[IsGuarantee] = 1
			THEN (CASE WHEN FST.[SalesCodeDepartmentId] IN (1010)
					AND DM.[RevenueGroupID] = 1 --RevGrp (NewBus)
					AND DM.[BusinessSegmentID] = 2 --BusSeg (EXT)
					AND DM.[MembershipShortName] <> 'POSTEXT'
					THEN 1 ELSE 0 END
				-
				CASE WHEN FST.SalesCodeDepartmentID IN (1099)
					AND DM.[MembershipShortName] IN ('EXT6', 'EXT12', 'EXT18','EXTENH6', 'EXTENH12', 'EXTENH9', 'EXTINITIAL',
														'NRESTORWK','NRESTBIWK','NRESTORE','LASER82','HWEXTBAS','HWEXTPLUS','HWANAGEN')
					THEN 1 ELSE 0 END)
					ELSE(CASE WHEN FST.[SalesCodeDepartmentId] IN (1010)
								AND DM.[RevenueGroupID] = 1 --RevGrp (NewBus)
								AND DM.[BusinessSegmentID] = 2 --BusSeg (EXT)
								AND DM.[MembershipShortName] <> 'POSTEXT'
							THEN 1 ELSE 0 	END
							-
							CASE WHEN FST.[SalesCodeDepartmentId] IN (1099)
								AND (PREVDM.[RevenueGroupID] = 1 or DM.[RevenueGroupID] = 1) --RevGrp (NewBus)
								AND (PREVDM.[BusinessSegmentID] = 2  or DM.[BusinessSegmentID] = 2)--BusSeg (EXT)
								AND (PREVDM.[MembershipShortName] <> 'POSTEXT'
									OR DM.[MembershipShortName] <> 'POSTEXT')
					THEN 1 ELSE 0 END)
			END AS NB_ExtCnt

	, CASE WHEN (( FST.[SalesCodeDepartmentId] IN (2020) OR (DSC.[SalesCodeNameShort] LIKE 'SURCREDIT%') )
			AND DM.[MembershipShortName] IN ('EXT6', 'EXT12', 'EXT18','EXTENH6', 'EXTENH12', 'EXTENH9', 'EXTINITIAL','NRESTORWK','NRESTBIWK',
													'NRESTORE', 'LASER82','HWEXTBAS','HWEXTPLUS','HWANAGEN')
			AND DSC.[SalesCodeNameShort]NOT IN ('EFTFEE','PCPREVWO','PCPMBRPMT')
			AND FST.[SalesCodeDepartmentId] <> 3065 --Exclude Laser
			) THEN FST.[OrderExtendedPriceCalc] ELSE 0
			END AS NB_ExtAmt

	, CASE WHEN FST.[IsGuarantee] = 1
			THEN (CASE WHEN FST.[SalesCodeDepartmentId] IN (1010)
						AND DM.[RevenueGroupID] = 1 AND DM.[BusinessSegmentID] = 6
						THEN 1 ELSE 0 END
					-
					CASE WHEN DM.[RevenueGroupID] IN (1099)
						--AND DM.[MembershipShortName] IN ('Xtrand','Xtrand6', 'Xtrand12') --RH 08/13/2018
						AND DM.[RevenueGroupID] = 1 AND DM.[BusinessSegmentID] = 6
						THEN 1 	ELSE 0 	END)
			ELSE (CASE WHEN FST.[SalesCodeDepartmentId] IN (1010)
						--AND DM.[MembershipShortName] IN ('Xtrand','Xtrand6', 'Xtrand12') --RH 08/13/2018
						AND DM.[RevenueGroupID] = 1 AND DM.[BusinessSegmentID] = 6
						THEN 1 ELSE 0 END
					-
					CASE WHEN FST.[SalesCodeDepartmentId] IN (1099)
						--AND (PREVDM.MembershipDescriptionShort IN ('Xtrand','Xtrand6', 'Xtrand12') --RH 08/13/2018
						--OR DM.[MembershipShortName] in ('Xtrand','Xtrand6', 'Xtrand12'))
						AND ((PREVDM.[RevenueGroupID] = 1 AND PREVDM.[BusinessSegmentID] = 6)
						OR (DM.[RevenueGroupID] = 1 AND DM.[BusinessSegmentID] = 6))
						THEN 1 ELSE 0 END)
			END	AS NB_XtrCnt

	, CASE WHEN (FST.[SalesCodeDepartmentId] IN (2020) AND DM.[RevenueGroupID] = 1
					AND DM.[BusinessSegmentID] = 6	AND FST.[SalesCodeDepartmentId] <> 3065 --Exclude Laser
				) THEN FST.[OrderExtendedPriceCalc] ELSE 0
				END AS NB_XtrAmt

	, CASE WHEN FST.[SalesCodeDepartmentId] IN (5010) THEN FST.[OrderQuantity] ELSE 0
			END AS NB_AppsCnt

	, CASE WHEN FST.[SalesCodeDepartmentId] IN (1075) AND PREVDM.[RevenueGroupID] = 1 AND DM.[RevenueGroupID] = 2 AND DM.[BusinessSegmentID] = 1
			THEN FST.[OrderQuantity] ELSE 0
			END AS NB_BIOConvCnt

	, CASE WHEN FST.[SalesCodeDepartmentId] IN (1075) AND PREVDM.RevenueGroupID = 1 AND DM.[RevenueGroupID] = 2	AND DM.[BusinessSegmentID] = 2
			THEN FST.[OrderQuantity] ELSE 0
			END AS NB_EXTConvCnt

	, CASE WHEN FST.[SalesCodeDepartmentId] IN (1075) AND PREVDM.RevenueGroupID = 1 AND DM.[RevenueGroupID] = 2	AND DM.[BusinessSegmentID] = 6
			THEN FST.[OrderQuantity] ELSE 0
			END AS NB_XTRConvCnt

	, CASE WHEN FST.[SalesCodeId] IN (399)  THEN 1 ELSE 0 END AS NB_RemCnt

	, CASE WHEN (FST.[SalesCodeDepartmentId] IN (2020) AND DM.[BusinessSegmentID] = 1
					and DM.[RevenueGroupID] IN (2,3) AND DM.[MembershipShortName] NOT IN ('MODEL','EMPLOYEE','EMPLOYEXT','MODELEXT','EMPLOYEE6') AND DSC.[SalesCodeNameShort] NOT IN ('EXTREVWO','NB1REVWO') )
				OR
				(DM.[MembershipShortName] IN ('EXTMEM','EXTMEMSOL', 'EXTPREMMEN', 'EXTPREMWOM','RRESTORWK','RRESTBIWK','RRESTORE','HWANAGENRR','HWEXTRRBA','HWEXTRRPL','EXTFLEX','EXTFLEXSOL') AND DSC.[SalesCodeNameShort] IN ('EXTREVWO') )
				OR
				(FST.[SalesCodeDepartmentId] IN (2020) and DM.[MembershipShortName] IN ('EXTMEM','EXTMEMSOL', 'EXTPREMMEN', 'EXTPREMWOM','RRESTORWK','RRESTBIWK','RRESTORE','HWANAGENRR','HWEXTRRBA','HWEXTRRPL','EXTFLEX','EXTFLEXSOL'))
				OR
				(FST.[SalesCodeDepartmentId] IN (2020) AND DM.[BusinessSegmentID] = 6 AND DM.[RevenueGroupID] = 2 )
				OR
				(DSC.[SalesCodeNameShort] IN ('PCPREVWO','PCPMBRPMT','EFTFEE')	AND DM.[MembershipShortName] NOT IN  ('GRDSVEZ'))
			THEN FST.[OrderExtendedPriceCalc] ELSE 0
			END AS PCP_NB2Amt

	, CASE WHEN ((FST.[SalesCodeDepartmentId] IN (2020) AND DM.[BusinessSegmentID] = 1
					AND DM.[RevenueGroupID] = 2	AND DM.[MembershipShortName] NOT IN ('NONPGM','MODEL','EMPLOYEE','EMPLOYEXT','MODELEXT','EXT6', 'EXT12','EXT18', 'EXTENH6', 'EXTENH12', 'EXTENH9', 'EXTINITIAL','NRESTORWK','NRESTBIWK','NRESTORE', 'LASER82')
					AND DSC.[SalesCodeNameShort] NOT IN ('EXTREVWO','NB1REVWO'))
					OR
					(DM.[MembershipShortName] IN  ('EXTMEM','EXTMEMSOL', 'EXTPREMMEN', 'EXTPREMWOM','RRESTORWK','RRESTBIWK','RRESTORE','HWANAGENRR','HWEXTRRBA','HWEXTRRPL','EXTFLEX','EXTFLEXSOL')
					AND DSC.[SalesCodeNameShort] IN ('EXTREVWO'))
								--OR
								--	(DM.[MembershipShortName] IN ('XTDMEMSOL','XTRANDMEM'))   --Removed RH 02/12/2015 - it did not limit Xtrands revenue
					OR
					(DM.[MembershipShortName] IN ('NONPGM') AND DSC.[SalesCodeNameShort] IN ('EFTFEE','PCPMBRPMT'))
					OR
					(FST.[SalesCodeDepartmentId] IN (2020)	AND DM.[MembershipShortName] IN  ('EXTMEM','EXTMEMSOL', 'EXTPREMMEN', 'EXTPREMWOM','RRESTORWK','RRESTBIWK','RRESTORE','HWANAGENRR','HWEXTRRBA','HWEXTRRPL','EXTFLEX','EXTFLEXSOL'))
					OR
					(FST.[SalesCodeDepartmentId] IN (2020) --AND DM.[MembershipShortName] IN ('XTRANDMEM','XTDMEMSOL','XTDMEM1000','XTDMSO1000'))  --Added RH 02/12/2015 to limit Xtrands revenue to where FST.[SalesCodeDepartmentId] IN (2020)
					AND DM.[BusinessSegmentID] = 6 AND DM.[RevenueGroupID] = 2 ) --RH 8/13/2018
					OR
					(DSC.[SalesCodeNameShort] IN ('PCPREVWO','PCPMBRPMT','EFTFEE') AND DM.[MembershipShortName] NOT IN ('NONPGM', 'GRDSVEZ')) )
				THEN FST.[OrderExtendedPriceCalc]	ELSE 0
				END AS PCP_PCPAmt

	, CASE WHEN (FST.[SalesCodeDepartmentId] IN (2020) AND DM.[BusinessSegmentID] = 1 AND DM.[RevenueGroupID] = 2
					AND DM.[MembershipShortName] NOT IN ('NONPGM','XTRANDMEM','XTDMEMSOL','XTDMEM1000','XTDMSO1000')
					AND DSC.[SalesCodeNameShort] NOT IN ('EXTREVWO','NB1REVWO'))
				OR
				(DM.[BusinessSegmentID] = 1 AND DSC.[SalesCodeNameShort] IN ('EFTFEE','PCPMBRPMT','PCPREVWO'))
			THEN FST.[OrderExtendedPriceCalc] ELSE 0
			END AS PCP_BioAmt

	, CASE WHEN (FST.[SalesCodeDepartmentId] IN (2020) --Membership Revenue
					AND DM.[BusinessSegmentID] = 6 AND DM.[RevenueGroupID] = 2 )
					--AND DM.[MembershipShortName] IN('XTRANDMEM','XTDMEMSOL','XTDMEM1000','XTDMSO1000')) --This is already in BusinessSegmentID = 6
				OR
				(DM.[BusinessSegmentID] = 6 AND DSC.[SalesCodeNameShort] IN ('EFTFEE','PCPMBRPMT','PCPREVWO')
								--AND DM.[MembershipShortName] IN('XTRANDMEM','XTDMEMSOL','XTDMEM1000','XTDMSO1000')
					AND DM.[RevenueGroupID] = 2 )
			THEN FST.[OrderExtendedPriceCalc] ELSE 0
			END AS PCP_XtrAmt

	, CASE WHEN (FST.[SalesCodeDepartmentId] IN (2020)
					AND DM.[BusinessSegmentID] = 2 AND DM.[RevenueGroupID] = 2)
				OR
				(DM.[MembershipShortName] IN  ('EXTMEM','EXTMEMSOL', 'EXTPREMMEN', 'EXTPREMWOM','RRESTORWK','RRESTBIWK','RRESTORE','HWANAGENRR','HWEXTRRBA','HWEXTRRPL','EXTFLEX','EXTFLEXSOL')
					AND DSC.[SalesCodeNameShort] IN ('EXTREVWO'))
			THEN FST.[OrderExtendedPriceCalc] ELSE 0
			END AS PCP_ExtMemAmt

	, CASE WHEN (FST.[SalesCodeDepartmentId] IN (2020, 7035)  --Added RH 01/16/2015
					AND DM.[MembershipShortName] IN ('NONPGM','RETAIL','HCFK')	AND DSC.[SalesCodeNameShort] NOT IN ('PCPMBRPMT','EFTFEE'))
			THEN FST.[OrderExtendedPriceCalc]	ELSE 0
			END AS PCPNonPgmAmt

	, CASE WHEN FST.[SalesCodeDepartmentId] IN (1070) THEN 1 ELSE 0
		END AS PCP_UpgCnt

	, CASE WHEN FST.[SalesCodeDepartmentId] IN (1080)  THEN 1 ELSE 0
		END AS PCP_DwnCnt

	, CASE WHEN (FST.[SalesCodeDepartmentId] IN (5010,5020,5030,5035,5037,5040,5050,7035) AND DSC.[SalesCodeNameShort] <> 'ADDONMDP' )
					AND DM.[BusinessSegmentID] IN (1,2,4,6)
			THEN FST.[OrderExtendedPriceCalc] ELSE 0
			END AS ServiceAmt

	, CASE WHEN ( FST.[SalesCodeDepartmentId] = 3065 OR DM.[MembershipShortName] IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) )
			THEN 0
			ELSE CASE WHEN ( dscd.SalesCodeDivisionID = 30 AND DM.[BusinessSegmentID] IN ( 1, 2, 4, 6, 7 ) )
				THEN FST.[OrderExtendedPriceCalc] ELSE 0 END
			END AS RetailAmt

	, CASE WHEN
			CASE WHEN ( FST.[SalesCodeDepartmentId] IN (5010,5020,5030,5035,5037,5040,5050,7035) AND DSC.[SalesCodeNameShort] <> 'ADDONMDP' )
					AND DM.[BusinessSegmentID] IN (1,2,4,6)
				THEN FST.[OrderQuantity] ELSE 0 END > 0
				THEN 1 	ELSE 0 END AS ClientServicedCnt

	, CASE WHEN (dscd.SalesCodeDivisionID IN (20)) THEN FST.[OrderExtendedPriceCalc]	ELSE 0 	END AS NetMembershipAmt

	, CASE WHEN FST.[SalesCodeDepartmentId] NOT IN (5060,5061,7010,7030,7050,7051) AND DSCD.[SalesCodeDivisionID] NOT IN (10)
			THEN FST.[OrderExtendedPriceCalc]	ELSE 0
			END AS NetSalesAmt

	, CASE WHEN FST.[SalesCodeDepartmentId] IN (1010, 1075, 1090, 2025)  AND DM.[BusinessSegmentID] = 3 	AND FST.[IsRefunded] = 0
			THEN 1 ELSE 0
			END AS S_GrossSurCnt

	, CASE WHEN FST.[SalesCodeDepartmentId] IN ( 1010, 1075,1090 )  -- Conversions(MMConv) Renewals (MMRenew)
				AND FST.[MembershipId]  in (43,44,259,260,261,262,263,264,265,266,267,268,269,270, 317,316)
			THEN 1 ELSE 0 END
		-
		CASE WHEN FST.[SalesCodeDepartmentId] IN ( 1099 )  -- Cancellations (MMCancel)
				AND FST.[MembershipId]  in (43,44,259,260,261,262,263,264,265,266,267,268,269,270,317,316)
				AND DSC.[SalesCodeNameShort] <> 'CANCELADDON'		--Add-on 9/20/2017 rh
			THEN 1 ELSE 0
			END AS S_SurCnt

	, CASE WHEN FST.[SalesCodeDepartmentId] IN (2020) AND FST.[SalesCodeId] NOT IN (912,913,1653,1654,1655,1656,1661,1662,1664,1665)  --These are Tri-Gen or PRP Add-Ons
				AND DM.[BusinessSegmentID] = 3
			THEN FST.[OrderExtendedPriceCalc] ELSE 0
			END AS S_SurAmt

	, CASE WHEN (FST.[SalesCodeDepartmentId] IN (3065)) THEN FST.[OrderQuantity]
			WHEN (DSC.[SalesCodeName] LIKE '%cap%' AND FST.[SalesCodeDepartmentId] = 2020) THEN FST.[OrderQuantity]
			WHEN (DSC.[SalesCodeName] LIKE '%laser%' AND FST.[SalesCodeDepartmentId] = 2020) THEN FST.[OrderQuantity]
			ELSE 0 END AS LaserCnt

	, CASE WHEN FST.[SalesCodeDepartmentId] IN (3065) THEN FST.[OrderExtendedPriceCalc] ELSE 0
			END AS LaserAmt

	, CASE WHEN Services.SalesOrderDetailGUID IS NOT NULL THEN 1
			WHEN FST.[SalesCodeDepartmentId] IN ( 1010 ) AND DM.[MembershipShortName] = 'MDP' THEN 1
			WHEN FST.[SalesCodeDepartmentId] IN ( 1006 ) AND DSC.[SalesCodeNameShort] = 'ADDONSMP' THEN 1   --Added Bosley SMP
			ELSE 0 END
		-
		CASE WHEN ( (FST.[SalesCodeDepartmentId] = 1099 AND  Services.SalesOrderDetailGUID IS NOT NULL)
					OR (FST.[SalesCodeDepartmentId] = 1099  -- Cancellations (MMCancel)
					AND  DM.[MembershipShortName] = 'MDP'  ) )
			THEN 1 ELSE 0
			END AS NB_MDPCnt

	, CASE WHEN FST.[SalesCodeDepartmentId] = 5062 AND DSC.[SalesCodeNameShort] NOT IN ( 'ADDONMDP', 'SVCSMP' ) THEN FST.[OrderExtendedPriceCalc]
			WHEN FST.[SalesCodeDepartmentId] = 2020 AND DM.[MembershipShortName] = 'MDP' THEN FST.[OrderExtendedPriceCalc]
			WHEN FST.[SalesCodeDepartmentId] IN ( 2030 ) AND DSC.[SalesCodeNameShort] = 'MEDADDONPMTSMP' THEN FST.[OrderExtendedPriceCalc] --Added Bosley SMP
			ELSE 0  END AS NB_MDPAmt

	, CASE WHEN (FST.[SalesCodeDepartmentId] IN (3065) AND DM.[RevenueGroupID] = 1 AND DM.[MembershipShortName] NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6') ) THEN FST.[OrderQuantity]
			WHEN (DSC.[SalesCodeName] LIKE '%cap%' AND FST.[SalesCodeDepartmentId] = 2020 AND DM.[RevenueGroupID] = 1 AND DM.[MembershipShortName] NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderQuantity]
			WHEN (DSC.[SalesCodeName] LIKE '%laser%' AND FST.[SalesCodeDepartmentId] = 2020 AND DM.[RevenueGroupID] = 1 AND DM.[MembershipShortName] NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderQuantity]
			ELSE 0 END AS NB_LaserCnt

	, CASE WHEN (FST.[SalesCodeDepartmentId] IN (3065) AND DM.[RevenueGroupID] = 1 AND DM.[MembershipShortName] NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderExtendedPriceCalc]
			WHEN (DSC.[SalesCodeName] LIKE '%cap%' AND FST.[SalesCodeDepartmentId] = 2020 AND DM.[RevenueGroupID] = 1 AND DM.[MembershipShortName] NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) )	THEN FST.[OrderExtendedPriceCalc]
			WHEN (DSC.[SalesCodeName] LIKE '%laser%' AND FST.[SalesCodeDepartmentId] = 2020 AND DM.[RevenueGroupID] = 1 AND DM.[MembershipShortName] NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderExtendedPriceCalc]
			ELSE 0 END AS NB_LaserAmt

	, CASE WHEN (FST.[SalesCodeDepartmentId] IN (3065) AND DM.[RevenueGroupID] IN (2,3,4,5) AND DM.[MembershipShortName] NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderQuantity]
			WHEN (DSC.[SalesCodeName] LIKE '%cap%' AND FST.[SalesCodeDepartmentId] = 2020 AND DM.[RevenueGroupID] IN (2,3,4,5) AND DM.[MembershipShortName] NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) )	THEN FST.[OrderQuantity]
			WHEN (DSC.[SalesCodeName] LIKE '%laser%' AND FST.[SalesCodeDepartmentId] = 2020 AND DM.[RevenueGroupID] IN (2,3,4,5) AND DM.[MembershipShortName] NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderQuantity]
			ELSE 0 END AS PCP_LaserCnt

	, CASE WHEN (FST.[SalesCodeDepartmentId] IN (3065) AND DM.[RevenueGroupID] IN (2,3,4,5) AND DM.[MembershipShortName] NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderExtendedPriceCalc]
			WHEN (DSC.[SalesCodeName] LIKE '%cap%' AND FST.[SalesCodeDepartmentId] = 2020 AND DM.[RevenueGroupID] IN (2,3,4,5) AND DM.[MembershipShortName] NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderExtendedPriceCalc]
			WHEN (DSC.[SalesCodeName] LIKE '%laser%' AND FST.[SalesCodeDepartmentId] = 2020 AND DM.[RevenueGroupID] IN (2,3,4,5) AND DM.[MembershipShortName] NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderExtendedPriceCalc]
			ELSE 0 END AS PCP_LaserAmt

	, CASE WHEN ( FST.[SalesCodeDepartmentId] = 3065 ) THEN 0
			ELSE CASE WHEN ( dscd.SalesCodeDivisionID = 30 AND DM.[BusinessSegmentID] IN ( 1, 2, 4, 6, 7 ) AND DM.[MembershipShortName] IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderExtendedPriceCalc]
						ELSE 0 END
			END AS EMP_RetailAmt

	, CASE WHEN (FST.[SalesCodeDepartmentId] IN (3065) AND DM.[RevenueGroupID] = 1 AND DM.[MembershipShortName] IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderQuantity]
			WHEN (DSC.[SalesCodeName] LIKE '%cap%' AND FST.[SalesCodeDepartmentId] = 2020 AND DM.[RevenueGroupID] = 1 AND DM.[MembershipShortName] IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderQuantity]
			WHEN (DSC.[SalesCodeName] LIKE '%laser%' AND FST.[SalesCodeDepartmentId] = 2020 AND DM.[RevenueGroupID] = 1 AND DM.[MembershipShortName] IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderQuantity]
			ELSE 0 END AS EMP_NB_LaserCnt

	, CASE WHEN (FST.[SalesCodeDepartmentId] IN (3065) AND DM.[RevenueGroupID] = 1 AND DM.[MembershipShortName] IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderExtendedPriceCalc]
			WHEN (DSC.[SalesCodeName] LIKE '%cap%' AND FST.[SalesCodeDepartmentId] = 2020 AND DM.[RevenueGroupID] = 1 AND DM.[MembershipShortName] IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderExtendedPriceCalc]
			WHEN (DSC.[SalesCodeName] LIKE '%laser%' AND FST.[SalesCodeDepartmentId] = 2020 AND DM.[RevenueGroupID] = 1 AND DM.[MembershipShortName] IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderExtendedPriceCalc]
			ELSE 0 END AS EMP_NB_LaserAmt

	, CASE WHEN (FST.[SalesCodeDepartmentId] IN (3065) AND DM.[RevenueGroupID] IN (2,3,4,5) AND DM.[MembershipShortName] IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderQuantity]
			WHEN (DSC.[SalesCodeName] LIKE '%cap%' AND FST.[SalesCodeDepartmentId] = 2020 AND DM.[RevenueGroupID] IN (2,3,4,5) AND DM.[MembershipShortName] IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderQuantity]
			WHEN (DSC.[SalesCodeName] LIKE '%laser%' AND FST.[SalesCodeDepartmentId] = 2020 AND DM.[RevenueGroupID] IN (2,3,4,5) AND DM.[MembershipShortName] IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderQuantity]
			ELSE 0 END AS EMP_PCP_LaserCnt

	, CASE WHEN (FST.[SalesCodeDepartmentId] IN (3065) AND DM.[RevenueGroupID] IN (2,3,4,5) AND DM.[MembershipShortName] IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderExtendedPriceCalc]
			WHEN (DSC.[SalesCodeName] LIKE '%cap%' AND FST.[SalesCodeDepartmentId] = 2020 AND DM.[RevenueGroupID] IN (2,3,4,5) AND DM.[MembershipShortName] IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderExtendedPriceCalc]
			WHEN (DSC.[SalesCodeName] LIKE '%laser%' AND FST.[SalesCodeDepartmentId] = 2020 AND DM.[RevenueGroupID] IN (2,3,4,5) AND DM.[MembershipShortName] IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderExtendedPriceCalc]
			ELSE 0 END AS EMP_PCP_LaserAmt

-- **** New Metrics based on SQL06 ->[HC_BI_CMS_DDS].[bi_cms_dds].[vwFactSalesConect] ******

	,  (((isnull(FST.[OrderPrice],(0))*isnull(FST.[OrderQuantity],(0))-isnull(FST.[OrderDiscount],(0)))
										+isnull(FST.[OrderTax1],(0)))+isnull(FST.[OrderTax2],(0)))
		AS	[SF-ExtendedPricePlusTax]


	,  (isnull(FST.[OrderTax1],(0))+isnull(FST.[OrderTax2],(0)))
		AS [SF-TotalTaxAmount]

	,CASE WHEN ( DM.[BusinessSegmentID] = 1 AND DM.[RevenueGroupID] = 2 AND FST.[SalesCodeId] = 351 )
			THEN 1 ELSE 0 END AS PCP_CXL

	,CASE WHEN DSC.[SalesCodeNameShort] IN ( 'ALCHOH', 'ALCHOH2' ) AND DM.[RevenueGroupID] = 1
			THEN FST.[OrderExtendedPriceCalc] ELSE 0 END AS NB_ALCAmt

	,CASE WHEN DSC.[SalesCodeNameShort] IN ( 'ALCHOH', 'ALCHOH2' ) AND DM.[RevenueGroupID] = 2 AND DM.[MembershipShortName] = 'NONPGM'
			THEN FST.[OrderExtendedPriceCalc] ELSE 0 END AS NB2_ALCAmt

	,CASE WHEN DSC.[SalesCodeNameShort] IN ( 'ALCHOH', 'ALCHOH2' ) AND DM.[RevenueGroupID] = 2 AND DM.[MembershipShortName] <> 'NONPGM'
			THEN FST.[OrderExtendedPriceCalc] ELSE 0 END AS PCP_ALCAmt

	,CASE WHEN DSC.[SalesCodeNameShort] IN ('480-116')
			THEN FST.[OrderExtendedPriceCalc] ELSE 0 END AS Retail_SPAAmt

	, CASE WHEN FST.[SalesCodeDepartmentId] IN ( 1099 ) AND DM.[BusinessSegmentID] = 1 AND DM.[RevenueGroupID] = 1
			THEN 1 ELSE 0 END AS NB_XTRP_CancelCnt

	, CASE WHEN FST.[SalesCodeDepartmentId] IN ( 1099 ) AND DM.[BusinessSegmentID] = 2 AND DM.[RevenueGroupID] = 1
			THEN 1 ELSE 0 END AS NB_EXT_CancelCnt

	,CASE WHEN FST.[SalesCodeDepartmentId] IN ( 1099 ) AND DM.[BusinessSegmentID] = 6 AND DM.[RevenueGroupID] = 1
			THEN 1 ELSE 0 END AS NB_XTR_CancelCnt



FROM [dbo].[FactSalesTransaction] FST
	INNER JOIN [dbo].[DimMembership] DM
		ON FST.[MembershipId] = DM.[MembershipId]
	INNER JOIN [dbo].[DimCustomerMembership] DCM
		ON DCM.[CustomerMembershipID] = FST.[CustomerMembershipId]
	LEFT JOIN [dbo].[DimSalesCode] DSC
		ON DSC.[SalesCodeID] = FST.[SalesCodeId]
	LEFT JOIN [dbo].[DimSalesCodeDepartment] DSCD
		ON DSCD.[SalesCodeDepartmentID] = FST.[SalesCodeDepartmentId]
	LEFT JOIN [ODS].[CNCT_cfgConfigurationCenter] CC
		ON FST.[CenterId] = CC.CenterID
	LEFT JOIN Services
		ON Services.SalesOrderDetailGUID = FST.[OrderDetailId] AND Services.RowID = 1
	LEFT OUTER JOIN MEDADDON
		ON MEDADDON.SalesOrderDetailGUID = FST.[OrderDetailId] AND MEDADDON.Ranking = 1
	LEFT JOIN [dbo].[DimMembership] PREVDM
		ON FST.[PreviousMembershipId] = PREVDM.[MembershipId]
	LEFT JOIN [dbo].[DimCenter] DC
		ON DC.[CenterID] = FST.[CenterId]
	LEFT JOIN [ODS].[CNCT_lkpTimeZone] TZ
		ON TZ.[TimeZoneID] = DC.[TimeZoneID]

WHERE (FST.[IsVoided] = 0 AND FST.[IsClosed] = 1) AND CONVERT(DATE,FST.[OrderDate]) >= '2019-01-01';
GO
