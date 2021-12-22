/* CreateDate: 05/14/2012 17:40:58.090 , ModifyDate: 11/21/2019 13:34:44.980 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				[selFeeProcessDates]
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				HDu
IMPLEMENTOR: 			HDu
DATE IMPLEMENTED: 		02/02/2012
LAST REVISION DATE: 	02/02/2012
--------------------------------------------------------------------------------------------------------
NOTES: 	Return process dates for previous, current and next month paycycles.
		02/02/2012 - HDu Created Stored Proc
		06/09/2015 - SAL Updated window for Month1 from 5 to 11 days
		06/15/2015 - SAL Updated window for Month1 from 11 to 16 days
		06/18/2015 - SAL Updated window for Month1 from 16 to 20 days
		06/19/2015 - SAL Updated window for Month1 from 20 to 27 days
		06/26/2015 - SAL Updated window for Month1 from 20 to 29 days
		06/26/2015 - SAL Updated window for Month1 from 29 back down to 5 days
		11/21/2019 - MVT Updated window for Month1 from 5 to 10 days
		11/21/2019 - SAL Updated window for Month1 from 10 to 5 days
--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC [selFeeProcessDates]
***********************************************************************/
CREATE PROCEDURE [dbo].[selFeeProcessDates]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @PROCESSMONTH1 AS DATETIME
	,@PROCESSMONTH2 AS DATETIME

	SELECT @PROCESSMONTH1 = GETDATE()
	,@PROCESSMONTH2 = DATEADD(MONTH,1,GETDATE())


		SELECT DATEADD(DAY,FeePayCycleValue-1,CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(GETDATE())-1),GETDATE()),101)) as ProcessDate
		,FeePayCycleID AS FeePayCycleID
		,YEAR(@PROCESSMONTH1) ProcessYear
		,MONTH(@PROCESSMONTH1) ProcessMonth
		FROM dbo.lkpFeePayCycle
		WHERE FeePayCycleValue != 0 AND DATEPART(day,@PROCESSMONTH1) < FeePayCycleValue + 10
	UNION
		SELECT DATEADD(DAY,FeePayCycleValue-1,CONVERT(VARCHAR(25),DATEADD(dd,-(DAY(DATEADD(mm,1,GETDATE()))-1),DATEADD(mm,1,GETDATE())),101)) as ProcessDate
		,FeePayCycleID AS FeePayCycleID
		,YEAR(@PROCESSMONTH2) ProcessYear
		,MONTH(@PROCESSMONTH2) ProcessMonth
		FROM dbo.lkpFeePayCycle
		WHERE FeePayCycleValue != 0 AND DATEPART(DAY, @PROCESSMONTH2) > FeePayCycleValue - 5
		ORDER BY ProcessDate

END
GO
