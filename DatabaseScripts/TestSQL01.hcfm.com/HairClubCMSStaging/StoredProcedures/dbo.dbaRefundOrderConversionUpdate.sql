/* CreateDate: 02/26/2013 16:35:41.467 , ModifyDate: 02/26/2013 16:35:41.467 */
GO
/*
==============================================================================
PROCEDURE:				dbaRefundOrderConversionUpdate

DESTINATION SERVER:		SQL01

DESTINATION DATABASE: 	HairClubCMS

RELATED APPLICATION:  	CMS

AUTHOR: 				Joe Enders

IMPLEMENTOR: 			Joe Enders

DATE IMPLEMENTED: 		02/21/2013

LAST REVISION DATE: 	02/21/2013

==============================================================================
DESCRIPTION:	Update Order (Sales Order Denormalized) table
==============================================================================
NOTES:
		* 02/21/2013 JGE - Created

==============================================================================
SAMPLE EXECUTION:
EXEC [dbaRefundOrderConversionUpdate] 292, 2000
==============================================================================
*/

CREATE PROCEDURE [dbo].[dbaRefundOrderConversionUpdate]
	@Center int,
	@NumberOfDays int
AS
BEGIN
	SET NOCOUNT ON

	Begin Transaction
		--
		-- Update Refund information on SalesOrderDetail Records
		--
              UPDATE sodref
              SET sodref.RefundedSalesOrderDetailGUID = sodtrx.SalesOrderDetailGUID,
                     sodref.IsRefundedFlag = 1,
                     sodref.lastupdate = GETUTCDATE(),
                     sodref.LastUpdateUser = 'sa-conv'
                     --select *
              FROM datSalesOrderDetail sodref
                     INNER JOIN datSalesOrder so
                           on sodref.salesorderguid = so.salesorderguid
                     INNER JOIN [hcsql2\sql2005].INFOSTORE.dbo.Transactions ref
                           ON sodref.center_temp = ref.Center
                                  and sodref.TransactionNumber_Temp = ref.transact_no
                     INNER JOIN [hcsql2\sql2005].INFOSTORE.dbo.Transactions trx
                           ON ref.Refund_OrigTransact_No = trx.transact_no
                                  and ref.Center = trx.Center
                     INNER JOIN datsalesorderdetail sodtrx
                           ON trx.Center = sodtrx.center_temp
                                  and trx.transact_no = sodtrx.TransactionNumber_Temp
              WHERE sodref.center_temp = @Center
                     AND    ref.date >= dateadd(dd,-@NumberOfDays,Getdate())
                     AND ref.refund_origtransact_no is not null
                     and ref.Code not in ('tender')
                     and sodref.RefundedSalesOrderDetailGUID is null
		--
		-- Update SO Refund Flag
		--
              UPDATE so
              SET so.isrefundedFlag = 1,
                     so.lastupdate = GETUTCDATE(),
                     so.LastUpdateUser = 'sa-conv'
                     --select *
              FROM datSalesOrderDetail sodref
                     INNER JOIN datSalesOrder so
                           on sodref.salesorderguid = so.salesorderguid
                     INNER JOIN [hcsql2\sql2005].INFOSTORE.dbo.Transactions ref
                           ON sodref.center_temp = ref.Center
                                  and sodref.TransactionNumber_Temp = ref.transact_no
                     INNER JOIN [hcsql2\sql2005].INFOSTORE.dbo.Transactions trx
                           ON ref.Refund_OrigTransact_No = trx.transact_no
                                  and ref.Center = trx.Center
                     INNER JOIN datsalesorderdetail sodtrx
                           ON trx.Center = sodtrx.center_temp
                                  and trx.transact_no = sodtrx.TransactionNumber_Temp
              WHERE sodref.center_temp = @Center
                     AND    ref.date >= dateadd(dd,-@NumberOfDays,Getdate())
                     AND ref.refund_origtransact_no is not null
                     and ref.Code not in ('tender')
                     and sodref.RefundedSalesOrderDetailGUID is null
		--
		--Create table object with ID column
		--
		IF OBJECT_ID('tempdb..#RefundableOrders') IS NOT NULL
		BEGIN
			DROP TABLE #RefundableOrders
		END

		CREATE TABLE #RefundableOrders(
			RefundSalesOrderDetailGuid UNIQUEIDENTIFIER,
			RefundedTotalQuantity int,
			RefundedTotalPrice money
		)

		INSERT INTO #RefundableOrders (RefundSalesOrderDetailGuid, RefundedTotalQuantity, RefundedTotalPrice)
		SELECT sodref.RefundedSalesOrderDetailGUID, abs(sum(sodref.quantity)), abs(sum(sodref.extendedpricecalc))
				  FROM datSalesOrder soref
						inner join datsalesorderdetail sodref on soref.salesorderguid = sodref.salesorderguid
						inner join datsalesorderdetail sodtrx on sodref.refundedsalesorderdetailguid = sodtrx.salesorderdetailguid
						inner join datsalesorder sotrx on sodtrx.salesorderguid = sotrx.salesorderguid
				  WHERE soref.centerid = @Center and
						soref.isrefundedflag = 1 and
						soref.isvoidedflag = 0 and
						soref.isclosedflag = 1
			   group by sodref.RefundedSalesOrderDetailGUID

	--
	-- Update Original Transaction
	--
				  -- Update refund amounts
				  UPDATE sodtrx
				  SET sodtrx.RefundedTotalQuantity = ro.RefundedTotalQuantity,
						 sodtrx.RefundedTotalPrice = ro.RefundedTotalPrice,
						 sodtrx.lastupdate = GETUTCDATE(),
						 sodtrx.LastUpdateUser = 'sa-conv'
				  FROM #RefundableOrders ro
						inner join datsalesorderdetail sodtrx on ro.refundsalesorderdetailguid = sodtrx.salesorderdetailguid

   	COMMIT TRANSACTION
END
GO
