/****** Object:  View [dbo].[VWFactSalesTransPerformer]    Script Date: 3/15/2022 2:11:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[VWFactSalesTransPerformer]
AS SELECT
	FST.[OrderDateKey]
	,FST.[OrderDate]
	,dbo.GetLocalFromUTC(FST.[OrderDate], TZ.[UTCOffset], TZ.[UsesDayLightSavingsFlag]) AS [OrderDateLocalUTC]
	,CONVERT(DATETIME,FST.[OrderDate] AT TIME ZONE 'UTC' AT TIME ZONE 'Eastern Standard Time') AS [OrderDateEastern]
	, FST.[OrderDetailId]
	, FST.[OrderId]
	, FST.[SalesCodeKey]
	, FST.[SalesCodeId]
	, DSC.[SalesCodeName]
	, DSC.[SalesCodeNameShort]
	, FST.[SalesCodeDepartmentKey]
	, FST.[SalesCodeDepartmentId]
	, DSCD.[SalesCodeDepartmentName]
	, FST.[CustomerId]
	, FST.[CustomerKey]
	, FST.[ServiceAppointmentId] as AppointmentId
	, FST.[PerformerId]
	, FST.[PerformerName]
	, DCP.CenterNumber as PerformerHomeCenter
    , SU.CenterId  as PerformerHomeCenterID
    , DCP.CenterKey as PerformerHomeCenterKey
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

	, CASE WHEN ((( FST.[SalesCodeDepartmentId] IN ( 2020 ) OR DSC.[SalesCodeNameShort] LIKE 'SURCREDIT%' )
			AND DM.[MembershipShortName] IN ('GRAD','GRAD12','GRDSVEZ','GRADSOL12','GRADSOL6','GRADSOL12','GRDSV12','GRDSVSOL12','GRDSV','GRDSVSOL','ELITENB','ELITENBSOL',
													'NSILVER', 'NMINIPREM','NGOLD','NPLATINUM','NDIAMOND','NPREMIERE','NSUPERPREM','NULTRAPREM','NPREM24','NPREM36', 'NPREM48',
													'NPREM60','NPREM72','HWSILVER','HWGOLD','HWPLAT')
			AND DSC.[SalesCodeNameShort] NOT IN ('EFTFEE','PCPREVWO')
			AND FST.[SalesCodeDepartmentId] <> 3065)
			OR ( FST.[SalesCodeDepartmentId] IN ( 2020 ) AND DM.[MembershipShortName] IN ( 'GRDSVEZ' )))
			THEN FST.[OrderExtendedPriceCalc] ELSE 0
			END AS NB_GradAmt

	, CASE WHEN (( FST.[SalesCodeDepartmentId] IN (2020) OR (DSC.[SalesCodeNameShort] LIKE 'SURCREDIT%') )
			AND DM.[MembershipShortName] IN ('EXT6', 'EXT12', 'EXT18','EXTENH6', 'EXTENH12', 'EXTENH9', 'EXTINITIAL','NRESTORWK','NRESTBIWK',
													'NRESTORE', 'LASER82','HWEXTBAS','HWEXTPLUS','HWANAGEN')
			AND DSC.[SalesCodeNameShort]NOT IN ('EFTFEE','PCPREVWO','PCPMBRPMT')
			AND FST.[SalesCodeDepartmentId] <> 3065 --Exclude Laser
			) THEN FST.[OrderExtendedPriceCalc] ELSE 0
			END AS NB_ExtAmt

	, CASE WHEN (FST.[SalesCodeDepartmentId] IN ( 2025 )	--Add-on Salescodes in Dept 2025 5/1/2017 km
			AND DM.[BusinessSegmentID] IN ( 2,3 )
			AND DSC.[SalesCodeNameShort] NOT IN ( 'BOSMEMADJTG','BOSMEMADJTGBPS','MEDADDONPMTTRI' ) )
			OR (FST.[SalesCodeDepartmentId] IN (2020) AND FST.[MembershipId] = 13)
			OR (DSC.[SalesCodeNameShort] IN ('NB1REVWO', 'EXTREVWO') AND DM.[MembershipShortName] IN ('POSTEXT'))
			THEN FST.[OrderExtendedPriceCalc] ELSE 0
			END S_PostExtAmt

	, CASE WHEN (FST.[SalesCodeDepartmentId] IN (2020) AND DM.[RevenueGroupID] = 1
					AND DM.[BusinessSegmentID] = 6	AND FST.[SalesCodeDepartmentId] <> 3065 --Exclude Laser
				) THEN FST.[OrderExtendedPriceCalc] ELSE 0
				END AS NB_XtrAmt

	, CASE WHEN FST.[SalesCodeDepartmentId] = 5062 AND DSC.[SalesCodeNameShort] NOT IN ( 'ADDONMDP', 'SVCSMP' ) THEN FST.[OrderExtendedPriceCalc]
			WHEN FST.[SalesCodeDepartmentId] = 2020 AND DM.[MembershipShortName] = 'MDP' THEN FST.[OrderExtendedPriceCalc]
			WHEN FST.[SalesCodeDepartmentId] IN ( 2030 ) AND DSC.[SalesCodeNameShort] = 'MEDADDONPMTSMP' THEN FST.[OrderExtendedPriceCalc] --Added Bosley SMP
			ELSE 0  END AS NB_MDPAmt

	, CASE WHEN (FST.[SalesCodeDepartmentId] IN (3065) AND DM.[RevenueGroupID] = 1 AND DM.[MembershipShortName] NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderExtendedPriceCalc]
			WHEN (DSC.[SalesCodeName] LIKE '%cap%' AND FST.[SalesCodeDepartmentId] = 2020 AND DM.[RevenueGroupID] = 1 AND DM.[MembershipShortName] NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) )	THEN FST.[OrderExtendedPriceCalc]
			WHEN (DSC.[SalesCodeName] LIKE '%laser%' AND FST.[SalesCodeDepartmentId] = 2020 AND DM.[RevenueGroupID] = 1 AND DM.[MembershipShortName] NOT IN ( 'EMPLOYEE', 'EMPLOYEXT', 'EMPLOYXTR', 'EMPLOYMDP','EMPLOYEE6' ) ) THEN FST.[OrderExtendedPriceCalc]
			ELSE 0 END AS NB_LaserAmt

	, CASE WHEN FST.[SalesCodeDepartmentId] IN (2020) AND FST.[SalesCodeId] NOT IN (912,913,1653,1654,1655,1656,1661,1662,1664,1665)  --These are Tri-Gen or PRP Add-Ons
				AND DM.[BusinessSegmentID] = 3
			THEN FST.[OrderExtendedPriceCalc] ELSE 0
			END AS S_SurAmt

	, CASE WHEN (FST.[SalesCodeId] IN (912,913,1653,1654,1655,1656,1661,1662,1664,1665)  --These are Tri-Gen or PRP Add-Ons
			AND FST.[MembershipId] IN ( 43,44,259,260,261,262,263,264,265,266,267,268,269,270,316,317 ))
			THEN FST.[OrderExtendedPriceCalc] ELSE 0
			END S_PRPAmt


FROM [dbo].[FactSalesTransaction] FST
	INNER JOIN [dbo].[DimMembership] DM
		ON FST.[MembershipId] = DM.[MembershipId]
	LEFT JOIN [dbo].[DimSalesCode] DSC
		ON DSC.[SalesCodeID] = FST.[SalesCodeId]
	LEFT JOIN [dbo].[DimSalesCodeDepartment] DSCD
		ON DSCD.[SalesCodeDepartmentID] = FST.[SalesCodeDepartmentId]
	LEFT JOIN [dbo].[DimCenter] DC
		ON DC.[CenterID] = FST.[CenterId]
	LEFT JOIN [ODS].[CNCT_lkpTimeZone] TZ
		ON TZ.[TimeZoneID] = DC.[TimeZoneID]
	LEFT JOIN DimSystemUser su
		ON su.UserId = convert(varchar(250), FST.PerformerId)
    LEFT JOIN DimCenter DCP
        ON DCP.CenterID = su.CenterId

WHERE (FST.[IsVoided] = 0 AND FST.[IsClosed] = 1) AND CONVERT(DATE,FST.[OrderDate]) >= '2020-01-01';
GO
