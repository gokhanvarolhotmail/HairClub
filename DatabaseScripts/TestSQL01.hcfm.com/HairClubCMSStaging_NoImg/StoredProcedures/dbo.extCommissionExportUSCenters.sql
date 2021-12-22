/* CreateDate: 03/14/2013 23:16:37.460 , ModifyDate: 06/15/2020 09:06:11.463 */
GO
/*
==============================================================================

PROCEDURE:				[extCommissionExportUSCenters]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_Commission]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	Export pay period details for all US centers for Certipay
==============================================================================
NOTES:
	03/22/2013 - MB - Replaced zeroes with blanks for the export
	04/29/2013 - MT - Modified to export CertipayNumber as '' when NULL
	06/08/2020 - DL-AP  TFS#14515 Add WeekEndDate field
==============================================================================
SAMPLE EXECUTION:
EXEC [extCommissionExportUSCenters] 562, 'x'
==============================================================================
*/
CREATE PROCEDURE [dbo].[extCommissionExportUSCenters] (
	@PayPeriodKey INT
   ,@User NVARCHAR(100)
)  AS
BEGIN
	SET NOCOUNT ON

	SELECT DE.EmployeePayrollID AS 'CertipayNumber'
	,	ISNULL(FCO.EmployeeFullName, FCH.EmployeeFullName) AS 'EmployeeName'
	,	CASE WHEN CONVERT(DATE, DATEADD(DAY, 6, FCH.AdvancedCommissionDate - DATEPART(dw, FCH.AdvancedCommissionDate) + CASE WHEN DATEPART(dw, FCH.AdvancedCommissionDate) < 6 THEN 0 ELSE 7 END)) > PP.EndDate THEN PP.EndDate
		ELSE CONVERT(DATE, DATEADD(DAY, 6, FCH.AdvancedCommissionDate - DATEPART(dw, FCH.AdvancedCommissionDate) + CASE WHEN DATEPART(dw, FCH.AdvancedCommissionDate) < 6 THEN 0 ELSE 7 END)) END AS 'WeekEndDate'
	,	CONVERT(NVARCHAR(10), CONVERT(NUMERIC(10,2), SUM(CASE WHEN FCH.CommissionTypeID NOT IN (25, 26, 2) THEN ISNULL(FCH.AdvancedCommission, 0) ELSE 0 END))) AS 'Commission'
	,	CONVERT(NVARCHAR(10), CONVERT(NUMERIC(10,2), SUM(CASE WHEN FCH.CommissionTypeID IN (26) THEN ISNULL(FCH.AdvancedCommission, 0) ELSE 0 END))) AS 'CashTips'
	,	CONVERT(NVARCHAR(10), CONVERT(NUMERIC(10,2), SUM(CASE WHEN FCH.CommissionTypeID IN (25) THEN ISNULL(FCH.AdvancedCommission, 0) ELSE 0 END))) AS 'NonCashTips'
	,	CONVERT(NVARCHAR(10), CONVERT(NUMERIC(10,2), SUM(CASE WHEN FCH.CommissionTypeID IN (2) THEN ISNULL(FCH.AdvancedCommission, 0) ELSE 0 END))) AS 'RetentionBonus'
	INTO #tmp
	FROM Commission_FactCommissionHeader_TABLE FCH
		INNER JOIN Commission_DimCommissionType_TABLE CT
			ON FCH.CommissionTypeID = CT.CommissionTypeID
		INNER JOIN Commission_lkpPayPeriods_TABLE PP
			ON FCH.AdvancedPayPeriodKey = PP.PayPeriodKey
		INNER JOIN HC_BI_ENT_DDS_DimCenter_TABLE CTR
			ON FCH.CenterKey = CTR.CenterKey
		LEFT OUTER JOIN Commission_FactCommissionOverride_TABLE FCO
			ON FCH.CommissionHeaderKey = FCO.CommissionHeaderKey
		LEFT OUTER JOIN HC_BI_CMS_DDS_DimEmployee_TABLE DE
			ON ISNULL(FCO.EmployeeKey, FCH.EmployeeKey) = DE.EmployeeKey
	WHERE CTR.CountryRegionDescriptionShort = 'US'
		AND FCH.AdvancedPayPeriodKey = @PayPeriodKey
		AND ISNULL(FCH.AdvancedCommission, 0) <> 0
		AND ISNULL(FCO.EmployeeKey, FCH.EmployeeKey) <> -1
	GROUP BY DE.EmployeePayrollID
	,	ISNULL(FCO.EmployeeFullName, FCH.EmployeeFullName)
	,	CASE WHEN CONVERT(DATE, DATEADD(DAY, 6, FCH.AdvancedCommissionDate - DATEPART(dw, FCH.AdvancedCommissionDate) + CASE WHEN DATEPART(dw, FCH.AdvancedCommissionDate) < 6 THEN 0 ELSE 7 END)) > PP.EndDate THEN PP.EndDate
		ELSE CONVERT(DATE, DATEADD(DAY, 6, FCH.AdvancedCommissionDate - DATEPART(dw, FCH.AdvancedCommissionDate) + CASE WHEN DATEPART(dw, FCH.AdvancedCommissionDate) < 6 THEN 0 ELSE 7 END)) END


	SELECT  ISNULL(CertipayNumber, '') AS 'CertipayNumber'
	,	EmployeeName
	,	WeekEndDate
	,	CASE WHEN Commission='0.00' THEN '' ELSE Commission END AS 'Commission'
	,	CASE WHEN CashTips='0.00' THEN '' ELSE CashTips END AS 'CashTips'
	,	CASE WHEN NonCashTips='0.00' THEN '' ELSE NonCashTips END AS 'NonCashTips'
	,	CASE WHEN RetentionBonus='0.00' THEN '' ELSE RetentionBonus END AS 'RetentionBonus'
	FROM #tmp
	ORDER BY EmployeeName
	,		WeekEndDate
END
GO
