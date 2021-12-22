/* CreateDate: 08/15/2011 13:08:04.983 , ModifyDate: 11/18/2013 14:06:14.690 */
GO
CREATE VIEW [dbo].[vwEmployeeHoursCertipaySurgery]
AS

SELECT  [LastName]
,       [FirstName]
,       [HomeDepartment]
,       [EmployeeNumber]
,       [EmployeeID]
,       [PeriodBegin]
,       [PeriodEnd]
,       [CheckDate]
,       [SalaryHours]
,       [RegularHours]
,       [OverTimeHours]
,       [PTO_Hours]
,       CASE WHEN [PerformerHomeCenter] LIKE '2%' THEN 100 + PerformerHomeCenter
             WHEN [PerformerHomeCenter] LIKE '[78]%' THEN PerformerHomeCenter - 200
             ELSE [PerformerHomeCenter]
        END AS [PerformerHomeCenter]
,       [ImportDate]
,       [GeneralLedger]
,       [PTHours]
,       [FuneralHours]
,       [JuryHours]
,       [SalaryEarnings]
,       [RegularEarnings]
,       [OTEarnings]
,       [PTEarnings]
,       [PTOEarnings]
,       [FuneralEarnings]
,       [JuryEarnings]
,       [TravelHours]
,       [TravelEarnings]
FROM    [HC_Accounting].[dbo].[EmployeeHoursCertipay]
GO
