/* CreateDate: 10/03/2013 14:53:55.020 , ModifyDate: 10/03/2013 14:53:56.747 */
GO
/*
==============================================================================

PROCEDURE:				[spRpt_lstPayPeriods]

DESTINATION SERVER:		SQL06

DESTINATION DATABASE: 	[HC_BI_Reportint]

IMPLEMENTOR: 			Marlon Burrell

==============================================================================
DESCRIPTION:	This procedure lists all pay periods
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [spRpt_lstPayPeriods]
==============================================================================
*/
CREATE PROCEDURE [dbo].[spRpt_lstPayPeriods] AS
BEGIN
	SET NOCOUNT ON

	SELECT PayPeriodKey
	,	CONVERT(VARCHAR, StartDate, 101) + ' - ' + CONVERT(VARCHAR, EndDate, 101) AS 'PayPeriod'
	FROM HC_Commission.dbo.lkpPayPeriods
	WHERE PayGroup=1
		AND StartDate < GETDATE()
	ORDER BY StartDate DESC

END
GO
