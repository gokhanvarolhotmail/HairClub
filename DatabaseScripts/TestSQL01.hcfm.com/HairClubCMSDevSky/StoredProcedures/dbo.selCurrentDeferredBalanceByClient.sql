/* CreateDate: 04/08/2014 10:16:20.580 , ModifyDate: 04/28/2020 16:27:36.750 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/***********************************************************************
PROCEDURE:				selCurrentDeferredBalanceByClient
DESTINATION SERVER:		SQL01
DESTINATION DATABASE: 	HairClubCMS
RELATED APPLICATION:  	CMS
AUTHOR: 				Mike Tovbin
IMPLEMENTOR: 			Mike Tovbin
DATE IMPLEMENTED: 		04/07/2014
LAST REVISION DATE: 	04/07/2014
--------------------------------------------------------------------------------------------------------
NOTES:

		* 04/07/2014	MVT	Created
		* 04/10/2014	MVT Modified to take into account payments made this month.
		* 04/20/2020	MVT Modified to use stored procedure from Deferred DAILY DB to determine
							Deferred.  Logic for adding in revenue for the current month remains the same.

--------------------------------------------------------------------------------------------------------
SAMPLE EXECUTION:
EXEC selCurrentDeferredBalanceByClient 336956 -- 129617
***********************************************************************/
CREATE PROCEDURE [dbo].[selCurrentDeferredBalanceByClient]
	@ClientIdentifier int

AS
BEGIN
	DECLARE @DBName nvarchar(30)
	SELECT @DBName = DB_NAME()
	DECLARE @DeferredRevenue money = 0.00
	DECLARE @PaymentsForCurrentMonth money = 0.00


	EXEC DeferredRevenue_extHairClubCMSGetDeferredBalanceByClient_PROC @ClientIdentifier, @DeferredRevenue OUTPUT

	-- determine all payments.
	SELECT @PaymentsForCurrentMonth = SUM(sod.ExtendedPriceCalc)
	FROM datSalesOrder so
		INNER JOIN datClient c ON c.ClientGUID = so.ClientGUID
		INNER JOIN datSalesOrderDetail sod ON so.SalesOrderGUID = sod.SalesOrderGUID
		INNER JOIN cfgSalesCode sc ON sc.SalesCodeID = sod.SalesCodeID
		INNER JOIN datClientMembership cm ON cm.ClientMembershipGUID = so.ClientMembershipGUID
		INNER JOIN cfgMembership m ON m.MembershipID = cm.MembershipID
		INNER JOIN lkpBusinessSegment bs ON bs.BusinessSegmentID = m.BusinessSegmentID
	WHERE c.ClientIdentifier = @ClientIdentifier
		AND DATEPART(mm,so.OrderDate) = DATEPART(mm,GETDATE())
		AND DATEPART(yy,so.OrderDate) = DATEPART(yy,GETDATE())
		AND so.IsClosedFlag = 1 AND so.IsVoidedFlag = 0
		AND bs.BusinessSegmentDescriptionShort <> 'SUR'
		AND sc.SalesCodeDepartmentID = 2020

	SET @DeferredRevenue = ISNULL(@DeferredRevenue, 0) + ISNULL(@PaymentsForCurrentMonth, 0)

	SELECT @DeferredRevenue
END
GO
