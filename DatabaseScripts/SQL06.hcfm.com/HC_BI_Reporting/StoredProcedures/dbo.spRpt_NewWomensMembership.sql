/* CreateDate: 04/10/2014 16:09:56.627 , ModifyDate: 12/24/2014 11:42:04.347 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				spRpt_NewWomensMembership
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_BI_Reporting
RELATED REPORT:			NewWomensMembership
AUTHOR:					Rachelen Hut
IMPLEMENTOR:			Rachelen Hut
DATE IMPLEMENTED:
------------------------------------------------------------------------
CHANGE HISTORY:
06/12/2014	RH	Changed to a "ROW NUMBER OVER" to find the latest Hair Application and Hair Length.
12/24/2014	RH	Added "AND SO.OrderDate >= DATEADD(mm,-12,@StartDate)"
					To exclude any earlier conversions (ClientIdentifier = 228663 in 230)
------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC spRpt_NewWomensMembership '12/1/2014', '12/24/2014'

***********************************************************************/

CREATE PROCEDURE [dbo].[spRpt_NewWomensMembership]
(
	@StartDate		DATETIME
	,	@EndDate	DATETIME
) AS
BEGIN

	SET FMTONLY OFF;
	SET NOCOUNT OFF;

SELECT 	CM.ClientMembershipBeginDate
		,	CM.ClientMembershipEndDate
		,	SO.OrderDate
		,	M.MembershipDescription
		,	CM.CenterSSID
		,	C.CenterDescriptionNumber
		,	CL.ClientIdentifier
		,	CL.ClientFullName
		,	CM.ClientMembershipStatusDescription
		,	MAX(CM.ClientMembershipContractPaidAmount) AS 'ContractPaidAmount'
		,	CM.ClientMembershipMonthlyFee
		,	SOD.Employee1SSID
		,	E.EmployeeInitials
		,	hairlen.HairSystemHairLengthValue
		,	hairlen.HairSystemOrderDate
		,	hairlen.HairSystemOrderNumber
		,	cancel.ClientMembershipEndDate AS 'CancelDate'
		,	upgrade.OrderDate AS 'UpgradeDate'

	FROM HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrder SO
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimSalesOrderDetail SOD
		ON SOD.SalesOrderKey = SO.SalesOrderKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CL
		ON CL.ClientKey = SO.ClientKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClientMembership CM
		ON CL.ClientKey = CM.ClientKey
	INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
		ON CM.MembershipKey = M.MembershipKey
	INNER JOIN HC_BI_ENT_DDS.bi_ent_dds.DimCenter C
		ON CM.CenterSSID = C.CenterSSID
	LEFT JOIN HC_BI_CMS_DDS.[bi_cms_dds].[FactHairSystemOrder] HSO
		ON  HSO.ClientKey = SO.ClientKey AND CM.ClientMembershipKey = HSO.ClientMembershipKey
	LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimEmployee E
		ON E.EmployeeSSID = SOD.Employee1SSID
	LEFT OUTER JOIN (
				-- Get Latest Hairlength Data
			SELECT HSO.HairSystemOrderNumber
			,	HSO.HairSystemOrderDate
			,	HSO.CenterKey
			,	HSO.ClientKey
			,	HSO.ClientMembershipKey
			,	HSO.HairSystemHairLengthKey
			,	HSHL.HairSystemHairLengthValue
			,   ROW_NUMBER() OVER ( PARTITION BY ClientKey ORDER BY HairSystemOrderDate DESC ) AS 'Ranking'
			FROM HC_BI_CMS_DDS.[bi_cms_dds].[FactHairSystemOrder] HSO
			LEFT JOIN HC_BI_CMS_DDS.bi_cms_dds.DimHairSystemHairLength HSHL
					ON HSHL.HairSystemHairLengthKey = HSO.HairSystemHairLengthKey
			WHERE HSHL.Active = 'Y'
			) hairlen
		ON SO.ClientKey = hairlen.ClientKey AND CM.ClientMembershipKey = hairlen.ClientMembershipKey
			AND hairlen.Ranking = 1

	LEFT OUTER JOIN (
				-- Get Cancellations
			SELECT CM.ClientMembershipEndDate
			,	DSO.ClientKey
			,	CM.ClientMembershipKey
			,   ROW_NUMBER() OVER ( PARTITION BY DSO.ClientKey ORDER BY CM.ClientMembershipEndDate DESC ) AS 'Ranking2'
			FROM HC_BI_CMS_DDS.[bi_cms_dds].DimSalesOrder DSO
			INNER JOIN HC_BI_CMS_DDS.[bi_cms_dds].DimSalesOrderDetail DSOD
				ON DSOD.SalesOrderKey = DSO.SalesOrderKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
				ON DSO.ClientKey = CLT.ClientKey
			INNER JOIN HC_BI_CMS_DDS.[bi_cms_dds].DimClientMembership CM
				ON CM.ClientKey = DSO.ClientKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
				ON M.MembershipSSID = CM.MembershipSSID
			INNER JOIN HC_BI_CMS_DDS.[bi_cms_dds].DimSalesCode DSC
				ON DSOD.SalesCodeSSID = DSC.SalesCodeSSID
			WHERE DSC.SalesCodeDescriptionShort = 'CANCEL'
			AND CLT.GenderSSID = 2
			AND (MembershipDescription LIKE 'Ruby%'OR MembershipDescription LIKE 'Sapphire%' OR MembershipDescription LIKE 'Diamond%' OR MembershipDescription LIKE 'Emerald%')
			AND ClientMembershipStatusDescription = 'Cancel'
			GROUP BY CM.ClientMembershipEndDate
			,	DSO.ClientKey
			,	CM.ClientMembershipKey
			) cancel
		ON SO.ClientKey = cancel.ClientKey AND CM.ClientMembershipKey = cancel.ClientMembershipKey
			AND cancel.Ranking2 = 1

	LEFT OUTER JOIN (
				-- Get Upgrades
			SELECT DSO.OrderDate
			,	CM.ClientKey
			,	CM.ClientMembershipKey
			,   ROW_NUMBER() OVER ( PARTITION BY DSO.ClientKey ORDER BY DSO.OrderDate DESC ) AS 'Ranking3'
			FROM HC_BI_CMS_DDS.[bi_cms_dds].DimSalesOrder DSO
			INNER JOIN HC_BI_CMS_DDS.[bi_cms_dds].DimSalesOrderDetail DSOD
				ON DSOD.SalesOrderKey = DSO.SalesOrderKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimClient CLT
				ON DSO.ClientKey = CLT.ClientKey
			INNER JOIN HC_BI_CMS_DDS.[bi_cms_dds].DimClientMembership CM
				ON CM.ClientKey = DSO.ClientKey
			INNER JOIN HC_BI_CMS_DDS.bi_cms_dds.DimMembership M
				ON M.MembershipSSID = CM.MembershipSSID
			INNER JOIN HC_BI_CMS_DDS.[bi_cms_dds].DimSalesCode DSC
				ON DSOD.SalesCodeSSID = DSC.SalesCodeSSID
			WHERE DSC.SalesCodeDescriptionShort IN('PCPXU','NB2XU')
			AND (MembershipDescription LIKE 'Ruby%'OR MembershipDescription LIKE 'Sapphire%' OR MembershipDescription LIKE 'Diamond%' OR MembershipDescription LIKE 'Emerald%')
			AND ClientMembershipStatusDescription = 'Active'
			) upgrade
		ON SO.ClientKey = upgrade.ClientKey AND CM.ClientMembershipKey = upgrade.ClientMembershipKey
			AND upgrade.Ranking3 = 1

	WHERE ClientMembershipBeginDate BETWEEN @StartDate AND @EndDate
	AND SOD.SalesCodeSSID = 356 --Convert Membership
	AND M.MembershipDescriptionShort IN('CRYSTL', 'CRYSTLPLUS', 'RUBY', 'RUBYPLUS', 'EMRLD', 'EMRLDPLUS',
		'SAPPHIRE', 'SAPPHRPLUS')
	AND SO.OrderDate >= DATEADD(mm,-12,@StartDate)  --To exclude any earlier conversions (ClientIdentifier = 228663 in 230)

	GROUP BY CM.ClientMembershipBeginDate
		,	CM.ClientMembershipEndDate
		,	SO.OrderDate
		,	M.MembershipDescription
		,	CM.CenterSSID
		,	C.CenterDescriptionNumber
		,	CL.ClientIdentifier
		,	CL.ClientFullName
		,	CM.ClientMembershipStatusDescription
		,	CM.ClientMembershipMonthlyFee
		,	SOD.Employee1SSID
		,	E.EmployeeInitials
		,	hairlen.HairSystemHairLengthValue
		,	hairlen.HairSystemOrderDate
		,	hairlen.HairSystemOrderNumber
		,	cancel.ClientMembershipEndDate
		,	upgrade.OrderDate

END
GO
