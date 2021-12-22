/* CreateDate: 02/18/2013 06:59:50.667 , ModifyDate: 06/04/2015 08:41:05.980 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
-- Procedure Name:			rptEndOfDayRecap
-- Procedure Description:
--
-- Created By:				Hdu
-- Implemented By:			Hdu
-- Last Modified By:		RMH
--
-- Date Created:			10/11/2012
-- Destination Server:		SQL01
-- Destination Database:	HairClubCMS
-- Related Application:		CMS
--------------------------------------------------------------------------------------------------------
NOTES:

	10/17/12	MLM		Modified the table Structure to tied RegisterLog to RegisterClose
	10/30/12	MLM		Modified the Query to return results from RegisterTender Table
	12/11/12	MLM		Added CloseDate to the results
	01/28/13	MLM		Modified Report to match new data structure
	02/06/13	MLM		Modified to Match New Specifications
	02/20/13	MLM		Fixed Issue with Recap Header
	06/06/13	MLM		Added Surgery Section
	1/2/2014	RMH		Added @OpeningBalance and LEFT JOIN dbo.datRegisterLog rl ON eod.EndOfDayGUID = rl.EndOfDayGUID
	5/27/2015	RMH		(WO#115068) Added ORDER BY tType.TenderTypeSortOrder and WHERE tType.IsActiveFlag = 1

--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC [rptEndOfDayRecap] 292, '4/1/2015', 1

EXEC [rptEndOfDayRecap] 292, '4/1/2015', 2
================================================================================================*/
CREATE PROCEDURE [dbo].[rptEndOfDayRecap]
(
	@CenterID INT,
	@EndOfDayDate DATETIME,
	@BusinessSegments INT = 0 -- 0 All, 1 Non-Surgery, 2 Surgery
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @CenterDescriptionFullCalc nvarchar(50)
		,	@DepositNumber varchar(25)
		,	@UserLogin varchar(25)
		,	@CloseDate DATETIME
		,	@OpeningBalance MONEY

	SELECT @CenterDescriptionFullCalc = c.CenterDescriptionFullCalc
		,	@DepositNumber = eod.DepositNumber
		,	@UserLogin = e.UserLogin
		,	@CloseDate = eod.CloseDate
		,	@OpeningBalance = rl.OpeningBalance
	FROM datEndOfDay eod
		INNER JOIN dbo.cfgCenter c
			ON eod.CenterID = c.CenterID
		INNER JOIN dbo.datEmployee e
			ON eod.EmployeeGUID = e.EmployeeGUID
		LEFT JOIN dbo.datRegisterLog rl
			ON rl.EndOfDayGUID = eod.EndOfDayGUID
	WHERE eod.EndOfDayDate = @EndOfDayDate
		AND eod.CenterID = @CenterID

	 IF (@BusinessSegments = 2 )
		BEGIN
			SELECT tType.TenderTypeDescription AS 'TenderTypeDescription'
				,	@CenterDescriptionFullCalc AS 'CenterDescriptionFullCalc'
				,	@EndOfDayDate AS 'EndOfDayDate'
				,	@DepositNumber AS 'DepositNumber'
				,	@UserLogin  AS 'UserLogin'
				,	ISNULL(@OpeningBalance,0.00) AS 'OpeningBalance'
				,	COUNT(sResults.TenderAmount) AS 'TenderQuantity'
				,	SUM(ISNULL(sResults.TenderAmount,0.00)) AS 'TenderTotal'
				,	SUM(ISNULL(tResults.RegisterQuantity,0.00)) AS 'EndOfDayQuantity'
				,	MAX(ISNULL(tResults.RegisterTotal,0.00)) AS 'EndOfDayTender'
				,	MAX(ISNULL(tResults.TotalVariance,0.00)) AS 'TotalVariance'
				,	CASE WHEN tType.TenderTypeDescriptionShort IN ('Cash','Check') THEN 1 ELSE tType.TenderTypeSortOrder END AS 'ROWGROUPING'
				,	@CloseDate  AS 'CloseDate'
				,	tType.TenderTypeSortOrder
			FROM dbo.LkpTenderType tType
				LEFT OUTER JOIN (
									Select DISTINCT rl.RegisterLogGUID
										,tt.TenderTypeID
										,eod.EndOfDayGUID
										,ISNULL(RegisterQuantity, 0.00) RegisterQuantity
										,ISNULL(RegisterTotal, 0.00) RegisterTotal
										,ISNULL(TotalVariance, 0.00) TotalVariance
									FROM dbo.lkpTenderType tt
										INNER JOIN dbo.datRegisterTender rt on tt.TenderTypeID = rt.TenderTypeID
										INNER JOIN dbo.datRegisterLog rl on rt.RegisterLogGUID = rl.RegisterLogGUID
										INNER JOIN dbo.datEndOfDay eod on rl.EndOfDayGUID = eod.EndOfDayGUID
									WHERE eod.EndOfDayDate = @EndOfDayDate
											AND eod.CenterID = @CenterID
											AND tt.IsActiveFlag = 1
								   ) tResults on tType.TenderTypeID = tResults.TendertypeID
				LEFT OUTER JOIN (
									SELECT tt.TenderTypeID
											,ISNULL(sot.Amount,0.00) as TenderAmount
									FROM dbo.lkpTenderType tt
										INNER JOIN datSalesOrderTender sot on tt.TenderTypeID = sot.TenderTypeID
										INNER JOIN datSalesOrder so on sot.SalesOrderGUID = so.SalesOrderGUID
										INNER JOIN datEndOfDay eod on so.EndOfDayGUID = eod.EndOfDayGUID
										INNER JOIN datClientMembership cm on so.ClientMembershipGUID = cm.ClientMembershipGUID
										INNER JOIN cfgMembership m on cm.MembershipID = m.MembershipID
										INNER JOIN lkpBusinessSegment bs on m.BusinessSegmentID = bs.BusinessSegmentID
									WHERE eod.EndOfDayDate = @EndOfDayDate
											AND eod.CenterID = @CenterID
											AND so.IsVoidedFlag = 0
											and bs.BusinessSegmentDescriptionShort = 'SUR'
											AND tt.IsActiveFlag = 1
									) sResults on tType.TenderTypeID = sResults.TenderTypeID
			WHERE tType.IsActiveFlag = 1
			GROUP BY tType.TenderTypeDescription
				,tType.TenderTypeDescriptionShort
				,tType.TenderTypeSortOrder
			ORDER BY tType.TenderTypeSortOrder  --Leave ORDER BY for TenderType = 'Finance AR'

		END
	ELSE
		BEGIN
		SELECT tType.TenderTypeDescription AS 'TenderTypeDescription'
				,	@CenterDescriptionFullCalc AS 'CenterDescriptionFullCalc'
				,	@EndOfDayDate AS 'EndOfDayDate'
				,	@DepositNumber AS 'DepositNumber'
				,	@UserLogin  AS 'UserLogin'
				,	ISNULL(@OpeningBalance,0.00) AS 'OpeningBalance'
				,	COUNT(sResults.TenderAmount) AS 'TenderQuantity'
				,	SUM(ISNULL(sResults.TenderAmount,0.00)) AS 'TenderTotal'
				,	SUM(ISNULL(tResults.RegisterQuantity,0.00)) AS 'EndOfDayQuantity'
				,	MAX(ISNULL(tResults.RegisterTotal,0.00)) AS 'EndOfDayTender'
				,	MAX(ISNULL(tResults.TotalVariance,0.00)) AS 'TotalVariance'
				,	CASE WHEN tType.TenderTypeDescriptionShort IN ('Cash','Check') THEN 1 ELSE tType.TenderTypeSortOrder END AS 'ROWGROUPING'
				,	@CloseDate  AS 'CloseDate'
				,	tType.TenderTypeSortOrder
			FROM dbo.LkpTenderType tType
				LEFT OUTER JOIN (
									Select DISTINCT rl.RegisterLogGUID
										,tt.TenderTypeID
										,eod.EndOfDayGUID
										,ISNULL(RegisterQuantity, 0.00) RegisterQuantity
										,ISNULL(RegisterTotal, 0.00) RegisterTotal
										,ISNULL(TotalVariance, 0.00) TotalVariance
									FROM dbo.lkpTenderType tt
										INNER JOIN dbo.datRegisterTender rt on tt.TenderTypeID = rt.TenderTypeID
										INNER JOIN dbo.datRegisterLog rl on rt.RegisterLogGUID = rl.RegisterLogGUID
										INNER JOIN dbo.datEndOfDay eod on rl.EndOfDayGUID = eod.EndOfDayGUID
									WHERE eod.EndOfDayDate = @EndOfDayDate
											AND eod.CenterID = @CenterID
											AND tt.IsActiveFlag = 1
								   ) tResults on tType.TenderTypeID = tResults.TendertypeID
				LEFT OUTER JOIN (
									SELECT tt.TenderTypeID
											,ISNULL(sot.Amount,0.00) as TenderAmount
									FROM dbo.lkpTenderType tt
										INNER JOIN datSalesOrderTender sot on tt.TenderTypeID = sot.TenderTypeID
										INNER JOIN datSalesOrder so on sot.SalesOrderGUID = so.SalesOrderGUID
										INNER JOIN datEndOfDay eod on so.EndOfDayGUID = eod.EndOfDayGUID
										INNER JOIN datClientMembership cm on so.ClientMembershipGUID = cm.ClientMembershipGUID
										INNER JOIN cfgMembership m on cm.MembershipID = m.MembershipID
										INNER JOIN lkpBusinessSegment bs on m.BusinessSegmentID = bs.BusinessSegmentID
									WHERE eod.EndOfDayDate = @EndOfDayDate
											AND eod.CenterID = @CenterID
											AND so.IsVoidedFlag = 0
											and bs.BusinessSegmentDescriptionShort <> 'SUR'
											AND tt.IsActiveFlag = 1
									) sResults on tType.TenderTypeID = sResults.TenderTypeID
			WHERE tType.IsActiveFlag = 1
			GROUP BY tType.TenderTypeDescription
				,tType.TenderTypeDescriptionShort
				,tType.TenderTypeSortOrder
			ORDER BY tType.TenderTypeSortOrder  --Leave ORDER BY for new TenderType = 'Finance AR'

		END


END
GO
