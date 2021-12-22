/* CreateDate: 02/18/2013 06:59:50.643 , ModifyDate: 09/19/2013 10:37:13.050 */
GO
/*===============================================================================================
-- Procedure Name:			rptEndOfDayTransactionsHdr
-- Procedure Description:
--
-- Created By:				MLM
-- Implemented By:			MLM
-- Last Modified By:		MLM
--
-- Date Created:			02/0/13
-- Destination Server:		SQL01
-- Destination Database:	HairClubCMS
-- Related Application:		CMS
--------------------------------------------------------------------------------------------------------
NOTES:
	02/05/13	MLM		Initial Creation
	08/06/13	MLM		Added IsSalesOrderRoundingEnabled
--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC [rptEndOfDayTransactionsHdr] 201, '2013-02-05'
================================================================================================*/
CREATE PROCEDURE [dbo].[rptEndOfDayTransactionsHdr]
(
	@CenterID INT
	,@EndOfDayDate DATETIME
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT c.CenterID
		,c.CenterDescription
		,c.CenterDescriptionFullCalc
		,eod.EndOfDayDate
		,eod.DepositNumber
		,e.UserLogin
		,cc.IsSalesOrderRoundingEnabled
	FROM datEndOfDay eod
		INNER JOIN cfgCenter c on eod.CenterID = c.CenterID
		INNER JOIN cfgConfigurationCenter cc on c.CenterID = cc.CenterID
		INNER JOIN datEmployee e on eod.EmployeeGUID = e.EmployeeGUID
	WHERE eod.CenterID = @CenterID
		AND eod.EndOfDayDate = @EndOfDayDate

END
GO
