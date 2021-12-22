/* CreateDate: 02/23/2016 09:10:35.410 , ModifyDate: 11/17/2017 09:26:17.510 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					vwd_AMNationalPricing
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Datazen
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
CREATED DATE:			02/22/2016
------------------------------------------------------------------------
NOTES: This view is being used in the Area Manager Datazen dashboard; There is only one set of data with no timeframe
------------------------------------------------------------------------
CHANGE HISTORY:

------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM vwd_AMNationalPricing ORDER BY CenterSSID
***********************************************************************/
CREATE VIEW [dbo].[vwd_AMNationalPricing]
AS

WITH 	NationalRate AS (SELECT q.RateStartDate
					,	q.CenterSSID
					,	q.CenterDescriptionNumber
					,	COUNT(q.ClientIdentifier) AS 'TotalClients'
					,	SUM(CASE WHEN q.EqualToNationalRate = 1 THEN 1 ELSE 0 END) AS 'NationalPricingClients'
					,	ROW_NUMBER() OVER(PARTITION BY q.CenterSSID ORDER BY q.RateStartDate) AS FirstRank


				FROM(
						SELECT  DMRBC.RateStartDate
						,	CTR.CenterSSID
						,       CTR.CenterDescriptionNumber
						,       CLT.ClientIdentifier
						,       CONVERT(VARCHAR, CLT.ClientIdentifier) + ' - ' + CLT.ClientFullName AS 'ClientName'
						,       DM.MembershipDescription AS 'Membership'
						,       DCM.ClientMembershipBeginDate AS 'MembershipBeginDate'
						,       DCM.ClientMembershipEndDate AS 'MembershipEndDate'
						,       DCM.ClientMembershipStatusDescription AS 'MembershipStatus'
						,       CASE DCE.FeePayCycleID
								  WHEN 1 THEN '1st of Month'
								  WHEN 2 THEN '15th of Month'
								END AS 'PayCycle'
						,             LEAT.EFTAccountTypeDescription AS 'AccountType'
						,       CAST(ROUND(DCM.ClientMembershipMonthlyFee, 2) AS MONEY) AS 'MonthlyFee'
						,             DMRBC.MembershipRate AS 'NationalRate'
						,             CASE WHEN DCM.ClientMembershipMonthlyFee = DMRBC.MembershipRate THEN 1 ELSE 0 END AS 'EqualToNationalRate'
						,             CASE WHEN DCM.ClientMembershipMonthlyFee < DMRBC.MembershipRate THEN 1 ELSE 0 END AS 'LessThanNationalRate'
						,             CASE WHEN DCM.ClientMembershipMonthlyFee > DMRBC.MembershipRate THEN 1 ELSE 0 END AS 'GreaterThanNationalRate'
						FROM    SQL05.HairClubCMS.dbo.datClientEFT DCE
								INNER JOIN SQL05.HairClubCMS.dbo.lkpEFTAccountType LEAT
											 ON LEAT.EFTAccountTypeID = DCE.EFTAccountTypeID
								INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
											 ON CLT.ClientSSID = DCE.ClientGUID
								INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
									ON CTR.CenterSSID = CLT.CenterSSID
								INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
									ON DCM.ClientMembershipSSID = DCE.ClientMembershipGUID
								INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership DM
									ON DM.MembershipSSID = DCM.MembershipSSID
								INNER JOIN HC_DeferredRevenue.dbo.DimMembershipRatesByCenter DMRBC
										ON DMRBC.CenterSSID = CTR.CenterSSID
											AND DMRBC.MembershipKey = DM.MembershipKey
											AND GETDATE() BETWEEN DMRBC.RateStartDate AND DMRBC.RateEndDate
						WHERE  CTR.CenterSSID LIKE '[278]%'
						) q
				 GROUP BY q.RateStartDate
					,	q.CenterSSID
					,	q.CenterDescriptionNumber
			),

Regions AS ( SELECT DR.RegionSSID
				,	DR.RegionKey
				,	DC.CenterSSID
				,	CASE WHEN LEN(DR.RegionSSID)= 1 THEN '10' ELSE '1' END
				     + CAST(DR.RegionSSID AS NVARCHAR(2)) + ' - ' + DR.RegionDescription AS 'RegionDescription'
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter DC
			INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimRegion DR
				ON DC.RegionSSID = DR.RegionSSID
			WHERE DC.Active = 'Y'
			GROUP BY DR.RegionSSID
				,	DR.RegionKey
				,	DC.CenterSSID
				,	DR.RegionDescription
),
AreaManagers AS ( SELECT CMA.CenterManagementAreaSSID
				,	CenterSSID
				,	CMA.CenterManagementAreaDescription
				FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
				INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
					ON CTR.CenterManagementAreaSSID = CMA.CenterManagementAreaSSID
				WHERE CMA.Active = 'Y')

SELECT 	3 AS 'Filter'
	,	NR.CenterSSID
	,	NR.CenterDescriptionNumber
	,	NR.TotalClients
	,	NR.NationalPricingClients
FROM NationalRate NR
WHERE NR.FirstRank = 1
GROUP BY NR.CenterSSID
	,	NR.CenterDescriptionNumber
	,	NR.TotalClients
	,	NR.NationalPricingClients

UNION
SELECT 	0 AS 'Filter'
	,	100 AS 'CenterSSID'
	,	'100 - Corporate' AS 'CenterDescriptionNumber'
	,	SUM(NR.TotalClients) AS 'TotalClients'
	,	SUM(NR.NationalPricingClients) AS 'NationalPricingClients'
FROM NationalRate NR
WHERE NR.FirstRank = 1
	AND CenterSSID LIKE '[2]%'
	AND LEN(CenterSSID) = 3


UNION
SELECT 	0 AS 'Filter'
	,	101 AS 'CenterSSID'
	,	'101 - Franchise' AS 'CenterDescriptionNumber'
	,	SUM(NR.TotalClients) AS 'TotalClients'
	,	SUM(NR.NationalPricingClients) AS 'NationalPricingClients'
FROM NationalRate NR
WHERE NR.FirstRank = 1
	AND CenterSSID LIKE '[78]%'
	AND LEN(CenterSSID) = 3

UNION		-- By Regions
SELECT 	1 AS 'Filter'
	,	REG.RegionSSID AS 'CenterSSID'
	,	REG.RegionDescription AS 'CenterDescriptionNumber'
	,	SUM(NR.TotalClients) AS 'TotalClients'
	,	SUM(NR.NationalPricingClients) AS 'NationalPricingClients'
FROM NationalRate NR
INNER JOIN Regions REG
	ON NR.CenterSSID = REG.CenterSSID
WHERE NR.FirstRank = 1
GROUP BY REG.RegionSSID
	,	REG.RegionDescription

UNION  --By AreaManagers
SELECT 	2 AS 'Filter'
	,	AM.CenterManagementAreaSSID AS 'CenterSSID'
	,	AM.CenterManagementAreaDescription AS 'CenterDescriptionNumber'
	,	SUM(NR.TotalClients) AS 'TotalClients'
	,	SUM(NR.NationalPricingClients) AS 'NationalPricingClients'
FROM NationalRate NR
INNER JOIN AreaManagers AM
	ON NR.CenterSSID = AM.CenterSSID
GROUP BY AM.CenterManagementAreaSSID
    ,	AM.CenterManagementAreaDescription
GO
