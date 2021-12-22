/* CreateDate: 11/12/2015 14:44:04.327 , ModifyDate: 06/19/2019 10:46:35.123 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
VIEW:					[vw_ARBalances]
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
AUTHOR:					Rachelen Hut
DATE IMPLEMENTED:		11/12/2015
------------------------------------------------------------------------
NOTES: This view is used by Accounting (Sharice Jones) to find the AR balances

------------------------------------------------------------------------
CHANGE HISTORY:
02/28/2017 - RH - Changed ClientARBalance not equal to zero to CLT.ClientARBalance > 0
05/01/2017 - RH - Removed use of fnGetCurrentMembershipDetailsByClientID - this was removing inactive clients; Changed both CLT.ARBalances >= 0 and FR.Balance >= 0
06/18/2019 - RH - Changed RegionID and RegionDescription to CenterManagementAreaSSID and CenterManagementAreaDescription (Case 7979); Changed CenterSSID to CenterNumber
------------------------------------------------------------------------
SAMPLE EXECUTION:

SELECT * FROM [vw_ARBalances] ORDER BY CenterDescriptionNumber
***********************************************************************/
CREATE VIEW [dbo].[vw_ARBalances]
AS

WITH EndOfMonth AS (
				SELECT	DD.DateKey
				,	DD.FullDate
				,	DD.MonthNumber
				,	DD.YearNumber
				FROM [HC_BI_ENT_DDS].[bief_dds].[DimDate] DD
				WHERE DD.FullDate BETWEEN DATEADD(DAY,-1,DATEDIFF(DAY,0,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)))
				AND DATEADD(MINUTE,-1,DATEDIFF(DAY,0,CAST(CAST(MONTH(GETUTCDATE()) AS VARCHAR(2)) + '/1/' + CAST(YEAR(GETUTCDATE()) AS VARCHAR(4)) AS DATETIME)))
				GROUP BY DD.DateKey
				,	DD.FullDate
				,	DD.MonthNumber
				, DD.YearNumber
			 )


,	Centers AS (
				SELECT CTR.CenterNumber, CTR.CenterKey, CTR.CenterDescriptionNumber
					FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter CTR
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterType CT
						ON CT.CenterTypeKey = CTR.CenterTypeKey
					WHERE CTR.Active = 'Y'
					AND CT.CenterTypeDescriptionShort = 'C'
					)

,	Receivables AS (
				SELECT  C.CenterNumber
				,       C.CenterDescriptionNumber
				,       CMA.CenterManagementAreaSSID
				,       CMA.CenterManagementAreaDescription
				,       CLT.ClientIdentifier
				,		CLT.ClientKey
				,       CLT.ClientLastName
				,       CLT.ClientFirstName
				,       M.MembershipDescription
				,       DCM.MembershipKey
				,		CLT.ClientARBalance
				,		ROW_NUMBER()OVER(PARTITION BY CLT.ClientIdentifier ORDER BY DCM.ClientMembershipEndDate DESC) AS Ranking

				FROM    HC_Accounting.dbo.FactReceivables FR
					INNER JOIN EndOfMonth DD
						ON FR.DateKey =DD.DateKey
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
						ON FR.ClientKey = CLT.ClientKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
						ON FR.CenterKey = C.CenterKey
					INNER JOIN Centers CTR
						ON C.CenterKey = CTR.CenterKey
					INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
							ON CMA.CenterManagementAreaSSID = C.CenterManagementAreaSSID
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership DCM
						ON( CLT.CurrentBioMatrixClientMembershipSSID = DCM.ClientMembershipSSID
							OR CLT.CurrentExtremeTherapyClientMembershipSSID = DCM.ClientMembershipSSID
							OR CLT.CurrentXtrandsClientMembershipSSID = DCM.ClientMembershipSSID )
					INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
							ON DCM.MembershipKey = M.MembershipKey

				WHERE M.RevenueGroupSSID = 2
					AND CLT.ClientARBalance >= 0
				GROUP BY C.CenterNumber
				,       C.CenterDescriptionNumber
				,       CMA.CenterManagementAreaSSID
				,       CMA.CenterManagementAreaDescription
				,       CLT.ClientIdentifier
				,		CLT.ClientKey
				,       CLT.ClientLastName
				,       CLT.ClientFirstName
				,       M.MembershipDescription
				,       DCM.MembershipKey
				,		DCM.ClientMembershipEndDate
				,		CLT.ClientARBalance
		)


,	Balance AS (SELECT  CLT.ClientKey
				,    MAX(FR.Balance) AS 'Ending_Balance'
				FROM    HC_Accounting.dbo.FactReceivables FR
						INNER JOIN EndOfMonth DD
							ON FR.DateKey = DD.DateKey
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
							ON FR.ClientKey = CLT.ClientKey
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
							ON( CLT.CurrentBioMatrixClientMembershipSSID = CM.ClientMembershipSSID
										OR CLT.CurrentExtremeTherapyClientMembershipSSID = CM.ClientMembershipSSID
										OR CLT.CurrentXtrandsClientMembershipSSID = CM.ClientMembershipSSID )
						INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
							ON CM.MembershipKey = M.MembershipKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
							ON FR.CenterKey = C.CenterKey
						INNER JOIN Centers
							ON C.CenterKey = Centers.CenterKey
						INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenterManagementArea CMA
							ON CMA.CenterManagementAreaSSID = C.CenterManagementAreaSSID
				WHERE   FR.Balance >= 0
						AND M.RevenueGroupSSID = 2

				GROUP BY CLT.ClientKey
				)




SELECT REC.CenterNumber
		,   CTR.CenterDescriptionNumber
		,   REC.CenterManagementAreaSSID
		,   REC.CenterManagementAreaDescription
		,   REC.ClientIdentifier
		,	REC.ClientKey
		,   REC.ClientLastName
		,   REC.ClientFirstName
		,   REC.MembershipDescription
		,   REC.MembershipKey
		,	ISNULL(REC.ClientARBalance,'0.00') AS 'ClientARBalance'
		,	ISNULL(Balance.Ending_Balance,'0.00') AS 'Ending_Balance'
FROM Receivables REC
	LEFT OUTER JOIN Balance
		ON REC.ClientKey = Balance.ClientKey
	INNER JOIN Centers CTR	ON CTR.CenterNumber = REC.CenterNumber
WHERE Ranking = 1
GO
