/* CreateDate: 07/31/2017 12:23:46.290 , ModifyDate: 07/31/2017 12:23:46.290 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				extHairClubCMSEarnedSummaryByCountry
DESTINATION SERVER:		SQL06
DESTINATION DATABASE:	HC_Commission
AUTHOR:					Dominic Leiba
IMPLEMENTOR:			Dominic Leiba
DATE IMPLEMENTED:		7/31/2017
DESCRIPTION:			7/31/2017
------------------------------------------------------------------------
NOTES:

------------------------------------------------------------------------
SAMPLE EXECUTION:

EXEC extHairClubCMSEarnedSummaryByCountry 'ALL', 512
EXEC extHairClubCMSEarnedSummaryByCountry 'US', 512
EXEC extHairClubCMSEarnedSummaryByCountry 'CA', 512
***********************************************************************/
CREATE PROCEDURE [dbo].extHairClubCMSEarnedSummaryByCountry
(
	@Country VARCHAR(3)
,	@PayPeriodKey INT
)
AS
BEGIN

declare @Centers as table (
		CenterKey INT
	,	ReportingCenterSSID INT
	,	CenterDescription VARCHAR(50)
	)


	IF @Country = 'ALL'
		BEGIN
			INSERT INTO @Centers
			SELECT CenterKey
			,	ReportingCenterSSID
			,	CenterDescription
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter
			WHERE ReportingCenterSSID LIKE '2%'
				AND Active = 'Y'
		END
	ELSE IF @Country = 'US'
		BEGIN
			INSERT INTO @Centers
			SELECT CenterKey
			,	ReportingCenterSSID
			,	CenterDescription
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter
			WHERE ReportingCenterSSID LIKE '2%'
				AND Active = 'Y'
				AND CountryRegionDescriptionShort = 'US'
		END
	ELSE IF @Country = 'CA'
		BEGIN
			INSERT INTO @Centers
			SELECT CenterKey
			,	ReportingCenterSSID
			,	CenterDescription
			FROM HC_BI_ENT_DDS.bi_ent_dds.DimCenter
			WHERE ReportingCenterSSID LIKE '2%'
				AND Active = 'Y'
				AND CountryRegionDescriptionShort = 'CA'
		END


	SELECT CONVERT(VARCHAR, PP.StartDate, 101) + ' - ' + CONVERT(VARCHAR, PP.EndDate, 101) AS 'PayPeriodDates'
	,	SUM(CASE WHEN CT.[Role] = 'NB Consult' AND FCH.CommissionTypeID NOT IN (25, 26) THEN ISNULL(FCH.AdvancedCommission, 0) ELSE 0 END) AS 'NBConsultantsCommission'
	,	SUM(CASE WHEN CT.[Role] = 'MA' AND FCH.CommissionTypeID NOT IN (25, 26) THEN ISNULL(FCH.AdvancedCommission, 0) ELSE 0 END) AS 'MembershipAdvisonCommission'
	,	SUM(CASE WHEN CT.[Role] = 'Stylist' AND FCH.CommissionTypeID NOT IN (25, 26) THEN ISNULL(FCH.AdvancedCommission, 0) ELSE 0 END) AS 'StylistCommission'
	,	SUM(CASE WHEN FCH.CommissionTypeID IN (25) THEN ISNULL(FCH.AdvancedCommission, 0) ELSE 0 END) AS 'NonCashTipsCommission'
	,	SUM(CASE WHEN FCH.CommissionTypeID IN (26) THEN ISNULL(FCH.AdvancedCommission, 0) ELSE 0 END) AS 'CashTipsCommission'
	,	MAX(PE.ExportDate) AS 'ExportDate'
	,	MAX(PE.UpdateUser) AS 'ExportUser'
	FROM FactCommissionHeader FCH
		INNER JOIN DimCommissionType CT
			ON FCH.CommissionTypeID = CT.CommissionTypeID
		INNER JOIN lkpPayPeriods PP
			ON FCH.AdvancedPayPeriodKey = PP.PayPeriodKey
		INNER JOIN @Centers CTR
			ON FCH.CenterKey = CTR.CenterKey
		LEFT OUTER JOIN DimPayrollExport PE
			ON PE.PayPeriodKey = @PayPeriodKey
			AND PE.CountryRegionDescriptionShort = @Country
		LEFT OUTER JOIN FactCommissionOverride FCO
			ON FCH.CommissionHeaderKey = FCO.CommissionHeaderKey
	WHERE FCH.AdvancedPayPeriodKey = @PayPeriodKey
		AND ISNULL(FCH.AdvancedCommission, 0) <> 0
		AND ISNULL(FCO.EmployeeKey, FCH.EmployeeKey) <> -1
	GROUP BY CONVERT(VARCHAR, PP.StartDate, 101) + ' - ' + CONVERT(VARCHAR, PP.EndDate, 101)

END
GO
