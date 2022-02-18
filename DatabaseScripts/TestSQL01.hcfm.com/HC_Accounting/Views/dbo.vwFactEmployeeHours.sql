/* CreateDate: 03/05/2013 10:27:34.433 , ModifyDate: 03/05/2013 10:27:34.433 */
GO
CREATE VIEW [dbo].[vwFactEmployeeHours]
AS

	SELECT EmpHours.EmployeeID
	,	EmpHours.LastName
	,	EmpHours.FirstName
	,	EmpHours.PerformerHomeCenter
	,	EmpHours.PeriodBegin
	,	DDPB.DateKey AS PBDateID
	,	EmpHours.PeriodEnd
	,	DDPE.DateKey AS PEDateID
	,	EmpHours.CheckDate
	,	DDCD.DateKey AS CDDateID
	,	CONVERT(NUMERIC(15, 2), EmpHours.SalaryHours / 1000) AS SalHours
	,	CONVERT(NUMERIC(15, 2), EmpHours.RegularHours / 1000) AS RegHours
	,	CONVERT(NUMERIC(15, 2), EmpHours.OverTimeHours / 1000) AS OTHours
	,	CONVERT(NUMERIC(15, 2), EmpHours.PTO_Hours / 1000) AS PTOHours
	,	CONVERT(NUMERIC(15, 2), EmpHours.PTHours / 1000) AS PartTimeHours
	,	CONVERT(NUMERIC(15, 2), EmpHours.FuneralHours / 1000) AS FuneralHours
	,	CONVERT(NUMERIC(15, 2), EmpHours.JuryHours / 1000) AS JuryHours
	,	EmpHours.GeneralLedger AS Account
	,	1 AS EmpCount
	FROM HC_Accounting.dbo.employeehourscertipay AS EmpHours
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate AS DDPB
			ON EmpHours.PeriodBegin = DDPB.FullDate
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate AS DDPE
			ON EmpHours.PeriodEnd = DDPE.FullDate
		INNER JOIN HC_BI_ENT_DDS.bief_dds.DimDate AS DDCD
			ON EmpHours.CheckDate = DDCD.FullDate
	WHERE (EmpHours.PeriodBegin > '10/20/07')
GO
