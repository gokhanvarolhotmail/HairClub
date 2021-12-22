/* CreateDate: 02/18/2013 07:20:48.807 , ModifyDate: 02/27/2017 09:49:29.180 */
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*===============================================================================================
-- Procedure Name:			rptOrphanedSalesOrders
-- Procedure Description:
--
-- Created By:				MLM
-- Implemented By:			MLM
-- Last Modified By:		MLM
--
-- Date Created:			12/11/2012
-- Destination Server:		SQL01
-- Destination Database:	HairClubCMS
-- Related Application:		CMS
--------------------------------------------------------------------------------------------------------
NOTES:


--------------------------------------------------------------------------------------------------------
Sample Execution:
EXEC [rptOrphanedSalesOrders] 260
================================================================================================*/
CREATE PROCEDURE [dbo].[rptOrphanedSalesOrders]
(
	@CenterID INT
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SELECT so.SalesOrderGUID
		,so.OrderDate
		,so.CenterID
		,c.ClientGUID
		,c.ClientFullNameCalc
		,c.ClientFullNameAltCalc
		,m.MembershipID
		,m.MembershipDescription
		,m.MembershipDescriptionShort
		,sc.SalesCodeDescription
		,sc.SalesCodeDescriptionShort
		,sod.Quantity
		,sod.Price
		,sod.Discount
		,sod.TotalTaxCalc
		,sod.PriceTaxCalc
		,tt.TenderTypeDescription
		,tt.TenderTypeDescriptionShort
		,sot.CreditCardLast4Digits
		,sot.[Amount] as TenderAmount
	FROM datSalesOrder so
		INNER JOIN datClient c on so.ClientGUID = c.ClientGUID
		INNER JOIN datClientMembership cm on so.ClientMembershipGUID = cm.ClientMembershipGUID
		INNER JOIN cfgMembership m on cm.MembershipId = m.MembershipId
		INNER JOIN datSalesOrderDetail sod on so.SalesOrderGUID = sod.SalesOrderGUID
		INNER JOIN datSalesOrderTender sot on so.SalesOrderGUID = sot.SalesOrderGUID
		INNER JOIN cfgSalesCode sc on sod.SalesCodeId = sc.SalesCodeId
		INNER JOIN lkpTenderType tt on sot.TenderTypeId = tt.TenderTypeId
	WHERE so.IsVoidedFlag = 0
		AND so.IsClosedFlag = 0
		AND so.CenterID = @CenterID


END
GO
