/* CreateDate: 02/17/2015 14:53:44.630 , ModifyDate: 05/27/2015 13:50:34.177 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
==============================================================================

PROCEDURE:				[selPayPeriod]

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

IMPLEMENTOR: 			Rachelen Hut

==============================================================================
DESCRIPTION:	Creates the list of pay periods for a drop-down for reports
==============================================================================
NOTES:
==============================================================================
SAMPLE EXECUTION:
EXEC [selPayPeriod]
==============================================================================
*/

CREATE PROCEDURE [dbo].[selPayPeriod]
  AS

BEGIN
	SET NOCOUNT ON


	SELECT PayPeriodKey AS 'Value'
		,	CONVERT(VARCHAR, StartDate, 101) + ' - ' + CONVERT(VARCHAR, EndDate, 101) AS 'Description'
	FROM Commission_lkpPayPeriods_TABLE PP
	WHERE PP.PayGroup = 1
		AND PP.PayDate <= DATEADD(MONTH,1,GETUTCDATE())
	ORDER BY PP.StartDate DESC

END
GO
